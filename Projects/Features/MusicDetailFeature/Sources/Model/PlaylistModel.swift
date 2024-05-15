import Foundation

/**
 이 구조체는 Playlist Domain이 API 서버의 변경사항을 반영한 후에 제거됩니다
 */
struct PlaylistModel: Equatable {
    let key: String
    let title: String
    let isPrivate: Bool
    let imageURL: String
    let songs: [SongModel]
    let createdAt: Int
    let modifiedAt: Int

    struct SongModel: Equatable {
        let videoID: String
        let title: String
        let artists: [String]
        let date: Int
        let start: Int
        let end: Int
        let likes: Int
        let isLiked: Bool
    }
}
