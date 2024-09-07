import ProjectDescription

public extension TargetDependency {
    struct XCFramework {}
}

public extension TargetDependency.XCFramework {
    static let Realm = TargetDependency.xcframework(
        path: .relativeToRoot("Carthage/Build/Realm.xcframework"),
        status: .required,
        condition: .when([.ios])
    )
    static let RealmSwift = TargetDependency.xcframework(
        path: .relativeToRoot("Carthage/Build/RealmSwift.xcframework"),
        status: .required,
        condition: .when([.ios])
    )
}
