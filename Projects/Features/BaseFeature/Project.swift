import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.BaseFeature.rawValue,
    targets: [
        .implements(
            module: .feature(.BaseFeature),
            product: .staticFramework,
            spec: .init(
                dependencies: [
                    .domain(target: .BaseDomain, type: .interface),
                    .Project.Module.FeatureThirdPartyLib,
                    .Project.UserInterfaces.DesignSystem,
                    .Project.Module.Utility
                ]
            )
        )
    ]
)

