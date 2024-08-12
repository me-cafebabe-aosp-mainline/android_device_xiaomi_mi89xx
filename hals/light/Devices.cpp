/*
 * Copyright (C) 2024 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include "Devices.h"

#define LOG_TAG "Devices"

#include <android-base/logging.h>

namespace aidl {
namespace android {
namespace hardware {
namespace light {

static const std::string kBacklightDevices[] = {
        "backlight",
        "panel0-backlight",
};

static std::vector<BacklightDevice> getBacklightDevices() {
    std::vector<BacklightDevice> devices;

    for (const auto& device : kBacklightDevices) {
        BacklightDevice backlight(device);
        if (backlight.exists()) {
            LOG(INFO) << "Found backlight device: " << backlight.getName();
            devices.push_back(backlight);
        }
    }

    return devices;
}

Devices::Devices()
    : mBacklightDevices(getBacklightDevices()) {
    if (!hasBacklightDevices()) {
        LOG(INFO) << "No backlight devices found";
    }
}

bool Devices::hasBacklightDevices() const {
    return !mBacklightDevices.empty();
}

void Devices::setBacklightColor(rgb color) {
    for (auto& device : mBacklightDevices) {
        device.setBrightness(color.toBrightness());
    }
}

void Devices::dump(int fd) const {
    dprintf(fd, "Backlight devices:\n");
    for (const auto& device : mBacklightDevices) {
        dprintf(fd, "- ");
        device.dump(fd);
        dprintf(fd, "\n");
    }
    dprintf(fd, "\n");

    return;
}

}  // namespace light
}  // namespace hardware
}  // namespace android
}  // namespace aidl
