import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteUserDataSource {
    func setProfile(image:String) -> Single<BaseEntity>
    func setUserName(name:String) -> Single<BaseEntity>
    func fetchSubPlayList() -> Single<[SubPlayListEntity]>
    func fetchFavoriteSong() -> Single<[FavoriteSongEntity]>
}
