import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "ArtistFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Features.PlayerFeature
    ]
    , resources: ["Resources/**"]
)
