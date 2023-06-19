import Foundation
import RxSwift
import DataMappingModule

public protocol FetchTokenUseCase {
    func execute(token:String,type:ProviderType) -> Single<AuthLoginEntity>
}
