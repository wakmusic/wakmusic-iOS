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
    case domain(Domain)
}

extension ModulePaths: MicroTargetPathConvertable {
    public func targetName(type: MicroTargetType) -> String {
        switch self {
        case let .feature(module as any MicroTargetPathConvertable),
            let .module(module as any MicroTargetPathConvertable),
            let .service(module as any MicroTargetPathConvertable),
            let .userInterface(module as any MicroTargetPathConvertable),
            let .domain(module as any MicroTargetPathConvertable):
            return module.targetName(type: type)
        }
    }
}

public extension ModulePaths {
    enum Feature: String, MicroTargetPathConvertable {
        case CreditSongListFeature
        case SongCreditFeature
        case TeamFeature
        case FruitDrawFeature
        case LyricHighlightingFeature
        case MyInfoFeature
        case MusicDetailFeature
        case PlaylistFeature
        case BaseFeature
        case ArtistFeature
        case ChartFeature
        case HomeFeature
        case MainTabFeature
        case RootFeature
        case SearchFeature
        case SignInFeature
        case StorageFeature
    }
}

public extension ModulePaths {
    enum Domain: String, MicroTargetPathConvertable {
        case PriceDomain
        case CreditDomain
        case TeamDomain
        case NotificationDomain
        case ImageDomain
        case SearchDomain
        case BaseDomain
        case AppDomain
        case ArtistDomain
        case AuthDomain
        case ChartDomain
        case FaqDomain
        case LikeDomain
        case NoticeDomain
        case PlaylistDomain
        case SongsDomain
        case UserDomain
    }
}

public extension ModulePaths {
    enum Module: String, MicroTargetPathConvertable {
        case Localization
        case LogManager
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
