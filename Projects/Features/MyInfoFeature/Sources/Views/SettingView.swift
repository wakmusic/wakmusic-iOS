import DesignSystem
import RxCocoa
import RxSwift
import SignInFeatureInterface
import SnapKit
import Then
import UIKit
import UserDomainInterface
import Utility

private protocol SettingStateProtocol {
    func updateIsHiddenWithDrawButton(isHidden: Bool)
    func updateIsHiddenLogoutButton(isHidden: Bool)
}

private protocol SettingActionProtocol {
    var dismissButtonDidTap: Observable<Void> { get }
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
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }

    private let dotImageView = UIImageView().then {
        $0.image = DesignSystemAsset.MyInfo.dot.image
    }

    fileprivate let withDrawLabel = WithDrawLabel()

    init() {
        super.init(frame: .zero)
        addView()
        setLayout()
        self.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
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
            dotImageView,
            withDrawLabel
        )
    }

    func setLayout() {
        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(STATUS_BAR_HEGHIT())
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
            $0.height.equalTo(360)
        }

        dotImageView.snp.makeConstraints {
            $0.top.equalTo(settingItemTableView.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(20)
            $0.width.height.equalTo(16)
        }

        withDrawLabel.snp.makeConstraints {
            $0.top.equalTo(settingItemTableView.snp.bottom).offset(12)
            $0.left.equalTo(dotImageView.snp.right)
            $0.right.equalToSuperview().inset(20)
        }
    }
}

extension SettingView: SettingStateProtocol {
    func updateIsHiddenWithDrawButton(isHidden: Bool) {
        self.dotImageView.isHidden = isHidden
        self.withDrawLabel.isHidden = isHidden
    }

    func updateIsHiddenLogoutButton(isHidden: Bool) {
        guard let dataSource = settingItemTableView.dataSource as? SettingItemDataSource else { return }
        settingItemTableView.reloadData()
        settingItemTableView.snp.updateConstraints {
            $0.height.equalTo(dataSource.currentSettingItems.count * 60)
        }
    }
}

extension Reactive: SettingActionProtocol where Base: SettingView {
    var dismissButtonDidTap: Observable<Void> { base.dismissButton.rx.tap.asObservable() }
}
