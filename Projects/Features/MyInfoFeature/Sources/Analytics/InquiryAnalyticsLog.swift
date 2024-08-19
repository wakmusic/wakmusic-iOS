import LogManager

enum InquiryAnalyticsLog: AnalyticsLogType {
    case clickInquirySubmitButton(type: LogInquiryType)

    enum LogInquiryType: String, AnalyticsLogEnumParametable {
        case bug = "버그 제보"
        case feature = "기능 제안"
        case addSong = "노래 추가"
        case modifySong = "노래 수정"
        case weeklyChart = "주간차트 영상"
        case credit = "참여 정보"

        init(mailSource: InquiryType) {
            switch mailSource {
            case .reportBug:
                self = .bug
            case .suggestFunction:
                self = .feature
            case .addSong:
                self = .addSong
            case .modifySong:
                self = .modifySong
            case .weeklyChart:
                self = .weeklyChart
            case .credit:
                self = .credit
            case .unknown:
                self = .bug
            }
        }
    }
}
