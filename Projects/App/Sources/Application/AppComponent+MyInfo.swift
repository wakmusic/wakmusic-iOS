import Foundation
import MyInfoFeature
import MyInfoFeatureInterface
@preconcurrency import NeedleFoundation

extension AppComponent {
    var myInfoFactory: any MyInfoFactory {
        MyInfoComponent(parent: self)
    }

    var settingFactory: any SettingFactory {
        SettingComponent(parent: self)
    }

    var openSourceLicenseFactory: any OpenSourceLicenseFactory {
        OpenSourceLicenseComponent(parent: self)
    }

    var questionFactory: any QuestionFactory {
        QuestionComponent(parent: self)
    }

    var faqFactory: any FaqFactory {
        FaqComponent(parent: self)
    }

    var faqContentFactory: any FaqContentFactory {
        FaqContentComponent(parent: self)
    }

    var serviceInfoFactory: any ServiceInfoFactory {
        ServiceInfoComponent(parent: self)
    }

    var profilePopupFactory: any ProfilePopupFactory {
        ProfilePopupComponent(parent: self)
    }

    var playTypeTogglePopupFactory: any PlayTypeTogglePopupFactory {
        PlayTypeTogglePopupComponent(parent: self)
    }
}
