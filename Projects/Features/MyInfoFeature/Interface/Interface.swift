import UIKit

public protocol MyInfoFactory {
    func makeView() -> UIViewController
}

public protocol SettingFactory {
    func makeView() -> UIViewController
}

public protocol AppPushSettingFactory {
    func makeView() -> UIViewController
}

public protocol OpenSourceLicenseFactory {
    func makeView() -> UIViewController
}

public protocol FaqFactory {
    func makeView() -> UIViewController
}

public protocol FaqContentFactory {
    func makeView(dataSource: [FaqModel]) -> UIViewController
}
