import DesignSystem
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

@MainActor
private protocol ParticleAnimationStateProtocol {
    func startAnimation()
}

final class ParticleAnimationView: UIView {
    private let isEnabledTouchEvent: Bool

    private let greenHeartImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.Storage.heartGreen.image
    }

    private let grayNoteImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.Storage.noteGray.image
    }

    private let leftMediumParticleIamge = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.Storage.particleMedium.image
    }

    private let leftSmallParticeImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.Storage.particleSmall.image
    }

    private let purpleHeartImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.Storage.heartPurple.image
    }

    private let blueHeartImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.Storage.heartBlue.image
    }

    private let yellowHeartImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.Storage.heartYellow.image
    }

    private let rightMediumParticleIamge = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.Storage.particleMedium.image
    }

    private let rightSmallParticeImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.Storage.particleSmall.image
    }

    init(isEnabledTouchEvent: Bool = false) {
        self.isEnabledTouchEvent = isEnabledTouchEvent
        super.init(frame: .zero)
        addView()
        setLayout()
        configureUI()
        bindNotification()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return isEnabledTouchEvent ? self : nil
    }
}

private extension ParticleAnimationView {
    func addView() {
        self.addSubviews(
            greenHeartImageView,
            grayNoteImage,
            leftMediumParticleIamge,
            leftSmallParticeImage,
            purpleHeartImage,
            blueHeartImage,
            yellowHeartImage,
            rightMediumParticleIamge,
            rightSmallParticeImage
        )
    }

    func setLayout() {
        greenHeartImageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(24.0.correctLeading)
            $0.top.equalToSuperview().offset(34.0.correctTop)
        }
        grayNoteImage.snp.makeConstraints {
            $0.left.equalToSuperview().inset(38.0.correctLeading)
            $0.top.equalToSuperview().offset(27.0.correctTop)
        }
        leftMediumParticleIamge.snp.makeConstraints {
            $0.left.equalToSuperview().inset(82.0.correctLeading)
            $0.top.equalToSuperview().offset(47.0.correctTop)
        }
        leftSmallParticeImage.snp.makeConstraints {
            $0.left.equalToSuperview().inset(91.0.correctLeading)
            $0.top.equalToSuperview().offset(42.0.correctTop)
        }
        purpleHeartImage.snp.makeConstraints {
            $0.left.equalToSuperview().inset(97.0.correctLeading)
            $0.top.equalToSuperview().offset(8.0.correctTop)
        }
        blueHeartImage.snp.makeConstraints {
            $0.left.equalToSuperview().inset(251.0.correctLeading)
            $0.top.equalToSuperview().offset(15.0.correctTop)
        }
        rightSmallParticeImage.snp.makeConstraints {
            $0.left.equalToSuperview().inset(297.0.correctLeading)
            $0.top.equalToSuperview().offset(42.0.correctTop)
        }
        yellowHeartImage.snp.makeConstraints {
            $0.left.equalToSuperview().inset(309.0.correctLeading)
            $0.top.equalToSuperview().offset(37.0.correctTop)
        }
        rightMediumParticleIamge.snp.makeConstraints {
            $0.left.equalToSuperview().inset(345.0.correctLeading)
            $0.top.equalToSuperview().offset(42.0.correctTop)
        }
    }

    func configureUI() {
        self.backgroundColor = .clear
    }

    func bindNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(removeAnimation),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(startAnimation),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
}

extension ParticleAnimationView: ParticleAnimationStateProtocol {
    @objc func removeAnimation() {
        self.subviews.forEach { $0.removeAllAnimations() }
    }

    @objc func startAnimation() {
        greenHeartImageView.moveAnimate(duration: 2.0, amount: 20, direction: .up)
        [grayNoteImage, leftMediumParticleIamge, leftSmallParticeImage].forEach {
            $0.moveAnimate(duration: 2.0, amount: 10, direction: .up)
        }
        purpleHeartImage.moveAnimate(duration: 2.0, amount: 8, direction: .down)
        blueHeartImage.moveAnimate(duration: 2.0, amount: 15, direction: .up)
        [rightSmallParticeImage, yellowHeartImage, rightMediumParticleIamge].forEach {
            $0.moveAnimate(duration: 3.0, amount: 15, direction: .up)
        }
    }
}
