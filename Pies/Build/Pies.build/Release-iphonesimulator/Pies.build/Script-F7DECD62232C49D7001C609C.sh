#!/bin/sh
#!/bin/sh

# Step 1: Define Macros
RELEASE_TYPE=""
FRAMEWORK_VERSION="NOTRIAL_VERSION"

# Step 2: Define OS and directories
END_FOLDER="iOS-Universal-Framework"
UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal
UNIVERSAL_FRAMEWORKFOLDER=${PROJECT_NAME}${RELEASE_TYPE}/${END_FOLDER}
DEVICE_OS="iphoneos"
DEVICE_SIMULATOR="iphonesimulator"

# Step 3: Make sure the output directories exists
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"
mkdir -p "${UNIVERSAL_FRAMEWORKFOLDER}"

# Step 4: Build Device and Simulator versions
# See: https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/xcodebuild.1.html
xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk ${DEVICE_OS}  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" OTHER_SWIFT_FLAGS="-D ${FRAMEWORK_VERSION}" clean build
xcodebuild -target "${PROJECT_NAME}" VALID_ARCHS="x86_64 i386" -configuration ${CONFIGURATION} -sdk ${DEVICE_SIMULATOR} ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" OTHER_SWIFT_FLAGS="-D ${FRAMEWORK_VERSION}" clean build

# Step 5: Copy the framework structure (from iphoneos build) to the universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-${DEVICE_OS}/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

# Step 6: Copy Swift modules from iphonesimulator build (if it exists) to the copied framework directory
SIMULATOR_SWIFT_MODULES_DIR="${BUILD_DIR}/${CONFIGURATION}-${DEVICE_SIMULATOR}/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/."
if [ -d "${SIMULATOR_SWIFT_MODULES_DIR}" ]; then
cp -R "${SIMULATOR_SWIFT_MODULES_DIR}" "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule"
fi

# Step 7: Create universal binary file using lipo and place the combined executable in the copied framework directory
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-${DEVICE_SIMULATOR}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-${DEVICE_OS}/${PROJECT_NAME}.framework/${PROJECT_NAME}"

# Step 8: Convenience step to copy the framework to the project's directory
cp -R "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework" "${UNIVERSAL_FRAMEWORKFOLDER}/"

# Step 9: Convenience step to open the project's directory in Finder
open "${UNIVERSAL_FRAMEWORKFOLDER}/"

# Step 10: Testing
# open "${UNIVERSAL_OUTPUTFOLDER}"

