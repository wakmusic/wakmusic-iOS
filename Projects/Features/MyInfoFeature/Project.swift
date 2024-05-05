import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.MyInfoFeature.rawValue,
    targets: [
        .interface(module: .feature(.MyInfoFeature)),
        .implements(module: .feature(.MyInfoFeature), dependencies: [
            .feature(target: .MyInfoFeature, type: .interface)
        ]),
        .testing(module: .feature(.MyInfoFeature), dependencies: [
            .feature(target: .MyInfoFeature, type: .interface)
        ]),
        .tests(module: .feature(.MyInfoFeature), dependencies: [
            .feature(target: .MyInfoFeature)
        ]),
        .demo(module: .feature(.MyInfoFeature), dependencies: [
            .feature(target: .MyInfoFeature)
        ])
    ]
)
