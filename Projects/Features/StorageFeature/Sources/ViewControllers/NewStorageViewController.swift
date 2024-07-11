import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Pageboy
import ReactorKit
import RxSwift
import SignInFeatureInterface
import Tabman
import UIKit
import Utility

final class NewStorageViewController: TabmanViewController, View {
    typealias Reactor = StorageReactor
    var disposeBag = DisposeBag()

    private var bottomSheetView: BottomSheetView!
    private var listStorageComponent: ListStorageComponent!
    private var multiPurposePopUpFactory: MultiPurposePopupFactory!
    private var likeStorageComponent: LikeStorageComponent!
    private var textPopUpFactory: TextPopUpFactory!
    private var signInFactory: SignInFactory!

    private var viewControllers: [UIViewController]!
    let storageView = StorageView()

    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = storageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    public static func viewController(
        reactor: Reactor,
        listStorageComponent: ListStorageComponent,
        multiPurposePopUpFactory: MultiPurposePopupFactory,
        likeStorageComponent: LikeStorageComponent,
        textPopUpFactory: TextPopUpFactory,
        signInFactory: SignInFactory
    ) -> NewStorageViewController {
        let viewController = NewStorageViewController(reactor: reactor)

        viewController.listStorageComponent = listStorageComponent
        viewController.multiPurposePopUpFactory = multiPurposePopUpFactory
        viewController.likeStorageComponent = likeStorageComponent
        viewController.viewControllers = [listStorageComponent.makeView(), likeStorageComponent.makeView()]
        viewController.textPopUpFactory = textPopUpFactory
        viewController.signInFactory = signInFactory
        return viewController
    }

    /// 탭맨 페이지 변경 감지 함수
    override public func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didScrollToPageAt index: TabmanViewController.PageIndex,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) {
        self.reactor?.action.onNext(.switchTab(index))
    }
}

extension NewStorageViewController {
    func bind(reactor: Reactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    func bindState(reactor: Reactor) {
        reactor.state.map(\.isEditing)
            .distinctUntilChanged()
            .bind(with: self) { owner, isEditing in
                owner.storageView.updateIsHiddenEditButton(isHidden: isEditing)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$showLoginAlert)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                guard let vc = owner.textPopUpFactory.makeView(
                    text: "로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?",
                    cancelButtonIsHidden: false,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        let loginVC = owner.signInFactory.makeView()
                        loginVC.modalPresentationStyle = .fullScreen
                        owner.present(loginVC, animated: true)
                    },
                    cancelCompletion: {}
                ) as? TextPopupViewController else {
                    return
                }
                owner.showBottomSheet(content: vc)
            })
            .disposed(by: disposeBag)
    }

    func bindAction(reactor: Reactor) {
        storageView.rx.editButtonDidTap
            .map { Reactor.Action.editButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        storageView.rx.saveButtonDidTap
            .map { Reactor.Action.saveButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

private extension NewStorageViewController {
    func configureUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // 탭바 설정
        self.dataSource = self
        let bar = TMBar.ButtonBar()

        // 배경색
        bar.backgroundView.style = .flat(color: .clear)

        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        bar.layout.contentMode = .intrinsic
        bar.layout.transitionStyle = .progressive
        bar.layout.interButtonSpacing = 24

        // 버튼 글씨 커스텀
        bar.buttons.customize { button in
            button.tintColor = DesignSystemAsset.BlueGrayColor.blueGray400.color
            button.selectedTintColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
            button.font = .WMFontSystem.t5(weight: .medium).font
            button.selectedFont = .WMFontSystem.t5(weight: .bold).font
        }

        // indicator
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = DesignSystemAsset.PrimaryColor.point.color
        bar.indicator.overscrollBehavior = .compress
        addBar(bar, dataSource: self, at: .custom(view: storageView.tabBarView, layout: nil))
    }
}

extension NewStorageViewController: PageboyViewControllerDataSource, TMBarDataSource {
    public func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        self.viewControllers.count
    }

    public func viewController(
        for pageboyViewController: Pageboy.PageboyViewController,
        at index: Pageboy.PageboyViewController.PageIndex
    ) -> UIViewController? {
        viewControllers[index]
    }

    public func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController
        .Page? {
        nil
    }

    public func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "내 리스트")
        case 1:
            return TMBarItem(title: "좋아요")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
}

extension NewStorageViewController: EqualHandleTappedType {
    func scrollToTop() {
        let current: Int = self.currentIndex ?? 0
        guard self.viewControllers.count > current else { return }
        if let myPlayList = self.viewControllers[current] as? ListStorageViewController {
            myPlayList.scrollToTop()
        } else if let favorite = self.viewControllers[current] as? FavoriteViewController {
            favorite.scrollToTop()
        }
    }

    public func equalHandleTapped() {
        let viewControllersCount: Int = self.navigationController?.viewControllers.count ?? 0
        if viewControllersCount > 1 {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
