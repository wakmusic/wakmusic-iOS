import DesignSystem
import LogManager
import SnapKit
import Then
import UIKit

public final class WMBottomSheetView: UIView {
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(items: [UIButton]) {
        super.init(frame: .zero)
        addViews()
        setLayout()
        configureUI()
        setupItems(items: items)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setupItems(items: [UIButton]) {
        items.forEach {
            self.stackView.addArrangedSubview($0)
        }
    }
}

private extension WMBottomSheetView {
    func configureUI() {
        backgroundColor = DesignSystemAsset.PrimaryColorV2.point.color
    }

    func addViews() {
        addSubview(stackView)
    }

    func setLayout() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let screenWidth = windowScene?.screen.bounds.size.width ?? .zero

        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(40 * screenWidth / 375)
            $0.verticalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
}

public extension UIViewController {
    func showInlineBottomSheet(
        content: UIView,
        size: CGFloat = 56,
        useSafeArea: Bool = false
    ) {
        let bottomSheetView = BottomSheetView(
            contentView: content,
            contentHeights: [size],
            useSafeAreaInsets: useSafeArea
        )

        bottomSheetView.present(in: self.view)
        NotificationCenter.default.post(name: .shouldHidePlaylistFloatingButton, object: nil)
    }

    func hideInlineBottomSheet() {
        guard let bottomSheetView = view.subviews
            .filter({ $0 is BottomSheetView })
            .last as? BottomSheetView else { return }

        bottomSheetView.dismiss()
        NotificationCenter.default.post(name: .shouldShowPlaylistFloatingButton, object: nil)
    }
}
