import Foundation
import RxSwift
import RxRelay
import DomainModule
import BaseFeature
import Utility
import DataMappingModule

public final class ChartContentViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let type: ChartDateType
    private let fetchChartRankingUseCase: FetchChartRankingUseCase
    private let fetchChartUpdateTimeUseCase: FetchChartUpdateTimeUseCase
    
    public init(
        type: ChartDateType,
        fetchChartRankingUseCase: FetchChartRankingUseCase,
        fetchChartUpdateTimeUseCase: FetchChartUpdateTimeUseCase
    ) {
        self.type = type
        self.fetchChartRankingUseCase = fetchChartRankingUseCase
        self.fetchChartUpdateTimeUseCase = fetchChartUpdateTimeUseCase
    }
    
    public struct Input {
        
        let indexPath:PublishRelay<IndexPath> = PublishRelay()
        let mandatoryLoadIndexPath:PublishRelay<[IndexPath]> = PublishRelay()
    }
    
    public struct Output {
        var canLoadMore: BehaviorRelay<Bool>  = BehaviorRelay(value: true)
        var dataSource: BehaviorRelay<[ChartRankingEntity]> = BehaviorRelay(value: [])
        var updateTime: BehaviorRelay<String> = BehaviorRelay(value: "")
    }
    
    public func transform(from input: Input) -> Output {
       
        let output = Output()

        fetchChartUpdateTimeUseCase
            .execute()
            .catchAndReturn("팬치들 미안해요 ㅠㅠ 잠시만 기다려주세요") // 이스터에그 🥰
            .asObservable()
            .do(onError: { _ in output.canLoadMore.accept(false) })
                .bind(to: output.updateTime)
            .disposed(by: disposeBag)

        fetchChartRankingUseCase
            .execute(type: type, limit: 100)
            .catchAndReturn([])
            .asObservable()
            .do(
                onNext: { (model) in output.canLoadMore.accept(!model.isEmpty)},
                onError: { _ in output.canLoadMore.accept(false) }
            )
                .bind(to: output.dataSource)
            .disposed(by: disposeBag)

    
            input.indexPath
                .withLatestFrom(output.dataSource){($0,$1)}
                .map({[weak self] (indexPath,dataSource) -> [ChartRankingEntity] in
                    
                    guard let self = self else{return [] }
                    
                    let index:Int = indexPath.row
                    
                    let song = dataSource[index]
                    
                    
                    NotificationCenter.default.post(name: .selectedSongOnChart, object: (self.type,song))
                    
                    
                    var newModel = dataSource
                    
                   newModel[index].isSelected = !newModel[index].isSelected
                    
                    
                    
                    return newModel
                })
                .bind(to: output.dataSource)
                .disposed(by: disposeBag)
        
                
    
        return output
    }
}
