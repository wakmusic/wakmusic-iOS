import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.MainTabFeature.rawValue,
    targets: [
        .implements(
            module: .feature(.MainTabFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .BaseFeature),
                    .feature(target: .HomeFeature),
                    .feature(target: .ChartFeature),
                    .feature(target: .SearchFeature),
                    .feature(target: .ArtistFeature),
                    .feature(target: .StorageFeature),
                    .feature(target: .PlayerFeature),
                    .feature(target: .MyInfoFeature),
                    .feature(target: .LyricHighlightingFeature),
                    .domain(target: .NoticeDomain, type: .interface)
                ]
            )
        )
    ]
)
