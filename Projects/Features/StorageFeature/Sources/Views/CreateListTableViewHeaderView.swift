import DesignSystem
import SnapKit
import Then
import UIKit
import Utility

final class CreateListTableViewHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "CreateListTableViewHeaderView"

    private let imageView = UIImageView().then {
        $0.image = DesignSystemAsset.Storage.storageNewPlaylistAdd.image
    }

    private let titleLabel = WMLabel(
        text: "리스트 만들기",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t6(weight: .medium),
        alignment: .center,
        kernValue: -0.5
    )

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func addView() {
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
    }

    private func setLayout() {
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(32)
        }

        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func configureUI() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.backgroundColor = .white
        self.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray200.color.cgColor.copy(alpha: 0.7)
    }
}
