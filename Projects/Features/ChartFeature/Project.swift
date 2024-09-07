import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.ChartFeature.rawValue,
    targets: [
        .interface(
            module: .feature(.ChartFeature)
        ),
        .implements(
            module: .feature(.ChartFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .BaseFeature),
                    .feature(target: .ChartFeature, type: .interface),
                    .feature(target: .SignInFeature, type: .interface),
                    .domain(target: .ChartDomain, type: .interface)
                ]
            )
        )
    ]
)
