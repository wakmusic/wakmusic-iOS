import DesignSystem
import SnapKit
import Then
import UIKit
import Utility

final class CreateListButton: UIButton {
    private let translucentView = UIVisualEffectView(effect: UIBlurEffect(style: .regular)).then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
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
    
    init() {
        super.init(frame: .zero)
        addView()
        setLayout()
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func addView() {
        self.addSubviews(
            translucentView,
            image,
            title
        )
    }

    private func setLayout() {
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
    }

    private func configureUI() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.setBackgroundColor(.white.withAlphaComponent(0.4), for: .normal)
        self.setBackgroundColor(.lightGray, for: .selected)
        self.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray200.color.cgColor.copy(alpha: 0.4)
        self.clipsToBounds = true
    }
}
