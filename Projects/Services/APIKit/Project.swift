import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "APIKit",
    product: .staticFramework,
    dependencies: [
        .Project.Module.ThirdPartyLib
    ]
)
