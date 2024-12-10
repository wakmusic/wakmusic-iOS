import BaseFeature
import BaseFeatureInterface
import ChartDomainInterface
import DesignSystem
import LogManager
import NeedleFoundation
import NVActivityIndicatorView
import PlaylistDomainInterface
import PlaylistFeatureInterface
import ReactorKit
import RxCocoa
import RxSwift
import UIKit
import Utility

final class BeforeSearchContentViewController: BaseReactorViewController<BeforeSearchReactor>, PlaylistDetailNavigator {
    private let wakmusicRecommendComponent: WakmusicRecommendComponent
    private let textPopupFactory: TextPopupFactory
    private(set) var playlistDetailFactory: any PlaylistDetailFactory

    private let tableView: UITableView = UITableView().then {
        $0.register(RecentRecordTableViewCell.self, forCellReuseIdentifier: "RecentRecordTableViewCell")
        $0.separatorStyle = .none
        $0.isHidden = true
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<BeforeSearchSection, BeforeVcDataSoruce> =
        createDataSource()

    private lazy var collectionView: UICollectionView = createCollectionView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
    }

    init(
        wakmusicRecommendComponent: WakmusicRecommendComponent,
        textPopupFactory: TextPopupFactory,
        playlistDetailFactory: any PlaylistDetailFactory,
        reactor: BeforeSearchReactor
    ) {
        self.textPopupFactory = textPopupFactory
        self.wakmusicRecommendComponent = wakmusicRecommendComponent
        self.playlistDetailFactory = playlistDetailFactory
        super.init(reactor: reactor)
    }

    deinit {
        LogManager.printDebug("❌ \(Self.self)")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
    }

    override public func addView() {
        super.addView()
        self.view.addSubviews(collectionView, tableView)
    }

    override public func setLayout() {
        super.setLayout()

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override public func configureUI() {
        super.configureUI()

        self.tableView.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        self.tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: APP_WIDTH(), height: PLAYER_HEIGHT()))
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: PLAYER_HEIGHT(), right: 0)
    }

    override public func bind(reactor: BeforeSearchReactor) {
        super.bind(reactor: reactor)

        // 헤더 적용을 위한 델리게이트
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        collectionView.delegate = self
    }

    override public func bindAction(reactor: BeforeSearchReactor) {
        super.bindAction(reactor: reactor)

        tableView.rx.modelSelected(String.self)
            .map { Reactor.Action.rencentTextDidTap($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    override public func bindState(reactor: BeforeSearchReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .bind(with: self) { owner, message in
                owner.showToast(text: message, font: .setFont(.t6(weight: .light)))
            }
            .disposed(by: disposeBag)

        sharedState.map(\.isLoading)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { onwer, isLoading in

                if isLoading {
                    onwer.indicator.startAnimating()
                } else {
                    onwer.indicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)

        // 검색 전, 최근 검색어 스위칭
        sharedState.map(\.showRecommend)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, flag in
                owner.tableView.isHidden = flag
                owner.collectionView.isHidden = !flag
            }
            .disposed(by: disposeBag)

        // 최근 검색어 tableView 셋팅
        Utility.PreferenceManager.shared.$recentRecords
            .compactMap { $0 ?? [] }
            .bind(to: tableView.rx.items) { (
                tableView: UITableView,
                index: Int,
                element: String
            ) -> RecentRecordTableViewCell in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "RecentRecordTableViewCell",
                    for: IndexPath(row: index, section: 0)
                ) as? RecentRecordTableViewCell else {
                    return RecentRecordTableViewCell()
                }
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.update(element)

                return cell
            }.disposed(by: disposeBag)

        sharedState.map(\.dataSource)
            .bind(with: self) { owner, dataSource in

                var snapShot = NSDiffableDataSourceSnapshot<BeforeSearchSection, BeforeVcDataSoruce>()
                snapShot.appendSections([.youtube, .recommend])

                snapShot.appendItems([.youtube(model: dataSource.currentVideo)], toSection: .youtube)
                snapShot.appendItems(dataSource.recommendPlayList.map { .recommend(model: $0) }, toSection: .recommend)

                #warning("추후 업데이트 시 사용")
                // snapShot.appendItems(tmp.map { .popularList(model: $0) }, toSection: .popularList)

                owner.dataSource.apply(snapShot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
    }
}

extension BeforeSearchContentViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let state = reactor?.currentState else {
            return .zero
        }

        if (Utility.PreferenceManager.shared.recentRecords ?? []).isEmpty {
            return (APP_HEIGHT() * 3) / 8
        } else {
            return 68
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 300))
        warningView.text = "최근 검색 기록이 없습니다."

        let recentRecordHeaderView = RecentRecordHeaderView()

        // 최근 검색어 전체 삭제 버튼 클릭 이벤트 받는 통로
        recentRecordHeaderView.completionHandler = { [weak self] in

            guard let self = self, let textPopupViewController = self.textPopupFactory.makeView(
                text: "전체 내역을 삭제하시겠습니까?",
                cancelButtonIsHidden: false,
                confirmButtonText: nil,
                cancelButtonText: nil,
                completion: { Utility.PreferenceManager.shared.recentRecords = nil },
                cancelCompletion: nil
            ) as? TextPopupViewController else {
                return
            }

            self.showBottomSheet(content: textPopupViewController)
        }

        if (Utility.PreferenceManager.shared.recentRecords ?? []).isEmpty {
            return warningView

        } else {
            return recentRecordHeaderView
        }
    }
}

// MARK: Compositional
extension BeforeSearchContentViewController {
    private func createCollectionView() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: BeforeSearchCollectionViewLayout())
    }

    private func createDataSource() -> UICollectionViewDiffableDataSource<BeforeSearchSection, BeforeVcDataSoruce> {
        // MARK: Cell

        let youtubeCellRegistration = UICollectionView
            .CellRegistration<YoutubeThumbnailCell, CurrentVideoEntity> { cell, indexPath, itemIdentifier in

                cell.update(model: itemIdentifier)
            }

        let recommendCellRegistration = UICollectionView.CellRegistration<
            RecommendPlayListCell,
            RecommendPlaylistEntity
        >(cellNib: UINib(
            nibName: "RecommendPlayListCell",
            bundle: BaseFeatureResources.bundle
        )) { cell, indexPath, itemIdentifier in
            cell.update(model: itemIdentifier)
        }

        #warning("추후 업데이트 시 사용")
//        let popularListCellRegistration = UICollectionView
//            .CellRegistration<PopularPlayListCell, Model> { cell, indexPath, item in
//
//                cell.update(item)
//            }

        // MARK: Header

        let headerRegistration = UICollectionView
            .SupplementaryRegistration<BeforeSearchSectionHeaderView>(
                elementKind: BeforeSearchSectionHeaderView
                    .kind
            ) { [weak self] supplementaryView, string, indexPath in

                guard let self, let layoutKind = BeforeSearchSection(rawValue: indexPath.section) else { return }
                supplementaryView.delegate = self
                supplementaryView.update(layoutKind.title, indexPath.section)
            }

        let dataSource = UICollectionViewDiffableDataSource<
            BeforeSearchSection,
            BeforeVcDataSoruce
        >(collectionView: collectionView) {
            (
                collectionView: UICollectionView,
                indexPath: IndexPath,
                item: BeforeVcDataSoruce
            ) -> UICollectionViewCell? in

            switch item {
            case let .youtube(model: model):
                return collectionView.dequeueConfiguredReusableCell(
                    using: youtubeCellRegistration,
                    for: indexPath,
                    item: model
                )
            case let .recommend(model: model):
                return
                    collectionView.dequeueConfiguredReusableCell(
                        using: recommendCellRegistration,
                        for: indexPath,
                        item: model
                    )

//            case let .popularList(model: model):
//                break
                #warning("추후 업데이트 시 사용")
//                return collectionView.dequeueConfiguredReusableCell(
//                    using: popularListCellRegistration,
//                    for: indexPath,
//                    item: model
//                )
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, index in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }

        return dataSource
    }
}

// MARK: CollectionView Deleagate
extension BeforeSearchContentViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        switch model {
        case let .youtube(model: model):
            // 주간 왁뮤
            WakmusicYoutubePlayer(id: model.id, playPlatform: .youtube).play()
            LogManager.analytics(SearchAnalyticsLog.clickLatestWakmuYoutubeVideo)
        case let .recommend(model: model):
            let log = CommonAnalyticsLog.clickPlaylistItem(location: .search, key: model.key)
            LogManager.analytics(log)
            navigateWMPlaylistDetail(key: model.key)

            #warning("추후 업데이트 시 사용")
//        case let .popularList(model: model):
//            LogManager.printDebug("popular \(model)")
        }
    }
}

// MARK: 전체보기
extension BeforeSearchContentViewController: BeforeSearchSectionHeaderViewDelegate {
    func tap(_ section: Int?) {
        if let section = section, let layoutKind = BeforeSearchSection(rawValue: section) {
            switch layoutKind {
            case .youtube:
                break
            case .recommend:
//                LogManager.analytics(SearchAnalyticsLog.clickRecommendPlaylistMore)
//                self.navigationController?.pushViewController(wakmusicRecommendComponent.makeView(), animated: true)
                #warning("추후 업데이트 시 사용")
                break
            case .popularList:
                #warning("추후 업데이트 시 사용")
                break
            }
        }
    }
}

extension BeforeSearchContentViewController {
    func scrollToTop() {
        collectionView.scroll(to: .top)
    }
}
