import DesignSystem
import RxCocoa
import RxGesture
import RxSwift
import UIKit

private protocol WithDrawLabelActionProtocol {
    var didTap: Observable<Void> { get }
}

final class WithDrawLabel: UILabel {
    private let targetText: String
    fileprivate let didTapSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()

    init(text: String = "회원 탈퇴를 원하신다면 여기를 눌러주세요.", targetText: String = "여기") {
        self.targetText = targetText
        super.init(frame: .zero)
        self.text = text

        guard let text = self.text else { return }
        let attrStr = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: attrStr.length)
        let targetRange = (text as NSString).range(of: targetText)
        let color = DesignSystemAsset.BlueGrayColor.blueGray500.color
        let font = UIFont.setFont(.t7(weight: .light))
        attrStr.addAttribute(.foregroundColor, value: color, range: fullRange)
        attrStr.addAttribute(.font, value: font, range: fullRange)
        attrStr.addAttribute(.kern, value: -0.5, range: fullRange)
        attrStr.addAttribute(.underlineStyle, value: 1, range: targetRange)

        self.attributedText = attrStr
        registerGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func registerGesture() {
        self.isUserInteractionEnabled = true
        self.rx.tapGesture()
            .when(.recognized)
            .filter { [weak self] gesture in
                guard let self = self else { return false }
                let location = gesture.location(in: self)
                return self.isTargetTapped(at: location)
            }
            .map { _ in () }
            .bind(to: didTapSubject)
            .disposed(by: disposeBag)
    }

    private func isTargetTapped(at point: CGPoint) -> Bool {
        guard let attributedText = attributedText else { return false }

        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(
            for: point,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        let targetRange = (text as NSString?)?.range(of: targetText) ?? NSRange(location: 0, length: 0)
        return NSLocationInRange(index, targetRange)
    }
}

extension Reactive where Base: WithDrawLabel {
    @MainActor
    var didTap: Observable<Void> {
        return base.didTapSubject.asObservable()
    }
}
