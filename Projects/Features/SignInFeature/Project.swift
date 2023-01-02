import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "SignInFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Features.BaseFeature
    ]
    , resources: ["Resources/**"]
)
