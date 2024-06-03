import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.SearchFeature.rawValue,
    targets: [
        .interface(module: .feature(.SearchFeature), dependencies: [
            .feature(target: .BaseFeature, type: .interface)
        ]),
        .implements(
            module: .feature(.SearchFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .PlayerFeature),
                    .feature(target: .SearchFeature, type: .interface),
                    .feature(target: .PlaylistFeature, type: .interface),
                    .domain(target: .SongsDomain, type: .interface),
                ]
            )
        ),
        .tests(module: .feature(.SearchFeature), dependencies: [
            .feature(target: .SearchFeature),
            .domain(target: .PlayListDomain, type: .testing)
        ]),

        .demo(module: .feature(.SearchFeature), dependencies: [
            .feature(target: .SearchFeature),
            .domain(target: .PlayListDomain, type: .testing)
        ])
    ]
)
