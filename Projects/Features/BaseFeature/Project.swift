import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "BaseFeature",
    product: .staticFramework,
    packages: [
        .RealmSwift
    ],
    dependencies: [
        .Project.Service.Domain,
        .Project.Module.FeatureThirdPartyLib,
        .Project.UserInterfaces.DesignSystem,
        .Project.Module.Utility,
        .SPM.RealmSwift
    ]
)
