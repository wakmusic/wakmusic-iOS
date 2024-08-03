import DesignSystem
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

final class LyricHighlightingCell: UICollectionViewCell {
    private let lyricLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LyricHighlightingCell {
    static func cellHeight(entity: LyricsEntity.Lyric) -> CGSize {
        return .init(
            width: APP_WIDTH(),
            height: entity.text.heightConstraintAt(
                width: APP_WIDTH() - 50,
                font: UIFont.WMFontSystem.t4(weight: .light).font
            )
        )
    }

    func update(entity: LyricsEntity.Lyric) {
        let style = NSMutableParagraphStyle()
        style.alignment = .center

        let attributedString = NSMutableAttributedString(
            string: entity.text,
            attributes: [
                .font: UIFont.WMFontSystem.t4(weight: .light).font,
                .backgroundColor: entity.isHighlighting ? DesignSystemAsset.PrimaryColorV2.point.color
                    .withAlphaComponent(0.5) : .clear,
                .foregroundColor: UIColor.white,
                .kern: -0.5,
                .paragraphStyle: style
            ]
        )
        lyricLabel.attributedText = attributedString
    }
}

private extension LyricHighlightingCell {
    func addSubViews() {
        contentView.addSubview(lyricLabel)
    }

    func setLayout() {
        lyricLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.verticalEdges.equalToSuperview()
        }
    }
}
