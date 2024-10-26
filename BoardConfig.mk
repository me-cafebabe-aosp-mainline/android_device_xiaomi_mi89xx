#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

USES_DEVICE_XIAOMI_MI89XX := true
DEVICE_PATH := device/xiaomi/mi89xx

# Arch
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

# Bootloader
TARGET_NO_BOOTLOADER := true

# Display
TARGET_SCREEN_DENSITY := 280

# Filesystem
BOARD_EXT4_SHARE_DUP_BLOCKS :=
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USERIMAGES_USE_EXT4 := true

# Graphics (Swiftshader)
include device/google/cuttlefish/shared/swiftshader/BoardConfig.mk

# Init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):init_xiaomi_mi89xx
TARGET_RECOVERY_DEVICE_MODULES := init_xiaomi_mi89xx

# Kernel
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_IMAGE_NAME := Image.gz
BOARD_KERNEL_PAGESIZE := 2048
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x01000000 --tags_offset 0x00000100
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/xiaomi/mi89xx

BOARD_KERNEL_APPEND_DTBS := \
    qcom/msm8953-xiaomi-mido.dtb \
    qcom/msm8953-xiaomi-oxygen.dtb \
    qcom/msm8953-xiaomi-uter.dtb \
    qcom/msm8953-xiaomi-vince.dtb

BOARD_KERNEL_CMDLINE := \
    audit=0 \
    console=ttyMSM0,115200n8 \
    log_buf_len=4M \
    loop.max_part=7 \
    panic=-1 \
    printk.devkmsg=on \
    rw \
    androidboot.boot_devices=soc@0/7824900.mmc \
    androidboot.fstab_suffix=mi89xx \
    androidboot.hardware=mi8953 \
    androidboot.init_fatal_reboot_target=recovery \
    androidboot.selinux=permissive

TARGET_KERNEL_CONFIG := \
    gki_defconfig \
    lineageos/qcom-msm8937_53.config \
    lineageos/xiaomi-mido.config \
    lineageos/xiaomi-oxygen.config \
    lineageos/xiaomi-uter.config \
    lineageos/xiaomi-vince.config \
    lineageos/customizations.config

# OTA
TARGET_OTA_ASSERT_DEVICE := mi89xx

# Partitions
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_EXTFS_INODE_COUNT := 10240
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_VENDORIMAGE_EXTFS_INODE_COUNT := 1024
BOARD_VENDORIMAGE_PARTITION_SIZE := 536870912
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

TARGET_COPY_OUT_VENDOR := vendor

# Platform
TARGET_BOARD_PLATFORM := mi89xx

# Properties
TARGET_SYSTEM_PROP := $(DEVICE_PATH)/configs/properties/system.prop
TARGET_VENDOR_PROP := $(DEVICE_PATH)/configs/properties/vendor.prop

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/configs/fstab/fstab.mi89xx
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# Security patch level
VENDOR_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += \
    $(DEVICE_PATH)/sepolicy/vendor

# VINTF
DEVICE_MANIFEST_FILE := \
    $(DEVICE_PATH)/configs/vintf/manifest.xml
