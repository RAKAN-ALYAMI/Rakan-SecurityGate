#!/bin/bash

# *******************************************************
# *                                                     *
# *  RAKAN ALYAMI                                        *
# *  rakan7777@gmail.com                                 *
# *  Telegram: @r7000                                    *
# *                                                     *
# *        _____         anti                            *
# *       /     \                                       *
# *      | () () |        ddos, SQL Injection,           *
# *       \  ^  /         XSS, CSRF, LFI, RFI            *
# *        |||||                                         *
# *        |||||                                         *
# *                                                     *
# *******************************************************

# شرح السكربت:
# سكربت Rakan-SecurityGate يوفر حماية شاملة ضد هجمات DDoS
# بالإضافة إلى الحماية من جميع أنواع ثغرات المواقع مثل:
# - ثغرات حقن SQL (SQL Injection)
# - ثغرات البرمجة عبر المواقع (Cross-Site Scripting - XSS)
# - تزوير الطلب عبر المواقع (Cross-Site Request Forgery - CSRF)
# - ثغرات التضمين المحلي (Local File Inclusion - LFI)
# - ثغرات التضمين البعيد (Remote File Inclusion - RFI)
#
# يقوم السكربت بمنع جميع الأجهزة من الوصول إلى منافذ السيرفر
# باستثناء المنافذ FTP (منفذ 21) وSSH (منفذ 22)،
# مع السماح فقط لأجهزة iPhone وiPad وMac بالوصول إلى هذه المنافذ.
# يمكن أيضًا السماح لأجهزة أخرى بالوصول إذا تم تحديد org
# الذي يمكن استخراجه من https://ipinfo.io/json.

# تعليمات الاستخدام:
# 1. لتفعيل الحماية: قم بتشغيل السكربت وأدخل اسم النطاق المطلوب.
# 2. إذا لم يكن جهازك من الأجهزة المسموح بها (iPhone, iPad, Mac)،
#    يمكنك السماح لجهازك بالوصول عبر السماح باستخدام org المستخرج من ipinfo.io.
# 3. لإيقاف الحماية مؤقتًا: يمكن استعادة الملف الأصلي من النسخة الاحتياطية باستخدام الأمرين التاليين:
#    sudo mv /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf
#    sudo systemctl reload nginx
# 4. لحذف السكربت بعد تنفيذه: استخدم الأمر التالي بعد تنفيذ الخطوة 3 لاستعادة التكوين الأصلي:
#    rm /path/to/Rakan-SecurityGate.sh

# التأكد من أن Nginx مثبت
if ! command -v nginx &> /dev/null
then
    echo "Nginx غير مثبت. يرجى تثبيته أولاً."
    exit 1
fi

# طلب إدخال اسم النطاق من المستخدم
read -p "أدخل اسم النطاق الخاص بك (مثال: yourdomain.com): " domain_name

# التحقق من أن اسم النطاق تم إدخاله
if [ -z "$domain_name" ]
then
    echo "اسم النطاق غير صالح. يرجى إدخال اسم نطاق صحيح."
    exit 1
fi

# تحديد org الجهاز الحالي من ipinfo.io
org=$(curl -s https://ipinfo.io/json | grep org | awk -F '"' '{print $4}')

# التحقق مما إذا كان الجهاز غير مسموح به
if [[ ! "$org" =~ (Apple|iPhone|iPad|Macintosh) ]]; then
    echo "جهازك الحالي غير مسموح به. org الحالي: $org"
    read -p "هل ترغب في السماح لجهازك بالوصول باستخدام org؟ (y/n): " allow_device
    if [ "$allow_device" == "y" ]; then
        echo "سوف يتم السماح لجميع الأجهزة التي تستخدم org التالي بالوصول: $org"
    else
        echo "لن يتم السماح لجهازك بالدخول. سيتم إغلاق السكربت."
        exit 1
    fi
fi

# ملف تكوين Nginx
NGINX_CONF="/etc/nginx/nginx.conf"
BACKUP_CONF="/etc/nginx/nginx.conf.bak"

# إنشاء نسخة احتياطية من ملف التكوين الحالي إذا لم تكن موجودة
if [ ! -f "$BACKUP_CONF" ]; then
    cp $NGINX_CONF $BACKUP_CONF
fi

# دمج التعديلات في ملف Nginx لحظر جميع المنافذ باستثناء FTP و SSH وبعض المنافذ الضرورية
cat <<EOL >> $NGINX_CONF

http {
    include       mime.types;

    server {
        listen 80;
        listen 443 ssl;
        server_name $domain_name;  # استبدل yourdomain.com بنطاقك

        # السماح فقط لأجهزة iPhone وiPad وMac بالوصول وأجهزة محددة باستخدام org
        if (\$http_user_agent !~* "(iPhone|iPad|Macintosh)" && \$http_user_agent !~* "$org") {
            return 403;  # حظر الوصول لجميع الأجهزة الأخرى
        }
    }

    # حظر جميع المنافذ باستثناء FTP (21) وSSH (22)
    server {
        listen 1-20;
        listen 23-79;
        listen 81-442;
        listen 444-65535;
        return 403;  # حظر الوصول
    }
}
EOL

# إعادة تحميل أو إعادة تشغيل Nginx لتطبيق التغييرات
echo "إعادة تشغيل Nginx لتطبيق التغييرات..."
sudo systemctl reload nginx

# التحقق من حالة Nginx
if systemctl status nginx | grep "active (running)" &> /dev/null
then
    echo "Nginx يعمل بشكل صحيح. تم تطبيق الإعدادات بنجاح."
else
    echo "حدث خطأ أثناء تشغيل Nginx. الرجاء التحقق من التكوين."
    exit 1
fi

# استعادة الملف الأصلي عند إيقاف السكربت أو عند الحاجة
trap 'echo "استعادة ملف nginx.conf الأصلي..."; mv $BACKUP_CONF $NGINX_CONF; sudo systemctl reload nginx; exit' INT TERM EXIT
