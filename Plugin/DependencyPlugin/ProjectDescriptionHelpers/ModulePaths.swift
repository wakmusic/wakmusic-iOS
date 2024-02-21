//
//  ModulePaths.swift
//  DependencyPlugin
//
//  Created by yongbeomkwak on 2/18/24.
//

import Foundation

public enum ModulePaths {
    case feature(Feature)
    case service(Service)
    case module(Module)
    case userInterface(UserInterface)
}

extension ModulePaths: MicroTargetPathConvertable {
    public func targetName(type: MicroTargetType) -> String {
        switch self {
        case let .feature(module as any MicroTargetPathConvertable),
            let .module(module as any MicroTargetPathConvertable),
            let .service(module as any MicroTargetPathConvertable),
            let .userInterface(module as any MicroTargetPathConvertable):
            return module.targetName(type: type)
        }
    }
}

public extension ModulePaths {
    enum Feature: String, MicroTargetPathConvertable {
        case BaseFeature
        case ArtistFeature
        case ChartFeature
        case CommonFeature
        case HomeFeature
        case MainTabFeature
        case PlayerFeature
        case RootFeature
        case SearchFeature
        case SignInFeature
        case StorageFeature
    }
}

public extension ModulePaths {
    enum Module: String, MicroTargetPathConvertable {
        case ErrorModule
        case FeatureThirdPartyLib
        case KeychainModule
        case ThirdPartyLib
        case Utility
    }
}

public extension ModulePaths {
    enum Service: String, MicroTargetPathConvertable {
        case APIKit
        case DatabaseModule
        case DataMappingModule
        case DataModule
        case DomainModule
        case NetworkModule
    }
}

public extension ModulePaths {
    enum UserInterface: String, MicroTargetPathConvertable {
        case DesignSystem
    }
}

public enum MicroTargetType: String {
    case interface = "Interface"
    case sources = ""
    case testing = "Testing"
    case unitTest = "Tests"
    case demo = "Demo"
}

public protocol MicroTargetPathConvertable {
    func targetName(type: MicroTargetType) -> String
}

public extension MicroTargetPathConvertable where Self: RawRepresentable {
    func targetName(type: MicroTargetType) -> String {
        "\(self.rawValue)\(type.rawValue)"
    }
}
