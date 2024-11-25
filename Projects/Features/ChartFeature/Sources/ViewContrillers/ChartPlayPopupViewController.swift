import DesignSystem
import LogManager
import SnapKit
import Then
import UIKit

@MainActor
public protocol ChartPlayPopupViewControllerDelegate: AnyObject {
    func playTapped(type: HalfPlayType)
}

public enum HalfPlayType {
    case front
    case back

    var playlistTitleString: String {
        switch self {
        case .front:
            return "왁뮤차트 TOP100 1위 ~ 50위"
        case .back:
            return "왁뮤차트 TOP100 51위 ~ 100위"
        }
    }
}

final class ChartPlayPopupViewController: UIViewController {
    private let titleLabel = WMLabel(
        text: "전체재생",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: UIFont.WMFontSystem.t2(weight: .bold),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t2(weight: .bold).lineHeight
    )

    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }

    private let frontHalfPlayButton = HorizontalAlignButton(
        imagePlacement: .trailing,
        title: "1 ~ 50위",
        image: DesignSystemAsset.Chart.halfPlay.image,
        font: .setFont(.t5(weight: .medium)),
        titleColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        spacing: 8
    ).then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray50.color
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private let backHalfPlayButton = HorizontalAlignButton(
        imagePlacement: .trailing,
        title: "51 ~ 100위",
        image: DesignSystemAsset.Chart.halfPlay.image,
        font: .setFont(.t5(weight: .medium)),
        titleColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        spacing: 8
    ).then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray50.color
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    public weak var delegate: ChartPlayPopupViewControllerDelegate?

    deinit { LogManager.printDebug("❌:: \(Self.self) deinit") }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("\(Self.self) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setLayout()
        configureUI()
        addAction()
    }
}

private extension ChartPlayPopupViewController {
    func addSubViews() {
        view.addSubviews(titleLabel, stackView)
        stackView.addArrangedSubviews(frontHalfPlayButton, backHalfPlayButton)
    }

    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.height.equalTo(72)
        }
    }

    func configureUI() {
        view.backgroundColor = .white
    }

    func addAction() {
        frontHalfPlayButton.addAction { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.delegate?.playTapped(type: .front)
            })
        }

        backHalfPlayButton.addAction { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.delegate?.playTapped(type: .back)
            })
        }
    }
}
