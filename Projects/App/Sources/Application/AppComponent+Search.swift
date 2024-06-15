import Foundation
import SearchFeature
import SearchFeatureInterface
import SearchDomainInterface
import SearchDomain

extension AppComponent {
    var searchFactory: any SearchFactory {
        SearchComponent(parent: self)
    }

    var beforeSearchComponent: BeforeSearchComponent {
        BeforeSearchComponent(parent: self)
    }

    var afterSearchComponent: AfterSearchComponent {
        AfterSearchComponent(parent: self)
    }

    var songSearchResultFactory: any SongSearchResultFactory {
        SongSearchResultComponent(parent: self)
    }

    var listSearchResultFactory: any ListSearchResultFactory {
        ListSearchResultComponent(parent: self)
    }

    var wakmusicRecommendComponent: WakmusicRecommendComponent {
        WakmusicRecommendComponent(parent: self)
    }
    
    
    // 도메인 영역
    
    var remoteSearchDataSource: any RemoteSearchDataSource {
        shared {
            RemoteSearchDataSourceImpl(keychain: keychain)
        }
    }

    var searchRepository: any SearchRepository {
        shared {
            SearchRepositoryImpl(remoteSearchDataSource: remoteSearchDataSource)
        }
    }

    var fetchSearchSongsUseCaseImpl: any FetchSearchSongsUseCase {
        shared {
            FetchSearchSongsUseCaseImpl(searchRepository: searchRepository)
        }
    }
    
    var fetchSearcPlaylistsUseCaseImpl: any FetchSearchPlaylistsUseCase {
        shared {
            FetchSearchPlaylistsUseCaseImpl(searchRepository: searchRepository)
        }
    }
}
