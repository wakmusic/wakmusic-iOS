import DesignSystem
import UIKit
import SnapKit
import Then

final class EmptyWarningView: UIView {
    private let imageView = UIImageView().then {
        $0.image = DesignSystemAsset.Search.warning.image
    }
    private let label = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t6(weight: .medium),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t6(weight: .medium).lineHeight,
        kernValue: -0.5
    )

    init(text: String) {
        super.init(frame: .zero)
        self.addView()
        self.setLayout()
        self.configureUI(text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmptyWarningView {
    func addView() {
        self.addSubviews(
            imageView,
            label
        )
    }
    
    func setLayout() {
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    func configureUI(_ text: String) {
        self.backgroundColor = .clear
        self.label.text = text
    }
}
