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
    }

    private let confirmButton = UIButton().then {
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
            descriptionLabel,
            noteImageView,
            confirmButton
        )
    }

    func setLayout() {
        popupContentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.center.equalToSuperview()
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

        noteImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(confirmButton.snp.top).offset(-80)
            $0.width.equalTo(275)
            $0.height.equalTo(200)
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
