import ProjectDescription

public extension TargetDependency {
    struct XCFramework {}
}

public extension TargetDependency.XCFramework {
    static let Realm = TargetDependency.xcframework(path: "Frameworks/Realm.xcframework")
    static let RealmSwift = TargetDependency.xcframework(path: "Frameworks/RealmSwift.xcframework")
}
