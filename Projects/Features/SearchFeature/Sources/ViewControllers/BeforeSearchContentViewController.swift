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



public final class BeforeSearchContentViewController: BaseReactorViewController<BeforeSearchReactor> {
    var tableView: UITableView = UITableView().then {
        $0.register(RecentRecordTableViewCell.self, forCellReuseIdentifier: "RecentRecordTableViewCell")
        $0.separatorStyle = .none
    }

    var playlistDetailFactory: PlaylistDetailFactory!
    var textPopUpFactory: TextPopUpFactory!
    
    init(textPopUpFactory: TextPopUpFactory,
         playlistDetailFactory: PlaylistDetailFactory,
         reactor: BeforeSearchReactor) {
        
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
    
    public override func addView() {
        super.addView()
        self.view.addSubviews(tableView)
    }
    
    public override func setLayout() {
        super.setLayout()
        
        tableView.snp.makeConstraints {
            $0.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
    }

    override public func configureUI() {
        super.configureUI()
        self.tableView.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: APP_WIDTH(), height: PLAYER_HEIGHT()))
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: PLAYER_HEIGHT(), right: 0)
        self.indicator.type = .circleStrokeSpin
        self.indicator.color = DesignSystemAsset.PrimaryColor.point.color
        

//        guard let parent = self.parent as? SearchViewController else {
//            return
//        }
//
//        // TODO: #531
//        parent.reactor?.state
//            .map(\.typingState)
//            .asObservable()
//            .map { $0 == .before }
//            .map { Reactor.Action.updateShowRecommend($0) }
//            .bind(to: self.reactor.action)
//            .disposed(by: disposeBag)
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
            .map{Reactor.Action.rencentTextDidTap($0)}
            .bind(to:reactor.action)
            .disposed(by: disposeBag)

    }

    override public func bindState(reactor: BeforeSearchReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share(replay: 2)

        let combine = Observable.combineLatest(
            sharedState.map(\.showRecommend),
            Utility.PreferenceManager.$recentRecords,
            sharedState.map(\.dataSource)
        )

        combine
            .map { (showRecommend: Bool, item: [String]?, _) -> [String] in
                DEBUG_LOG("hhh \(showRecommend) \(item)")
                if showRecommend { // 만약 추천리스트면 검색목록 보여지면 안되므로 빈 배열
                    return []
                } else {
                    return item ?? []
                }
            }
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

        if state.showRecommend {
            return RecommendPlayListView.getViewHeight(model: state.dataSource)

        } else if (Utility.PreferenceManager.recentRecords ?? []).isEmpty {
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

        let recommendView = RecommendPlayListView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: APP_WIDTH(),
                height: RecommendPlayListView.getViewHeight(model: state.dataSource)
            )
        )
        recommendView.dataSource = state.dataSource
        recommendView.delegate = self

        if state.showRecommend {
            return recommendView

        } else if (Utility.PreferenceManager.recentRecords ?? []).isEmpty {
            return warningView

        } else {
            return recentRecordHeaderView
        }
    }
}

extension BeforeSearchContentViewController: RecommendPlayListViewDelegate {
    public func itemSelected(model: RecommendPlayListEntity) {
        lazy var playListDetailVc = playlistDetailFactory.makeView(
            id: model.key,
            isCustom: false
        )
        self.navigationController?.pushViewController(playListDetailVc, animated: true)
    }
}

extension BeforeSearchContentViewController {
    func scrollToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }
}
