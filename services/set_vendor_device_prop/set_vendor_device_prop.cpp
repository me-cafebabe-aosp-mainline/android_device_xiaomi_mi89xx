#include <fstream>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

#include <android-base/properties.h>
#include <android-base/strings.h>

#ifndef ARRAY_SIZE
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
#endif

using android::base::SetProperty;
using android::base::StartsWith;

typedef struct device_info {
    std::string codename;
    unsigned int lcd_density;
} device_info_t;

const std::string kDtCompatiblePath = "/sys/firmware/devicetree/base/compatible";
const std::string kPropCodename = "ro.vendor.device.codename";
const std::string kPropLcdDensity = "ro.vendor.device.lcd_density";
const std::string kPropSoc = "ro.vendor.device.soc";
const std::string kPropSocFamily = "ro.vendor.device.soc_family";

const device_info_t device_info_table[] = {
        // clang-format off

    // Mi8917
    {"riva", 280},
    {"rolex", 280},
    {"tiare", 280},
    {"ugglite", 260},

    // Mi8937
    {"land", 280},
    {"prada", 280},
    {"santoni", 280},
    {"ugg", 260},

    // Xiaomi MSM8953
    {"oxygen", 342},
    {"uter", 400},
    {"vince", 440},

        // clang-format on
};

std::unordered_map<std::string, std::string> kSocFamilyMap = {
        // clang-format off
    {"msm8916", "msm8916"},
    {"msm8917", "msm8937"},
    {"msm8920", "msm8937"},
    {"msm8929", "msm8916"},
    {"msm8937", "msm8937"},
    {"msm8939", "msm8916"},
    {"msm8940", "msm8937"},
    {"msm8952", "msm8952"},
    {"msm8953", "msm8953"},
    {"msm8956", "msm8952"},
    {"msm8976", "msm8952"},
    {"msm8996", "msm8996"},
    {"msm8998", "msm8998"},
    {"qm215", "msm8937"},
    {"sdm429", "msm8937"},
    {"sdm439", "msm8937"},
    {"sdm450", "msm8953"},
    {"sdm630", "msm8998"},
    {"sdm632", "msm8953"},
    {"sdm660", "msm8998"},
        // clang-format on
};

std::vector<std::string> readDtCompatible(const std::string& filename) {
    std::vector<std::string> result;
    std::ifstream file(filename, std::ios::binary);

    if (!file) {
        std::cerr << "Could not open file: " << filename << std::endl;
        return result;
    }

    std::string buffer;
    char ch;

    // Read file byte by byte
    while (file.get(ch)) {
        if (ch != '\0') {
            buffer += ch;
        } else {
            if (!buffer.empty()) {
                result.push_back(buffer);
                buffer.clear();
            }
        }
    }

    // Push any remaining buffer as a string
    if (!buffer.empty()) {
        result.push_back(buffer);
    }

    return result;
}

int main() {
    bool ret = true;
    std::string device_codename, device_soc, device_soc_family;
    std::vector<std::string> compatibles = readDtCompatible(kDtCompatiblePath);

    if (compatibles.empty()) {
        std::cout << "Failed to read " << kDtCompatiblePath << std::endl;
        return 1;
    }

    for (const auto& compatible : compatibles) {
        if (StartsWith(compatible, "xiaomi,")) {
            if (!device_codename.empty()) continue;
            device_codename = compatible.substr(7);
            std::cout << "Device codename: " << device_codename << std::endl;
            ret &= SetProperty(kPropCodename, device_codename);
        } else if (StartsWith(compatible, "qcom,")) {
            if (!device_soc.empty()) continue;
            device_soc = compatible.substr(5);
            std::cout << "SoC: " << device_soc << std::endl;
            ret &= SetProperty(kPropSoc, device_soc);
        }
    }

    for (const auto& [soc, soc_family] : kSocFamilyMap) {
        if (device_soc == soc) {
            device_soc_family = soc_family;
            std::cout << "SoC Family: " << device_soc_family << std::endl;
            ret &= SetProperty(kPropSocFamily, device_soc_family);
            break;
        }
    }

    bool have_set_device_specific_properties = false;
    for (int i = 0; i < ARRAY_SIZE(device_info_table); i++) {
        if (device_codename == device_info_table[i].codename) {
            ret &= SetProperty(kPropLcdDensity, std::to_string(device_info_table[i].lcd_density));
            have_set_device_specific_properties = true;
            break;
        }
    }

    if (!have_set_device_specific_properties) {
        ret &= SetProperty(kPropLcdDensity, "320");
    }

    return (!device_codename.empty() && !device_soc.empty() && !device_soc_family.empty() &&
            ret == true)
                   ? 0
                   : 1;
}
