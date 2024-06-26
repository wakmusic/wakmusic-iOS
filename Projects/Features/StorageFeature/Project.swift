import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.StorageFeature.rawValue,
    targets: [
        .interface(module: .feature(.StorageFeature)),
        .implements(
            module: .feature(.StorageFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .SignInFeature),
                    .feature(target: .PlaylistFeature, type: .interface),
                    .feature(target: .StorageFeature, type: .interface),
                    .feature(target: .FruitDrawFeature, type: .interface),
                    .domain(target: .FaqDomain, type: .interface),
                    .domain(target: .NoticeDomain, type: .interface),
                    .domain(target: .PlaylistDomain, type: .interface),
                    .domain(target: .UserDomain, type: .interface),
                ]
            )
        )
    ]
)
