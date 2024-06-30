import DesignSystem
import SnapKit
import Then
import UIKit
import UserDomainInterface
import Utility

public final class FruitInfoPopupViewController: UIViewController {
    private let popupContentView = UIView().then {
        $0.backgroundColor = colorFromRGB(0xF2F4F7).withAlphaComponent(0.8)
    }

    private var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    private let descriptionLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t2(weight: .bold),
        alignment: .center
    ).then {
        $0.numberOfLines = 0
    }

    private let noteImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let confirmButton = UIButton(type: .system).then {
        $0.backgroundColor = DesignSystemAsset.PrimaryColorV2.point.color
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.blueGray25.color, for: .normal)
        $0.titleLabel?.font = .setFont(.t4(weight: .medium))
        $0.titleLabel?.setTextWithAttributes(alignment: .center)
    }

    private let item: FruitEntity

    public init(
        item: FruitEntity
    ) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("\(Self.self) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setLayout()
        configureUI()
        addAction()
    }
}

private extension FruitInfoPopupViewController {
    func addSubViews() {
        view.addSubview(popupContentView)
        popupContentView.addSubviews(
            blurView,
            descriptionLabel,
            noteImageView,
            confirmButton
        )
    }

    func setLayout() {
        let is320 = APP_WIDTH() < 375

        popupContentView.snp.makeConstraints {
            $0.width.equalTo(is320 ? APP_WIDTH() - 40 : 335)
            $0.center.equalToSuperview()
        }

        blurView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(confirmButton.snp.top)
        }

        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(56)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(32)
        }

        let is320Width: CGFloat = (275 * APP_WIDTH()) / 375
        let is320Height: CGFloat = (is320Width * 200) / 275

        noteImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(confirmButton.snp.top).offset(-80)
            $0.width.equalTo(is320 ? is320Width : 275)
            $0.height.equalTo(is320 ? is320Height : 200)
        }
    }

    func configureUI() {
        view.backgroundColor = .clear
        popupContentView.layer.cornerRadius = 24
        popupContentView.clipsToBounds = true
        descriptionLabel.text = item.name
        noteImageView.kf.setImage(
            with: URL(string: item.imageURL),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
    }

    func addAction() {
        confirmButton.addAction { [weak self] in
            guard let self else { return }
            self.dismiss(animated: true)
        }
    }
}
