import DesignSystem
import RxCocoa
import RxSwift
import SearchDomainInterface
import SnapKit
import Then
import UIKit

@MainActor
private protocol OptionButtonStateProtocol {
    func updateSortrState(_ filterType: SortType)
}

private protocol OptionButtonActionProtocol {
    var didTap: Observable<Void> { get }
}

final class OptionButton: UIView {
    private let leftLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.NewGrayColor.gray900.color,
        font: .t6(weight: .medium),
        alignment: .right,
        lineHeight: UIFont.WMFontSystem.t6().lineHeight
    ).then {
        $0.numberOfLines = 1
    }

    private let rightImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Search.arrowDown.image
    }

    private var sortType: SortType

    fileprivate let tapGestureRecognizer = UITapGestureRecognizer()

    public init(_ sortType: SortType) {
        self.sortType = sortType
        super.init(frame: .zero)
        addSubviews()
        setLayout()
        configureUI()
        bindAction()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OptionButton {
    private func addSubviews() {
        self.addSubviews(
            leftLabel,
            rightImageView
        )
    }

    private func setLayout() {
        leftLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        rightImageView.snp.makeConstraints {
            $0.leading.equalTo(leftLabel.snp.trailing).offset(3)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }

    private func configureUI() {
        leftLabel.text = sortType.title
    }

    private func bindAction() {
        self.addGestureRecognizer(tapGestureRecognizer)
        self.isUserInteractionEnabled = true
    }
}

extension OptionButton: OptionButtonStateProtocol {
    func updateSortrState(_ type: SortType) {
        self.sortType = type
        leftLabel.text = sortType.title
    }
}

extension Reactive: OptionButtonActionProtocol where Base: OptionButton {
    var didTap: Observable<Void> {
        return base.tapGestureRecognizer.rx.event.map { _ in }.asObservable()
    }
}
