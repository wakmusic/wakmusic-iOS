import Foundation
import MyInfoFeature
import MyInfoFeatureInterface

extension AppComponent {
    var myInfoComponent: MyInfoComponent {
        MyInfoComponent(parent: self)
    }

    var settingComponent: SettingComponent {
        SettingComponent(parent: self)
    }

    var teamInfoComponent: TeamInfoComponent {
        TeamInfoComponent(parent: self)
    }

    var appPushSettingComponent: AppPushSettingComponent {
        AppPushSettingComponent(parent: self)
    }
}
