import Foundation
import RxSwift
import DataMappingModule

public protocol WithdrawUserInfoUseCase {
    func execute(token:String) -> Single<BaseEntity>
}
