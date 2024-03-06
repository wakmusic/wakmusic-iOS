import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Feature.RootFeature.rawValue,
    targets: [
        .implements(
            module: .feature(.RootFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [.feature(target: .BaseFeature),
                               .feature(target: .MainTabFeature),
                               .domain(target: .AppDomain, type: .interface)]
            )
        )
    ]
)
