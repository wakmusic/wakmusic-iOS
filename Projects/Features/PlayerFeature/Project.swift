import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.PlayerFeature.rawValue,
    targets: [
        .implements(
            module: .feature(.PlayerFeature),
            product: .staticFramework,
            spec: .init(
                dependencies: [
                    .feature(target: .CommonFeature),
                    .domain(target: .LikeDomain, type: .interface)
                ]
            )
        )
    ]
)
