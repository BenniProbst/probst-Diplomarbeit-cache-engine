// V33.D.3 (2026-05-21) - MessreiheV32Validator Tests

#include "../../02_messung_driver/messreihe_v32_validator.hpp"

#include <gtest/gtest.h>
#include <string>

namespace v32 = comdare::diplomarbeit::messung_driver::v32;

namespace {

constexpr std::string_view kValidXml = R"(<?xml version="1.0" encoding="UTF-8"?>
<messreihe version="32">
  <metadata>
    <name>test</name>
    <description>x</description>
    <mode>defined</mode>
  </metadata>
  <execution_engines>
    <engine id="ee_a" type="CacheEngineExecutionEngineAdapter" name="CE"/>
    <engine id="ee_b" type="PrtArtExecutionEngineAdapter" name="PA"/>
  </execution_engines>
  <tupel id="t01">
    <workload kind="YCSB_C_ReadOnly" record_count="100" operation_count="10" seed="42"/>
  </tupel>
  <output>
    <binary_path>x.bin</binary_path>
    <csv_path>x.csv</csv_path>
    <latex_path>x.tex</latex_path>
    <comparison_metrics>true</comparison_metrics>
  </output>
</messreihe>)";

} // namespace

TEST(MessreiheV32Validator, ValidXmlPassesValidation) {
    auto report = v32::MessreiheV32Validator::validate_string(kValidXml);
    EXPECT_TRUE(report.valid) << "Errors: " << report.error_count();
    for (const auto& issue : report.issues) { ADD_FAILURE() << "Unexpected issue: " << issue.message; }
}

TEST(MessreiheV32Validator, MissingMessreiheRoot) {
    auto report = v32::MessreiheV32Validator::validate_string("<?xml version=\"1.0\"?><foo/>");
    EXPECT_FALSE(report.valid);
    EXPECT_TRUE(report.has_errors());
}

TEST(MessreiheV32Validator, WrongVersionFails) {
    std::string xml = std::string(kValidXml);
    auto        pos = xml.find("version=\"32\"");
    ASSERT_NE(pos, std::string::npos);
    xml.replace(pos, std::string("version=\"32\"").size(), "version=\"31\"");
    auto report = v32::MessreiheV32Validator::validate_string(xml);
    EXPECT_FALSE(report.valid);
}

TEST(MessreiheV32Validator, OnlyOneEngineFails) {
    std::string xml = std::string(kValidXml);
    auto        pos = xml.find("<engine id=\"ee_b\"");
    ASSERT_NE(pos, std::string::npos);
    auto end = xml.find("/>", pos);
    xml.erase(pos, end - pos + 2);
    auto report = v32::MessreiheV32Validator::validate_string(xml);
    EXPECT_FALSE(report.valid);
}

TEST(MessreiheV32Validator, NoTupelFails) {
    std::string xml = std::string(kValidXml);
    auto        pos = xml.find("<tupel");
    auto        end = xml.find("</tupel>", pos);
    xml.erase(pos, end - pos + std::string("</tupel>").size());
    auto report = v32::MessreiheV32Validator::validate_string(xml);
    EXPECT_FALSE(report.valid);
}

TEST(MessreiheV32Validator, InvalidModeFails) {
    std::string xml = std::string(kValidXml);
    auto        pos = xml.find("<mode>defined</mode>");
    xml.replace(pos, std::string("<mode>defined</mode>").size(), "<mode>weird</mode>");
    auto report = v32::MessreiheV32Validator::validate_string(xml);
    EXPECT_FALSE(report.valid);
}

TEST(MessreiheV32Validator, ValidatesShippedExampleFile) {
    auto report = v32::MessreiheV32Validator::validate_file("test_data_xml/messreihe_v32_schema_example.xml");
    // Wenn das File nicht gefunden -> Skip (CTest WORKING_DIRECTORY-Problem)
    if (!report.valid && report.issues.size() == 1 &&
        report.issues[0].message.find("Cannot open") != std::string::npos) {
        GTEST_SKIP() << "Working dir mismatch: " << report.issues[0].message;
    }
    EXPECT_TRUE(report.valid) << "Real example XML failed validation";
}
