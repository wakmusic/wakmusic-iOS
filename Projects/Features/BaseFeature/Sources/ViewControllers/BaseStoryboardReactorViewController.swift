import NVActivityIndicatorView
import ReactorKit
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

open class BaseStoryboardReactorViewController<R: Reactor>: UIViewController, StoryboardView,
    ViewControllerFromStoryBoard {
    public var disposeBag = DisposeBag()

//    @available(*, unavailable)
//    public required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

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
        // 내용 유지?
        if #available(iOS 15.0, *) {
            let tableViews = self.view.subviews
                .compactMap { $0 as? UITableView }
                .forEach {
                    $0.sectionHeaderTopPadding = 0
                }
        }
    }

    open func configureNavigation() {
        // 내용 유지?
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    open func bindState(reactor: R) {}
    open func bindAction(reactor: R) {}
}
