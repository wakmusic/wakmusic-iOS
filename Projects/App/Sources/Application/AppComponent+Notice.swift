import BaseFeature
import MainTabFeature
import MyInfoFeature
import MyInfoFeatureInterface
import NoticeDomain
import NoticeDomainInterface
import StorageFeature

public extension AppComponent {
    var noticePopupComponent: NoticePopupComponent {
        NoticePopupComponent(parent: self)
    }

    var noticeFactory: any NoticeFactory {
        NoticeComponent(parent: self)
    }

    var noticeDetailFactory: any NoticeDetailFactory {
        NoticeDetailComponent(parent: self)
    }

    var remoteNoticeDataSource: any RemoteNoticeDataSource {
        shared {
            RemoteNoticeDataSourceImpl(keychain: keychain)
        }
    }

    var noticeRepository: any NoticeRepository {
        shared {
            NoticeRepositoryImpl(remoteNoticeDataSource: remoteNoticeDataSource)
        }
    }

    var fetchNoticeAllUseCase: any FetchNoticeAllUseCase {
        shared {
            FetchNoticeAllUseCaseImpl(noticeRepository: noticeRepository)
        }
    }

    var fetchNoticePopupUseCase: any FetchNoticePopupUseCase {
        shared {
            FetchNoticePopupUseCaseImpl(noticeRepository: noticeRepository)
        }
    }

    var fetchNoticeCategoriesUseCase: any FetchNoticeCategoriesUseCase {
        shared {
            FetchNoticeCategoriesUseCaseImpl(noticeRepository: noticeRepository)
        }
    }

    var fetchNoticeIDListUseCase: any FetchNoticeIDListUseCase {
        shared {
            FetchNoticeIDListUseCaseImpl(noticeRepository: noticeRepository)
        }
    }
}
