import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.PlaylistFeature.rawValue,
    targets: [
        .interface(module: .feature(.PlaylistFeature)),
        .implements(
            module: .feature(.PlaylistFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .BaseFeature),
                    .feature(target: .PlaylistFeature, type: .interface)
                ]
            )
        ),
        .testing(module: .feature(.PlaylistFeature), dependencies: [
            .feature(target: .PlaylistFeature, type: .interface)
        ]),
        .tests(module: .feature(.PlaylistFeature), dependencies: [
            .feature(target: .PlaylistFeature)
        ])
    ]
)
