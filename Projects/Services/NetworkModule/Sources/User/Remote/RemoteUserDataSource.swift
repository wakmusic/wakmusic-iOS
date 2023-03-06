import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteUserDataSource {
    func fetchProfileList() -> Single<[ProfileListEntity]>
    func setProfile(image:String) -> Single<BaseEntity>
    func setUserName(name:String) -> Single<BaseEntity>
    func fetchPlayList() -> Single<[PlayListEntity]>
    func fetchFavoriteSong() -> Single<[FavoriteSongEntity]>
    func editFavoriteSongsOrder(ids:[String]) -> Single<BaseEntity>
    func editPlayListOrder(ids:[String]) -> Single<BaseEntity>
}
