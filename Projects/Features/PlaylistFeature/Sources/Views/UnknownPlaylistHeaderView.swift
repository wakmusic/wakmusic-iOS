import DesignSystem
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

private protocol UnknownPlaylistHeaderStateProtocol {
    func updateData(_ model: PlaylistDetailHeaderModel)
}

final class UnknownPlaylistHeaderView: UIView {
    private var thumbnailImageView: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }

    private let scrollView: UIScrollView = UIScrollView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray25.color.withAlphaComponent(0.4)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.white.cgColor
        $0.clipsToBounds = true
        $0.verticalScrollIndicatorInsets = .init(top: 20, left: .zero, bottom: 12, right: 6)
    }

    private let stackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
    }

    private let containerView: UIView = UIView()

    private let titleLabel: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t3(weight: .bold),
        lineHeight: UIFont.WMFontSystem.t3(weight: .bold).lineHeight
    ).then {
        $0.numberOfLines = .zero
    }

    let countLabel: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray600.color,
        font: .t6_1(weight: .light),
        lineHeight: UIFont.WMFontSystem.t6_1(weight: .light).lineHeight
    )

    let nickNameLabel: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray600.color,
        font: .t6_1(weight: .medium),
        lineHeight: UIFont.WMFontSystem.t6(weight: .medium).lineHeight
    ).then {
        $0.numberOfLines = .zero
    }

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

extension UnknownPlaylistHeaderView {
    private func addView() {
        self.addSubviews(thumbnailImageView, scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(containerView)
        containerView.addSubviews(titleLabel, countLabel, nickNameLabel)
    }

    private func setLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.width.height.equalTo(140)
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }

        scrollView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }

        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        countLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(titleLabel)
        }

        nickNameLabel.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(countLabel.snp.bottom).offset(2)
            $0.horizontalEdges.equalTo(titleLabel)
            $0.bottom.greaterThanOrEqualToSuperview().inset(12)
        }
    }
}

extension UnknownPlaylistHeaderView: UnknownPlaylistHeaderStateProtocol {
    func updateData(_ model: PlaylistDetailHeaderModel) {
        titleLabel.text = model.title
        thumbnailImageView.kf.setImage(with: URL(string: model.image))
        countLabel.text = "\(model.songCount)곡"
        nickNameLabel.text = model.userName
    }
}
