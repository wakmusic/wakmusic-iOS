import BaseFeature
import BaseFeatureInterface
import Foundation
@preconcurrency import NeedleFoundation

public extension AppComponent {
    var multiPurposePopupFactory: any MultiPurposePopupFactory {
        MultiPurposePopupComponent(parent: self)
    }

    var textPopupFactory: any TextPopupFactory {
        TextPopupComponent(parent: self)
    }

    var containSongsFactory: any ContainSongsFactory {
        ContainSongsComponent(parent: self)
    }

    var privacyFactory: any PrivacyFactory {
        PrivacyComponent(parent: self)
    }

    var serviceTermsFactory: any ServiceTermFactory {
        ServiceTermsComponent(parent: self)
    }
}
