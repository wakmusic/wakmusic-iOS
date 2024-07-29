import BaseFeature
import DesignSystem
import SongsDomainInterface
import UIKit
import Utility

protocol NewSongsCellDelegate: AnyObject {
    func tappedThumbnail(id: String)
}

class NewSongsCell: UITableViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!

    private var model: NewSongsEntity?
    weak var delegate: NewSongsCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .clear
        albumImageView.clipsToBounds = true
        albumImageView.layer.cornerRadius = 4
        albumImageView.contentMode = .scaleAspectFill
    }

    @IBAction func playButtonAction(_ sender: Any) {
        guard let song = self.model else { return }
        delegate?.tappedThumbnail(id: song.id)
    }
}

extension NewSongsCell {
    func update(model: NewSongsEntity) {
        self.model = model
        contentView.backgroundColor = model.isSelected ? DesignSystemAsset.BlueGrayColor.gray200
            .color : DesignSystemAsset.BlueGrayColor.gray100.color

        titleStringLabel.text = model.title
        titleStringLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        titleStringLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        titleStringLabel.setTextWithAttributes(kernValue: -0.5)

        artistLabel.text = model.artist
        artistLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        artistLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        artistLabel.setTextWithAttributes(kernValue: -0.5)

        viewsLabel.text = model.views.addCommaToNumber() + "회"
        viewsLabel.font = DesignSystemFontFamily.SCoreDream._3Light.font(size: 12)

        albumImageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchYoutubeThumbnail(id: model.id).toString),
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )
    }
}
