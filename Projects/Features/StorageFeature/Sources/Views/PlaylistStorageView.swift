import BaseFeature
import BaseFeatureInterface
import DesignSystem
import LogManager
import NVActivityIndicatorView
import PlaylistFeatureInterface
import RxCocoa
import RxDataSources
import RxRelay
import RxSwift
import SignInFeatureInterface
import SongsDomainInterface
import UIKit
import UserDomainInterface
import Utility

private protocol PlaylistStorageStateProtocol {
    func updateActivityIndicatorState(isPlaying: Bool)
    func updateEmptyWarningViewState(isShow: Bool)
}

private protocol PlaylistStorageActionProtocol {
    var createListButtonDidTap: Observable<Void> { get }
    var refreshControlValueChanged: Observable<Void> { get }
}

final class PlaylistStorageView: UIView {
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(MyPlaylistTableViewCell.self, forCellReuseIdentifier: MyPlaylistTableViewCell.reuseIdentifer)
        $0.register(
            CreateListTableViewHeaderView.self,
            forHeaderFooterViewReuseIdentifier: CreateListTableViewHeaderView.reuseIdentifier
        )
    }

    let emptyWarningView = WarningView(frame: .init(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT() / 3))

    private let activityIndicator = NVActivityIndicatorView(
        frame: .zero,
        type: .circleStrokeSpin,
        color: DesignSystemAsset.PrimaryColor.point.color
    )

    let refreshControl = UIRefreshControl()

    init() {
        super.init(frame: .zero)
        addView()
        setLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addView() {
        self.addSubviews(
            tableView,
            emptyWarningView,
            activityIndicator
        )
    }

    func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(60)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-56)
        }
        emptyWarningView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.center.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
        tableView.refreshControl = refreshControl
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)

        emptyWarningView.isHidden = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}

extension PlaylistStorageView: PlaylistStorageStateProtocol {
    func updateEmptyWarningViewState(isShow: Bool) {
        self.emptyWarningView.isHidden = !isShow
    }

    func updateActivityIndicatorState(isPlaying: Bool) {
        if isPlaying {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
}

extension Reactive: PlaylistStorageActionProtocol where Base: PlaylistStorageView {
    var refreshControlValueChanged: Observable<Void> {
        base.refreshControl.rx.controlEvent(.valueChanged).map { () }.asObservable()
    }

    var createListButtonDidTap: Observable<Void> {
        return .empty()
    }
}
