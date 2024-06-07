import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

private protocol DrawActionProtocol {
    var drawButtonDidTap: Observable<Void> { get }
}

final class DrawButtonView: UIView {
    let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray200.color.cgColor
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    let titleLabel = UILabel().then {
        $0.text = "내 열매"
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
    }

    let countLabel = UILabel().then {
        $0.text = "0개"
        $0.font = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        $0.textColor = DesignSystemAsset.PrimaryColorV2.point.color
    }

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

extension DrawButtonView {
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

extension Reactive: DrawActionProtocol where Base: DrawButtonView {
    var drawButtonDidTap: Observable<Void> { base.drawButton.rx.tap.asObservable() }
}