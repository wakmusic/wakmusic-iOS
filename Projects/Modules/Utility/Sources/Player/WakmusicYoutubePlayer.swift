import Foundation
import UIKit

public struct WakmusicYoutubePlayer: WakmusicPlayer {
    private let youtubeURLGenerator: any YoutubeURLGeneratable
    private let id: String

    public init(
        id: String,
        youtubeURLGenerator: any YoutubeURLGeneratable = YoutubeURLGenerator()
    ) {
        self.id = id
        self.youtubeURLGenerator = youtubeURLGenerator
    }

    public func play() {
        playYoutube(id: id)
    }
}

private extension WakmusicYoutubePlayer {
    func playYoutube(id: String) {
        if let youtubeAppURL = URL(string: youtubeURLGenerator.generateYoutubeVideoAppURL(id: id)),
           UIApplication.shared.canOpenURL(youtubeAppURL) {
            UIApplication.shared.open(youtubeAppURL)
        } else if
            let youtubeWebURL = URL(string: youtubeURLGenerator.generateYoutubeVideoWebURL(id: id)),
            UIApplication.shared.canOpenURL(youtubeWebURL) {
            UIApplication.shared.open(youtubeWebURL)
        }
    }
}
