import ProjectDescription

public extension TargetDependency {
    struct Project {
        public struct Module {}
        public struct Service {}
    }
}

public extension TargetDependency.Project.Module {
    static let KeychainModule = TargetDependency.module(name: "KeychainModule")
    static let ErrorModule = TargetDependency.module(name: "ErrorModule")
    static let UtilityModule = TargetDependency.module(name: "UtilityModule")
}

public extension TargetDependency.Project.Service {
    static let APIModule = TargetDependency.service(name: "APIModule")
    static let DataMappingModule = TargetDependency.service(name: "DataMappingModule")
    static let DataModule = TargetDependency.service(name: "DataModule")
    static let DatabaseModule = TargetDependency.service(name: "DatabaseModule")
    static let NetworkModule = TargetDependency.service(name: "NetworkModule")
    static let DomainModule = TargetDependency.service(name: "DomainModule")
}
