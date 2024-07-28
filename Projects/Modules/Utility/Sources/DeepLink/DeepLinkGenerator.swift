import Foundation

public protocol DeepLinkGeneratable {
    func generatePlaylistDeepLink(key: String) -> String
}

public final class DeepLinkGenerator: DeepLinkGeneratable {
    public init() {}

    public func generatePlaylistDeepLink(key: String) -> String {
        #warning("나중에 딥링크 변경하기")
        return "https://\(WM_UNIVERSALLINK_TEST_DOMAIN())/playlist/\(key)"
    }
}
