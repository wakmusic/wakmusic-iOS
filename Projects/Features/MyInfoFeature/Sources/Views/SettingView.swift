import DesignSystem
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import SignInFeatureInterface
import SnapKit
import Then
import UIKit
import UserDomainInterface
import Utility

@MainActor
private protocol SettingStateProtocol {
    func updateIsHiddenWithDrawButton(isHidden: Bool)
    func updateIsHiddenLogoutButton(isHidden: Bool)
    func updateActivityIndicatorState(isPlaying: Bool)
}

private protocol SettingActionProtocol {
    var dismissButtonDidTap: Observable<Void> { get }
    var withDrawButtonDidTap: Observable<Void> { get }
}

final class SettingView: UIView {
    private let wmNavigationbarView = WMNavigationBarView()

    fileprivate let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
        $0.setImage(dismissImage, for: .normal)
    }

    private let titleLabel = WMLabel(
        text: "설정",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t5(weight: .medium),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t5().lineHeight,
        kernValue: -0.5
    )

    let settingItemTableView = UITableView().then {
        $0.register(SettingItemTableViewCell.self, forCellReuseIdentifier: SettingItemTableViewCell.reuseIdentifier)
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    }

    private let withDrawContentView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 60))

    private let dotImageView = UIImageView().then {
        $0.image = DesignSystemAsset.MyInfo.dot.image
    }

    fileprivate let withDrawLabel = WithDrawLabel().then {
        $0.preferredMaxLayoutWidth = APP_WIDTH() - 56
    }

    private let activityIndicator = NVActivityIndicatorView(
        frame: .zero,
        type: .circleStrokeSpin,
        color: DesignSystemAsset.PrimaryColor.point.color
    )

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
}

private extension SettingView {
    func addView() {
        self.addSubviews(
            wmNavigationbarView,
            titleLabel,
            settingItemTableView,
            activityIndicator
        )
        withDrawContentView.addSubviews(dotImageView, withDrawLabel)
        settingItemTableView.tableFooterView = withDrawContentView
    }

    func setLayout() {
        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
        wmNavigationbarView.setLeftViews([dismissButton])

        titleLabel.snp.makeConstraints {
            $0.center.equalTo(wmNavigationbarView.snp.center)
        }

        settingItemTableView.snp.makeConstraints {
            $0.top.equalTo(wmNavigationbarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        dotImageView.snp.makeConstraints {
            $0.top.equalTo(withDrawContentView.snp.top).offset(12)
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(16)
        }

        withDrawLabel.snp.makeConstraints {
            $0.top.equalTo(dotImageView.snp.top)
            $0.left.equalTo(dotImageView.snp.right)
            $0.height.equalTo(18)
        }

        activityIndicator.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.center.equalToSuperview()
        }
    }

    func configureUI() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}

extension SettingView: SettingStateProtocol {
    func updateActivityIndicatorState(isPlaying: Bool) {
        if isPlaying {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }

    func updateIsHiddenWithDrawButton(isHidden: Bool) {
        self.dotImageView.isHidden = isHidden
        self.withDrawLabel.isHidden = isHidden
    }

    func updateIsHiddenLogoutButton(isHidden: Bool) {
        guard let dataSource = settingItemTableView.dataSource as? SettingItemDataSource else { return }
        settingItemTableView.reloadData()
    }

    func updateNotificationAuthorizationStatus(granted: Bool) {
        DispatchQueue.main.async {
            self.settingItemTableView.reloadData()
        }
    }
}

extension Reactive: @preconcurrency SettingActionProtocol where Base: SettingView {
    @MainActor
    var withDrawButtonDidTap: Observable<Void> { base.withDrawLabel.rx.didTap }
    var dismissButtonDidTap: Observable<Void> { base.dismissButton.rx.tap.asObservable() }
}
