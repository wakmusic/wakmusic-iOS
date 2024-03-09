import Combine
import DataMappingModule
import ErrorModule
import Foundation
import RxSwift

public protocol FetchChartUpdateTimeUseCase {
    func execute(type: ChartDateType) -> Single<String>
}
