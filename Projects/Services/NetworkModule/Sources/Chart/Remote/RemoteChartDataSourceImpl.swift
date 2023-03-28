import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation

public final class RemoteChartDataSourceImpl: BaseRemoteDataSource<ChartAPI>, RemoteChartDataSource {
    public func fetchChartRanking(type: ChartDateType, limit: Int) -> Single<[SongEntity]> {
        request(.fetchChartRanking(type: type, limit: limit))
            .map([SingleSongResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }
    
    public func fetchChartUpdateTime() -> Single<String> {
        request(.fetchChartUpdateTime)
            .map { String(data: $0.data, encoding: .utf8) ?? "" }
    }
}
