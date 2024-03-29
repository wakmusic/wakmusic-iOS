import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.StorageFeature.rawValue,
    targets: [
        .implements(
            module: .feature(.StorageFeature),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .feature(target: .SignInFeature),
                    .domain(target: .FaqDomain, type: .interface),
                    .domain(target: .NoticeDomain, type: .interface),
                    .domain(target: .PlayListDomain, type: .interface),
                    .domain(target: .UserDomain, type: .interface)
                ]
            )
        )
    ]
)
