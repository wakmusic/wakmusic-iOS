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
}

private protocol LikeStorageActionProtocol {
    var loginButtonDidTap: Observable<Void> { get }
    var createListButtonDidTap: Observable<Void> { get }
    var refreshControlValueChanged: Observable<Void> { get }
    var drawFruitButtonDidTap: Observable<Void> { get }
}

final class LikeStorageView: UIView {
    let createListButton = CreateListButton(frame: .zero)

    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(ListStorageTableViewCell.self, forCellReuseIdentifier: ListStorageTableViewCell.reuseIdentifer)
        $0.separatorStyle = .none
    }

    fileprivate let drawFruitButton = UIButton().then {
        $0.setTitle("음표 열매 뽑으러 가기", for: .normal)
    }

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

    func addView() {
        self.addSubviews(
            createListButton,
            tableView,
            drawFruitButton,
            loginWarningView,
            activityIndicator
        )
    }

    func setLayout() {
        createListButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.top.equalTo(safeAreaLayoutGuide).offset(68)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(createListButton.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(drawFruitButton.snp.top)
        }
        drawFruitButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        loginWarningView.snp.makeConstraints {
            $0.width.equalTo(164)
            $0.height.equalTo(176)
            $0.top.equalTo(createListButton.snp.bottom).offset(80)
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

        loginWarningView.isHidden = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()

        drawFruitButton.setAttributedTitle(
            NSAttributedString(
                string: "음표 열매 뽑으러 가기",
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

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = drawFruitButton.bounds
    }
}

extension LikeStorageView: LikeStorageStateProtocol {
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

    var drawFruitButtonDidTap: Observable<Void> {
        base.drawFruitButton.rx.tap.asObservable()
    }

    var refreshControlValueChanged: Observable<Void> {
        base.refreshControl.rx.controlEvent(.valueChanged).map { () }.asObservable()
    }

    var createListButtonDidTap: Observable<Void> {
        base.createListButton.rx.tap.asObservable()
    }
}
