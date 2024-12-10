import DesignSystem
import Kingfisher
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

@MainActor
private protocol ProfileStateProtocol {
    func updateProfileImage(image: String)
    func updateNickName(nickname: String)
    func updatePlatform(platform: String)
}

private protocol ProfileActionProtocol {
    var profileImageDidTap: Observable<Void> { get }
}

final class ProfileView: UIView {
    fileprivate let imageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 92 / 2.0
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }

    private let nameLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t4(weight: .light),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t4().lineHeight,
        kernValue: -0.5
    ).then {
        $0.backgroundColor = .clear
        $0.numberOfLines = .zero
    }

    private let platformLabel = WMLabel(
        text: "로 로그인 중",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray600.color,
        font: .t6(weight: .light),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t6().lineHeight,
        kernValue: -0.5
    ).then {
        $0.backgroundColor = .clear
        $0.numberOfLines = .zero
    }

    fileprivate let didTapProfileImageSubject = PublishSubject<Void>()
    private let scaleDownTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    private let disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)
        addView()
        setLayout()
        registerGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func highlightName() {
        guard let text = self.nameLabel.text else { return }
        let attrStr = NSMutableAttributedString(string: text)
        let strLength = attrStr.length
        let nameRange = NSRange(location: 0, length: strLength - 1)
        let lastRange = NSRange(location: strLength - 1, length: 1)
        let color = DesignSystemAsset.BlueGrayColor.blueGray900.color
        let lightColor = DesignSystemAsset.BlueGrayColor.blueGray500.color
        let font = UIFont.setFont(.t3(weight: .medium))
        let lightFont = UIFont.setFont(.t4(weight: .light))
        attrStr.addAttribute(.foregroundColor, value: color, range: nameRange)
        attrStr.addAttribute(.font, value: font, range: nameRange)
        attrStr.addAttribute(.foregroundColor, value: lightColor, range: lastRange)
        attrStr.addAttribute(.font, value: lightFont, range: lastRange)
        self.nameLabel.attributedText = attrStr
    }
}

private extension ProfileView {
    func addView() {
        self.addSubview(imageView)
        self.addSubview(nameLabel)
        self.addSubview(platformLabel)
    }

    func setLayout() {
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(92)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.centerX.equalTo(imageView.snp.centerX)
        }

        platformLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }

    func registerGesture() {
        imageView.rx.longPressGesture(configuration: { gestureRecognizer, delegate in
            gestureRecognizer.minimumPressDuration = 0.0
            delegate.selfFailureRequirementPolicy = .always
        })
        .bind(with: self) { owner, gesture in
            switch gesture.state {
            case .began:
                UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
                    owner.imageView.transform = owner.scaleDownTransform
                }
                .startAnimation()
            case .ended, .cancelled:
                let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.5, animations: {
                    owner.imageView.transform = .identity
                })
                animator.startAnimation()
                owner.didTapProfileImageSubject.onNext(())
            default:
                break
            }
        }
        .disposed(by: disposeBag)
    }
}

extension ProfileView: ProfileStateProtocol {
    func updateProfileImage(image: String) {
        imageView.kf.setImage(
            with: URL(string: image),
            placeholder: nil,
            options: [
                .transition(.fade(0.5)),
                .processor(DownsamplingImageProcessor(size: CGSize(width: 300, height: 300)))
            ]
        )
    }

    func updateNickName(nickname: String) {
        nameLabel.text = nickname + "님"
        highlightName()
    }

    func updatePlatform(platform: String) {
        var platformStr = ""
        switch platform {
        case "naver":
            platformStr = "네이버"
        case "google":
            platformStr = "구글"
        case "apple":
            platformStr = "애플"
        default:
            platformStr = "Unknown"
        }
        platformLabel.text = "\(platformStr)로 로그인 중"
    }
}

extension Reactive: @preconcurrency ProfileActionProtocol where Base: ProfileView {
    @MainActor
    var profileImageDidTap: Observable<Void> {
        return base.didTapProfileImageSubject.asObserver()
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.asyncInstance)
    }
}
