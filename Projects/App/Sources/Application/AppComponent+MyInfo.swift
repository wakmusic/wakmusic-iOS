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

    #warning("팀 소개 페이지 만들때 추가 예정")
//    var teamInfoComponent: TeamInfoComponent {
//        TeamInfoComponent(parent: self)
//    }
}
