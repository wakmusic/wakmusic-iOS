import BaseFeature
import BaseFeatureInterface
import Foundation

public extension AppComponent {
    var multiPurposePopUpFactory: any MultiPurposePopupFactory {
        MultiPurposePopupComponent(parent: self)
    }

    var textPopUpFactory: any TextPopUpFactory {
        TextPopUpComponent(parent: self)
    }

    var togglePopUpFactory: any TogglePopUpFactory {
        TogglePopUpComponent(parent: self)
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
