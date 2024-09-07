import Foundation

public protocol WMDeepLinkGeneratable {
    func generatePlaylistDeepLink(key: String) -> String
}

public final class WMDeepLinkGenerator: WMDeepLinkGeneratable {
    public init() {}

    public func generatePlaylistDeepLink(key: String) -> String {
        return "https://\(WM_UNIVERSALLINK_DOMAIN())/playlist/\(key)"
    }
}
