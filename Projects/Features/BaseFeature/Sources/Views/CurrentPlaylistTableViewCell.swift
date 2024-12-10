import DesignSystem
import UIKit
import UserDomainInterface
import Utility

class CurrentPlaylistTableViewCell: UITableViewCell {
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var playlistCountLabel: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        Task { @MainActor in
            self.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
            self.playlistImageView.layer.cornerRadius = 4
            self.playlistNameLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
            self.playlistNameLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
            self.playlistNameLabel.setTextWithAttributes(kernValue: -0.5)
            self.playlistCountLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
            self.playlistCountLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
            self.playlistCountLabel.setTextWithAttributes(kernValue: -0.5)
            self.lockImageView.image = DesignSystemAsset.Storage.storageClose.image
        }
    }
}

extension CurrentPlaylistTableViewCell {
    func update(model: PlaylistEntity) {
        self.playlistImageView.kf.setImage(
            with: URL(string: model.image),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
        self.playlistNameLabel.text = model.title
        self.playlistCountLabel.text = "\(model.songCount)곡"
        self.lockImageView.isHidden = !model.private
    }
}
