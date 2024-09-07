import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.PlaylistFeature.rawValue,
    targets: [
        .interface(module: .feature(.PlaylistFeature), dependencies: [
            .feature(target: .BaseFeature, type: .interface)

        ]),
        .implements(
            module: .feature(.PlaylistFeature), dependencies: [
                .feature(target: .BaseFeature),
                .feature(target: .PlaylistFeature, type: .interface),
                .feature(target: .SignInFeature, type: .interface),
                .domain(target: .AuthDomain, type: .interface),
                .domain(target: .PlaylistDomain, type: .interface),
                .domain(target: .ImageDomain, type: .interface)
            ]
        ),
        .testing(module: .feature(.PlaylistFeature), dependencies: [
            .feature(target: .PlaylistFeature, type: .interface)
        ]),
        .tests(module: .feature(.PlaylistFeature), dependencies: [
            .feature(target: .PlaylistFeature)
        ]),
        .demo(module: .feature(.PlaylistFeature), dependencies: [
            .feature(target: .PlaylistFeature)
        ])
    ]
)
