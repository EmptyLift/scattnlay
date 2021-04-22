#include "gtest/gtest.h"
#include "../src/nmie-impl.hpp"
#include "../src/nmie-precision.hpp"

// TODO fails for MP with 100 digits.
#ifndef MULTI_PRECISION
TEST(BulkSphere, DISABLED_ArgPi) {
//TEST(BulkSphere, ArgPi) {
  std::vector<double> WLs{50, 80, 100,200, 400}; //nm
  double host_index = 2.;
  double core_radius = 100.; //nm
  double delta = 1e-5;
  nmie::MultiLayerMie<nmie::FloatType> nmie;
  nmie.SetLayersIndex({std::complex<double>(4,0)});
  for (auto WL:WLs) {
    nmie.SetLayersSize({2*nmie.PI_*host_index*core_radius/(WL+delta)});
    nmie.RunMieCalculation();
    double Qabs_p = std::abs(static_cast<double>(nmie.GetQabs()));

    nmie.SetLayersSize({2*nmie.PI_*host_index*core_radius/(WL-delta)});
    nmie.RunMieCalculation();
    double Qabs_m = std::abs(static_cast<double>(nmie.GetQabs()));

    nmie.SetLayersSize({2*nmie.PI_*host_index*core_radius/(WL)});
    nmie.RunMieCalculation();
    double Qabs = std::abs(static_cast<double>(nmie.GetQabs()));
    EXPECT_GT(Qabs_p+Qabs_m, Qabs);
  }
}
#endif

TEST(BulkSphere, HandlesInput) {
  nmie::MultiLayerMie<nmie::FloatType> nmie;
  // A list of tests for a bulk sphere from
  // Hong Du, "Mie-scattering calculation," Appl. Opt. 43, 1951-1956 (2004)
  // table 1: sphere size and refractive index
  // followed by resulting extinction and scattering efficiencies
  std::vector< std::tuple< double, std::complex<double>, double, double, char > >
      parameters_and_results
      {
          // x, {Re(m), Im(m)}, Qext, Qsca, test_name
//          {0.099, {0.75,0}, 7.417859e-06, 7.417859e-06, 'a'},
//          {0.101, {0.75,0}, 8.033538e-06, 8.033538e-06, 'b'},
//          {10,    {0.75,0},     2.232265, 2.232265, 'c'},
//          {1000,  {0.75,0},     1.997908, 1.997908, 'd'},
          {100,   {1.33,1e-5}, 2.101321, 2.096594, 'e'},
//          {10000, {1.33,1e-5}, 2.004089, 1.723857, 'f'},
//          {0.055, {1.5, 1},    0.101491, 1.131687e-05, 'g'},
//          {0.056, {1.5, 1},   0.1033467, 1.216311e-05, 'h'},
//          {100,   {1.5, 1},    2.097502, 1.283697, 'i'},
//          {10000, {1.5, 1},    2.004368, 1.236574, 'j'},
//          {1,     {10,  10},   2.532993, 2.049405, 'k'},
//          {100,   {10,  10,},  2.071124, 1.836785, 'l'},
//          {10000, {10,  10},   2.005914, 1.795393, 'm'},
      };
  for (const auto &data : parameters_and_results) {
    nmie.SetLayersSize({std::get<0>(data)});
    nmie.SetLayersIndex({std::get<1>(data)});
//    nmie.SetMaxTerms(150);
    nmie.RunMieCalculation();
    double Qext = static_cast<double>(nmie.GetQext());
    double Qsca = static_cast<double>(nmie.GetQsca());
    double Qext_Du =  std::get<2>(data);
    double Qsca_Du =  std::get<3>(data);
    EXPECT_FLOAT_EQ(Qext_Du, Qext)
              << "Extinction of the bulk sphere, test case:" << std::get<4>(data)
              << "\nnmax_ = " << nmie.GetMaxTerms();
    EXPECT_FLOAT_EQ(Qsca_Du, Qsca)
              << "Scattering of the bulk sphere, test case:" << std::get<4>(data);
  }

}
int main(int argc, char **argv) {
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
