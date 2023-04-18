#!/bin/sh
echo $0 $*
progdir=`dirname "$0"`
homedir=$progdir/advmenu


infoPanel -t "Easy LogoTweak" -m "LOADING...\n \nEasy LogoTweak by Schmurtz\nMusic : The World Of Douve by DOUVE" --persistent &

# running thumbnails_generator for AdvanceMenu
./thumbnails_generator.sh

touch /tmp/dismiss_info_panel


echo "Running advancemenu now !"
cd $homedir
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
HOME=/mnt/SDCARD/App/EasyLogoTweak/advmenu ./advmenu
(sleep 0.5 && echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable) &

