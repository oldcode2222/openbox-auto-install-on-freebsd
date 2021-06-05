#!/bin/sh

#############################################################################
#                                                                           #
# Author: Hirotoshi Kawai                                                   #
# Description: Automated sh scripts install openbox and extra...            #
# OS: This script made with Ubuntu 18.04 LTS                                #
#     for FreeBSD 12 64bit on VirtualBox                                    #
#                                                                           #
#############################################################################

sudo pkg install xorg openbox openbox-arc-theme slim slim-freebsd-black-theme \
     bash fish plank xfce4-desktop xfce4-power-manager tint2 git \
     ja-fcitx-mozc compton firefox thunderbird \
     sakura emacs vim ja-mozc-el-emacs26 thunar noto noto-basic \
     noto-extra noto-jp ja-font-vlgothic scrot rofi i3lock xautolock nano

sudo Xorg -configure
sudo mv /root/xorg.conf.new /etc/X11/xorg.conf

git clone https://github.com/powerline/fonts.git ~/powerline-fonts
. ~/powerline-fonts/install.sh
git clone https://github.com/addy-dclxvi/tint2-theme-collections ~/.config/tint2 --depth 1 
git clone https://github.com/addy-dclxvi/openbox-theme-collections ~/.themes

echo -e "#!/bin/sh\n\nexport LC_ALL=ja_JP.UTF-8\n\
export LANGUAGE=ja_JP.UTF-8\nexport LANG=ja_JP.UTF-8\n\n\
export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\n\
export XMODIFIERS=@im=fcitx\n\n/usr/local/bin/mozc start\n\
fcitx -r -d\ncompton -b\nplank &\nxfdesktop &\n\n\
setxkbmap -layout jp\nxrandr -s 1024x768\n\
tint2 -c ~/.config/tint2/minima/minima.tint2rc &\n\n\
exec openbox-session" >> ~/.xinitrc

sudo sh -c 'echo -e "dbus_enable=\"YES\"\nhald_enable=\"YES\"\n\
polkitd_enable=\"YES\"\n\
ntpdate_enable=\"YES\"\n\
ntpdate_flags=\"-b ntp.nict.jp\"\n\
slim_enable=\"YES\"" >> /etc/rc.conf'

sudo sed -i -e "/^login_cmd.*exec.*\/bin\/sh/s/login_cmd/#login_cmd/" /usr/local/etc/slim.conf
sudo sed -i -e "/^#login_cmd.*exec.*\/bin\/bash/s/#login_cmd/login_cmd/" /usr/local/etc/slim.conf
sudo sed -i -e "/^login_cmd.*exec.*\/bin\/bash/s/\/bin\/bash/\/usr\/local\/bin\/bash/" /usr/local/etc/slim.conf
sudo sed -i -e "/^current_theme/s/default/slim-freebsd-black-theme/" /usr/local/etc/slim.conf

chsh -s /usr/local/bin/bash

echo "########################################################################"
echo
echo "Please reboot! Then will start Desktop Environment."
echo 
echo "########################################################################"
