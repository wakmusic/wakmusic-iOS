import DataMappingModule
import DomainModule
import Utility

public extension SingleChartRankingResponseDTO {
    func toDomain(type: ChartDateType) -> ChartRankingEntity {
        var views: Int = 0
        var last: Int = 0
        
        switch type {
        case .monthly:
            views = monthly?.views ?? 0
            last = monthly?.last ?? 0
        case .weekly:
            views = weekly?.views ?? 0
            last = weekly?.last ?? 0
        case .daily:
            views = daily?.views ?? 0
            last = daily?.last ?? 0
        case .hourly:
            views = hourly?.views ?? 0
            last = hourly?.last ?? 0
        case .total:
            views = total?.views ?? 0
            last = total?.last ?? 0
        }
        
        return ChartRankingEntity(
            id: id,
            title: title,
            artist: artist,
            remix: remix,
            reaction: reaction,
            views: views,
            last: last,
            increase: increase ?? 0,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
        )
    }
}
