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

    private var items: [UIButton] = []

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init() {
        super.init(frame: .zero)
        addViews()
        setLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setupItems(with items: [UIButton]) {
        self.items = items
        self.items.forEach {
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
