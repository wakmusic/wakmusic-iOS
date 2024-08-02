import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.CreditSongListFeature.rawValue,
    targets: [
        .interface(module: .feature(.CreditSongListFeature)),
        .implements(module: .feature(.CreditSongListFeature), dependencies: [
            .feature(target: .BaseFeature),
            .feature(target: .CreditSongListFeature, type: .interface),
            .feature(target: .SignInFeature, type: .interface),
            .domain(target: .CreditDomain, type: .interface)
        ]),
        .testing(module: .feature(.CreditSongListFeature), dependencies: [
            .feature(target: .CreditSongListFeature, type: .interface)
        ]),
        .tests(module: .feature(.CreditSongListFeature), dependencies: [
            .feature(target: .CreditSongListFeature)
        ]),
        .demo(module: .feature(.CreditSongListFeature), dependencies: [
            .feature(target: .CreditSongListFeature),
            .domain(target: .CreditDomain, type: .testing)
        ])
    ]
)
