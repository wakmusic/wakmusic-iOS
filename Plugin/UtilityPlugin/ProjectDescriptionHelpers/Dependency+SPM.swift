import ProjectDescription

public extension TargetDependency {
    struct SPM {}
}

public extension TargetDependency.SPM {
    static let Moya = TargetDependency.external(name: "Moya")
    static let Kingfisher = TargetDependency.external(name: "Kingfisher")
    static let YoutubeKit = TargetDependency.external(name: "YoutubeKit")
    static let YouTubePlayerKit = TargetDependency.external(name: "YouTubePlayerKit")
    static let RxSwift = TargetDependency.external(name: "RxSwift")
    static let RxCocoa = TargetDependency.external(name: "RxCocoa")
    static let Snapkit = TargetDependency.external(name: "Snapkit")
    static let Then = TargetDependency.external(name: "Then")
}

public extension Package {
}
