#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Defines
TARGET_DISPLAY_USE ?= drm
TARGET_HAS_BATTERY ?= true

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@7.1-impl \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.audio.service \
    android.hardware.bluetooth.audio-impl

PRODUCT_PACKAGES += \
    audio.bluetooth.default \
    audio.primary.default \
    audio.r_submix.default \
    audio.usb.default

# Audio configs
PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration_7_0.xml \
    frameworks/av/media/libeffects/data/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/msd_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/msd_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/surround_sound_configuration_5_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/surround_sound_configuration_5_0.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

# Bootanimation
TARGET_BOOTANIMATION_HALF_RES := true
TARGET_SCREEN_WIDTH := 720
TARGET_SCREEN_HEIGHT := 1280

# Dalvik heap
$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)

# DLKM Loader
PRODUCT_PACKAGES += \
    dlkm_loader

# Fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Firmware
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/firmware/,$(TARGET_COPY_OUT_VENDOR)/firmware/)

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software

# Graphics (Composer)
ifeq ($(TARGET_DISPLAY_USE),drm)
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.4-service \
    hwcomposer.drm
PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.hwcomposer=drm
else ifeq ($(TARGET_DISPLAY_USE),fb)
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.1-service
endif

# Graphics (Gralloc)
ifeq ($(TARGET_DISPLAY_USE),drm)
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    gralloc.gbm
PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.gralloc=gbm
else ifeq ($(TARGET_DISPLAY_USE),fb)
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl-2.1
endif

# Graphics (Mesa)
PRODUCT_PACKAGES += \
    mesa3d

# Graphics (Swiftshader)
PRODUCT_PACKAGES += \
    vulkan.pastel

PRODUCT_REQUIRES_INSECURE_EXECMEM_FOR_SWIFTSHADER := true

# Health
ifeq ($(TARGET_HAS_BATTERY),true)
PRODUCT_PACKAGES += \
    android.hardware.health-service.example \
    android.hardware.health-service.example_recovery \
    charger_res_images_vendor
else
PRODUCT_PACKAGES += \
    android.hardware.health-service.cuttlefish_recovery \
    com.google.cf.health
endif

# Init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/fstab/fstab.mi89xx:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.mi89xx \
    $(LOCAL_PATH)/configs/init/init.common.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.common.usb.rc \
    $(LOCAL_PATH)/configs/init/init.mi89xx.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mi89xx.rc \
    $(LOCAL_PATH)/configs/init/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc

# Kernel
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# Keymint
PRODUCT_PACKAGES += \
    android.hardware.security.keymint-service

# Light
PRODUCT_PACKAGES += \
    android.hardware.light-service.mi89xx

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlays/overlay

PRODUCT_ENFORCE_RRO_TARGETS := *

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.software.credentials.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.credentials.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

PRODUCT_PACKAGES += \
    android.hardware.audio.low_latency.prebuilt.xml \
    android.hardware.bluetooth.prebuilt.xml \
    android.hardware.bluetooth_le.prebuilt.xml \
    android.hardware.usb.accessory.prebuilt.xml \
    android.hardware.usb.host.prebuilt.xml \
    android.hardware.wifi.prebuilt.xml \
    android.hardware.wifi.direct.prebuilt.xml \
    android.software.ipsec_tunnels.prebuilt.xml

PRODUCT_PACKAGES += \
    android.hardware.vulkan.level-0.prebuilt.xml \
    android.hardware.vulkan.version-1_0_3.prebuilt.xml \
    android.software.vulkan.deqp.level-latest.prebuilt.xml \
    android.software.opengles.deqp.level-latest.prebuilt.xml

# Ramdisk
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/fstab/fstab.mi89xx:$(TARGET_COPY_OUT_RAMDISK)/fstab.mi89xx

# Recovery
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/init/init.recovery.mi89xx.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.mi89xx.rc \
    $(LOCAL_PATH)/configs/init/ueventd.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/ueventd.rc \
    $(LOCAL_PATH)/configs/scripts/set_udc-recovery.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/set_udc-recovery.sh

# Scoped Storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Seccomp policy
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/seccomp_policy/mediaswcodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    $(LOCAL_PATH)/seccomp_policy/mediaswcodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaswcodec.policy

# Set device properties
PRODUCT_PACKAGES += \
    set_vendor_device_prop \
    set_vendor_device_prop.recovery

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 33

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Suspend blocker
PRODUCT_PACKAGES += \
    suspend_blocker

# UFFD GC
PRODUCT_ENABLE_UFFD_GC := true

# USB
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/scripts/set_udc.sh:$(TARGET_COPY_OUT_VENDOR)/bin/set_udc.sh

PRODUCT_PACKAGES += \
    android.hardware.usb@1.3-service.basic

# Vendor service manager
PRODUCT_PACKAGES += \
    vndservicemanager
