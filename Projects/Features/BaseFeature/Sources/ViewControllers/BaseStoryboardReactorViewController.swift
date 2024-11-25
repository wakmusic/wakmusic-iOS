import NVActivityIndicatorView
import ReactorKit
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

open class BaseStoryboardReactorViewController<R: Reactor>: UIViewController,
                                                            @preconcurrency StoryboardView,
                                                            ViewControllerFromStoryBoard {
    public var disposeBag = DisposeBag()

    override open func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
    }

    open func bind(reactor: R) {
        bindState(reactor: reactor)
        bindAction(reactor: reactor)
    }

    open func configureUI() {
        self.view.subviews
            .compactMap { $0 as? UITableView }
            .forEach {
                $0.sectionHeaderTopPadding = 0
            }
    }

    open func configureNavigation() {
        // 내용 유지?
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    open func bindState(reactor: R) {}
    open func bindAction(reactor: R) {}
}
