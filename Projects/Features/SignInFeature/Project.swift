import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

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
