import SnapKit
import Then
import UIKit
import DesignSystem

protocol TogglePopupItemButtonViewDelegate: AnyObject {
    func tappedButtonAction(title: String)
}

final class TogglePopupItemButtonView: UIView {
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
    
    private let button = UIButton()
    
    private weak var delegate: TogglePopupItemButtonViewDelegate?

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
    
    func setDelegate(_ delegate: TogglePopupItemButtonViewDelegate) {
        self.delegate = delegate
    }
    
    func setTitleWithOption(
        title: String,
        shouldCheckAppIsInstalled: Bool = false
    ) {
        self.titleLabel.text = title
        self.shouldCheckAppIsInstalled = shouldCheckAppIsInstalled
    }
}

private extension TogglePopupItemButtonView {
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
    }

    func addViews() {
        addSubview(baseView)
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(button)
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
    }
}
