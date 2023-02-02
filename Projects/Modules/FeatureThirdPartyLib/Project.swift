import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "FeatureThirdPartyLib",
    product: .framework,
    dependencies: [
        .SPM.Needle,
        .SPM.FlexLayout,
        .SPM.PanModal,
        .SPM.Lottie,
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.ReactorKit,
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.Kingfisher,
        .SPM.Tabman,
        .SPM.YoutubeKit,
        .SPM.RxDataSources,
        .SPM.RxKeyboard,
        .SPM.SwiftEntryKit,
        .SPM.NaverLogin
    ]
)
