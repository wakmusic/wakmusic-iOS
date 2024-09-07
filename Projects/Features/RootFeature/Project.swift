import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.RootFeature.rawValue,
    targets: [
        .implements(
            module: .feature(.RootFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .MainTabFeature),
                    .feature(target: .BaseFeature, type: .interface),
                    .domain(target: .AppDomain, type: .interface),
                    .domain(target: .UserDomain, type: .interface)
                ]
            )
        )
    ]
)
