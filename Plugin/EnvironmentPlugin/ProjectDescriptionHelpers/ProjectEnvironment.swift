import Foundation
import ProjectDescription

public struct ProjectEnvironment {
    public let previousName : String
    public let name: String
    public let organizationName: String
    @available(*, deprecated, message: "'DeploymentTarget' was deprecated, use instead of 'DeploymentTargets' and 'Destinations'")
    public let deploymentTarget: DeploymentTarget
    public let deploymentTargets: DeploymentTargets
    public let destinations : Destinations
    public let baseSetting: SettingsDictionary

   
}

public let env = ProjectEnvironment(
    previousName: "Billboardoo",
    name: "WaktaverseMusic",
    organizationName: "yongbeomkwak",
    deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
    deploymentTargets: .iOS("14.0"),
    destinations: .iOS,
    baseSetting: SettingsDictionary()
        .marketingVersion("2.2.2")
        .currentProjectVersion("0")
        .debugInformationFormat(DebugInformationFormat.dwarfWithDsym)
        .otherLinkerFlags(["-ObjC"])
        .bitcodeEnabled(false)
)

