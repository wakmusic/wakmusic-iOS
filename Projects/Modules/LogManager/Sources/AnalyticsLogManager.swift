import FirebaseAnalytics
import Foundation
import OSLog
import ThirdPartyLib

fileprivate extension OSLog {
    static let subSystem = Bundle.main.bundleIdentifier ?? ""
    static let debug = OSLog(subsystem: subSystem, category: "DEBUG")
    static let analytics = OSLog(subsystem: subSystem, category: "ANALYTICS")
    static let error = OSLog(subsystem: subSystem, category: "ERROR")
}

private extension LogManager {
    static func log(
        _ message: Any,
        level: Level,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
            let logger = Logger(subsystem: OSLog.subSystem, category: level.category)

            let fileName = file.components(separatedBy: "/").last ?? "unknown.swift"
            let functionName = function.components(separatedBy: "(").first ?? "unknown"
            let footerMessage = "\(fileName) | \(functionName):\(line)"

            let logMessage = "[\(level.symbol) \(level.category)] > \(message)\n-> \(footerMessage)"
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

public enum LogManager {
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

public extension LogManager {
    static func setUserID(
        userID: String?,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Analytics.setUserID(userID)

        LogManager.printDebug(
            "Set Analytics UserID : \(String(describing: userID))",
            file: file,
            function: function,
            line: line
        )
    }

    static func printDebug(
        _ message: Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        LogManager.log(
            message,
            level: .debug,
            file: file,
            function: function,
            line: line
        )
    }

    static func analytics(
        _ log: any AnalyticsLogType
    ) {
        #if RELEASE
            Analytics.logEvent(log.name, parameters: log.params)
        #elseif DEBUG
            LogHistoryStorage.shared.appendHistory(log: log)
        #endif
        let message = """
        \(log.name) logged
        parameters : \(log.params)
        """
        LogManager.log(message, level: .analytics)
    }

    static func printError(
        _ message: Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        LogManager.log(
            message,
            level: .error,
            file: file,
            function: function,
            line: line
        )
    }
}
