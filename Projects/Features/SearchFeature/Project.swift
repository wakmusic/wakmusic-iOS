import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.SearchFeature.rawValue,
    targets: [
        .implements(
            module: .feature(.SearchFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .PlayerFeature),
                    .feature(target: .PlaylistFeature, type: .interface),
                    .domain(target: .SongsDomain, type: .interface),
                    
                ]
            )
        )
    ]
)
