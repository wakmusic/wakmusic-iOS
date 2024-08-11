import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.SongCreditFeature.rawValue,
    targets: [
        .interface(module: .feature(.SongCreditFeature)),
        .implements(module: .feature(.SongCreditFeature), dependencies: [
            .feature(target: .SongCreditFeature, type: .interface),
            .feature(target: .CreditSongListFeature, type: .interface),
            .feature(target: .ArtistFeature, type: .interface),
            .feature(target: .BaseFeature),
            .domain(target: .SongsDomain, type: .interface)
        ]),
        .testing(module: .feature(.SongCreditFeature), dependencies: [
            .feature(target: .SongCreditFeature, type: .interface)
        ]),
        .tests(module: .feature(.SongCreditFeature), dependencies: [
            .feature(target: .SongCreditFeature)
        ]),
        .demo(module: .feature(.SongCreditFeature), dependencies: [
            .feature(target: .SongCreditFeature),
            .domain(target: .SongsDomain, type: .testing)
        ])
    ]
)
