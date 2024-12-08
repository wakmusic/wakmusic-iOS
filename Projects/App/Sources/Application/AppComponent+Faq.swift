import BaseFeature
import FaqDomain
import FaqDomainInterface
@preconcurrency import NeedleFoundation
import SignInFeature

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함

public extension AppComponent {
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
