import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(name: ModulePaths.Feature.StorageFeature.rawValue, targets: [

    .implements(
        module: .feature(.StorageFeature),
        product: .staticFramework,
        spec: .init(resources: ["Resources/**"],
                    dependencies: [.feature(target: .SignInFeature)]))
    
])


