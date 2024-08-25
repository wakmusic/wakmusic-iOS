import MarqueeLabel
import UIKit

public final class WMLabel: UILabel {
    override public var text: String? {
        get {
            self.attributedText?.string
        } set {
            self.attributedText = NSMutableAttributedString(string: newValue ?? "", attributes: attributes)
        }
    }

    var attributes: [NSAttributedString.Key: Any]?

    public init(
        text: String,
        textColor: UIColor = .init(),
        font: UIFont.WMFontSystem,
        alignment: NSTextAlignment = .left,
        lineHeight: CGFloat? = nil,
        kernValue: Double? = -0.5,
        lineSpacing: CGFloat? = nil,
        lineHeightMultiple: CGFloat? = nil
    ) {
        super.init(frame: .zero)
        self.textColor = textColor
        self.font = .setFont(font)
        self.textAlignment = alignment
        attributes = self.getTextWithAttributes(
            lineHeight: lineHeight ?? font.lineHeight,
            kernValue: kernValue,
            lineSpacing: lineSpacing,
            lineHeightMultiple: lineHeightMultiple,
            alignment: alignment
        )

        self.attributedText = NSMutableAttributedString(string: text, attributes: attributes)
    }

    convenience init(
        text: String,
        textColor: UIColor = .init(),
        font: UIFont.WMFontSystem,
        alignment: NSTextAlignment = .left,
        lineHeight: CGFloat? = nil,
        kernValue: Double? = -0.5
    ) {
        self.init(
            text: text,
            textColor: textColor,
            font: font,
            alignment: alignment,
            lineHeight: lineHeight,
            kernValue: kernValue,
            lineSpacing: nil,
            lineHeightMultiple: nil
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setFont(_ style: UIFont.WMFontSystem) {
        self.font = UIFont.setFont(style)
    }
}
