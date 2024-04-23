import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Utility",
    product: .staticFramework,
    dependencies: [
        .module(target: .LogManager),
        .Project.Module.ThirdPartyLib
    ]
)
