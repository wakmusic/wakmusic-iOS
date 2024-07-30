import Foundation
import SongsDomainInterface
import Utility

struct FetchCreditSongListResponseDTO: Decodable {
    let songID, title: String
    let artists: [String]
    let views, likes: Int
    let date: Int
    let karaokeNumber: FetchCreditSongListResponseDTO.KaraokeNumber

    enum CodingKeys: String, CodingKey {
        case title, artists, date, views, likes
        case songID = "videoId"
        case karaokeNumber
    }
}

extension FetchCreditSongListResponseDTO {
    struct KaraokeNumber: Decodable {
        let TJ, KY: Int?
    }
}

extension FetchCreditSongListResponseDTO {
    func toDomain() -> SongEntity {
        return SongEntity(
            id: songID,
            title: title,
            artist: artists.joined(separator: ", "),
            views: views,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd"),
            likes: likes,
            karaokeNumber: .init(TJ: karaokeNumber.TJ, KY: karaokeNumber.KY)
        )
    }
}

extension [FetchCreditSongListResponseDTO] {
    func toDomain() -> [SongEntity] {
        return self.map { $0.toDomain() }
    }
}
