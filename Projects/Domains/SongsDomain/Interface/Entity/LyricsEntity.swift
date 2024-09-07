import Foundation

public struct LyricsEntity {
    public init(
        provider: String,
        lyrics: [LyricsEntity.Lyric]
    ) {
        self.provider = provider
        self.lyrics = lyrics
    }

    public let provider: String
    public let lyrics: [LyricsEntity.Lyric]
}

public extension LyricsEntity {
    struct Lyric {
        public init(
            text: String
        ) {
            self.text = text
        }

        public let text: String
        public var isHighlighting: Bool = false
    }
}
