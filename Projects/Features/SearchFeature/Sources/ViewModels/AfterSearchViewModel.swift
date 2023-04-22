//
//  SearchViewModel.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import BaseFeature
import DomainModule
import Utility




public final class AfterSearchViewModel:ViewModelType {
   
    


    
    var disposeBag = DisposeBag()
    var fetchSearchSongUseCase:FetchSearchSongUseCase!
    
    public init(fetchSearchSongUseCase:FetchSearchSongUseCase){
        
        DEBUG_LOG("✅ AfterSearchViewModel 생성")
        self.fetchSearchSongUseCase = fetchSearchSongUseCase
        
        

        
        
        
        
    }

    public struct Input {
        let text:BehaviorRelay<String> = BehaviorRelay<String>(value: "")
        let notiResult:PublishRelay<SongEntity> = PublishRelay()
        
    }

    public struct Output {
        
        let dataSource:BehaviorRelay<[[SearchSectionModel]]> = BehaviorRelay<[[SearchSectionModel]]>(value: [])
        
        // 검색 후 재 검색 시 남아 있는 데이터 처리를 위한 변수
        let isFetchStart:PublishSubject<Void> = PublishSubject()
        let songEntityOfSelectedSongs: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
        
        
    }
    
    public func transform(from input: Input) -> Output {
        
        let output = Output()

        input.text
            .filter({!$0.isEmpty}) //빈 것에 대한 예외 처리
            .do(onNext: { _ in
                
                // 네트워크 시작점을 포착하기 위한 구간 
                
                output.isFetchStart.onNext(())
            })
            .flatMap { [weak self] (str:String) -> Observable<(([SongEntity], [SongEntity]), [SongEntity])> in
                
                guard let self = self else{
                    return Observable.empty()
                }
                
                let zip = Observable.zip(self.fetchSearchSongUseCase.execute(type: .title, keyword: str).asObservable(), self.fetchSearchSongUseCase.execute(type: .artist, keyword: str).asObservable())
                let remix = self.fetchSearchSongUseCase.execute(type: .remix, keyword: str).asObservable()
                
                let result = Observable.zip(zip, remix)
                
                return result
            }
            .map{ [weak self] (res,r3) in
            
            var results:[[SearchSectionModel]] = []
            
            
            let (r1, r2) = res
            
            var all: [SearchSectionModel] = []
            
            if !r1.isEmpty && ( r2.isEmpty && r3.isEmpty ) {
                    all =    [
                        SearchSectionModel(model: (.song,r1.count), items: r1 ),

                ]
            }
            
            else if !r2.isEmpty && ( r1.isEmpty && r3.isEmpty ) {
                    all =    [
                    SearchSectionModel(model: (.artist,r2.count), items: r2 ),

                ]
            }
            
            else if !r3.isEmpty && ( r1.isEmpty && r2.isEmpty ) {
                    all =    [
                    SearchSectionModel(model: (.remix,r3.count), items: r3 ),

                ]
            }
            
            else {
                
                all  = [
                    SearchSectionModel(model: (.song,r1.count), items: r1.count > 3 ? Array(r1[0...2]) : r1 ),
                    SearchSectionModel(model: (.artist,r2.count), items: r2.count > 3 ? Array(r2[0...2]) : r2 ),
                    SearchSectionModel(model: (.remix,r3.count), items: r3.count > 3 ? Array(r3[0...2]) : r3 )
                
                ]
                
            }
            

            results.append(all)
            results.append([SearchSectionModel(model: (.song,r1.count), items: r1)])
            results.append([SearchSectionModel(model: (.artist,r2.count), items: r2)])
            results.append([SearchSectionModel(model: (.remix,r3.count), items: r3)])
            

            return results
        }.bind(to: output.dataSource)
            .disposed(by: disposeBag)
    
        
        NotificationCenter.default.rx.notification(.selectedSongOnSearch)
            .map({ notification -> SongEntity in
                guard let result = notification.object as? (TabPosition,SongEntity) else {
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
