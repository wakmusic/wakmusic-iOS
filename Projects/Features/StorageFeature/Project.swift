import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(name: ModulePaths.Feature.StorageFeature.rawValue, targets: [

//    .interface(module: .feature(.StorageFeature),dependencies: [
//    
//        .feature(target: .StorageFeature, type: .interface)
//    ]),
    
    .implements(
        module: .feature(.StorageFeature),
        product: .staticFramework,
        spec: .init(resources: ["Resources/**"],
                    dependencies: [.feature(target: .SignInFeature)]))
    
])

//let project = Project.makeModule(
//    name: "StorageFeature",
//    product: .staticFramework,
//    dependencies: [
//        .Project.Features.SignInFeature
//    ]
//    , resources: ["Resources/**"]
//)
