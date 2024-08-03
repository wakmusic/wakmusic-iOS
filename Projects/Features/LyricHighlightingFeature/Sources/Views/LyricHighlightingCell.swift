import DesignSystem
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

final class LyricHighlightingCell: UICollectionViewCell {
    private let lyricLabel = WMLabel(
        text: "",
        textColor: .white,
        font: .t4(weight: .light),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t4().lineHeight,
        kernValue: -0.5
    ).then {
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
    func update(entity: LyricsEntity.Lyric) {
        lyricLabel.text = entity.text
        lyricLabel.setBackgroundColorForAttributedString(
            color: entity.isHighlighting ?
                DesignSystemAsset.PrimaryColorV2.point.color.withAlphaComponent(0.5) : .clear
        )
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

private extension UILabel {
    func setBackgroundColorForAttributedString(color: UIColor) {
        guard let attributedText = self.attributedText else { return }
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)

        mutableAttributedText.addAttribute(
            .backgroundColor,
            value: color,
            range: NSRange(location: 0, length: attributedText.length)
        )
        self.attributedText = mutableAttributedText
    }
}
