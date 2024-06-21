import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.ChartFeature.rawValue,
    targets: [
        .implements(
            module: .feature(.ChartFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .BaseFeature),
                    .domain(target: .ChartDomain, type: .interface)
                ]
            )
        )
    ]
)
