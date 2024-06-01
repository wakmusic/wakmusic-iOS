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

    private let titleLabel = UILabel().then {
        $0.numberOfLines = .zero
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
        $0.text = "설정"
        $0.font = .setFont(.t5(weight: .medium))
    }

    fileprivate let withDrawButton = UIButton().then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.titleLabel?.font = .setFont(.t7(weight: .bold))
        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.blueGray400.color, for: .normal)
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray300.color.cgColor
    }

    private let versionLabel = UILabel().then {
        $0.text = "0.0.0"
        $0.font = DesignSystemFontFamily.SCoreDream._3Light.font(size: 12)
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray500.color
    }

    private let vStackView = UIStackView().then {
        $0.axis = .vertical
    }

    fileprivate let notiNavgationButton = SettingItemView().then {
        $0.setLeftTitle("앱 알림 받기")
    }

    fileprivate let termNavgationButton = SettingItemView().then {
        $0.setLeftTitle("서비스 이용약관")
    }

    fileprivate let privacyNavgationButton = SettingItemView().then {
        $0.setLeftTitle("개인정보 처리 방침")
    }

    fileprivate let openSourceNavgationButton = SettingItemView().then {
        $0.setLeftTitle("오픈소스 라이선스")
    }

    fileprivate let removeCacheButton = SettingItemView().then {
        $0.setLeftTitle("캐시 데이터 지우기")
    }

    fileprivate let versionInfoButton = SettingItemView().then {
        $0.setLeftTitle("버전 정보")
        $0.setRightImage(nil)
    }

    private let dotImageView = UIImageView().then {
        $0.image = DesignSystemAsset.MyInfo.dot.image
    }

    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.text = "왁타버스 뮤직 팀에 속한 모든 팀원들은 부아내비 (부려먹는 게 아니라 내가 비빈 거다)라는 모토를 가슴에 새기고 일하고 있습니다."
        $0.font = .setFont(.t7(weight: .light))
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray500.color
        $0.lineBreakMode = .byWordWrapping
    }

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
            descriptionLabel
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
        wmNavigationbarView.setRightViews([withDrawButton])

        titleLabel.snp.makeConstraints {
            $0.center.equalTo(wmNavigationbarView.snp.center)
        }

        withDrawButton.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.height.equalTo(24)
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
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.bottom).offset(12)
            $0.left.equalTo(dotImageView.snp.right)
            $0.right.equalToSuperview().inset(20)
        }
    }
}

extension SettingView: SettingStateProtocol {}

extension Reactive: SettingActionProtocol where Base: SettingView {
    var dismissButtonDidTap: Observable<Void> { base.dismissButton.rx.tap.asObservable() }
    var withDrawButtonDidTap: Observable<Void> { base.withDrawButton.rx.tap.asObservable() }
    var appPushSettingNavigationButtonDidTap: Observable<Void> { base.notiNavgationButton.rx.didTap }
    var termsNavigationButtonDidTap: Observable<Void> { base.termNavgationButton.rx.didTap }
    var privacyNavigationButtonDidTap: Observable<Void> { base.privacyNavgationButton.rx.didTap }
    var openSourceNavigationButtonDidTap: Observable<Void> { base.openSourceNavgationButton.rx.didTap }
    var removeCacheButtonDidTap: Observable<Void> { base.removeCacheButton.rx.didTap }
    var versionInfoButtonDidTap: RxSwift.Observable<Void> { base.versionInfoButton.rx.didTap }
}
