#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifeq ($(USES_DEVICE_XIAOMI_MI89XX),true)
include $(call all-makefiles-under,$(LOCAL_PATH))
endif
