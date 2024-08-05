import DesignSystem
import SnapKit
import Then
import UIKit

final class PlaylistCoverOptionTableViewCell: UITableViewCell {
    static let identifier: String = "PlaylistCoverOptionTableViewCell"

    private let superView: UIView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray100.color.cgColor
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray50.color
        $0.clipsToBounds = true
    }

    private let titleLabel: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t5(weight: .medium)
    ).then {
        $0.numberOfLines = 2
    }

    private let productView: UIView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.PrimaryColorV2.point.color
    }.then {
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }

    private let noteImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DesignSystemAsset.Playlist.miniNote.image
    }

    private let costLabel: WMLabel = WMLabel(
        text: "",
        textColor: .white,
        font: .t6(weight: .medium),
        alignment: .center
    )

    private let productTypeLabel: WMLabel = WMLabel(
        text: "",
        textColor: .white,
        font: .t7(weight: .bold),
        alignment: .center
    )

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addViews() {
        self.contentView.addSubviews(superView)
        self.superView.addSubviews(titleLabel, productView)
        self.productView.addSubviews(noteImageView, costLabel, productTypeLabel)
    }

    func setLayout() {
        superView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(8)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.verticalEdges.equalToSuperview()
        }

        productView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().offset(-30)
            $0.centerY.equalToSuperview()
            $0.width.greaterThanOrEqualTo(72)
            $0.height.equalTo(30)
        }

        noteImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(14)
        }

        costLabel.snp.makeConstraints {
            $0.leading.equalTo(noteImageView.snp.trailing).offset(2)
            $0.width.greaterThanOrEqualTo(9)
            $0.verticalEdges.equalToSuperview()
        }

        productTypeLabel.snp.makeConstraints {
            $0.leading.equalTo(costLabel.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.equalTo(21)
            $0.verticalEdges.equalToSuperview()
        }
    }
}

extension PlaylistCoverOptionTableViewCell {
    public func update(_ model: PlaylistCoverOptionModel) {
        titleLabel.text = model.title
        costLabel.text = "\(model.price)"
        productTypeLabel.text = model.price == .zero ? "무료" : "구매"
    }
}
