import Foundation
import RxSwift
import RxRelay
import DomainModule
import BaseFeature
import Utility
import DataMappingModule

public final class ChartViewModel:ViewModelType {
   
    private let disposeBag = DisposeBag()
    private let fetchChartRankingUseCase: FetchChartRankingUseCase
    
    public  struct Input {
        
    }
    
    public  struct Output {
        
    }
    
    init(fetchChartRankingUseCase:FetchChartRankingUseCase){
        self.fetchChartRankingUseCase = fetchChartRankingUseCase
    }
    
  
    public func transform(from input: Input) -> Output {
        
        return Output()
    }
    
    
}
