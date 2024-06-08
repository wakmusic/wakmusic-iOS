import Foundation
import SearchFeature
import SearchFeatureInterface

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
}
