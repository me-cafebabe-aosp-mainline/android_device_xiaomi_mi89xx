#! /system/bin/sh
# Grep and set the vendor.usb.controller property from
# /sys/class/udc at the boot time.
#
# Upstream commit eb9b7bfd5954 ("arm64: dts: qcom: Harmonize DWC
# USB3 DT nodes name") (v5.14-rc1) changed the DTS USB node names,
# breaking the sys.usb.controller property hardcoded in the
# platform specific init.usb.common.rc
#
# This script will get rid of the static/hardcoded property name
# which we set in init.<hw>.usb.rc and set it to the available
# on-board USB controller from /sys/class/udc instead.

# Searching for db845c's DWC3 UDC explicitly
UDC_ADDRESS=7000000
UDC=`/system/bin/ls /sys/class/udc/ | /system/bin/grep $UDC_ADDRESS`
setprop sys.usb.controller $UDC

# TMP
echo set_udc-recovery.sh > /dev/kmsg
/system/bin/ls /sys/class/udc/ > /dev/kmsg
