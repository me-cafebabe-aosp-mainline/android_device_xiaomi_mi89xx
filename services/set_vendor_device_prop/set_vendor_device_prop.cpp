#include <fstream>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

#include <android-base/properties.h>
#include <android-base/strings.h>

using android::base::SetProperty;
using android::base::StartsWith;

const std::string kDtCompatiblePath = "/sys/firmware/devicetree/base/compatible";
const std::string kPropCodename = "ro.vendor.device.codename";
const std::string kPropSoc = "ro.vendor.device.soc";
const std::string kPropSocFamily = "ro.vendor.device.soc_family";

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

    return (!device_codename.empty() && !device_soc.empty() && !device_soc_family.empty() &&
            ret == true)
                   ? 0
                   : 1;
}
