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

public protocol NoticeFactory {
    func makeView() -> UIViewController
}

public protocol NoticeDetailFactory {
    func makeView(model: FetchNoticeModel) -> UIViewController
}

public protocol QuestionFactory {
    func makeView() -> UIViewController
}

public protocol TeamInfoFactory {
    func makeView() -> UIViewController
}
