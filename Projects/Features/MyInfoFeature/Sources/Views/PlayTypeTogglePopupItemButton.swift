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
        $0.layer.borderWidth = 1
        $0.backgroundColor = .white
        $0.layer.addShadow(
            color: UIColor(hex: "#080F34"),
            alpha: 0.08,
            x: 0,
            y: 2,
            blur: 4,
            spread: 0
        )
    }

    private let titleLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t5(weight: .light),
        alignment: .left
    )

    private let imageView = UIImageView().then {
        $0.image = DesignSystemAsset.Storage.checkBox.image
        $0.contentMode = .scaleAspectFit
    }

    private let installButton = InstallButton().then {
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
        if let url = URL(string: "youtubemusic://"), UIApplication.shared.canOpenURL(url) {
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
                DesignSystemAsset.PrimaryColorV2.decrease.color.cgColor :
                DesignSystemAsset.BlueGrayColor.blueGray200.color.withAlphaComponent(0.4).cgColor

            self.baseView.layer.shadowOpacity = isSelected ? 0.08 : 0
        }

        self.imageView.image = isSelected ?
            DesignSystemAsset.Storage.checkBox.image : nil

        let font = isSelected ?
            UIFont.WMFontSystem.t5(weight: .medium) :
            UIFont.WMFontSystem.t5(weight: .light)
        self.titleLabel.setFont(font)
        self.titleLabel.textColor = isSelected ?
            DesignSystemAsset.PrimaryColorV2.decrease.color :
            DesignSystemAsset.BlueGrayColor.blueGray900.color
    }

    func setActions() {
        let buttonAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.tappedButtonAction(title: titleLabel.text ?? "")
        }
        button.addAction(buttonAction, for: .touchUpInside)

        installButton.addAction {
            let youtubeMusicAppStoreURL = "itms-apps://apps.apple.com/app/id1017492454"
            if let url = URL(string: youtubeMusicAppStoreURL) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
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
            $0.trailing.equalTo(imageView.snp.leading).offset(-20)
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
            $0.edges.equalToSuperview()
        }
    }
}

private extension PlayTypeTogglePopupItemButtonView {
    class InstallButton: UIButton {
        private let messageLabel = WMLabel(
            text: "미설치",
            textColor: DesignSystemAsset.BlueGrayColor.gray400.color,
            font: .t7(weight: .bold),
            alignment: .center
        ).then {
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.gray300.color.cgColor
            $0.backgroundColor = .white
            $0.clipsToBounds = true
        }

        init() {
            super.init(frame: .zero)
            addViews()
            setLayout()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func addViews() {
            addSubviews(messageLabel)
        }

        func setLayout() {
            messageLabel.snp.makeConstraints {
                $0.width.equalTo(55)
                $0.height.equalTo(24)
                $0.trailing.equalToSuperview().inset(20)
                $0.centerY.equalToSuperview()
            }
        }
    }
}
