import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.HomeFeature.rawValue,
    targets: [
        .implements(
            module: .feature(.HomeFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .BaseFeature),
                    .feature(target: .PlaylistFeature, type: .interface),
                    .feature(target: .MusicDetailFeature, type: .interface),
                    .domain(target: .ChartDomain, type: .interface),
                    .domain(target: .SongsDomain, type: .interface),
                ]
            )
        )
    ]
)
