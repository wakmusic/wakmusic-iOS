import DesignSystem
import RxCocoa
import RxSwift
import SignInFeatureInterface
import SnapKit
import Then
import UIKit
import UserDomainInterface
import Utility

private protocol TeamInfoStateProtocol {}

private protocol TeamInfoActionProtocol {
    var dismissButtonDidTap: Observable<Void> { get }
}

final class TeamInfoView: UIView {
    private let wmNavigationbarView = WMNavigationBarView()

    fileprivate let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
        $0.setImage(dismissImage, for: .normal)
    }

    private let titleLabel = UILabel().then {
        $0.numberOfLines = .zero
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
        $0.text = "팀 소개"
        $0.font = .setFont(.t5(weight: .medium))
        $0.setTextWithAttributes(kernValue: -0.5)
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

private extension TeamInfoView {
    func addView() {
        self.addSubviews(
            wmNavigationbarView,
            titleLabel
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
    }
}

extension TeamInfoView: TeamInfoStateProtocol {}

extension Reactive: TeamInfoActionProtocol where Base: TeamInfoView {
    var dismissButtonDidTap: Observable<Void> { base.dismissButton.rx.tap.asObservable() }
}
