import BaseFeature
import BaseFeatureInterface
import Foundation

public extension AppComponent {
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory {
        MultiPurposePopUpComponent(parent: self)
    }

    var textPopUpFactory: any TextPopUpFactory {
        TextPopUpComponent(parent: self)
    }
    
    var containSongsFactory: any ContainSongsFactory {
        ContainSongsComponent(parent: self)
    }
}
