//
//  AppComponent+Search.swift
//  WaktaverseMusic
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import FaqDomain
import FaqDomainInterface
import MyInfoFeature
import SignInFeature

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함

public extension AppComponent {
    var questionComponent: QuestionComponent {
        QuestionComponent(parent: self)
    }

    var faqComponent: FaqComponent {
        FaqComponent(parent: self)
    }

    var faqContentComponent: FaqContentComponent {
        FaqContentComponent(parent: self)
    }

    var remoteFaqDataSource: any RemoteFaqDataSource {
        shared {
            RemoteFaqDataSourceImpl(keychain: keychain)
        }
    }

    var faqRepository: any FaqRepository {
        shared {
            FaqRepositoryImpl(remoteFaqDataSource: remoteFaqDataSource)
        }
    }

    var fetchFaqCategoriesUseCase: any FetchFaqCategoriesUseCase {
        shared {
            FetchFaqCategoriesUseCaseImpl(faqRepository: faqRepository)
        }
    }

    var fetchFaqUseCase: any FetchFaqUseCase {
        shared {
            FetchFaqUseCaseImpl(faqRepository: faqRepository)
        }
    }
}
