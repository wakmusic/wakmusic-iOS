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

private protocol ListStorageStateProtocol {
    func updateActivityIndicatorState(isPlaying: Bool)
    func updateRefreshControlState(isPlaying: Bool)
    func updateIsEnabledRefreshControl(isEnabled: Bool)
    func updateIsHiddenLoginWarningView(isHidden: Bool)
    func updateIsHiddenEmptyWarningView(isHidden: Bool)
    func startParticeAnimation()
    func removeParticeAnimation()
}

private protocol ListStorageActionProtocol {
    var loginButtonDidTap: Observable<Void> { get }
    var refreshControlValueChanged: Observable<Void> { get }
    var drawFruitButtonDidTap: Observable<Void> { get }
}

final class ListStorageView: UIView {
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(ListStorageTableViewCell.self, forCellReuseIdentifier: ListStorageTableViewCell.reuseIdentifer)
        $0.separatorStyle = .none
    }

    fileprivate let drawFruitButton = UIButton().then {
        $0.setTitle("음표 열매 뽑기", for: .normal)
    }

    private let particleAnimationView = ParticleAnimationView()

    fileprivate let loginWarningView = LoginWarningView(text: "로그인 하고\n리스트를 확인해보세요.") { return }

    private let activityIndicator = NVActivityIndicatorView(
        frame: .zero,
        type: .circleStrokeSpin,
        color: DesignSystemAsset.PrimaryColor.point.color
    )

    fileprivate let refreshControl = UIRefreshControl()

    private var gradientLayer = CAGradientLayer()

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

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = drawFruitButton.bounds
    }
}

private extension ListStorageView {
    func addView() {
        self.addSubviews(
            tableView,
            drawFruitButton,
            particleAnimationView,
            loginWarningView,
            activityIndicator
        )
    }

    func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(68 - 16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(drawFruitButton.snp.top)
        }
        drawFruitButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        particleAnimationView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        loginWarningView.snp.makeConstraints {
            $0.width.equalTo(164)
            $0.height.equalTo(176)
            $0.top.equalTo(tableView.snp.top).offset(56 + 80)
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
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        tableView.sectionHeaderTopPadding = 0

        loginWarningView.isHidden = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()

        drawFruitButton.setAttributedTitle(
            NSAttributedString(
                string: "음표 열매 뽑기",
                attributes: [
                    .kern: -0.5,
                    .font: UIFont.WMFontSystem.t4(weight: .bold).font,
                    .foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        gradientLayer.colors = [UIColor(hex: "#0098E5").cgColor, UIColor(hex: "#968FE8").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        drawFruitButton.layer.addSublayer(gradientLayer)
    }
}

extension ListStorageView: ListStorageStateProtocol {
    func startParticeAnimation() {
        particleAnimationView.startAnimation()
    }

    func removeParticeAnimation() {
        particleAnimationView.removeAnimation()
    }

    func updateIsHiddenEmptyWarningView(isHidden: Bool) {
        if tableView.frame.size == .zero { return }
        let isLoggedIn = loginWarningView.isHidden

        let warningView = WMWarningView(
            text: "리스트가 없습니다."
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

extension Reactive: ListStorageActionProtocol where Base: ListStorageView {
    var loginButtonDidTap: Observable<Void> {
        base.loginWarningView.loginButtonDidTapSubject.asObservable()
    }

    var drawFruitButtonDidTap: Observable<Void> {
        base.drawFruitButton.rx.tap.asObservable()
    }

    var refreshControlValueChanged: Observable<Void> {
        base.refreshControl.rx.controlEvent(.valueChanged).map { () }.asObservable()
    }
}
