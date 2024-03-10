import DataMappingModule
import DomainModule
import Utility

public extension SinglePlayListDetailResponseDTO {
    func toDomain() -> PlayListDetailEntity {
        PlayListDetailEntity(
            key: key ?? "",
            title: title,
            songs: (songs ?? []).map { (dto) in
                return SongEntity(
                    id: dto.id,
                    title: dto.title,
                    artist: dto.artist,
                    remix: dto.remix,
                    reaction: dto.reaction,
                    views: dto.total?.views ?? 0,
                    last: dto.total?.last ?? 0,
                    date: dto.date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
                )
            },
            image: image.name ?? "",
            image_square_version: image.square ?? 0,
            image_round_version: image.round ?? 0,
            version: image.version ?? 0
        )
    }
}

public extension SingleSongResponseDTO {
    func toDomain() -> SongEntity {
        SongEntity(
            id: id,
            title: title,
            artist: artist,
            remix: remix,
            reaction: reaction,
            views: total?.views ?? 0,
            last: total?.last ?? 0,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
        )
    }
}
