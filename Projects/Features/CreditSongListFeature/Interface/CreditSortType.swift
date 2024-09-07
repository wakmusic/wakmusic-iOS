public enum CreditSongSortType: CaseIterable {
    case latest
    case popular
    case oldest

    public var display: String {
        switch self {
        case .latest:
            return "최신순"
        case .popular:
            return "인기순"
        case .oldest:
            return "과거순"
        }
    }
}
