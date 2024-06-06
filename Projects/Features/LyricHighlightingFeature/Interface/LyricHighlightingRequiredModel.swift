import Foundation

public struct LyricHighlightingRequiredModel {
    public let songID: String
    public let title: String
    public let artist: String
    public let highlightingItems: [String]

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
