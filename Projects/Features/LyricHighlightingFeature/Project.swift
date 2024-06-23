import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.LyricHighlightingFeature.rawValue,
    targets: [
        .interface(
            module: .feature(.LyricHighlightingFeature)
        ),
        .implements(
            module: .feature(.LyricHighlightingFeature),
            dependencies: [
                .feature(target: .BaseFeature),
                .feature(target: .LyricHighlightingFeature, type: .interface),
                .domain(target: .SongsDomain, type: .interface),
                .domain(target: .ImageDomain, type: .interface)
            ]
        ),
        .tests(
            module: .feature(.LyricHighlightingFeature),
            dependencies: [.feature(target: .LyricHighlightingFeature)]
        ),
        .demo(
            module: .feature(.LyricHighlightingFeature),
            dependencies: [
                .feature(target: .LyricHighlightingFeature)
            ]
        )
    ]
)
