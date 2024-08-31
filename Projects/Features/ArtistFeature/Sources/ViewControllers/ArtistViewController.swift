import ArtistFeatureInterface
import BaseFeature
import DesignSystem
import Localization
import LogManager
import NeedleFoundation
import NVActivityIndicatorView
import ReactorKit
import RxCocoa
import RxSwift
import UIKit
import Utility

public final class ArtistViewController:
    BaseViewController,
    ViewControllerFromStoryBoard,
    EqualHandleTappedType,
    StoryboardView {
    public typealias Reactor = ArtistReactor

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    private let retryWarningView = WMRetryWarningView(
        description: LocalizationStrings.unknownErrorWarning,
        retryButtonTitle: LocalizationStrings.titleRetry
    )
    private let translucentView = UIVisualEffectView(effect: UIBlurEffect(style: .light)).then {
        $0.alpha = 0
    }

    var artistDetailFactory: ArtistDetailFactory!
    public var disposeBag: DisposeBag = DisposeBag()

    override public func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLayout()
        configureUI()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        LogManager.analytics(ArtistAnalyticsLog.viewPage(pageName: "artist"))
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    public func bind(reactor: ArtistReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindAction(reactor: ArtistReactor) {
        reactor.action.onNext(Reactor.Action.viewDidLoad)
        // Storyboard 기반이기에 바로 viewDidLoad로 onNext, 만약 codebase로 전환 시 `methodInvoked(#selector(viewDidLoad))` 로 옵저빙

        collectionView.rx.itemSelected
            .withLatestFrom(reactor.state.map(\.artistList)) { ($0, $1) }
            .do(onNext: { [collectionView] indexPath, _ in
                guard let cell = collectionView?.cellForItem(at: indexPath) as? ArtistListCell else { return }
                cell.animateSizeDownToUp(timeInterval: 0.3)
            })
            .delay(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .map { $0.1[$0.0.row] }
            .bind(with: self) { owner, entity in
                LogManager.analytics(ArtistAnalyticsLog.clickArtistItem(artist: entity.id))
                let viewController = owner.artistDetailFactory.makeView(artistID: entity.id)
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)

        collectionView.rx.didScroll
            .bind(with: self) { owner, _ in
                let offsetY: CGFloat = owner.collectionView.contentOffset.y + STATUS_BAR_HEGHIT()
                owner.translucentView.alpha = min(max(offsetY / owner.translucentView.frame.height, 0), 1)
            }
            .disposed(by: disposeBag)
    }

    private func bindState(reactor: ArtistReactor) {
        let sharedState = reactor.state.share(replay: 1)

        sharedState.map(\.artistList)
            .skip(1)
            .do(onNext: { [activityIndicator, retryWarningView] entities in
                retryWarningView.isHidden = !entities.isEmpty
                activityIndicator?.stopAnimating()
            })
            .bind(to: collectionView.rx.items) { collectionView, index, artist in
                let indexPath = IndexPath(item: index, section: 0)
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ArtistListCell",
                    for: indexPath
                ) as? ArtistListCell else {
                    return UICollectionViewCell()
                }
                cell.update(model: artist)
                return cell
            }
            .disposed(by: disposeBag)
    }

    public static func viewController(
        reactor: ArtistReactor,
        artistDetailFactory: ArtistDetailFactory
    ) -> ArtistViewController {
        let viewController = ArtistViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        viewController.reactor = reactor
        viewController.artistDetailFactory = artistDetailFactory
        return viewController
    }
}

private extension ArtistViewController {
    func addSubviews() {
        view.addSubviews(retryWarningView, translucentView)
    }

    func setLayout() {
        let topOffset = (APP_HEIGHT() - SAFEAREA_BOTTOM_HEIGHT() - PLAYER_HEIGHT() - 160) / 3.0
        retryWarningView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(topOffset + STATUS_BAR_HEGHIT())
        }

        translucentView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }

    func configureUI() {
        view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        activityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.startAnimating()

        let sideSpace: CGFloat = 20.0
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 15, left: sideSpace, bottom: 15, right: sideSpace)
//        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 8 // 열 사이의 간격
        layout.headerHeight = 0
        layout.footerHeight = 56.0

        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.showsVerticalScrollIndicator = false

        retryWarningView.isHidden = true
        retryWarningView.delegate = self
    }
}

extension ArtistViewController: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY: CGFloat = scrollView.contentOffset.y + STATUS_BAR_HEGHIT()
        translucentView.alpha = min(max(offsetY / translucentView.frame.height, 0), 1)
    }
}

extension ArtistViewController: WMRetryWarningViewDelegate {
    public func tappedRetryButton() {
        retryWarningView.isHidden = true
        activityIndicator.startAnimating()
        reactor?.action.onNext(Reactor.Action.viewDidLoad)
    }
}

extension ArtistViewController: WaterfallLayoutDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout: WaterfallLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let originWidth: CGFloat = 106.0
        let originHeight: CGFloat = 130.0
        let rate: CGFloat = originHeight / max(1.0, originWidth)

        let sideSpace: CGFloat = 8.0
        let width: CGFloat = APP_WIDTH() - ((sideSpace * 2.0) + 40.0)
        let topSpace: CGFloat = 55.0
        let spacingWithNameHeight: CGFloat = 4.0 + 24.0 + topSpace + 15
        let imageHeight: CGFloat = width * rate

        switch indexPath.item {
        case 0, 2:
            return CGSize(width: width, height: imageHeight + (width / 2) + spacingWithNameHeight)
        default:
            return CGSize(width: width, height: imageHeight + spacingWithNameHeight)
        }
    }

    public func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 3, distributionMethod: .balanced)
    }
}

public extension ArtistViewController {
    func equalHandleTapped() {
        let viewControllersCount: Int = self.navigationController?.viewControllers.count ?? 0
        if viewControllersCount > 1 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            guard reactor?.currentState.artistList.isEmpty == false else { return }
            self.collectionView.setContentOffset(CGPoint(x: 0, y: -STATUS_BAR_HEGHIT()), animated: true)
        }
    }
}

extension ArtistViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
