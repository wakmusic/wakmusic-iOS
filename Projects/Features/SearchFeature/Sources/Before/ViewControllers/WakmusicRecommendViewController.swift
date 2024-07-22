import BaseFeature
import DesignSystem
import LogManager
import PlaylistDomainInterface
import PlaylistFeatureInterface
import UIKit
import Utility

final class WakmusicRecommendViewController: BaseReactorViewController<WakmusicRecommendReactor> {
    private let wakmusicPlaylistDetailFactory: any WakmusicPlaylistDetailFactory

    private let wmNavigationbarView = WMNavigationBarView().then {
        $0.setTitle("왁뮤팀이 추천하는 리스트")
    }

    private let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
        $0.setImage(dismissImage, for: .normal)
    }

    private lazy var collectionView: UICollectionView = createCollectionView().then {
        $0.backgroundColor = .clear
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<RecommendSection, RecommendPlaylistEntity> =
        createDataSource()

    init(wakmusicPlaylistDetailFactory: any WakmusicPlaylistDetailFactory, reactor: WakmusicRecommendReactor) {
        self.wakmusicPlaylistDetailFactory = wakmusicPlaylistDetailFactory
        super.init(reactor: reactor)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        reactor?.action.onNext(.viewDidLoad)

        LogManager.analytics(CommonAnalyticsLog.viewPage(pageName: .wakmusicRecommendPlaylist))
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    override func addView() {
        super.addView()
        self.view.addSubviews(wmNavigationbarView, collectionView)
    }

    override func setLayout() {
        super.setLayout()

        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(STATUS_BAR_HEGHIT())
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
        wmNavigationbarView.setLeftViews([dismissButton])

        collectionView.snp.makeConstraints {
            $0.top.equalTo(wmNavigationbarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    override func bind(reactor: WakmusicRecommendReactor) {
        super.bind(reactor: reactor)
        collectionView.delegate = self
    }

    override func bindState(reactor: WakmusicRecommendReactor) {
        super.bindState(reactor: reactor)
        let sharedState = reactor.state.share()

        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .bind(with: self) { owner, message in
                owner.showToast(text: message, font: .setFont(.t6(weight: .light)))
            }
            .disposed(by: disposeBag)

        sharedState.map(\.dataSource)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, recommendPlaylist in

                var snapShot = owner.dataSource.snapshot(for: .main)
                snapShot.append(recommendPlaylist)
                owner.dataSource.apply(snapShot, to: .main)

            })
            .disposed(by: disposeBag)

        sharedState.map(\.isLoading)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, isLoading in
                if isLoading {
                    owner.indicator.startAnimating()
                } else {
                    owner.indicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: WakmusicRecommendReactor) {
        super.bindAction(reactor: reactor)

        dismissButton.rx
            .tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension WakmusicRecommendViewController {
    private func createCollectionView() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: RecommendCollectionViewLayout())
    }

    private func createDataSource() -> UICollectionViewDiffableDataSource<RecommendSection, RecommendPlaylistEntity> {
        let recommendCellRegistration = UICollectionView.CellRegistration<
            RecommendPlayListCell,
            RecommendPlaylistEntity
        >(cellNib: UINib(
            nibName: "RecommendPlayListCell",
            bundle: BaseFeatureResources.bundle
        )) { cell, indexPath, item in
            cell.update(
                model: item
            )
        }
        let dataSource = UICollectionViewDiffableDataSource<
            RecommendSection,
            RecommendPlaylistEntity
        >(collectionView: collectionView) {
            (
                collectionView: UICollectionView, indexPath: IndexPath, item: RecommendPlaylistEntity
            ) -> UICollectionViewCell? in

            return
                collectionView.dequeueConfiguredReusableCell(
                    using: recommendCellRegistration,
                    for: indexPath,
                    item: item
                )
        }

        return dataSource
    }

    private func initDataSource() {
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<RecommendSection, RecommendPlaylistEntity>()

        snapshot.appendSections([.main])

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension WakmusicRecommendViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        self.navigationController?.pushViewController(
            wakmusicPlaylistDetailFactory.makeView(key: model.key),
            animated: true
        )
    }
}
