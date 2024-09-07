import DesignSystem
import UIKit

internal class RectangleButton: UIButton {
    func setColor(isHighlight: Bool) {
        let pointColor = DesignSystemAsset.PrimaryColor.point.color
        if isHighlight {
            self.setColor(title: pointColor, border: pointColor)
        } else {
            self.setColor(
                title: DesignSystemAsset.BlueGrayColor.gray400.color,
                border: DesignSystemAsset.BlueGrayColor.gray300.color
            )
        }
    }

    func setColor(title: UIColor, border: UIColor) {
        self.setTitleColor(title, for: .normal)
        self.layer.borderColor = border.cgColor
    }
}
