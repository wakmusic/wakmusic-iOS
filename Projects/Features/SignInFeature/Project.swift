import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.SignInFeature.rawValue,
    targets: [
        .implements(
            module: .feature(.SignInFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .PlayerFeature),
                    .domain(target: .AuthDomain, type: .interface)
                ]
            )
        )
    ]
)
