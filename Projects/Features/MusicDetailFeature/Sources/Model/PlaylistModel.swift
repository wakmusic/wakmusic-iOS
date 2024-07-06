import Foundation
import PlaylistDomainInterface
import SongsDomainInterface

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
        let artistString: String
        let date: String
        let likes: Int
        let isLiked: Bool
        let karaokeNumber: KaraokeNumber

        struct KaraokeNumber: Equatable {
            let tj: Int?
            let ky: Int?
        }
    }
}

extension SongEntity {
    func toModel(isLiked: Bool) -> PlaylistModel.SongModel {
        PlaylistModel.SongModel(
            videoID: self.id,
            title: self.title,
            artistString: self.artist,
            date: self.date,
            likes: self.likes,
            isLiked: isLiked,
            karaokeNumber: PlaylistModel.SongModel.KaraokeNumber(
                tj: self.karaokeNumber.TJ,
                ky: self.karaokeNumber.KY
            )
        )
    }
}
