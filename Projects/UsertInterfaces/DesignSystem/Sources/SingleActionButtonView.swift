import SnapKit
import Then
import UIKit

@MainActor
public protocol SingleActionButtonViewDelegate: AnyObject {
    func tappedButtonAction()
}

public final class SingleActionButtonView: UIView {
    private let baseView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.gray200.color.withAlphaComponent(0.7).cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .white.withAlphaComponent(0.4)
    }

    private let translucentView = UIVisualEffectView(effect: UIBlurEffect(style: .regular)).then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let label = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t6(weight: .medium),
        alignment: .center
    )

    private let button = UIButton()

    public weak var delegate: SingleActionButtonViewDelegate?

    private let topSpacing: CGFloat

    public init(frame: CGRect, topSpacing: CGFloat = 16) {
        self.topSpacing = topSpacing
        super.init(frame: frame)
        backgroundColor = .clear
        addView()
        setLayout()
        addAction()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setTitleAndImage(
        text: String,
        textColor: UIColor = DesignSystemAsset.NewGrayColor.gray900.color,
        image: UIImage
    ) {
        label.text = text
        label.textColor = textColor
        imageView.image = image
    }
}

private extension SingleActionButtonView {
    func addAction() {
        let buttonAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.tappedButtonAction()
        }
        button.addAction(buttonAction, for: .touchUpInside)
    }

    func addView() {
        addSubview(translucentView)
        addSubview(baseView)
        addSubview(imageView)
        addSubview(label)
        addSubview(button)
    }

    func setLayout() {
        baseView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topSpacing)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }

        imageView.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.leading.equalTo(baseView.snp.leading).offset(32)
            $0.centerY.equalTo(baseView.snp.centerY)
        }

        button.snp.makeConstraints {
            $0.edges.equalTo(baseView)
        }

        label.snp.makeConstraints {
            $0.center.equalTo(button.snp.center)
        }

        translucentView.snp.makeConstraints {
            $0.edges.equalTo(baseView)
        }
    }
}
