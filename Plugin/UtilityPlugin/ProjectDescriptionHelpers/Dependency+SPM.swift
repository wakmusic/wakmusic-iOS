import ProjectDescription

public extension TargetDependency {
    struct SPM {}
}

public extension TargetDependency.SPM {
    static let Moya = TargetDependency.external(name: "Moya")
    static let RxMoya = TargetDependency.external(name: "RxMoya")
    static let YoutubeKit = TargetDependency.external(name: "YoutubeKit")
    static let PanModal = TargetDependency.external(name: "PanModal")
    static let RxSwift = TargetDependency.external(name: "RxSwift")
    static let RxCocoa = TargetDependency.external(name: "RxCocoa")
    static let ReactorKit = TargetDependency.external(name: "ReactorKit")
    static let Kingfisher = TargetDependency.external(name: "Kingfisher")
    static let Then = TargetDependency.external(name: "Then")
    static let SnapKit = TargetDependency.external(name: "SnapKit")
    static let ReachabilitySwift = TargetDependency.external(name: "ReachabilitySwift")
    static let Lottie = TargetDependency.external(name: "Lottie")
    static let Firebase = TargetDependency.external(name: "FirebaseAnalytics")
    static let PinLayout = TargetDependency.external(name: "PinLayout")
    static let FlexLayout = TargetDependency.external(name: "FlexLayout")
    static let Quick = TargetDependency.external(name: "Quick")
    static let Nimble = TargetDependency.external(name: "Nimble")
    static let Needle = TargetDependency.external(name: "NeedleFoundation")
    static let Tabman = TargetDependency.external(name: "Tabman")
    static let RxDataSources = TargetDependency.external(name: "RxDataSources")
    static let RxKeyboard = TargetDependency.external(name: "RxKeyboard")
    static let SwiftEntryKit = TargetDependency.external(name: "SwiftEntryKit")
    static let NaverLogin = TargetDependency.external(name: "naveridlogin-ios-sp")
   // static let GoogoleLogin = TargetDependency.external(name: "GoogleSignIn")
}

public extension Package {
}
