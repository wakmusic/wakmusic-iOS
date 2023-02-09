import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation


public final class PlayListDataSourceImpl: BaseRemoteDataSource<PlayListAPI>, PlayListDataSource {
    public func fetchRecommendPlayList() ->Single<[RecommendPlayListEntity]> {
        request(.fetchRecommendPlayList)
            .map([SingleRecommendPlayListResponseDTO].self)
            .map{$0.map{$0.toDomain()}}
        
       
    }
    
   
    
    
    
  
    
 
}
