import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.MyInfoFeature.rawValue,
    targets: [
        .interface(module: .feature(.MyInfoFeature), dependencies: [
            .domain(target: .NoticeDomain, type: .interface),
            .domain(target: .FaqDomain, type: .interface)
        ]),
        .implements(
            module: .feature(.MyInfoFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .BaseFeature),
                    .feature(target: .MyInfoFeature, type: .interface),
                    .feature(target: .SignInFeature, type: .interface),
                    .feature(target: .FruitDrawFeature, type: .interface),
                    .feature(target: .TeamFeature, type: .interface),
                    .domain(target: .FaqDomain, type: .interface),
                    .domain(target: .NoticeDomain, type: .interface),
                    .domain(target: .AuthDomain, type: .interface),
                    .domain(target: .UserDomain, type: .interface),
                    .domain(target: .ImageDomain, type: .interface),
                    .domain(target: .NotificationDomain, type: .interface)
                ]
            )
        ),
        .testing(module: .feature(.MyInfoFeature), dependencies: [
            .feature(target: .MyInfoFeature),
            .feature(target: .MyInfoFeature, type: .interface),
            .feature(target: .BaseFeature, type: .testing),
            .feature(target: .SignInFeature, type: .testing),
            .domain(target: .FaqDomain, type: .testing),
            .domain(target: .NoticeDomain, type: .testing)
        ]),
        .tests(module: .feature(.MyInfoFeature), dependencies: [
            .feature(target: .MyInfoFeature)
        ]),
        .demo(module: .feature(.MyInfoFeature), dependencies: [
            .feature(target: .MyInfoFeature, type: .testing)
        ])
    ]
)
