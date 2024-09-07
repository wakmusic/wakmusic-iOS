import ArtistFeatureInterface
import BaseFeature
import CreditSongListFeatureInterface
import DesignSystem
import Kingfisher
import Localization
import LogManager
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

final class SongCreditViewController: BaseReactorViewController<SongCreditReactor> {
    private typealias SectionType = String
    private typealias ItemType = CreditModel.CreditWorker

    private let songCreditCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let songCreditLayout = CreditCollectionViewLayout()
        $0.collectionViewLayout = songCreditLayout
        $0.contentInset = .init(top: 0, left: 20, bottom: 20, right: 20)
        $0.backgroundColor = .clear
    }

    private lazy var creditPositionHeaderViewRegistration = UICollectionView.SupplementaryRegistration<
        CreditCollectionViewPositionHeaderView
    >(
        elementKind: UICollectionView.elementKindSectionHeader
    ) { [reactor] supplementaryView, _, indexPath in
        let position = reactor?.currentState.credits[safe: indexPath.section]?.position ?? ""
        supplementaryView.configure(position: position)
    }

    private lazy var creditCellRegistration = UICollectionView.CellRegistration<
        CreditCollectionViewCell, ItemType
    > { cell, _, itemIdentifier in
        cell.configure(name: itemIdentifier.name)
    }

    private lazy var creditDiffableDataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>(
        collectionView: songCreditCollectionView
    ) { [creditCellRegistration] collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueConfiguredReusableCell(
            using: creditCellRegistration,
            for: indexPath,
            item: itemIdentifier
        )
        return cell
    }.then {
        $0.supplementaryViewProvider = { [creditPositionHeaderViewRegistration] collectionView, kind, index in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: creditPositionHeaderViewRegistration,
                    for: index
                )
            } else {
                fatalError()
            }
        }
    }

    private let dismissButton = UIButton(type: .system).then {
        $0.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        $0.tintColor = .white
    }

    private let backgroundImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let warningView = UIView().then {
        $0.isHidden = true
    }

    private let warningImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DesignSystemAsset.LyricHighlighting.errorDark.image
    }

    private let warningLabel = WMLabel(
        text: "참여 정보가 없습니다.",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray200.color,
        font: .t6(weight: .light),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t6(weight: .light).lineHeight
    ).then {
        $0.numberOfLines = 0
        $0.preferredMaxLayoutWidth = APP_WIDTH() - 40
    }

    private let dimmedBackgroundView = UIView()
    private var dimmedGridentLayer: DimmedGradientLayer?
    private let wmNavigationbarView = WMNavigationBarView()

    private let creditSongListFactory: any CreditSongListFactory
    private let artistDetailFactory: any ArtistDetailFactory

    init(
        reactor: SongCreditReactor,
        creditSongListFactory: any CreditSongListFactory,
        artistDetailFactory: any ArtistDetailFactory
    ) {
        self.creditSongListFactory = creditSongListFactory
        self.artistDetailFactory = artistDetailFactory
        super.init(reactor: reactor)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let log = CommonAnalyticsLog.viewPage(pageName: .songCredit)
        LogManager.analytics(log)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if dimmedGridentLayer == nil {
            let dimmedGridentLayer = DimmedGradientLayer(frame: dimmedBackgroundView.bounds)
            dimmedBackgroundView.layer.insertSublayer(dimmedGridentLayer, at: 0)
            self.dimmedGridentLayer = dimmedGridentLayer
        }
    }

    override func addView() {
        view.addSubviews(
            backgroundImageView,
            dimmedBackgroundView,
            songCreditCollectionView,
            wmNavigationbarView,
            warningView
        )
        warningView.addSubviews(warningImageView, warningLabel)
    }

    override func setLayout() {
        songCreditCollectionView.snp.makeConstraints {
            $0.top.equalTo(wmNavigationbarView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        dimmedBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(STATUS_BAR_HEGHIT())
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }

        warningView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(APP_HEIGHT() * ((294.0 - 6.0) / 812.0))
            $0.centerX.equalToSuperview()
        }

        warningImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        warningLabel.snp.makeConstraints {
            $0.top.equalTo(warningImageView.snp.bottom).offset(-2)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    override func configureNavigation() {
        wmNavigationbarView.setLeftViews([dismissButton])
        wmNavigationbarView.setTitle(LocalizationStrings.titleCreditList, textColor: .white)
    }

    override func bindAction(reactor: SongCreditReactor) {
        self.rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        dismissButton.rx.tap
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        songCreditCollectionView.rx.itemSelected
            .compactMap { [reactor] indexPath in
                reactor.currentState.credits[safe: indexPath.section]?.names[safe: indexPath.row]
            }
            .do(onNext: { worker in
                let log = SongCreditAnalyticsLog.clickCreditItem(name: worker.name)
                LogManager.analytics(log)
            })
            .map(Reactor.Action.creditSelected(worker:))
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: SongCreditReactor) {
        let sharedState = reactor.state.share()

        sharedState.map(\.credits)
            .skip(1)
            .distinctUntilChanged()
            .bind { [creditDiffableDataSource, warningView] credits in
                warningView.isHidden = !credits.isEmpty
                var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
                snapshot.appendSections(credits.map(\.position))
                credits.forEach { snapshot.appendItems($0.names, toSection: $0.position) }
                creditDiffableDataSource.apply(snapshot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)

        sharedState.map(\.backgroundImageURL)
            .bind(with: backgroundImageView) { backgroundImageView, backgroundImageModel in
                let alternativeSources = [backgroundImageModel.alternativeImageURL]
                    .compactMap { URL(string: $0) }
                    .map { Source.network($0) }

                backgroundImageView.kf.setImage(
                    with: URL(string: backgroundImageModel.imageURL),
                    options: [
                        .transition(.fade(0.5)),
                        .processor(
                            DownsamplingImageProcessor(
                                size: .init(width: 10, height: 10)
                            )
                        ),
                        .alternativeSources(alternativeSources)
                    ]
                )
            }
            .disposed(by: disposeBag)

        sharedState
            .compactMap(\.navigateType)
            .bind(with: self) { owner, navigate in
                switch navigate {
                case .back:
                    owner.back()

                case let .creditDetail(worker):
                    owner.navigateCreditDetail(worker: worker)
                }
            }
            .disposed(by: disposeBag)
    }
}

private extension SongCreditViewController {
    func back() {
        self.navigationController?.popViewController(animated: true)
    }

    func navigateCreditDetail(worker: CreditModel.CreditWorker) {
        switch worker.creditType {
        case .default:
            let viewController = creditSongListFactory.makeViewController(workerName: worker.name)
            self.navigationController?.pushViewController(viewController, animated: true)

        case let .artist(artistID):
            let viewController = artistDetailFactory.makeView(artistID: artistID)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
