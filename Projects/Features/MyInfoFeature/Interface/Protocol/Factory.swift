import FaqDomainInterface
import NoticeDomainInterface
import UIKit

public protocol MyInfoFactory {
    func makeView() -> UIViewController
}

public protocol SettingFactory {
    func makeView() -> UIViewController
}

public protocol OpenSourceLicenseFactory {
    func makeView() -> UIViewController
}

public protocol FaqFactory {
    func makeView() -> UIViewController
}

public protocol FaqContentFactory {
    func makeView(dataSource: [FaqEntity]) -> UIViewController
}

public protocol NoticeFactory {
    func makeView() -> UIViewController
}

public protocol NoticeDetailFactory {
    func makeView(model: FetchNoticeEntity) -> UIViewController
}

public protocol QuestionFactory {
    func makeView() -> UIViewController
}

public protocol ServiceInfoFactory {
    func makeView() -> UIViewController
}

public protocol ProfilePopupFactory {
    func makeView(completion: (() -> Void)?) -> UIViewController
}
