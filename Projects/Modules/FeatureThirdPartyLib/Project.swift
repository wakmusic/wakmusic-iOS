import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "FeatureThirdPartyLib",
    product: .framework,
    dependencies: [
        .SPM.Needle
    ]
)
