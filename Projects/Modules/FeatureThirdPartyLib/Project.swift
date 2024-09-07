import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.FeatureThirdPartyLib.rawValue,
    packages: [],
    targets: [
        .implements(module: .module(.FeatureThirdPartyLib), product: .framework, dependencies: [
            .SPM.Needle,
            .SPM.FittedSheets,
            .SPM.Lottie,
            .SPM.RxSwift,
            .SPM.RxCocoa,
            .SPM.SnapKit,
            .SPM.Then,
            .SPM.Kingfisher,
            .SPM.Tabman,
            .SPM.ReactorKit,
            .SPM.RxDataSources,
            .SPM.RxKeyboard,
            .SPM.SwiftEntryKit,
            .SPM.NVActivityIndicatorView
        ])
    ]
)
