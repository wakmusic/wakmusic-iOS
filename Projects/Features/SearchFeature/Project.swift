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
                    .feature(target: .BaseFeature),
                    .feature(target: .SearchFeature, type: .interface),
                    .feature(target: .PlaylistFeature, type: .interface),
                    .feature(target: .SignInFeature, type: .interface),
                    .domain(target: .SearchDomain, type: .interface),
                    .domain(target: .ChartDomain, type: .interface)
                ]
            )
        ),
        .tests(module: .feature(.SearchFeature), dependencies: [
            .feature(target: .SearchFeature),
            .domain(target: .PlaylistDomain, type: .testing)
        ]),

        .demo(module: .feature(.SearchFeature), dependencies: [
            .feature(target: .SearchFeature),
            .domain(target: .PlaylistDomain, type: .testing),
            .feature(target: .PlaylistFeature, type: .testing)
        ])
    ]
)
