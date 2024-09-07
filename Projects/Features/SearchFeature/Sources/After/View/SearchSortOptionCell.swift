import DesignSystem
import SearchDomainInterface
import SnapKit
import Then
import UIKit

final class SearchSortOptionCell: UITableViewCell {
    static let identifer: String = "SearchOptionCell"
    private var label: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t4(weight: .light)
    )
    private var checkImageView: UIImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Storage.checkBox.image
        $0.contentMode = .scaleAspectFit
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchSortOptionCell {
    private func addSubviews() {
        self.contentView.addSubviews(label, checkImageView)
    }

    private func setLayout() {
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(checkImageView.snp.leading).offset(-10)
        }

        checkImageView.snp.makeConstraints {
            $0.height.width.equalTo(25)
            $0.centerY.equalTo(label.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    public func update(_ model: SortType, _ selectedModel: SortType) {
        self.label.text = model.title

        if model == selectedModel {
            label.font = .setFont(.t4(weight: .medium))
        } else {
            label.font = .setFont(.t4(weight: .light))
        }

        checkImageView.isHidden = model != selectedModel
    }
}
