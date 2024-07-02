import DesignSystem
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

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
        $0.image = DesignSystemAsset.MyInfo.iconColor.image
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

    init() {
        super.init(frame: .zero)
        addView()
        setLayout()
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

extension ProfileView {
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
}

extension ProfileView: ProfileStateProtocol {
    func updateProfileImage(image: String) {
        imageView.kf.setImage(
            with: URL(string: image),
            placeholder: DesignSystemAsset.MyInfo.iconColor.image,
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

extension Reactive: ProfileActionProtocol where Base: ProfileView {
    var profileImageDidTap: Observable<Void> {
        let tapGestureRecognizer = UITapGestureRecognizer()
        base.imageView.addGestureRecognizer(tapGestureRecognizer)
        base.imageView.isUserInteractionEnabled = true
        return tapGestureRecognizer.rx.event.map { _ in }.asObservable()
    }
}
