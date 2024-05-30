import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

private protocol ProfileActionProtocol {}

final class ProfileView: UIView {
    enum PlatformType: String {
        case naver = "네이버"
        case google = "구글"
        case apple = "애플"
    }

    private let imageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.MyInfo.iconColor.image
    }

    private let nameLabel: UILabel = UILabel().then {
        $0.text = "님"
        $0.font = .setFont(.t3(weight: .medium))
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        $0.numberOfLines = .zero
    }

    private let platformLabel: UILabel = UILabel().then {
        $0.text = ""
        $0.font = .setFont(.t6(weight: .light))
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray600.color
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        $0.numberOfLines = .zero
    }

    init(name: String?, platform: PlatformType) {
        super.init(frame: .zero)
        nameLabel.text = name
        platformLabel.text = String("\(platform.rawValue)로 로그인 중")
        addView()
        setLayout()
        highlightName()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func highlightName() {
        guard let text = self.nameLabel.text else { return }
        let attributeString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "님")
        let color = DesignSystemAsset.BlueGrayColor.blueGray500.color
        let font = UIFont.setFont(.t4(weight: .light))
        attributeString.addAttribute(.foregroundColor, value: color, range: range)
        attributeString.addAttribute(.font, value: font, range: range)
        self.nameLabel.attributedText = attributeString
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

extension Reactive: ProfileActionProtocol where Base: ProfileView {}
