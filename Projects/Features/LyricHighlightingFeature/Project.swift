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
                .feature(target: .PlayerFeature),
                .feature(target: .LyricHighlightingFeature, type: .interface)
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