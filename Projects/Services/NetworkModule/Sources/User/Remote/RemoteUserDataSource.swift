import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteUserDataSource {
    func setProfile(token:String,image:String) -> Single<BaseEntity>
    func setUserName(token:String,name:String) -> Single<BaseEntity>
    func fetchSubPlayList(token:String) -> Single<[SubPlayListEntity]>
    func fetchFavoriteSong(token:String) -> Single<[FavoriteSongEntity]>
}
