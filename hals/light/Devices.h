/*
 * Copyright (C) 2024 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#pragma once

#include <vector>
#include "BacklightDevice.h"
#include "IDumpable.h"
#include "Utils.h"

namespace aidl {
namespace android {
namespace hardware {
namespace light {

class Devices : public IDumpable {
  public:
    Devices();

    bool hasBacklightDevices() const;

    void setBacklightColor(rgb color);

    void dump(int fd) const override;

  private:
    // Backlight
    std::vector<BacklightDevice> mBacklightDevices;
};

}  // namespace light
}  // namespace hardware
}  // namespace android
}  // namespace aidl
