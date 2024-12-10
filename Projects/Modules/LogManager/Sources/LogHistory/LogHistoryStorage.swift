#if DEBUG || QA
    import Foundation

    final class LogHistoryStorage: @unchecked Sendable {
        static let shared = LogHistoryStorage()

        private let lock = NSRecursiveLock()
        private(set) var logHistory: [any AnalyticsLogType] = []

        func appendHistory(log: any AnalyticsLogType) {
            lock.lock()
            defer { lock.unlock() }
            logHistory.append(log)
        }
    }

#endif
