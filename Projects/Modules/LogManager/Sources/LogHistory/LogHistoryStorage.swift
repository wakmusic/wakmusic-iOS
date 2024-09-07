#if DEBUG || QA
    import Foundation

    final class LogHistoryStorage {
        static let shared = LogHistoryStorage()

        private(set) var logHistory: [any AnalyticsLogType] = []

        func appendHistory(log: any AnalyticsLogType) {
            logHistory.append(log)
        }
    }

#endif
