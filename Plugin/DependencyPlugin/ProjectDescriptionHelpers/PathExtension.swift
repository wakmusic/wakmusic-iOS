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
    static func relativeToDomain(_ path: String) -> Self {
        return .relativeToRoot("Projects/Domains/\(path)")
    }
    static var app: Self {
        return .relativeToRoot("Projects/App")
    }
}

