import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

#warning("에러 모듈위치 변경 필요")
let project = Project.module(
    name: ModulePaths.Feature.BaseFeature.rawValue,
    targets: [
        .interface(module: .feature(.BaseFeature)),
        .implements(
            module: .feature(.BaseFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .BaseFeature, type: .interface),
                    .domain(target: .BaseDomain, type: .interface),
                    .domain(target: .AuthDomain, type: .interface),
                    .domain(target: .PlaylistDomain, type: .interface),
                    .domain(target: .UserDomain, type: .interface),
                    .domain(target: .NoticeDomain, type: .interface),
                    .domain(target: .PriceDomain, type: .interface),
                    .module(target: .ErrorModule),
                    .module(target: .FeatureThirdPartyLib),
                    .userInterface(target: .DesignSystem),
                    .module(target: .Utility),
                    .SPM.RxGesture,
                ]
            )
        ),
        .testing(
            module: .feature(.BaseFeature),
            dependencies: [
                .feature(target: .BaseFeature),
                .feature(target: .BaseFeature, type: .interface),
                .domain(target: .BaseDomain, type: .testing)
            ]
        )
    ]
)
