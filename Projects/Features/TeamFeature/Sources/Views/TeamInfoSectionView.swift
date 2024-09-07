import DesignSystem
import UIKit
import Utility

protocol TeamInfoSectionViewDelegate: AnyObject {
    func toggleSection(header: TeamInfoSectionView, section: Int)
}

final class TeamInfoSectionView: UITableViewHeaderFooterView {
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

    private var section: Int = 0
    weak var delegate: TeamInfoSectionViewDelegate?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubViews()
        setLayout()
        configureUI()
        addTapGestureRecognizers()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TeamInfoSectionView {
    func update(section: Int, title: String, isOpen: Bool) {
        self.section = section
        titleLabel.text = title
        folderImageView.image = isOpen ?
            DesignSystemAsset.Team.folderOn.image : DesignSystemAsset.Team.folderOff.image
        arrowImageView.image = isOpen ?
            DesignSystemAsset.Team.arrowTop.image : DesignSystemAsset.Team.arrowBottom.image
    }

    func rotate(isOpen: Bool) {
        arrowImageView.rotate(.pi)
    }
}

private extension TeamInfoSectionView {
    func addTapGestureRecognizers() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sectionTapped(_:)))
        addGestureRecognizer(gesture)
        isUserInteractionEnabled = true
    }

    @objc func sectionTapped(_ sender: UITapGestureRecognizer) {
        guard let header = sender.view as? TeamInfoSectionView else {
            return
        }
        delegate?.toggleSection(header: header, section: section)
    }

    func addSubViews() {
        addSubviews(folderImageView, titleLabel, arrowImageView)
    }

    func setLayout() {
        folderImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(40)
        }

        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(folderImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(arrowImageView.snp.leading).offset(-10)
            $0.verticalEdges.equalToSuperview()
        }
    }

    func configureUI() {
        contentView.backgroundColor = colorFromRGB(0xF2F4F7)
    }
}
