#!/bin/sh

# Fix lool resolv.conf problem (wizdude)
rm /opt/lool/systemplate/etc/resolv.conf
ln -s /etc/resolv.conf /opt/lool/systemplate/etc/resolv.conf


# Replace trusted host
perl -pi -e "s/localhost<\/host>/${domain}<\/host>/g" /etc/loolwsd/loolwsd.xml
su -c "/usr/bin/loolwsd --version --disable-ssl --o:sys_template_path=/opt/lool/systemplate --o:lo_template_path=/opt/collaboraoffice5.1 --o:child_root_path=/opt/lool/child-roots --o:file_server_root_path=/usr/share/loolwsd" -s /bin/bash lool

