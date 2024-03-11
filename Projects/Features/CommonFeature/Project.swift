import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.CommonFeature.rawValue,
    targets: [
        .implements(
            module: .feature(.CommonFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .BaseFeature),
                    .domain(target: .PlayListDomain, type: .interface),
                    .domain(target: .UserDomain, type: .interface)
                ]
            )
        )
    ]
)
