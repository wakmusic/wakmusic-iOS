import Foundation
import RxSwift
import DataMappingModule

public protocol FetchTokenUseCase {
    func execute(id:String,type:ProviderType) -> Single<AuthLoginEntity>
}
