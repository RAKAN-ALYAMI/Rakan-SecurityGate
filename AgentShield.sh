#!/bin/bash

# ملف لتسجيل عناوين IP المحظورة
blocked_ips_file="/var/log/blocked_ips.log"

# اسأل المستخدم عن الـ User Agent الذي يريد السماح له
read -p "Please enter the User Agent you want to allow: " allowed_user_agent

# إعداد جدار الحماية للسماح فقط بالـ User Agent المحدد على المنفذين 80 و 443
iptables -A INPUT -p tcp --dport 80 -m string --string "$allowed_user_agent" --algo bm -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -m string --string "$allowed_user_agent" --algo bm -j ACCEPT

# إعداد جدار الحماية لتسجيل وحظر الزيارات غير المسموح بها
iptables -A INPUT -p tcp --dport 80 -j LOG --log-prefix "Blocked: " --log-level 4
iptables -A INPUT -p tcp --dport 443 -j LOG --log-prefix "Blocked: " --log-level 4
iptables -A INPUT -p tcp --dport 80 -j DROP
iptables -A INPUT -p tcp --dport 443 -j DROP

echo "Firewall rules added. Only the specified User Agent is allowed on ports 80 and 443."

# وظيفة لاستعراض الزيارات المحظورة
function view_blocked {
    echo "Blocked IPs:"
    cat $blocked_ips_file
}

# وظيفة لإزالة الحظر عن IP محدد
function unblock_ip {
    read -p "Enter the IP address you want to unblock: " ip
    iptables -D INPUT -s $ip -j DROP
    sed -i "/$ip/d" $blocked_ips_file
    echo "Unblocked IP: $ip"
}

# وظيفة لإزالة جميع القواعد عند حذف السكربت
function remove_all_blocks {
    echo "Removing all blocked IPs and firewall rules..."
    while read -r ip; do
        iptables -D INPUT -s $ip -j DROP
    done < $blocked_ips_file

    # إزالة جميع القواعد الأخرى المتعلقة بالمنفذين 80 و 443
    iptables -D INPUT -p tcp --dport 80 -m string --string "$allowed_user_agent" --algo bm -j ACCEPT
    iptables -D INPUT -p tcp --dport 443 -m string --string "$allowed_user_agent" --algo bm -j ACCEPT
    iptables -D INPUT -p tcp --dport 80 -j LOG --log-prefix "Blocked: " --log-level 4
    iptables -D INPUT -p tcp --dport 443 -j LOG --log-prefix "Blocked: " --log-level 4
    iptables -D INPUT -p tcp --dport 80 -j DROP
    iptables -D INPUT -p tcp --dport 443 -j DROP

    # حذف ملف الـ log الخاص بالـ IPs المحظورة
    rm -f $blocked_ips_file

    echo "All blocked IPs and firewall rules have been removed."
}

# عرض القائمة الرئيسية
while true; do
    echo "Options:"
    echo "1. View blocked IPs"
    echo "2. Unblock an IP"
    echo "3. Remove all blocks and firewall rules"
    echo "4. Exit"
    read -p "Choose an option: " option

    case $option in
        1) view_blocked ;;
        2) unblock_ip ;;
        3) remove_all_blocks ;;
        4) exit ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
