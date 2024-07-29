import ArtistDomainInterface
import BaseFeature
import DesignSystem
import Kingfisher
import SongsDomainInterface
import UIKit
import Utility

protocol ArtistMusicCellDelegate: AnyObject {
    func tappedThumbnail(id: String)
}

final class ArtistMusicCell: UITableViewCell {
    @IBOutlet weak var albumImageButton: UIButton!
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var groupStringLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!

    private var model: ArtistSongListEntity?
    weak var delegate: ArtistMusicCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        albumImageButton.layer.cornerRadius = 4
        albumImageButton.contentMode = .scaleAspectFill
        albumImageButton.clipsToBounds = true

        titleStringLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        groupStringLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        releaseDateLabel.font = DesignSystemFontFamily.SCoreDream._3Light.font(size: 12)
    }

    @IBAction func thumbnailToPlayButtonAction(_ sender: Any) {
        guard let song = self.model else { return }
        delegate?.tappedThumbnail(id: song.songID)
    }
}

extension ArtistMusicCell {
    func update(model: ArtistSongListEntity) {
        self.model = model
        contentView.backgroundColor = model.isSelected ?
            DesignSystemAsset.BlueGrayColor.gray200.color : UIColor.clear

        titleStringLabel.attributedText = getAttributedString(
            text: model.title,
            font: DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        )

        groupStringLabel.attributedText = getAttributedString(
            text: model.artist,
            font: DesignSystemFontFamily.Pretendard.light.font(size: 12)
        )

        releaseDateLabel.attributedText = getAttributedString(
            text: model.date,
            font: DesignSystemFontFamily.SCoreDream._3Light.font(size: 12)
        )

        let modifier = AnyImageModifier { return $0.withRenderingMode(.alwaysOriginal) }
        albumImageButton.kf.setImage(
            with: URL(string: WMImageAPI.fetchYoutubeThumbnail(id: model.songID).toString),
            for: .normal,
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.imageModifier(modifier), .transition(.fade(0.2))]
        )
    }
}

private extension ArtistMusicCell {
    func getAttributedString(
        text: String,
        font: UIFont
    ) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        return attributedString
    }
}
