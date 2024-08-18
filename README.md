
# Rakan-SecurityGate

**Rakan-SecurityGate** is a security script designed to protect a server by allowing only specific devices (iPhone, iPad, Mac) to access the server while blocking all others. It includes protection against DDoS attacks and common web vulnerabilities like RFI, LFI, CSRF, SQL Injection, and XSS.

**Rakan-SecurityGate** هو سكربت أمني لحماية السيرفر من خلال السماح فقط لأجهزة محددة (iPhone, iPad, Mac) بالدخول إلى السيرفر ومنع جميع الأجهزة الأخرى. يشمل الحماية ضد هجمات DDoS وثغرات المواقع الشائعة مثل RFI، LFI، CSRF، SQL Injection، و XSS.

## Features | الميزات

- Allows access only for iPhone, iPad, and Mac devices.
- Blocks all other devices from accessing the server.
- Supports adding additional devices using `org` extracted from `ipinfo.io`.
- Provides protection against:
  - DDoS (Distributed Denial of Service) attacks
  - RFI (Remote File Inclusion)
  - LFI (Local File Inclusion)
  - CSRF (Cross-Site Request Forgery)
  - SQL Injection
  - XSS (Cross-Site Scripting)

- يسمح بالوصول فقط لأجهزة iPhone و iPad و Mac.
- يحظر جميع الأجهزة الأخرى من الوصول إلى السيرفر.
- يدعم إضافة أجهزة إضافية باستخدام `org` المستخرج من `ipinfo.io`.
- يوفر الحماية ضد:
  - هجمات DDoS (هجمات الحرمان من الخدمة الموزعة)
  - ثغرات RFI (تضمين الملفات عن بُعد)
  - ثغرات LFI (تضمين الملفات المحلية)
  - ثغرات CSRF (تزوير الطلب عبر المواقع)
  - ثغرات SQL Injection (حقن قواعد البيانات)
  - ثغرات XSS (البرمجة عبر المواقع)

## Installation | التثبيت

To install and run the Rakan-SecurityGate script on your server, follow these steps:

لتثبيت وتشغيل سكربت Rakan-SecurityGate على سيرفرك، اتبع الخطوات التالية:

1. **Clone the repository | استنساخ المستودع:**

   ```bash
   git clone https://github.com/RAKAN-ALYAMI/Rakan-SecurityGate.git
   cd Rakan-SecurityGate
   ```

2. **Make the script executable | جعل السكربت قابلاً للتنفيذ:**

   ```bash
   chmod +x Rakan-SecurityGate.sh
   ```

3. **Run the script | تشغيل السكربت:**

   ```bash
   sudo ./Rakan-SecurityGate.sh
   ```

   The script will prompt you to enter your domain name. Follow the on-screen instructions.

   سيطلب منك السكربت إدخال اسم النطاق الخاص بك. اتبع التعليمات الظاهرة على الشاشة.

## Usage | الاستخدام

### Allowing Additional Devices | السماح بأجهزة إضافية

If your device is not an iPhone, iPad, or Mac, the script will check your `org` using `ipinfo.io`. If you wish to allow access for your device, the script will prompt you to confirm:

إذا كان جهازك ليس iPhone أو iPad أو Mac، سيقوم السكربت بفحص `org` الخاص بك باستخدام `ipinfo.io`. إذا كنت ترغب في السماح لجهازك بالوصول، سيطلب منك السكربت التأكيد:

- The script will display your `org`.
- يمكنك اختيار السماح لجميع الأجهزة التي تستخدم نفس `org` بالوصول.

### Stopping the Script | إيقاف السكربت

To stop the script and restore the original `nginx.conf` configuration:

لإيقاف السكربت واستعادة تكوين `nginx.conf` الأصلي:

1. Restore the original configuration | استعادة التكوين الأصلي:

   ```bash
   sudo mv /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf
   ```

2. Reload the Nginx service | إعادة تحميل خدمة Nginx:

   ```bash
   sudo systemctl reload nginx
   ```

### Uninstalling the Script | إلغاء تثبيت السكربت

If you wish to remove the script after running it:

إذا كنت ترغب في إزالة السكربت بعد تشغيله:

1. Follow the steps to stop the script | اتبع الخطوات لإيقاف السكربت.
2. Remove the script file | احذف ملف السكربت:

   ```bash
   rm /path/to/Rakan-SecurityGate.sh
   ```

## License | الرخصة

This project is licensed under the MIT License.

هذا المشروع مرخص تحت رخصة MIT.

## Contact | التواصل

For any inquiries or support, please contact:

لأي استفسارات أو دعم، يرجى التواصل:

- **Author | المؤلف:** Rakan Alyami
- **Email | البريد الإلكتروني:** rakan7777@gmail.com
- **Telegram:** https://t.me/r7000r
