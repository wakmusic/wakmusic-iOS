import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.SignInFeature.rawValue,
    targets: [
        .interface(module: .feature(.SignInFeature)),
        .implements(
            module: .feature(.SignInFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .BaseFeature),
                    .module(target: .KeychainModule),
                    .domain(target: .AuthDomain, type: .interface),
                    .domain(target: .UserDomain, type: .interface),
                    .feature(target: .SignInFeature, type: .interface)
                ]
            )
        ),
        .testing(
            module: .feature(.SignInFeature),
            dependencies: [
                .feature(target: .SignInFeature),
                .feature(target: .SignInFeature, type: .interface),
                .domain(target: .AuthDomain, type: .testing),
                .domain(target: .UserDomain, type: .testing)
            ]
        )
    ]
)
