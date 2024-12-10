import Foundation
@preconcurrency import NeedleFoundation
import SearchDomain
import SearchDomainInterface
import SearchFeature
import SearchFeatureInterface

extension AppComponent {
    var searchGlobalScrollState: any SearchGlobalScrollProtocol {
        shared {
            SearchGlobalScrollState()
        }
    }

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

    var searchSortOptionComponent: SearchSortOptionComponent {
        SearchSortOptionComponent(parent: self)
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

    var fetchSearchSongsUseCase: any FetchSearchSongsUseCase {
        shared {
            FetchSearchSongsUseCaseImpl(searchRepository: searchRepository)
        }
    }

    var fetchSearchPlaylistsUseCase: any FetchSearchPlaylistsUseCase {
        shared {
            FetchSearchPlaylistsUseCaseImpl(searchRepository: searchRepository)
        }
    }
}
