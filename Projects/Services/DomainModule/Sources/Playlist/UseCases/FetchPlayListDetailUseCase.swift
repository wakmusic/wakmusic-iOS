import Foundation
import RxSwift
import DataMappingModule

public protocol FetchPlayListDetailUseCase {
    func execute(id:String,type:PlayListType) -> Single<PlayListDetailEntity>
}
