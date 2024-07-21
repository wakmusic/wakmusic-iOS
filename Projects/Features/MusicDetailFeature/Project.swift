import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.MusicDetailFeature.rawValue,
    targets: [
        .interface(module: .feature(.MusicDetailFeature)),
        .implements(module: .feature(.MusicDetailFeature), dependencies: [
            .feature(target: .MusicDetailFeature, type: .interface),
            .feature(target: .BaseFeature),
            .feature(target: .LyricHighlightingFeature, type: .interface),
            .domain(target: .SongsDomain, type: .interface),
            .feature(target: .SongCreditFeature, type: .interface)
        ]),
        .tests(module: .feature(.MusicDetailFeature), dependencies: [
            .feature(target: .MusicDetailFeature)
        ]),
        .demo(module: .feature(.MusicDetailFeature), dependencies: [
            .feature(target: .MusicDetailFeature),
            .domain(target: .SongsDomain, type: .testing)
        ])
    ]
)
