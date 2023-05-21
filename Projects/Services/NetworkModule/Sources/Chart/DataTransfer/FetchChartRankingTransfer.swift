import DataMappingModule
import DomainModule
import Utility

public extension SingleChartRankingResponseDTO {
    func toDomain() -> ChartRankingEntity {
        ChartRankingEntity(
            id: id,
            title: title,
            artist: artist,
            remix: remix,
            reaction: reaction,
            views: views,
            last: last,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
        )
    }
}
