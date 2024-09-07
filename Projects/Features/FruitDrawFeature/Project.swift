import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.FruitDrawFeature.rawValue,
    targets: [
        .interface(module: .feature(.FruitDrawFeature)),
        .implements(
            module: .feature(.FruitDrawFeature),
            dependencies: [
                .feature(target: .FruitDrawFeature, type: .interface),
                .feature(target: .BaseFeature),
                .domain(target: .UserDomain, type: .interface),
                .domain(target: .AuthDomain, type: .interface)
            ]
        ),
        .demo(
            module: .feature(.FruitDrawFeature),
            dependencies: [
                .feature(target: .FruitDrawFeature)
            ]
        )
    ]
)
