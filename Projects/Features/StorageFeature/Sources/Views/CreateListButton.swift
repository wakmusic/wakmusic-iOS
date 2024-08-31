import DesignSystem
import SnapKit
import Then
import UIKit
import Utility

final class CreateListButtonView: UIView {
    private let baseView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray200.color.withAlphaComponent(0.4).cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .white.withAlphaComponent(0.4)
        $0.clipsToBounds = true
    }
    
    private let translucentView = UIVisualEffectView(effect: UIBlurEffect(style: .regular)).then {
        $0.layer.cornerRadius = 8
    }

    private let image = UIImageView().then {
        $0.image = DesignSystemAsset.Storage.storageNewPlaylistAdd.image
    }

    private let title = WMLabel(
        text: "리스트 만들기",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t6(weight: .medium),
        alignment: .center,
        kernValue: -0.5
    )
    
    let button = UIButton()
    
    private let padding: UIEdgeInsets
    
    init(padding: UIEdgeInsets = .zero) {
        self.padding = padding
        super.init(frame: .zero)
        addView()
        setLayout()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addView() {
        self.addSubview(baseView)
        baseView.addSubviews(
            translucentView,
            image,
            title,
            button
        )
    }

    private func setLayout() {
        baseView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(padding.top)
            $0.leading.equalToSuperview().inset(padding.left)
            $0.trailing.equalToSuperview().inset(padding.right)
            $0.bottom.equalToSuperview().inset(padding.bottom)
        }
        
        translucentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        image.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(32)
        }

        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureUI() {
        self.backgroundColor = .clear
    }
}
