import ProjectDescription

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
    
    static let firebaseCrashlytics = TargetScript.pre(
        path: .relativeToRoot("Scripts/FirebaseCrashlyticsScript.sh"),
        name: "FirebaseCrashlytics",
        inputPaths: [
            Path("${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}"),
            Path("$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)"),
        ]
    )
}
