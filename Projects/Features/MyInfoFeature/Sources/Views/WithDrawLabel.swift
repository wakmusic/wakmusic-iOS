import DesignSystem
import RxCocoa
import RxSwift
import UIKit

private protocol WithDrawLabelActionProtocol {
    var didTap: Observable<Void> { get }
}

final class WithDrawLabel: UILabel {
    private let target = "여기"

    init(_ text: String = "회원 탈퇴를 원하신다면 여기를 눌러주세요.") {
        super.init(frame: .zero)
        self.text = text
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure() {
        guard let text = self.text else { return }
        let attrStr = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: attrStr.length)
        let targetRange = (text as NSString).range(of: target)
        let color = DesignSystemAsset.BlueGrayColor.blueGray500.color
        let font = UIFont.setFont(.t7(weight: .light))
        attrStr.addAttribute(.foregroundColor, value: color, range: fullRange)
        attrStr.addAttribute(.font, value: font, range: fullRange)
        attrStr.addAttribute(.kern, value: -0.5, range: fullRange)
        attrStr.addAttribute(.underlineStyle, value: 1, range: targetRange)

        self.attributedText = attrStr
    }
}

extension Reactive: WithDrawLabelActionProtocol where Base: WithDrawLabel {
    var didTap: Observable<Void> {
        let tapGestureRecognizer = UITapGestureRecognizer()
        base.addGestureRecognizer(tapGestureRecognizer)
        base.isUserInteractionEnabled = true
        return tapGestureRecognizer.rx.event.map { _ in }.asObservable()
    }
}
