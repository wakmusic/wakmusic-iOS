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
        let mandatoryLoadIndexPath:PublishRelay<[SongEntity]> = PublishRelay()
    }
    
    public struct Output {
        var canLoadMore: BehaviorRelay<Bool>  = BehaviorRelay(value: true)
        var dataSource: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
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
                .map({[weak self] (indexPath,dataSource) -> [SongEntity] in
                    
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
        
        
        
        
        NotificationCenter.default.rx.notification(.selectedSongOnChart)
            .filter({ [weak self]  in
                
                guard let self = self else{return false}
                
                
                guard let result = $0.object as? (ChartDateType,SongEntity) else {
                    return false
                }
                
                
                return self.type != result.0
            })
            .map({(res) -> SongEntity  in
                

                guard let result = res.object as? (ChartDateType,SongEntity) else {
                    return SongEntity(id: "-", title: "", artist: "", remix: "", reaction: "", views: 0, last: 0, date: "")
                }
                
                return result.1
            })
            .filter({$0.id != "-"})
            .withLatestFrom(output.dataSource){($0,$1)}
            .map{ [weak self] (song:SongEntity,dataSource:[SongEntity]) -> [SongEntity] in
                
                
                DEBUG_LOG("Song \(song)")
                var models = dataSource
                
                    
                if let row = models.firstIndex(where: { $0 == song }){
                    models[row].isSelected = !models[row].isSelected
                }
                
                
                
                
               
                
            
                
                return models
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        
        input.mandatoryLoadIndexPath
            .withLatestFrom(output.dataSource) {($0,$1)}
            .map({ (songs,dataSource) -> [SongEntity] in
                
                var newModel = dataSource
                
                DEBUG_LOG("Song \(songs)")
                
                    
                for song in songs {
                        
                    if let index = newModel.firstIndex(where: {$0 == song}) {
                        newModel[index].isSelected = true
                    }
                
                    
                }
                

                
                return newModel
            })
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
                
    
        return output
    }
}
