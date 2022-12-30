import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "CommonFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Service.Domain,
        .Project.Module.Utility,
        .Project.Module.FeatureThirdPartyLib,
        .Project.UserInterfaces.DesignSystem,
    ]
)
