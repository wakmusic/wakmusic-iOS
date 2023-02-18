import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteUserDataSource {
    func setProfile(token:String,image:String) -> Completable
    func setUserName(token:String,name:String) -> Completable
    func fetchSubPlayList(token:String) -> Single<[SubPlayListEntity]>
}
