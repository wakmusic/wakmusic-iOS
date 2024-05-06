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

    var afterSearchContentComponent: AfterSearchContentComponent {
        AfterSearchContentComponent(parent: self)
    }
}
