import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.TeamFeature.rawValue,
    targets: [
        .interface(
            module: .feature(.TeamFeature),
            dependencies: [
                .domain(target: .TeamDomain, type: .interface)
            ]
        ),
        .implements(
            module: .feature(.TeamFeature),
            dependencies: [
                .feature(target: .TeamFeature, type: .interface),
                .feature(target: .BaseFeature),
                .domain(target: .TeamDomain, type: .interface)
            ]
        ),
        .demo(
            module: .feature(.TeamFeature),
            dependencies: [
                .feature(target: .TeamFeature)
            ]
        )
    ]
)
