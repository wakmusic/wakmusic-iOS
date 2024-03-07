import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Feature.ArtistFeature.rawValue,
    targets: [
        .implements(
            module: .feature(.ArtistFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .PlayerFeature),
                    .domain(target: .ArtistDomain, type: .interface)
                ]
            )
        )
    ]
)
