import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "UtilityModule",
    product: .staticFramework,
    dependencies: [
        .Project.Module.ErrorModule,
        .SPM.Kingfisher,
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.Then,
        .SPM.YouTubePlayerKit,
        .SPM.YoutubeKit
    ]
)
