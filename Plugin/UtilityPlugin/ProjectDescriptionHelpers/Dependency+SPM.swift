import ProjectDescription

public extension TargetDependency {
    struct SPM {}
}

public extension TargetDependency.SPM {
    static let Moya = TargetDependency.external(name: "Moya")
    static let RxMoya = TargetDependency.external(name: "RxMoya")
    static let Kingfisher = TargetDependency.external(name: "Kingfisher")
    static let YoutubeKit = TargetDependency.external(name: "YoutubeKit")
    static let YouTubePlayerKit = TargetDependency.external(name: "YouTubePlayerKit")
    static let RxSwift = TargetDependency.external(name: "RxSwift")
    static let RxCocoa = TargetDependency.external(name: "RxCocoa")
    static let Snapkit = TargetDependency.external(name: "Snapkit")
    static let Then = TargetDependency.external(name: "Then")
    static let Needle = TargetDependency.external(name: "NeedleFoundation")
}

public extension Package {
}
