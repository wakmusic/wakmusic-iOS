import Foundation
import RxSwift
import DataMappingModule

public protocol AddSongIntoPlayListUseCase {
    func execute(key: String,songs:[String]) -> Single<AddSongEntity>
}
