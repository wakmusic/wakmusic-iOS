import Foundation

public protocol DeepLinkGeneratable {
    func generatePlaylistDeepLink(key: String) -> String
 
}

public final class DeepLinkGenerator: DeepLinkGeneratable {
    
    public init() {}

    func generatePlaylistDeepLink(key: String) -> String {
        return 
    }
    
}


