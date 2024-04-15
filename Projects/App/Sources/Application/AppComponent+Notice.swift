//
//  AppComponent+Notice.swift
//  WaktaverseMusic
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import CommonFeature
import MainTabFeature
import NoticeDomain
import NoticeDomainInterface
import StorageFeature

public extension AppComponent {
    var noticePopupComponent: NoticePopupComponent {
        NoticePopupComponent(parent: self)
    }

    var noticeComponent: NoticeComponent {
        NoticeComponent(parent: self)
    }

    var noticeDetailComponent: NoticeDetailComponent {
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

    var fetchNoticeUseCase: any FetchNoticeUseCase {
        shared {
            FetchNoticeUseCaseImpl(noticeRepository: noticeRepository)
        }
    }

    var fetchNoticeCategoriesUseCase: any FetchNoticeCategoriesUseCase {
        shared {
            FetchNoticeCategoriesUseCaseImpl(noticeRepository: noticeRepository)
        }
    }
}
