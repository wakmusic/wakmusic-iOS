import Foundation
import MyInfoFeature

extension AppComponent {
    var myInfoComponent: MyInfoComponent {
        MyInfoComponent(parent: self)
    }
}
