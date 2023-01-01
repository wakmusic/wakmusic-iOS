import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "RootFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Features.CommonFeature
    ]
    , sources: ["Sources/**",
                "Sources/**/*.xib",
                "Sources/**/*.storyboard"]
    , resources: ["Resources/**"]
)
