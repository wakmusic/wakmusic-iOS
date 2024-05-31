import UIKit

public protocol MyInfoFactory {
    func makeView() -> UIViewController
}

public protocol SettingFactory {
    func makeView() -> UIViewController
}
