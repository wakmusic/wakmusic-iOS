import Foundation
import PlaylistDomainInterface
import SongsDomainInterface

struct SongModel: Equatable {
    let videoID: String
    let title: String
    let artistString: String
    let date: String
    let views: Int
    let likes: Int
    let isLiked: Bool
    let karaokeNumber: KaraokeNumber

    struct KaraokeNumber: Equatable {
        let tj: Int?
        let ky: Int?
    }

    func updateIsLiked(likes: Int, isLiked: Bool) -> SongModel {
        SongModel(
            videoID: self.videoID,
            title: self.title,
            artistString: self.artistString,
            date: self.date,
            views: self.views,
            likes: likes,
            isLiked: isLiked,
            karaokeNumber: self.karaokeNumber
        )
    }
}

extension SongDetailEntity {
    func toModel() -> SongModel {
        SongModel(
            videoID: self.id,
            title: self.title,
            artistString: self.artist,
            date: self.date,
            views: self.views,
            likes: self.likes,
            isLiked: self.isLiked,
            karaokeNumber: SongModel.KaraokeNumber(
                tj: self.karaokeNumber.tj,
                ky: self.karaokeNumber.ky
            )
        )
    }
}
