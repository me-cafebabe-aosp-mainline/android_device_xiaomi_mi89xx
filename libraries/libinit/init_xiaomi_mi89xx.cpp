/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <libinit_dalvik_heap.h>
#include <libinit_utils.h>

#include "vendor_init.h"

void set_debugging_props() {
    property_override("persist.sys.usb.config", "adb");
    property_override("ro.adb.secure", "0");
    property_override("ro.debuggable", "1");
    property_override("ro.boot.verifiedbootstate", "orange");
    property_override("ro.secure", "0");
    set_ro_build_prop("build.tags", "test-keys");
    set_ro_build_prop("build.type", "eng");
}

void vendor_load_properties() {
    set_dalvik_heap();
    set_debugging_props();
}
