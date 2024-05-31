import BaseFeature
import BaseFeatureInterface
import DesignSystem
import NeedleFoundation
import NVActivityIndicatorView
import PlayListDomainInterface
import PlaylistFeatureInterface
import ReactorKit
import RxCocoa
import RxSwift
import UIKit
import Utility
import LogManager


// DatSource model 실제 Entity로 교체


public final class BeforeSearchContentViewController: BaseReactorViewController<BeforeSearchReactor> {
    
    fileprivate enum Section: Int {
        case top
        case mid
        case bottom
    }

    enum DataSource: Hashable {
        case youtube(model: Model)
        case recommand(model2: Model)
        case popularList(model: Model)

        var title: String {
            switch self {
            case let .youtube(model):
                return model.title
            case let .recommand(model2):
                return model2.title
            case let .popularList(model):
                return model.title
            }
        }
    }

    fileprivate var playlistDetailFactory: PlaylistDetailFactory!
    fileprivate var textPopUpFactory: TextPopUpFactory!
    fileprivate var dataSource: UICollectionViewDiffableDataSource<Section, DataSource>! = nil
    
    fileprivate var collectionView: UICollectionView! = nil
    
    fileprivate var tableView: UITableView = UITableView().then {
        $0.register(RecentRecordTableViewCell.self, forCellReuseIdentifier: "RecentRecordTableViewCell")
        $0.separatorStyle = .none
        $0.isHidden = true
    }



    init(
        textPopUpFactory: TextPopUpFactory,
        playlistDetailFactory: PlaylistDetailFactory,
        reactor: BeforeSearchReactor
    ) {
        super.init(reactor: reactor)
        self.textPopUpFactory = textPopUpFactory
        self.playlistDetailFactory = playlistDetailFactory
    }

    deinit {
        DEBUG_LOG("❌ \(Self.self)")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
    }

    override public func addView() {
        super.addView()
        self.view.addSubviews(tableView)
        createCollectionView()
        configureDataSource()
    }

    override public func setLayout() {
        super.setLayout()

        tableView.snp.makeConstraints {
            $0.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
    }

    override public func configureUI() {
        super.configureUI()
        self.tableView.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: APP_WIDTH(), height: PLAYER_HEIGHT()))
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: PLAYER_HEIGHT(), right: 0)
        self.indicator.type = .circleStrokeSpin
        self.indicator.color = DesignSystemAsset.PrimaryColor.point.color
    }

    override public func bind(reactor: BeforeSearchReactor) {
        self.indicator.startAnimating()
        super.bind(reactor: reactor)
        self.indicator.stopAnimating()

        // 헤더 적용을 위한 델리게이트
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
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

        let sharedState = reactor.state.share(replay: 2)
        
        // 검색 전, 최근 검색어 스위칭
        sharedState.map(\.showRecommend)
            .withUnretained(self)
            .bind { (owner, flag) in
                owner.tableView.isHidden = flag
                owner.collectionView.isHidden = !flag
            }
            .disposed(by: disposeBag)
        
        // 최근 검색어 tableView 셋팅
        Utility.PreferenceManager.$recentRecords
            .compactMap({ $0 ?? []})
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

        if (Utility.PreferenceManager.recentRecords ?? []).isEmpty {
            return (APP_HEIGHT() * 3) / 8
        } else {
            return 68
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 300))
        warningView.text = "최근 검색 기록이 없습니다."

        guard let state = reactor?.currentState else {
            return nil
        }

        let recentRecordHeaderView = RecentRecordHeaderView()

        // 최근 검색어 전체 삭제 버튼 클릭 이벤트 받는 통로
        recentRecordHeaderView.completionHandler = { [weak self] in

            guard let self = self, let textPopupViewController = self.textPopUpFactory.makeView(
                text: "전체 내역을 삭제하시겠습니까?",
                cancelButtonIsHidden: false,
                allowsDragAndTapToDismiss: nil,
                confirmButtonText: nil,
                cancelButtonText: nil,
                completion: { Utility.PreferenceManager.recentRecords = nil },
                cancelCompletion: nil
            ) as? TextPopupViewController else {
                return
            }

            self.showPanModal(content: textPopupViewController)
        }

        if (Utility.PreferenceManager.recentRecords ?? []).isEmpty {
            return warningView

        } else {
            return recentRecordHeaderView
        }
    }
}

// MARK: Compositional
extension BeforeSearchContentViewController {
    func createCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

        collectionView.backgroundColor = .systemGray
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

                guard let self else { return nil }

                guard let layoutKind = Section(rawValue: sectionIndex) else { return nil }

                return self.configureSection(layoutKind)
        }

        return layout
    }

    private func configureSection(_ layout: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        var item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 8, bottom: 0, trailing: 8)

        var group: NSCollectionLayoutGroup! = nil
        var section: NSCollectionLayoutSection! = nil
        let headerLayout = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerLayout,
            elementKind: BeforeSearchSectionHeaderView.kind,
            alignment: .top
        )

        header.contentInsets = .init(top: .zero, leading: 8, bottom: .zero, trailing: 8)

        switch layout {
        case .top:

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.87)
            )
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: 20, trailing: .zero)

        case .mid:

            let groupWidth: CGFloat = (APP_WIDTH() - (20 + 8 + 20)) / 2.0
            let groupeight: CGFloat = (80.0 * groupWidth) / 164.0

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(groupWidth),
                heightDimension: .absolute(groupeight)
            )
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)

        case .bottom:

            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(190))

            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        }

        section.orthogonalScrollingBehavior = .continuous

        return section
    }

    private func configureDataSource() {
        let youtubeCellRegistration = UICollectionView
            .CellRegistration<YoutubeThumbnailCell, Model> { cell, indexPath, item in
            }

        let recommandCellRegistration = UICollectionView.CellRegistration<RecommendPlayListCell, Model>(cellNib: UINib(
            nibName: "RecommendPlayListCell",
            bundle: BaseFeatureResources.bundle
        )) { cell, indexPath, itemIdentifier in
            cell.update(model: RecommendPlayListEntity(
                key: "best",
                title: "임시 플레이리스트",
                image_round_version: 1,
                image_sqaure_version: 1
            ))
        }

        let popularListCellRegistration = UICollectionView
            .CellRegistration<PopularPlayListCell, Model> { cell, indexPath, item in

                cell.update(item)
            }

        let headerRegistration = UICollectionView
            .SupplementaryRegistration<BeforeSearchSectionHeaderView>(
                elementKind: BeforeSearchSectionHeaderView
                    .kind
            ) { [weak self] supplementaryView, string, indexPath in

                guard let self else { return }
                supplementaryView.delegate = self
                supplementaryView.update("임시 타이틀", indexPath.section)
            }

        dataSource = UICollectionViewDiffableDataSource<Section, DataSource>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: DataSource) -> UICollectionViewCell? in

            switch item {
            case let .youtube(model: model):
                return collectionView.dequeueConfiguredReusableCell(
                    using: youtubeCellRegistration,
                    for: indexPath,
                    item: model
                )
            case let .recommand(model2: model2):
                return
                    collectionView.dequeueConfiguredReusableCell(
                        using: recommandCellRegistration,
                        for: indexPath,
                        item: model2
                    )

            case let .popularList(model: model):
                return collectionView.dequeueConfiguredReusableCell(
                    using: popularListCellRegistration,
                    for: indexPath,
                    item: model
                )
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, index in

            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, DataSource>()
        snapshot.appendSections([.top, .mid, .bottom])
        snapshot.appendItems([.youtube(model: Model(title: "Hello"))], toSection: .top)
        snapshot.appendItems(
            [
                .recommand(model2: Model(title: "123")),
                .recommand(model2: Model(title: "456")),
                .recommand(model2: Model(title: "4564")),
                .recommand(model2: Model(title: "4516")),
            ],
            toSection: .mid
        )
        snapshot.appendItems(
            [
                .popularList(model: Model(title: "Hello1")),
                .popularList(model: Model(title: "Hello2")),
                .popularList(model: Model(title: "Hello3")),
            ],
            toSection: .bottom
        )
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: CollectionView Deleagte
extension BeforeSearchContentViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = dataSource.itemIdentifier(for: indexPath) as? DataSource else {
            return
        }

        switch model {
        case let .youtube(model: model):
            LogManager.printDebug("youtube \(model)")
        case let .recommand(model2: model2):
            LogManager.printDebug("recommand \(model2)")
        case let .popularList(model: model):
            LogManager.printDebug("popular \(model)")
        }
    }
}

// MARK: 전체보기
extension BeforeSearchContentViewController: BeforeSearchSectionHeaderViewDelegate {
    func tap(_ section: Int?) {
        if let section = section, let layoutKind = Section(rawValue: section) {
            print(layoutKind)
        }
    }
}

extension BeforeSearchContentViewController {
    func scrollToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }
}
