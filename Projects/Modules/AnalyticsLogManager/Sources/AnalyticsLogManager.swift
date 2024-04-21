import FirebaseAnalytics
import Foundation
import OSLog

fileprivate extension OSLog {
    static let subSystem = Bundle.main.bundleIdentifier ?? ""
    static let debug = OSLog(subsystem: subSystem, category: "DEBUG")
    static let analytics = OSLog(subsystem: subSystem, category: "ANALYTICS")
    static let error = OSLog(subsystem: subSystem, category: "ERROR")
}

private extension AnalyticsLogManager {
    static func log(_ message: Any, level: Level) {
        #if DEBUG
            let logger = Logger(subsystem: OSLog.subSystem, category: level.category)
            let logMessage = "[\(level.symbol) \(level.category)] > \(message)"
            switch level {
            case .debug:
                logger.debug("\(logMessage)")
            case .analytics:
                logger.info("\(logMessage)")
            case .error:
                logger.error("\(logMessage)")
            }
        #endif
    }
}

public enum AnalyticsLogManager {
    fileprivate enum Level {
        case debug
        case analytics
        case error

        fileprivate var symbol: String {
            switch self {
            case .debug: "🔵"
            case .analytics: "🟡"
            case .error: "🔴"
            }
        }

        fileprivate var category: String {
            switch self {
            case .debug: "DEBUG"
            case .analytics: "ANALYTICS"
            case .error: "ERROR"
            }
        }
    }
}

public extension AnalyticsLogManager {
    static func setUserID(userID: String?) {
        Analytics.setUserID(userID)
    }

    static func setDefaultParameters(params: [String: Any]) {
        Analytics.setDefaultEventParameters(params)
    }

    static func debug(_ message: Any) {
        AnalyticsLogManager.log(message, level: .debug)
    }

    static func analytics(_ log: any AnalyticsLog) {
        #if RELEASE
            Analytics.logEvent(log.name, parameters: log.params)
        #endif
        let message = """
        \(log.name) logged
        parameters : \(log.params)
        """
        AnalyticsLogManager.log(message, level: .analytics)
    }

    static func error(_ message: Any) {
        AnalyticsLogManager.log(message, level: .error)
    }
}
