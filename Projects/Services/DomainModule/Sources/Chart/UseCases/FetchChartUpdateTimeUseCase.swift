import Combine
import DataMappingModule
import ErrorModule
import RxSwift
import Foundation

public protocol FetchChartUpdateTimeUseCase {
    func execute() -> Single<String>
}
