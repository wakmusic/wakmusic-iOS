import DesignSystem
import Foundation
import UIKit

final class TeamInfoSectionCell: UITableViewCell {
    private let folderImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Team.folderOn.image
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t5(weight: .medium)
    ).then {
        $0.numberOfLines = 2
    }

    private let arrowImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Team.arrowTop.image
        $0.contentMode = .scaleAspectFit
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TeamInfoSectionCell {
    func update() {}
}

private extension TeamInfoSectionCell {
    func addSubViews() {
        contentView.addSubviews(folderImageView, titleLabel, arrowImageView)
    }

    func setLayout() {
        folderImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(40)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-10)
            $0.verticalEdges.equalToSuperview()
        }

        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.size.equalTo(24)
            $0.centerX.equalToSuperview()
        }
    }
}
