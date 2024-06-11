import DesignSystem
import RxCocoa
import RxSwift
import SignInFeatureInterface
import SnapKit
import Then
import UIKit
import UserDomainInterface
import Utility

private protocol SettingStateProtocol {}

private protocol SettingActionProtocol {
    var dismissButtonDidTap: Observable<Void> { get }
    var withDrawButtonDidTap: Observable<Void> { get }
    var appPushSettingNavigationButtonDidTap: Observable<Void> { get }
    var termsNavigationButtonDidTap: Observable<Void> { get }
    var privacyNavigationButtonDidTap: Observable<Void> { get }
    var openSourceNavigationButtonDidTap: Observable<Void> { get }
    var removeCacheButtonDidTap: Observable<Void> { get }
    var versionInfoButtonDidTap: Observable<Void> { get }
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

    private let versionLabel = UILabel().then {
        $0.text = "0.0.0"
        $0.font = DesignSystemFontFamily.SCoreDream._3Light.font(size: 12)
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray500.color
        $0.setTextWithAttributes(kernValue: -0.5)
    }

    private let vStackView = UIStackView().then {
        $0.axis = .vertical
    }

    fileprivate let notiNavgationButton = SettingItemButton().then {
        $0.setLeftTitle("앱 알림 받기")
    }

    fileprivate let termNavgationButton = SettingItemButton().then {
        $0.setLeftTitle("서비스 이용약관")
    }

    fileprivate let privacyNavgationButton = SettingItemButton().then {
        $0.setLeftTitle("개인정보 처리 방침")
    }

    fileprivate let openSourceNavgationButton = SettingItemButton().then {
        $0.setLeftTitle("오픈소스 라이선스")
    }

    fileprivate let removeCacheButton = SettingItemButton().then {
        $0.setLeftTitle("캐시 데이터 지우기")
    }

    fileprivate let versionInfoButton = SettingItemButton().then {
        $0.setLeftTitle("버전 정보")
        $0.setRightImage(nil)
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
            vStackView,
            versionLabel,
            dotImageView,
            withDrawLabel
        )
        vStackView.addArrangedSubviews(
            notiNavgationButton,
            termNavgationButton,
            privacyNavgationButton,
            openSourceNavgationButton,
            removeCacheButton,
            versionInfoButton
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

        vStackView.snp.makeConstraints {
            $0.top.equalTo(wmNavigationbarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }

        versionLabel.snp.makeConstraints {
            $0.centerY.equalTo(versionInfoButton.snp.centerY)
            $0.right.equalTo(versionInfoButton.snp.right).inset(24)
        }

        dotImageView.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(20)
            $0.width.height.equalTo(16)
        }

        withDrawLabel.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.bottom).offset(12)
            $0.left.equalTo(dotImageView.snp.right)
            $0.right.equalToSuperview().inset(20)
        }
    }
}

extension SettingView: SettingStateProtocol {}

extension Reactive: SettingActionProtocol where Base: SettingView {
    var dismissButtonDidTap: Observable<Void> { base.dismissButton.rx.tap.asObservable() }
    var withDrawButtonDidTap: Observable<Void> { base.withDrawLabel.rx.didTap }
    var appPushSettingNavigationButtonDidTap: Observable<Void> { base.notiNavgationButton.rx.didTap }
    var termsNavigationButtonDidTap: Observable<Void> { base.termNavgationButton.rx.didTap }
    var privacyNavigationButtonDidTap: Observable<Void> { base.privacyNavgationButton.rx.didTap }
    var openSourceNavigationButtonDidTap: Observable<Void> { base.openSourceNavgationButton.rx.didTap }
    var removeCacheButtonDidTap: Observable<Void> { base.removeCacheButton.rx.didTap }
    var versionInfoButtonDidTap: RxSwift.Observable<Void> { base.versionInfoButton.rx.didTap }
}
