import Foundation
@preconcurrency import RxSwift
import Utility

protocol PlaylistCommonService {
    var removeSubscriptionPlaylistEvent: Observable<Notification> { get }
}

final class DefaultPlaylistCommonService: PlaylistCommonService, Sendable {
    let removeSubscriptionPlaylistEvent: Observable<Notification> = NotificationCenter.default.rx
        .notification(.didRemovedSubscriptionPlaylist)

    static let shared = DefaultPlaylistCommonService()
}
