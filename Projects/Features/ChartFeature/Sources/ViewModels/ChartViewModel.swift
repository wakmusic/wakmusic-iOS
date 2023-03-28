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
        
        let output = Output()
        
        NotificationCenter.default.rx.notification(.selectedSongOnChart)
            .map({ notification -> SongEntity in
                
                
                
                guard let result = notification.object as? (ChartDateType,SongEntity) else {
                    return SongEntity(id: "_", title: "", artist: "", remix: "", reaction: "", views: 0, last: 0, date: "")
                }
                
                
                
                return result.1
                
            })
            .filter({$0.id != "_"})
            .bind(to: input.notiResult)
            .disposed(by: disposeBag)
        
        
        input.notiResult
            
            .withLatestFrom(output.songEntityOfSelectedSongs){ ($0,$1) }
            .map({ (song,songs) -> [SongEntity]   in
                
                var nextSongs = songs
                
                if nextSongs.contains(where: {$0 == song}) {
                    
                    let index = nextSongs.firstIndex(of: song)!
                    nextSongs.remove(at: index)
                }
                
                else {
                    nextSongs.append(song)
                }
                    
                return nextSongs
            })
            .bind(to: output.songEntityOfSelectedSongs)
            .disposed(by: disposeBag)
        
        
        
        
        return output
    }
    
    
}
