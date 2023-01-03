import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToFeature(_ path: String) -> Self {
        return .relativeToRoot("Projects/Features/\(path)")
    }
    static func relativeToSections(_ path: String) -> Self {
        return .relativeToRoot("Projects/\(path)")
    }
    static func relativeToModule(_ path: String) -> Self {
        return .relativeToRoot("Projects/Modules/\(path)")
    }
    static func relativeToService(_ path: String) -> Self {
        return .relativeToRoot("Projects/Services/\(path)")
    }
    static func relativeToUserInterfaces(_ path: String) -> Self {
        return .relativeToRoot("Projects/UsertInterfaces/\(path)")
    }
    static var app: Self {
        return .relativeToRoot("Projects/App")
    }
}

public extension TargetDependency {
    static func module(name: String) -> Self {
        return .project(target: name, path: .relativeToModule(name))
    }
    static func service(name: String) -> Self {
        return .project(target: name, path: .relativeToService(name))
    }
    static func feature(name: String) -> Self {
        return .project(target: name, path: .relativeToFeature(name))
    }
    static func ui(name: String) -> Self {
        return .project(target: name, path: .relativeToUserInterfaces(name))
    }
}
