import DesignSystem
import Kingfisher
import Lottie
import RxGesture
import RxSwift
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

final class CreditSongCollectionViewCell: UICollectionViewCell {
    private let thumbnailImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.dummyThumbnailSmall.image
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }

    private lazy var songInfoStackView = UIStackView(arrangedSubviews: [titleLabel, artistLabel]).then {
        $0.axis = .vertical
        $0.distribution = .fill
    }

    private let titleLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        font: .t6(weight: .medium)
    ).then {
        $0.lineBreakMode = .byTruncatingTail
    }

    private let artistLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        font: .t7(weight: .light)
    ).then {
        $0.lineBreakMode = .byTruncatingTail
    }

    private let dateLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        font: .t7(weight: .score3Light),
        alignment: .right
    ).then {
        $0.lineBreakMode = .byTruncatingTail
    }

    private let disposeBag = DisposeBag()
    private var handler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setLayout()
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setThumbnailTapHandler(_ handler: @escaping () -> Void) {
        self.handler = handler
    }

    func update(_ model: CreditSongModel, isSelected: Bool) {
        self.thumbnailImageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchYoutubeThumbnail(id: model.id).toString),
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )

        self.titleLabel.text = model.title
        self.artistLabel.text = model.artist
        self.dateLabel.text = model.date
        self.backgroundColor = isSelected ? DesignSystemAsset.BlueGrayColor.gray200.color : UIColor.clear
    }
}

private extension CreditSongCollectionViewCell {
    func addViews() {
        contentView.addSubviews(thumbnailImageView, songInfoStackView, dateLabel)
    }

    func setLayout() {
        contentView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.edges.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.width.equalTo(thumbnailImageView.snp.height).multipliedBy(16.0 / 9.0)
        }

        songInfoStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(dateLabel.snp.leading).offset(-16)
        }

        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    func bind() {
        thumbnailImageView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.handler?()
            }
            .disposed(by: disposeBag)
    }
}
