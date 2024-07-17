import Foundation
import UIKit

public struct WakmusicYoutubePlayer: WakmusicPlayer {
    private let youtubeURLGenerator: any YoutubeURLGeneratable
    private let ids: [String]

    public init(
        id: String,
        youtubeURLGenerator: any YoutubeURLGeneratable = YoutubeURLGenerator()
    ) {
        self.ids = [id]
        self.youtubeURLGenerator = youtubeURLGenerator
    }

    public init(
        ids: [String],
        youtubeURLGenerator: any YoutubeURLGeneratable = YoutubeURLGenerator()
    ) {
        self.ids = ids
        self.youtubeURLGenerator = youtubeURLGenerator
    }

    public func play() {
        playYoutube(ids: ids)
    }
}

private extension WakmusicYoutubePlayer {
    func playYoutube(ids: [String]) {
        if let appURL = urlForYoutubeApp(ids: ids) {
            UIApplication.shared.open(appURL)
        } else if let webURL = urlForYoutubeWeb(ids: ids) {
            UIApplication.shared.open(webURL)
        }
    }

    func urlForYoutubeApp(ids: [String]) -> URL? {
        if ids.count == 1,
           let id = ids.first,
           let youtubeAppURL = URL(string: youtubeURLGenerator.generateYoutubeVideoAppURL(id: id)),
           UIApplication.shared.canOpenURL(youtubeAppURL) {
            return youtubeAppURL
        } else if
            let youtubeAppURL = URL(string: youtubeURLGenerator.generateYoutubeVideoAppURL(ids: ids)),
            UIApplication.shared.canOpenURL(youtubeAppURL) {
            return youtubeAppURL
        }
        return nil
    }

    func urlForYoutubeWeb(ids: [String]) -> URL? {
        if ids.count == 1,
           let id = ids.first,
           let youtubeWebURL = URL(string: youtubeURLGenerator.generateYoutubeVideoWebURL(id: id)),
           UIApplication.shared.canOpenURL(youtubeWebURL) {
            return youtubeWebURL
        } else if
            let youtubeWebURL = URL(string: youtubeURLGenerator.generateYoutubeVideoWebURL(ids: ids)),
            UIApplication.shared.canOpenURL(youtubeWebURL) {
            return youtubeWebURL
        }
        return nil
    }
}
