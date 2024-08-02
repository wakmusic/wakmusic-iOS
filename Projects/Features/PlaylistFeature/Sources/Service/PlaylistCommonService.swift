import Foundation
import RxSwift
import Utility

protocol PlaylistCommonService {
    var removeSubscriptionPlaylistEvent: Observable<Notification> { get }
}

final class DefaultPlaylistCommonService: PlaylistCommonService {
    let removeSubscriptionPlaylistEvent: Observable<Notification> = NotificationCenter.default.rx.notification(.removeSubscriptionPlaylist)

    static let shared = DefaultPlaylistCommonService()
}
