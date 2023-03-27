import Foundation
import RxSwift
import RxRelay
import DomainModule
import BaseFeature
import Utility
import DataMappingModule

public final class ChartViewModel:ViewModelType {
   
    private let disposeBag = DisposeBag()

    
    public  struct Input {
        let notiResult:PublishRelay<SongEntity> = PublishRelay()
    }
    
    public  struct Output {
        let songEntityOfSelectedSongs: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
    }
    
  
    
  
    public func transform(from input: Input) -> Output {
        
        return Output()
    }
    
    
}
