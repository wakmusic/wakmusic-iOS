import BaseFeature
import BaseFeatureInterface
import DesignSystem
import LogManager
import NeedleFoundation
import ReactorKit
import RxCocoa
import RxKeyboard
import RxSwift
import SearchFeatureInterface
import SnapKit
import UIKit
import Utility

final class SearchViewController: BaseStoryboardReactorViewController<SearchReactor>, @preconcurrency ContainerViewType,
    EqualHandleTappedType {
    private enum Font {
        static let headerFontSize: CGFloat = 16
    }

    private enum Color {
        static let pointColor: UIColor = DesignSystemAsset.PrimaryColorV2.point.color
        static let grayColor: UIColor = DesignSystemAsset.BlueGrayColor.gray400.color
    }

    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchTextFiled: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchHeaderView: UIView!
    @IBOutlet public weak var contentView: UIView!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var searchHeaderViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchHeaderContentView: UIView!
    private var beforeSearchComponent: BeforeSearchComponent!
    private var afterSearchComponent: AfterSearchComponent!
    private var textPopupFactory: TextPopupFactory!

    private lazy var beforeVC = beforeSearchComponent.makeView()

    private var afterVC: AfterSearchViewController?

    private var searchGlobalScrollState: SearchGlobalScrollProtocol!

    private let maxHeight: CGFloat = -56
    private var previousScrollOffset: CGFloat = 0

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogManager.analytics(CommonAnalyticsLog.viewPage(pageName: .search))
    }

    public static func viewController(
        reactor: SearchReactor,
        beforeSearchComponent: BeforeSearchComponent,
        afterSearchComponent: AfterSearchComponent,
        textPopupFactory: TextPopupFactory,
        searchGlobalScrollState: any SearchGlobalScrollProtocol
    ) -> SearchViewController {
        let viewController = SearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)

        viewController.reactor = reactor
        viewController.beforeSearchComponent = beforeSearchComponent
        viewController.afterSearchComponent = afterSearchComponent
        viewController.textPopupFactory = textPopupFactory
        viewController.searchGlobalScrollState = searchGlobalScrollState
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
        self.cancelButton.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray200.color.cgColor
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.backgroundColor = .white

        self.searchTextFiled.tintColor = UIColor.white
        self.view.backgroundColor = .clear

        self.add(asChildViewController: beforeVC)
    }

    override public func bind(reactor: SearchReactor) {
        super.bind(reactor: reactor)

        searchGlobalScrollState.scrollAmountObservable
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self, onNext: { owner, source in

                let offsetY: CGFloat = source.0
                let scrollDiff = offsetY - owner.previousScrollOffset
                let absoluteTop: CGFloat = 0
                let absoluteBottom: CGFloat = source.1
                let isScrollingDown = scrollDiff > 0 && offsetY > absoluteTop
                let isScrollingUp = scrollDiff < 0 && offsetY < absoluteBottom

                guard offsetY < absoluteBottom else { return }
                var newHeight = owner.searchHeaderViewTopConstraint.constant

                if isScrollingDown {
                    newHeight = max(owner.maxHeight, owner.searchHeaderViewTopConstraint.constant - abs(scrollDiff))
                } else if isScrollingUp {
                    if offsetY <= abs(owner.maxHeight) {
                        newHeight = min(0, owner.searchHeaderViewTopConstraint.constant + abs(scrollDiff))
                    }
                }

                if newHeight != owner.searchHeaderViewTopConstraint.constant {
                    owner.searchHeaderViewTopConstraint.constant = newHeight
                    owner.updateHeader()
                }
                owner.view.layoutIfNeeded()
                owner.previousScrollOffset = offsetY
            })
            .disposed(by: disposeBag)

        searchGlobalScrollState.expandSearchHeaderObservable
            .skip(1)
            .asDriver(onErrorJustReturn: ())
            .drive(with: self, onNext: { owner, _ in
                let openAmount = owner.searchHeaderViewTopConstraint.constant + abs(owner.maxHeight)
                let percentage = openAmount / abs(owner.maxHeight)

                guard percentage != 1 else { return }
                owner.searchHeaderContentView.alpha = 1
                owner.searchHeaderViewTopConstraint.constant = 0
                owner.searchHeaderView.backgroundColor = .white
            })
            .disposed(by: disposeBag)
    }

    private func updateHeader() {
        // percentage == 1 ? 확장 : 축소
        let openAmount = self.searchHeaderViewTopConstraint.constant + abs(self.maxHeight)
        let percentage = openAmount / abs(self.maxHeight)
        self.searchHeaderContentView.alpha = percentage
        self.searchHeaderView.backgroundColor = percentage == 0 ?
            DesignSystemAsset.BlueGrayColor.gray100.color : .white
    }

    override public func bindState(reactor: SearchReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        sharedState
            .map { ($0.typingState, $0.text) }
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind { owner, data in

                let (state, text) = data

                owner.cancelButton.alpha = state != .before ? 1.0 : .zero
                owner.reactSearchHeader(state)
                owner.bindSubView(state: state, text: text)

                guard state == .search else {
                    return
                }

                if text.isWhiteSpace {
                    guard let textPopupViewController = owner.textPopupFactory.makeView(
                        text: "검색어를 입력해주세요.",
                        cancelButtonIsHidden: true,
                        confirmButtonText: nil,
                        cancelButtonText: nil,
                        completion: nil,
                        cancelCompletion: nil
                    ) as? TextPopupViewController else {
                        return
                    }
                    owner.showBottomSheet(content: textPopupViewController)
                } else {
                    LogManager.setUserProperty(property: .latestSearchKeyword(keyword: text))
                    owner.searchTextFiled.rx.text.onNext(text)
                    PreferenceManager.shared.addRecentRecords(word: text)
                    owner.view.endEditing(true)
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
                    NotificationCenter.default.post(name: .willStatusBarEnterDarkBackground, object: nil)
                    reactor.action.onNext(.switchTypingState(.typing))

                } else if event == .editingDidEnd {
                    NotificationCenter.default.post(name: .willStatusBarEnterLightBackground, object: nil)

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
                let tmp = keyboardVisibleHeight - SAFEAREA_BOTTOM_HEIGHT() - 56 // 탭바 높이 추가
                self.contentViewBottomConstraint.constant = tmp > 0 ? tmp : 0
            })
            .disposed(by: disposeBag)
    }
}

extension SearchViewController {
    private func bindSubView(state: TypingStatus, text: String?) {
        if let nowChildVc = children.first as? BeforeSearchContentViewController {
            guard state == .search else {
                return
            }

            guard let text = text, !text.isWhiteSpace else {
                return
            }
            afterVC = afterSearchComponent.makeView(text: text)

            self.remove(asChildViewController: beforeVC)
            self.add(asChildViewController: afterVC)

        } else if let nowChildVc = children.first as? AfterSearchViewController {
            guard state == .before || state == .typing else {
                return
            }
            self.remove(asChildViewController: afterVC)
            afterVC = nil
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

extension SearchViewController {
    public nonisolated func equalHandleTapped() {
        Task { @MainActor in
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
}
