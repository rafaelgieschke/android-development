# Copyright (C) 2021 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
LOCAL_PATH := $(call my-dir)

KMI_CHK_SCRIPT := $(LOCAL_PATH)/kmi_compatibility_test.sh

# Current kernel symbol files to be checked
# Use the one under $(LOCAL_PATH)/sym-[56].* by default for self testing.
# The reason not to use the one under kernel/prebuilts/5.* by default
# is because the KMI ABI may not be stable during development.
#
# Set CURR_5_15_SYMVERS/CURR_6_1_SYMVERS explicitly for the actual
# current kernel symbol file to be checked. E.g.,
# $ m CURR_6_1_SYMVERS=kernel/prebuilts/6.1/arm64/Module.symvers \
#     gki_6_1_kmi_compatibility_test
CURR_5_15_SYMVERS ?= development/gki/kmi_abi_chk/sym-5.15/Module.symvers
CURR_6_1_SYMVERS ?= development/gki/kmi_abi_chk/sym-6.1/Module.symvers

# Previous kernel symbol files, against which the latest one is checked
# The file names of previous kernel symbol files are of this form:
#     *.symvers-$(BID)
# Here *.symvers is a symbolic link to the latest build.
PREV_5_15_SYMVERS := $(LOCAL_PATH)/sym-5.15/Module.symvers
PREV_6_1_SYMVERS := $(LOCAL_PATH)/sym-6.1/Module.symvers

include $(CLEAR_VARS)
LOCAL_MODULE := a14_5_15_kmi_compatibility_test
LOCAL_MODULE_CLASS := FAKE
LOCAL_MODULE_TAGS := optional
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): $(KMI_CHK_SCRIPT) $(CURR_5_15_SYMVERS) $(PREV_5_15_SYMVERS)
	@mkdir -p $(dir $@)
	$(hide) $(KMI_CHK_SCRIPT) $(CURR_5_15_SYMVERS) $(PREV_5_15_SYMVERS)
	$(hide) touch $@

include $(CLEAR_VARS)
LOCAL_MODULE := a14_6_1_kmi_compatibility_test
LOCAL_MODULE_CLASS := FAKE
LOCAL_MODULE_TAGS := optional
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): $(KMI_CHK_SCRIPT) $(CURR_6_1_SYMVERS) $(PREV_6_1_SYMVERS)
	@mkdir -p $(dir $@)
	$(hide) $(KMI_CHK_SCRIPT) $(CURR_6_1_SYMVERS) $(PREV_6_1_SYMVERS)
	$(hide) touch $@

include $(CLEAR_VARS)
LOCAL_MODULE := a14_kmi_compatibility_test
LOCAL_REQUIRED_MODULES := a14_5_15_kmi_compatibility_test a14_6_1_kmi_compatibility_test
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
include $(BUILD_PHONY_PACKAGE)
