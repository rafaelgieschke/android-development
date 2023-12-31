// Copyright (C) 2019 The Android Open Source Project
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "utils/api_level.h"

#include <sstream>

#include <gtest/gtest.h>


namespace header_checker {
namespace utils {


TEST(ApiLevelTest, Parse) {
  std::istringstream json_stream("{\"UpsideDownCake\":9000}");
  utils::ApiLevelMap api_level_map;
  api_level_map.Load(json_stream);

  EXPECT_FALSE(api_level_map.Parse(""));
  EXPECT_FALSE(api_level_map.Parse("A"));

  EXPECT_TRUE(api_level_map.Parse("current").has_value());
  EXPECT_EQ(FUTURE_API_LEVEL, api_level_map.Parse("current").value());

  EXPECT_TRUE(api_level_map.Parse("UpsideDownCake").has_value());
  EXPECT_EQ(9000, api_level_map.Parse("UpsideDownCake").value());

  EXPECT_TRUE(api_level_map.Parse("16").has_value());
  EXPECT_EQ(16l, api_level_map.Parse("16").value());
}


}  // namespace utils
}  // namespace header_checker
