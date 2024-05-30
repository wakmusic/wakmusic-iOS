import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.MyInfoFeature.rawValue,
    targets: [
        .interface(module: .feature(.MyInfoFeature)),
        .implements(module: .feature(.MyInfoFeature), dependencies: [
            .feature(target: .BaseFeature),
            .feature(target: .MyInfoFeature, type: .interface),
            .feature(target: .SignInFeature, type: .interface),
            .domain(target: .FaqDomain, type: .interface),
            .domain(target: .NoticeDomain, type: .interface),
            .domain(target: .AuthDomain, type: .interface),
            .domain(target: .UserDomain, type: .interface)
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
