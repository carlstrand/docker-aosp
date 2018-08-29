#!/bin/sh

################################################################################
# BUILD SCRIPT
#
# ${1}: device codename (e.g., sirius)
# ${2}: build type (e.g., userdebug)
# ${3}: rom build type (e.g., HOMEMADE)
# Optional ${4}: command passed to AOSP make (e.g., build AOSP module)
################################################################################

#=================================#
# PARAMETER NAMING                #
#=================================#
export DEVICE_NAME=${1}
export BUILD_TYPE=${2}
export ROM_BUILD_TYPE=${3}
export PARAM_NUM_REQ=3
export PARAM_NUM_PASSED=$#

#=================================#
# CONFIG SECTION                  #
#=================================#

# Directory of the AOSP TREE
export BASE_DIR=omni
export FULL_DIR=/mnt/android/${BASE_DIR}

# Output directory of the target device
export OUT_DEVICE="${FULL_DIR}/out/target/product/${DEVICE_NAME}"

# Enable ccache; The directory will be named "ccache/[device]" in the mounted
# android volume.
export USE_CCACHE=1
prebuilts/misc/linux-x86/ccache/ccache -M 50G
export CCACHE_DIR=/mnt/android/ccache/${DEVICE_NAME}

# Generate a compile_commands.json file to aid code navigation.
export SOONG_GEN_COMPDB=1
export SOONG_LINK_COMPDB_TO=$ANDROID_BUILD_TOP

# Number of threads to use for building. Default: #(logical cores) - 1
export THREAD_NUM=$(($(nproc) - 1))

#=================================#
# BUILD SETUP                     #
#=================================#

cd "${FULL_DIR}"

#source venv/bin/activate
source build/envsetup.sh


# Cleanup steps to trigger re-copying of files. The make system handles source
# file changes.
rm -rf ${OUT_DEVICE}/cache
rm -rf ${OUT_DEVICE}/data
rm -rf ${OUT_DEVICE}/recovery
rm -rf ${OUT_DEVICE}/root
rm -rf ${OUT_DEVICE}/system
rm -rf ${OUT_DEVICE}/*.zip
rm -rf ${FULL_DIR}/out/dist/*

#=================================#
# EXECUTE THE BUILD CMD           #
#=================================#

if [ ${PARAM_NUM_PASSED} -eq ${PARAM_NUM_REQ} ]; then
	lunch omni_${DEVICE_NAME}-${BUILD_TYPE}
	make -j${THREAD_NUM} otapackage
else
	lunch omni_${DEVICE_NAME}-${BUILD_TYPE}
	make -j${THREAD_NUM} ${4}
fi


