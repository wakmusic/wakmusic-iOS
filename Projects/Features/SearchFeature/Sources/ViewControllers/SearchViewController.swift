import BaseFeature
import BaseFeatureInterface
import DesignSystem
import NeedleFoundation
import PanModal
import ReactorKit
import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import UIKit
import Utility

internal final class SearchViewController: BaseStoryboardReactorViewController<SearchReactor>, ContainerViewType,
    EqualHandleTappedType {
    private enum Font {
        static let headerFontSize: CGFloat = 16
    }

    private enum Color {
        static let pointColor: UIColor = DesignSystemAsset.PrimaryColor.point.color
        static let grayColor: UIColor = DesignSystemAsset.GrayColor.gray400.color
    }

    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchTextFiled: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchHeaderView: UIView!
    @IBOutlet public weak var contentView: UIView!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!

    var beforeSearchComponent: BeforeSearchComponent!
    var afterSearchComponent: AfterSearchComponent!
    var textPopUpFactory: TextPopUpFactory!

    private lazy var beforeVC = beforeSearchComponent.makeView().then {
        $0.delegate = self
    }

    private lazy var afterVC = afterSearchComponent.makeView()

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    public static func viewController(
        reactor: SearchReactor,
        beforeSearchComponent: BeforeSearchComponent,
        afterSearchComponent: AfterSearchComponent,
        textPopUpFactory: TextPopUpFactory
    ) -> SearchViewController {
        let viewController = SearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)

        viewController.reactor = reactor
        viewController.beforeSearchComponent = beforeSearchComponent
        viewController.afterSearchComponent = afterSearchComponent
        viewController.textPopUpFactory = textPopUpFactory
        return viewController
    }

    override public func configureUI() {
        super.configureUI()

        // MARK: 검색 돋보기 이미지
        self.searchImageView.image = DesignSystemAsset.Search.search.image.withRenderingMode(.alwaysTemplate)

        // MARK: 서치바
        self.searchTextFiled.borderStyle = .none // 텍스트 필드 테두리 제거
        self.searchTextFiled.font = DesignSystemFontFamily.Pretendard.medium.font(size: Font.headerFontSize)

        // MARK: 검색 취소 버튼
        self.cancelButton.titleLabel?.text = "취소"
        self.cancelButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 12)
        self.cancelButton.layer.cornerRadius = 4
        self.cancelButton.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.backgroundColor = .white

        self.searchTextFiled.tintColor = UIColor.white
        self.view.backgroundColor = .clear

        self.add(asChildViewController: beforeVC)
    }

    override public func bind(reactor: SearchReactor) {
        super.bind(reactor: reactor)
    }

    override public func bindState(reactor: SearchReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share(replay: 1)

        sharedState
            .map { ($0.typingState, $0.text) }
            .withUnretained(self)
            .bind { owner, data in

                let (state, text) = data

                owner.cancelButton.alpha = state == .typing ? 1.0 : .zero
                owner.reactSearchHeader(state)
                owner.bindSubView(state)

                guard state == .search else {
                    return
                }

                if text.isEmpty {
                    guard let textPopupViewController = owner.textPopUpFactory.makeView(
                        text: "검색어를 입력해주세요.",
                        cancelButtonIsHidden: true,
                        allowsDragAndTapToDismiss: nil,
                        confirmButtonText: nil,
                        cancelButtonText: nil,
                        completion: nil,
                        cancelCompletion: nil
                    ) as? TextPopupViewController else {
                        return
                    }
                    owner.showPanModal(content: textPopupViewController)
                } else {
                    PreferenceManager.shared.addRecentRecords(word: text)
                    UIView.setAnimationsEnabled(false)
                    owner.view.endEditing(true)
                    UIView.setAnimationsEnabled(true)
                }
            }
            .disposed(by: disposeBag)
    }

    override public func bindAction(reactor: SearchReactor) {
        super.bindAction(reactor: reactor)

        cancelButton.rx.tap
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.view.endEditing(true)
                owner.searchTextFiled.rx.text.onNext("")
                if let nowChildVc = owner.children.first as? AfterSearchViewController {
                    nowChildVc.clearSongCart()
                }
            })
            .map { _ in SearchReactor.Action.cancelButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchTextFiled
            .rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .map { SearchReactor.Action.updateText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        let editingDidBegin = searchTextFiled.rx.controlEvent(.editingDidBegin)
        let editingDidEnd = searchTextFiled.rx.controlEvent(.editingDidEnd)
        let editingDidEndOnExit = searchTextFiled.rx.controlEvent(.editingDidEndOnExit)

        let mergeObservable = Observable.merge(
            editingDidBegin.map { UIControl.Event.editingDidBegin },
            editingDidEnd.map { UIControl.Event.editingDidEnd },
            editingDidEndOnExit.map { UIControl.Event.editingDidEndOnExit }
        )

        mergeObservable
            .withUnretained(self)
            .bind { owner, event in

                if event == .editingDidBegin {
                    NotificationCenter.default.post(name: .statusBarEnterDarkBackground, object: nil)
                    reactor.action.onNext(.switchTypingState(.typing))

                } else if event == .editingDidEnd {
                    NotificationCenter.default.post(name: .statusBarEnterLightBackground, object: nil)

                } else {
                    reactor.action.onNext(.switchTypingState(.search))
                }
            }
            .disposed(by: disposeBag)

        RxKeyboard.instance.visibleHeight // 드라이브: 무조건 메인쓰레드에서 돌아감
            .drive(onNext: { [weak self] keyboardVisibleHeight in

                guard let self = self else {
                    return
                }
                // 키보드는 바텀 SafeArea부터 계산되므로 빼야함
                let window: UIWindow? = UIApplication.shared.windows.first
                let safeAreaInsetsBottom: CGFloat = window?.safeAreaInsets.bottom ?? 0
                let tmp = keyboardVisibleHeight - safeAreaInsetsBottom - 56 // 탭바 높이 추가
                self.contentViewBottomConstraint.constant = tmp > 0 ? tmp : 0
            })
            .disposed(by: disposeBag)
    }
}

extension SearchViewController {
    private func bindSubView(_ state: TypingStatus) {
        /*
         A:부모
         B:자식

         서브뷰 추가
         A.addChild(B)
         A.view.addSubview(B.view)
         B.didMove(toParent: A)

         서브뷰 삭제
         B.willMove(toParent: nil) // 제거되기 직전에 호출
         B.removeFromParent() // parentVC로 부터 관계 삭제
         B.view.removeFromSuperview() // parentVC.view.addsubView()와 반대 기능

         */

        if let nowChildVc = children.first as? BeforeSearchContentViewController {
            guard state == .search else {
                return
            }

            guard let text = reactor?.currentState.text else {
                return
            }

            self.remove(asChildViewController: beforeVC)
            self.add(asChildViewController: afterVC)

            guard let childReactor = afterVC.reactor else {
                return
            }

            childReactor.action.onNext(.updateData(text))
        } else if let nowChildVc = children.first as? AfterSearchViewController {
            guard state == .before || state == .typing else {
                return
            }
            self.remove(asChildViewController: afterVC)
            self.add(asChildViewController: beforeVC)
        }
    }

    private func reactSearchHeader(_ state: TypingStatus) {
        var placeHolderAttributes = [
            NSAttributedString.Key.foregroundColor: Color.grayColor,
            NSAttributedString.Key.font: DesignSystemFontFamily.Pretendard.medium.font(size: Font.headerFontSize)
        ]

        var bgColor: UIColor = .white
        var textColor: UIColor = .black
        var tintColor: UIColor = Color.grayColor

        if state == .typing {
            placeHolderAttributes[.foregroundColor] = UIColor.white
            bgColor = Color.pointColor
            textColor = .white
            tintColor = .white
        }

        self.searchHeaderView.backgroundColor = bgColor
        self.searchTextFiled.textColor = textColor
        self.searchTextFiled.attributedPlaceholder = NSAttributedString(
            string: "검색어를 입력하세요.",
            attributes: placeHolderAttributes
        )
        self.searchImageView.tintColor = tintColor
    }
}

extension SearchViewController: BeforeSearchContentViewDelegate {
    func itemSelected(_ keyword: String) {
        searchTextFiled.rx.text.onNext(keyword)
        PreferenceManager.shared.addRecentRecords(word: keyword)

        guard let reactor = reactor else {
            return
        }

        reactor.action.onNext(.updateText(keyword))
        reactor.action.onNext(.switchTypingState(.search))

        UIView.setAnimationsEnabled(false)
        view.endEditing(true) // 바인드 서브 뷰를 먼저 해야 tabMan tabBar가 짤리는 버그를 방지
        UIView.setAnimationsEnabled(true)
    }
}

extension SearchViewController {
    public func equalHandleTapped() {
        let viewControllersCount: Int = self.navigationController?.viewControllers.count ?? 0
        if viewControllersCount > 1 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            if let before = children.first as? BeforeSearchContentViewController {
                before.scrollToTop()
            } else if let after = children.first as? AfterSearchViewController {
                after.scrollToTop()
            }
        }
    }
}
