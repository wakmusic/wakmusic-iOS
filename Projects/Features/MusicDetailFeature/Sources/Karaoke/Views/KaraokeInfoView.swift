import DesignSystem
import SnapKit
import Then
import UIKit

@MainActor
private protocol KaraokeStateProtocol {
    func update(ky: Int?, tj: Int?)
}

final class KaraokeInfoView: UIView {
    private let kyKaraokeView: KaraokeContentView = KaraokeContentView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray50.color
    }

    private let tyKaraokeView: KaraokeContentView = KaraokeContentView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray50.color
    }

    private lazy var stackView: UIStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 8

        $0.addArrangedSubviews(kyKaraokeView, tyKaraokeView)
    }

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear

        addViews()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        self.addSubviews(stackView)
    }

    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
    }
}

extension KaraokeInfoView: KaraokeStateProtocol {
    func update(ky: Int?, tj: Int?) {
        kyKaraokeView.update(number: ky, kind: .KY)
        tyKaraokeView.update(number: tj, kind: .TJ)
    }
}
