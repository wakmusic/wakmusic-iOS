#if DEBUG || QA
    import Foundation

    struct LogHistorySectionItem: Hashable, Equatable {
        let index: Int
        let log: any AnalyticsLogType

        func hash(into hasher: inout Hasher) {
            hasher.combine(index)
            hasher.combine(log.name)
        }

        static func == (lhs: LogHistorySectionItem, rhs: LogHistorySectionItem) -> Bool {
            lhs.index == rhs.index && lhs.log.name == rhs.log.name
        }
    }
#endif
