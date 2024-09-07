import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.HomeFeature.rawValue,
    targets: [
        .interface(
            module: .feature(.HomeFeature),
            dependencies: []
        ),
        .implements(
            module: .feature(.HomeFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .BaseFeature),
                    .feature(target: .HomeFeature, type: .interface),
                    .feature(target: .ChartFeature, type: .interface),
                    .feature(target: .PlaylistFeature, type: .interface),
                    .feature(target: .SignInFeature, type: .interface),
                    .domain(target: .ChartDomain, type: .interface),
                    .domain(target: .SongsDomain, type: .interface),
                ]
            )
        )
    ]
)
