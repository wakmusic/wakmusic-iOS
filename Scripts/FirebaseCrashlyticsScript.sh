#if [ "${CONFIGURATION}" != "Debug" ]; then
"../.build/checkouts/firebase-ios-sdk/Crashlytics/run"
"../.build/checkouts/firebase-ios-sdk/Crashlytics/run" -gsp ../Projects/App/Resources/GoogleService-Info.plist
"../.build/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols" -gsp ../Projects/App/Resources/GoogleService-Info.plist -p ios ${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}
#fi
