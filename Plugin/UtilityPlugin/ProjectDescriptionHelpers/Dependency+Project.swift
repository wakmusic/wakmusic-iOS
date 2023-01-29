import ProjectDescription

public extension TargetDependency {
    struct Project {
        public struct Features {}
        public struct Module {}
        public struct Service {}
        public struct UserInterfaces {}
    }
}

public extension TargetDependency.Project.Features {
    static let PlayerFeature = TargetDependency.feature(name: "PlayerFeature")
    static let StorageFeature = TargetDependency.feature(name: "StorageFeature")
    static let SignInFeature = TargetDependency.feature(name: "SignInFeature")
    static let HomeFeature = TargetDependency.feature(name: "HomeFeature")
    static let ChartFeature = TargetDependency.feature(name: "ChartFeature")
    static let SearchFeature = TargetDependency.feature(name: "SearchFeature")
    static let MainTabFeature = TargetDependency.feature(name: "MainTabFeature")
    static let ArtistFeature = TargetDependency.feature(name: "ArtistFeature")
    static let BaseFeature = TargetDependency.feature(name: "BaseFeature")
    static let RootFeature = TargetDependency.feature(name: "RootFeature")
}

public extension TargetDependency.Project.Module {
    static let FeatureThirdPartyLib = TargetDependency.module(name: "FeatureThirdPartyLib")
    static let ThirdPartyLib = TargetDependency.module(name: "ThirdPartyLib")
    static let Utility = TargetDependency.module(name: "Utility")
    static let KeychainModule = TargetDependency.module(name: "KeychainModule")
    static let ErrorModule = TargetDependency.module(name: "ErrorModule")
}

public extension TargetDependency.Project.Service {
    static let APIKit = TargetDependency.service(name: "APIKit")
    static let Data = TargetDependency.service(name: "DataModule")
    static let Domain = TargetDependency.service(name: "DomainModule")
    static let DatabaseModule = TargetDependency.service(name: "DatabaseModule")
    static let DataMappingModule = TargetDependency.service(name: "DataMappingModule")
    static let NetworkModule = TargetDependency.service(name: "NetworkModule")
}

public extension TargetDependency.Project.UserInterfaces {
    static let DesignSystem = TargetDependency.ui(name: "DesignSystem")
}
