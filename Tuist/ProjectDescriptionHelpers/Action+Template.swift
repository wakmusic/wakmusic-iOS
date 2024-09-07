import ProjectDescription
import Foundation

public extension TargetScript {
    static let swiftLint = TargetScript.pre(
        path: Path.relativeToRoot("Scripts/SwiftLintRunScript.sh"),
        name: "SwiftLint",
        basedOnDependencyAnalysis: false
    )

    static let needle = TargetScript.pre(
        path: .relativeToRoot("Scripts/NeedleRunScript.sh"),
        name: "Needle",
        basedOnDependencyAnalysis: false
    )

    static let firebaseInfoByConfiguration = TargetScript.post(
        script: """
            case "${CONFIGURATION}" in
              "Release" )
                cp -r "$SRCROOT/Resources/GoogleService-Info.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
                ;;
              *)
                cp -r "$SRCROOT/Resources/GoogleService-Info-QA.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
                ;;
            esac

            """,
        name: "Firebase Info copy by Configuration",
        basedOnDependencyAnalysis: false
    )
    
    static let firebaseCrashlytics = TargetScript.post(
        script:
            """
            ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
            "${ROOT_DIR}/.build/checkouts/firebase-ios-sdk/Crashlytics/run"
            """
        ,
        name: "FirebaseCrashlytics",
        inputPaths: [
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}",
            "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)"
        ],
        basedOnDependencyAnalysis: false
    )
}
