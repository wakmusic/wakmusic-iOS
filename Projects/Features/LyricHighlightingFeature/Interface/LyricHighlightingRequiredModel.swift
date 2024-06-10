import Foundation

public struct LyricHighlightingRequiredModel {
    public let songID: String
    public let title: String
    public let artist: String
    public let highlightingItems: [String]

    ///  가사 하이라이팅 화면에 주입해줘야할 필수 아이템
    public init(
        songID: String, // 노래 고유 ID
        title: String, // 노래 제목
        artist: String, // 아티스트 이름
        highlightingItems: [String] = [] // 데코레이팅 화면으로 넘어갈 때만 넣으면됩니다.
    ) {
        self.songID = songID
        self.title = title
        self.artist = artist
        self.highlightingItems = highlightingItems
    }
}
