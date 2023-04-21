import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "MainTabFeature",
    product: .staticFramework,
    packages: [
        .RealmSwift
    ],
    dependencies: [
        .Project.Features.BaseFeature,
        .Project.Features.HomeFeature,
        .Project.Features.ChartFeature,
        .Project.Features.SearchFeature,
        .Project.Features.ArtistFeature,
        .Project.Features.StorageFeature,
        .Project.Features.PlayerFeature,
        .SPM.RealmSwift
    ]
    , resources: ["Resources/**"]
)
