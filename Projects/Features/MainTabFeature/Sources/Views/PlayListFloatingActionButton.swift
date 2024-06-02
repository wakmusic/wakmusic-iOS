import DesignSystem
import UIKit

final class PlayListFloatingActionButton: UIButton {
    init() {
        super.init(frame: .zero)
        setupButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2.0
        self.clipsToBounds = true
    }
    
    private func setupButton() {
        self.setImage(
            DesignSystemAsset.Main.playlist.image
                .withTintColor(DesignSystemAsset.BlueGrayColor.blueGray900.color, renderingMode: .alwaysOriginal),
            for: .normal
        )
        self.backgroundColor = .white
    }
}
