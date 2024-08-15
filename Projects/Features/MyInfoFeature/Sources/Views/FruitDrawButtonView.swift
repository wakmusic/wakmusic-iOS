import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

private protocol FruitDrawStateProtocol {
    func updateFruitCount(count: Int)
}

private protocol FruitDrawActionProtocol {
    var drawButtonDidTap: Observable<Void> { get }
}

final class FruitDrawButtonView: UIView {
    let backgroundView = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.4)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray200.color.cgColor
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    let titleLabel = WMLabel(
        text: "내 열매",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t5(weight: .medium),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t5().lineHeight,
        kernValue: -0.5
    )

    let countLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.PrimaryColorV2.point.color,
        font: .t5(weight: .bold),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t5().lineHeight,
        kernValue: -0.5
    )

    let drawButton = UIButton().then {
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        $0.setTitle("뽑기", for: .normal)
        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.blueGray900.color, for: .normal)
        $0.setImage(DesignSystemAsset.Home.homeArrowRight.image, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }

    init() {
        super.init(frame: .zero)
        addView()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FruitDrawButtonView {
    func addView() {
        self.addSubviews(
            backgroundView,
            titleLabel,
            countLabel,
            drawButton
        )
    }

    func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(backgroundView.snp.left).offset(20)
        }

        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(titleLabel.snp.right).offset(8)
        }

        drawButton.snp.makeConstraints {
            $0.verticalEdges.equalTo(backgroundView.snp.verticalEdges)
            $0.trailing.equalTo(backgroundView.snp.trailing)
            $0.width.equalTo(80)
        }
    }
}

extension FruitDrawButtonView: FruitDrawStateProtocol {
    func updateFruitCount(count: Int) {
        countLabel.text = count >= 0 ? "\(count)개" : ""
    }
}

extension Reactive: FruitDrawActionProtocol where Base: FruitDrawButtonView {
    var drawButtonDidTap: Observable<Void> { base.drawButton.rx.tap.asObservable() }
}
