//
//  TargetDependency+MicroFeatureTarget.swift
//  DependencyPlugin
//
//  Created by yongbeomkwak on 2/18/24.
//

import Foundation
import ProjectDescription

public extension TargetDependency {
    static func feature(
        target: ModulePaths.Feature,
        type: MicroTargetType = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .relativeToFeature(target.rawValue)
        )
    }

    static func service(
        target: ModulePaths.Service,
        type: MicroTargetType = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .relativeToService(target.rawValue)
        )
    }

    static func module(
        target: ModulePaths.Module,
        type: MicroTargetType = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .relativeToModule(target.rawValue)
        )
    }

    static func userInterface(
        target: ModulePaths.UserInterface,
        type: MicroTargetType = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .relativeToUserInterfaces(target.rawValue)
        )
    }
    
    static func domain(
        target: ModulePaths.Domain,
        type: MicroTargetType = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .relativeToDomain(target.rawValue)
        )
    }
}
