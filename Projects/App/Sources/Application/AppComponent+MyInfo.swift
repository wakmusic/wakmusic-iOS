import Foundation
import MyInfoFeature
import MyInfoFeatureInterface

extension AppComponent {
    var myInfoFactory: any MyInfoFactory {
        MyInfoComponent(parent: self)
    }

    var settingFactory: any SettingFactory {
        SettingComponent(parent: self)
    }

    var teamInfoFactory: any TeamInfoFactory {
        TeamInfoComponent(parent: self)
    }

    var appPushSettingFactory: any AppPushSettingFactory {
        AppPushSettingComponent(parent: self)
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
}
