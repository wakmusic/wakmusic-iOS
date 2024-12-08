import FaqDomainInterface
import NoticeDomainInterface
import UIKit

@MainActor
public protocol MyInfoFactory {
    func makeView() -> UIViewController
}

@MainActor
public protocol SettingFactory {
    func makeView() -> UIViewController
}

@MainActor
public protocol OpenSourceLicenseFactory {
    func makeView() -> UIViewController
}

@MainActor
public protocol FaqFactory {
    func makeView() -> UIViewController
}

@MainActor
public protocol FaqContentFactory {
    func makeView(dataSource: [FaqEntity]) -> UIViewController
}

@MainActor
public protocol NoticeFactory {
    func makeView() -> UIViewController
}

@MainActor
public protocol NoticeDetailFactory {
    func makeView(model: FetchNoticeEntity) -> UIViewController
}

@MainActor
public protocol QuestionFactory {
    func makeView() -> UIViewController
}

@MainActor
public protocol ServiceInfoFactory {
    func makeView() -> UIViewController
}

@MainActor
public protocol ProfilePopupFactory {
    func makeView(completion: (() -> Void)?) -> UIViewController
}
