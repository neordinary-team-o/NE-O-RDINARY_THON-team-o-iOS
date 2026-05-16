//
//  FireBaseConfig.swift
//  MyPlugin
//
//  Created by Jae hyung Kim on 3/12/26.
//

import Foundation
import ProjectDescription

private let fireBaseRunScript = """
#!/bin/sh

set -euo pipefail

echo "[Script] CHECKING dSYM: ${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}"
ls -l "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}"

CRASHLYTICS_RUN_SCRIPT="${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"

if [ ! -f "$CRASHLYTICS_RUN_SCRIPT" ]; then
  CRASHLYTICS_RUN_SCRIPT="${PROJECT_DIR}/../../Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run"
fi

if [ ! -f "$CRASHLYTICS_RUN_SCRIPT" ]; then
  echo "warning: [Script] Crashlytics run script not found. Skipping upload."
  exit 0
fi

"$CRASHLYTICS_RUN_SCRIPT"
"""

let fireBaseInfoPlistScript = """
#!/bin/sh

set -euo pipefail

PATH_TO_GOOGLE_PLISTS="${SRCROOT}/AppSettingFiles/InfoPlist"

echo "[Script] Checking Dev plist path: $PATH_TO_GOOGLE_PLISTS/GoogleService-Dev-Info.plist"
echo "[Script] Checking Live plist path: $PATH_TO_GOOGLE_PLISTS/GoogleService-Live-Info.plist"
echo "[Script] Checking target resource dir: ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

case "${CONFIGURATION}" in
   "Dev")
    echo "[Script] Checking Dev MODE"
     cp "$PATH_TO_GOOGLE_PLISTS/GoogleService-Dev-Info.plist" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/GoogleService-Info.plist"
     ;;
   *)
     echo "[Script] Checking LIVE MODE"
     cp "$PATH_TO_GOOGLE_PLISTS/GoogleService-Live-Info.plist" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/GoogleService-Info.plist"
     ;;
esac
"""


extension TargetScript {
    public static let fireBase = Self.pre(
        script: fireBaseInfoPlistScript,
        name: "FirebaseInfoPlistScript",
        basedOnDependencyAnalysis: false
    )
    
    public static let fireBaseCrashlyticsRun = Self.post(
        script: fireBaseRunScript,
        name: "Firebase Crashlytics",
        inputPaths: [
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}",
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}",
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist",
            "$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist",
            "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)"
        ],
        basedOnDependencyAnalysis: false
    )
        
}

/*
 "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}",
 "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)",
*/
