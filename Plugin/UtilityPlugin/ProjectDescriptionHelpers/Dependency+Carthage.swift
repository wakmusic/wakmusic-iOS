import ProjectDescription

public extension TargetDependency {
    struct Carthage {}
}

public extension TargetDependency.Carthage {
    static let Realm = TargetDependency.external(name: "Realm")
    static let RealmSwift = TargetDependency.external(name: "RealmSwift")
}
