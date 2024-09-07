import Foundation
import ProjectDescription

public enum GenerateEnvironment: String {
    case ci = "CI"
    case cd = "CD"
    case dev = "DEV"
}

let environment = ProcessInfo.processInfo.environment["TUIST_ENV"] ?? ""
public let generateEnvironment = GenerateEnvironment(rawValue: environment) ?? .dev

public extension GenerateEnvironment {
    var appScripts: [TargetScript] {
        switch self {
            
        case .ci:
            return []
            
        case .cd:
            return [.firebaseInfoByConfiguration, .firebaseCrashlytics]

        case .dev:
            return [.swiftLint, .needle]
        }
    }
}
