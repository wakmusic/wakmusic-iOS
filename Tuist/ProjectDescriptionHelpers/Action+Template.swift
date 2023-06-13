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
    
    static let firebaseCrashlytics = TargetScript.post(
        path: .relativeToRoot("Scripts/FirebaseCrashlyticsScript.sh"),
        name: "FirebaseCrashlytics",
        inputPaths: [
          "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}",
          "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)"
        ],
        runForInstallBuildsOnly: true
    )
}
