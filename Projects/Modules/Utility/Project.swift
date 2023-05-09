import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Utility",
    product: .staticFramework,
    dependencies: [
        .Project.Module.ThirdPartyLib
    ]
)
