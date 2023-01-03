import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "DomainModule",
    product: .staticFramework,
    dependencies: [
        .Project.Module.ThirdPartyLib
    ]
)
