import Foundation

public struct LyricHighlightingRequiredModel {
    let songID: String
    let title: String
    let artist: String
    let highlightingItems: [String]

    public init(
        songID: String,
        title: String,
        artist: String,
        highlightingItems: [String]
    ) {
        self.songID = songID
        self.title = title
        self.artist = artist
        self.highlightingItems = highlightingItems
    }
}
