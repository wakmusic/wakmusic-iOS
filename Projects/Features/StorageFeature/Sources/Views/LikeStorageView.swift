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

private protocol LikeStorageStateProtocol {
    func updateActivityIndicatorState(isPlaying: Bool)
    func updateRefreshControlState(isPlaying: Bool)
    func updateIsEnabledRefreshControl(isEnabled: Bool)
    func updateIsHiddenLoginWarningView(isHidden: Bool)
    func updateIsHiddenEmptyWarningView(isHidden: Bool)
}

private protocol LikeStorageActionProtocol {
    var loginButtonDidTap: Observable<Void> { get }
    var refreshControlValueChanged: Observable<Void> { get }
}

final class LikeStorageView: UIView {
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(LikeStorageTableViewCell.self, forCellReuseIdentifier: LikeStorageTableViewCell.reuseIdentifer)
        $0.separatorStyle = .none
        $0.allowsSelectionDuringEditing = true
    }

    fileprivate let loginWarningView = LoginWarningView(text: "로그인 하고\n좋아요를 확인해보세요.") { return }

    private let activityIndicator = NVActivityIndicatorView(
        frame: .zero,
        type: .circleStrokeSpin,
        color: DesignSystemAsset.PrimaryColor.point.color
    )

    fileprivate let refreshControl = UIRefreshControl()

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
            loginWarningView,
            activityIndicator
        )
    }

    func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(52)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        loginWarningView.snp.makeConstraints {
            $0.width.equalTo(164)
            $0.height.equalTo(176)
            $0.top.equalTo(tableView.snp.top).offset(148)
            $0.centerX.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.center.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
        tableView.refreshControl = refreshControl
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        loginWarningView.isHidden = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}

extension LikeStorageView: LikeStorageStateProtocol {
    func updateIsHiddenEmptyWarningView(isHidden: Bool) {
        if tableView.frame.size == .zero { return }
        let isLoggedIn = loginWarningView.isHidden

        let warningView = WMWarningView(
            text: "좋아요한 곡이 없습니다."
        )

        if !isHidden && isLoggedIn {
            tableView.setBackgroundView(warningView, tableView.frame.height / 3 - 40)
        } else {
            tableView.restore()
        }
    }

    func updateIsEnabledRefreshControl(isEnabled: Bool) {
        self.tableView.refreshControl = isEnabled ? refreshControl : nil
    }

    func updateIsHiddenLoginWarningView(isHidden: Bool) {
        self.loginWarningView.isHidden = isHidden
    }

    func updateRefreshControlState(isPlaying: Bool) {
        if isPlaying {
            self.refreshControl.beginRefreshing()
        } else {
            self.refreshControl.endRefreshing()
        }
    }

    func updateActivityIndicatorState(isPlaying: Bool) {
        if isPlaying {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
}

extension Reactive: LikeStorageActionProtocol where Base: LikeStorageView {
    var loginButtonDidTap: Observable<Void> {
        base.loginWarningView.loginButtonDidTapSubject.asObservable()
    }

    var refreshControlValueChanged: Observable<Void> {
        base.refreshControl.rx.controlEvent(.valueChanged).map { () }.asObservable()
    }
}
