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
