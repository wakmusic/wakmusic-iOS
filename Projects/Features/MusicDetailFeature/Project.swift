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
            .feature(target: .SongCreditFeature, type: .interface),
            .feature(target: .SignInFeature, type: .interface),
            .feature(target: .ArtistFeature, type: .interface),
            .domain(target: .SongsDomain, type: .interface),
            .domain(target: .LikeDomain, type: .interface),
            .domain(target: .ArtistDomain, type: .interface)
        ]),
        .tests(module: .feature(.MusicDetailFeature), dependencies: [
            .feature(target: .MusicDetailFeature),
            .domain(target: .SongsDomain, type: .testing),
            .domain(target: .LikeDomain, type: .testing),
            .domain(target: .ArtistDomain, type: .testing)
        ]),
        .demo(module: .feature(.MusicDetailFeature), dependencies: [
            .feature(target: .MusicDetailFeature),
            .domain(target: .SongsDomain, type: .testing),
            .domain(target: .LikeDomain, type: .testing),
            .domain(target: .ArtistDomain, type: .testing)
        ])
    ]
)
