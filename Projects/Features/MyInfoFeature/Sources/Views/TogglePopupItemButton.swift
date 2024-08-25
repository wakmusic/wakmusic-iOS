import DesignSystem
import SnapKit
import Then
import UIKit

protocol PlayTypeTogglePopupItemButtonViewDelegate: AnyObject {
    func tappedButtonAction(title: String)
}

final class PlayTypeTogglePopupItemButtonView: UIView {
    private let baseView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.gray200.color.cgColor
        $0.layer.borderWidth = 2
        $0.backgroundColor = .white
    }

    private let titleLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t5(weight: .light),
        alignment: .left
    )

    private let imageView = UIImageView().then {
        $0.image = DesignSystemAsset.MyInfo.donut.image
        $0.contentMode = .scaleAspectFit
    }

    private let installButton = UIButton().then {
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.gray300.color.cgColor
        $0.setTitle("미설치", for: .normal)
        $0.setBackgroundColor(.white, for: .normal)
        $0.setBackgroundColor(.lightGray, for: .highlighted)
        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.gray400.color, for: .normal)
        $0.setTitleColor(.white, for: .highlighted)
        $0.titleLabel?.font = UIFont.WMFontSystem.t7(weight: .bold).font
        $0.clipsToBounds = true
        $0.isHidden = true
    }

    private let button = UIButton()

    private weak var delegate: PlayTypeTogglePopupItemButtonViewDelegate?

    private var shouldCheckAppIsInstalled: Bool = false

    var isSelected: Bool = false {
        didSet {
            didChangedSelection(isSelected)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addViews()
        setLayout()
        setActions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDelegate(_ delegate: PlayTypeTogglePopupItemButtonViewDelegate) {
        self.delegate = delegate
    }

    func setTitleWithOption(
        title: String,
        shouldCheckAppIsInstalled: Bool = false
    ) {
        self.titleLabel.text = title
        self.shouldCheckAppIsInstalled = shouldCheckAppIsInstalled
        if shouldCheckAppIsInstalled {
            checkAppIsInstalled()
        }
    }

    @discardableResult
    func checkAppIsInstalled() -> Bool {
        let isInstalled: Bool
        if let url = URL(string: "youtube-music://"), UIApplication.shared.canOpenURL(url) {
            isInstalled = true
        } else {
            isInstalled = false
        }
        installButton.isHidden = isInstalled
        button.isEnabled = isInstalled

        return isInstalled
    }
}

private extension PlayTypeTogglePopupItemButtonView {
    func didChangedSelection(_ isSelected: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }

            self.baseView.layer.borderColor = isSelected ?
                DesignSystemAsset.PrimaryColorV2.point.color.cgColor :
                DesignSystemAsset.BlueGrayColor.blueGray200.color.cgColor
        }

        self.imageView.image = isSelected ?
            DesignSystemAsset.MyInfo.donutColor.image :
            DesignSystemAsset.MyInfo.donut.image

        let font = isSelected ?
            UIFont.WMFontSystem.t5(weight: .medium) :
            UIFont.WMFontSystem.t5(weight: .light)
        self.titleLabel.setFont(font)
    }

    func setActions() {
        let buttonAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.tappedButtonAction(title: titleLabel.text ?? "")
        }
        button.addAction(buttonAction, for: .touchUpInside)

        installButton.addAction {
            print("installButton did Tap")
            let youtubeMusicAppStoreURL = "itms-apps://apps.apple.com/app/id1017492454"
            if let url = URL(string: youtubeMusicAppStoreURL) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            self.installButton.isHidden = true
            self.button.isEnabled = true
        }
    }

    func addViews() {
        addSubview(baseView)
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(button)
        addSubview(installButton)
    }

    func setLayout() {
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(imageView.snp.trailing).offset(20)
        }

        imageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        button.snp.makeConstraints {
            $0.edges.equalTo(baseView)
        }

        installButton.snp.makeConstraints {
            $0.width.equalTo(55)
            $0.height.equalTo(24)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
