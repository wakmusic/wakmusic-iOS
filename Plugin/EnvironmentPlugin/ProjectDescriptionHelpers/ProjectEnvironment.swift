//
//  ProjectEnvironment.swift
//  UtilityPlugin
//
//  Created by yongbeomkwak on 2/17/24.
//

import Foundation
import ProjectDescription

public struct ProjectEnvironment {
    public let previousName : String
    public let name: String
    public let organizationName: String
    public let deploymentTarget: DeploymentTarget
    public let baseSetting: SettingsDictionary
}

public let env = ProjectEnvironment(
    previousName: "Billboardoo",
    name: "WaktaverseMusic",
    organizationName: "yongbeomkwak",
    deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
    baseSetting: SettingsDictionary()
        .marketingVersion("2.2.2")
        .currentProjectVersion("0")
        .debugInformationFormat(DebugInformationFormat.dwarfWithDsym)
        .otherLinkerFlags(["-ObjC"])
        .bitcodeEnabled(false)
)

