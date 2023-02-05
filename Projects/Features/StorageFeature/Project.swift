import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "StorageFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Features.SignInFeature
    ]
    , resources: ["Resources/**"]
)
