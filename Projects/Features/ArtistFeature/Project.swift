import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.ArtistFeature.rawValue,
    targets: [
        .interface(
            module: .feature(.ArtistFeature),
            dependencies: [.domain(target: .ArtistDomain, type: .interface)]
        ),
        .implements(
            module: .feature(.ArtistFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .BaseFeature),
                    .feature(target: .ArtistFeature, type: .interface),
                    .feature(target: .SignInFeature, type: .interface),
                    .domain(target: .ArtistDomain, type: .interface)
                ]
            )
        ),
        .tests(module: .feature(.ArtistFeature), dependencies: [
            .feature(target: .ArtistFeature),
            .domain(target: .ArtistDomain, type: .testing)
        ])
    ]
)
