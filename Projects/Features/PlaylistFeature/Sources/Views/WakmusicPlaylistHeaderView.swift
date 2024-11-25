import DesignSystem
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

@MainActor
private protocol WakmusicPlaylistHeaderStateProtocol {
    func updateData(_ model: PlaylistDetailHeaderModel)
}

final class WakmusicPlaylistHeaderView: UIView {
    private var thumbnailImageView: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }

    private let containerView: UIView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray25.color.withAlphaComponent(0.4)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.white.cgColor
        $0.clipsToBounds = true
    }

    private let titleLabel: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t3(weight: .bold),
        lineHeight: UIFont.WMFontSystem.t3(weight: .bold).lineHeight
    ).then {
        $0.numberOfLines = 0
    }

    let subtitleLabel: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray600.color,
        font: .t6_1(weight: .light),
        lineHeight: UIFont.WMFontSystem.t6_1(weight: .light).lineHeight
    )

    override init(frame: CGRect) {
        super.init(frame: frame)

        addView()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WakmusicPlaylistHeaderView {
    private func addView() {
        self.addSubviews(thumbnailImageView, containerView)
        containerView.addSubviews(titleLabel, subtitleLabel)
    }

    private func setLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.width.height.equalTo(140)
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }

        containerView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
    }
}

extension WakmusicPlaylistHeaderView: WakmusicPlaylistHeaderStateProtocol {
    func updateData(_ model: PlaylistDetailHeaderModel) {
        titleLabel.text = model.title
        thumbnailImageView.kf.setImage(with: URL(string: model.image))

        subtitleLabel.text = "\(model.songCount)곡"
    }
}
