import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "DesignSystem",
    product: .framework,
    dependencies: [.SPM.MarqueeLabel],
    resources: ["Resources/**"]
)
