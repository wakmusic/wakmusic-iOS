import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "FeatureThirdPartyLib",
    product: .framework,
    packages: [
        .YouTubePlayerKit
    ],
    dependencies: [
        .SPM.Needle,
        .SPM.PanModal,
        .SPM.Lottie,
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.Kingfisher,
        .SPM.Tabman,
        .SPM.RxDataSources,
        .SPM.RxKeyboard,
        .SPM.SwiftEntryKit,
        .SPM.CryptoSwift,
        .SPM.YouTubePlayerKit,
        .SPM.MarqueeLabel,
        .SPM.NVActivityIndicatorView
    ]
)
