import DesignSystem
import Localization
import SnapKit
import Then
import UIKit
import Utility

final class RandomPlayButtonGroupView: UIView {
    private let randomPlayButton = RandomPlayButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addAction(didTap: @escaping () -> Void) {
        randomPlayButton.addAction {
            didTap()
        }
    }

    private func setupView() {
        addSubviews(randomPlayButton)
        randomPlayButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(12)
        }
    }
}

private final class RandomPlayButton: UIButton {
    private let randomImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Chart.shufflePlay.image
        $0.tintColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
        $0.contentMode = .scaleAspectFit
    }

    private let playLabel = UILabel().then {
        $0.text = LocalizationStrings.titleRandomPlay
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
        $0.font = .setFont(.t6(weight: .medium))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubviews(randomImageView, playLabel)

        randomImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(32)
            $0.size.equalTo(32)
        }

        playLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        layer.borderWidth = 1
        layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray200.color
            .withAlphaComponent(0.4).cgColor
        layer.cornerRadius = 8
        backgroundColor = DesignSystemAsset.PrimaryColorV2.white.color
    }
}
