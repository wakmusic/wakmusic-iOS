import DesignSystem
import Foundation
import UIKit
import Utility

final class TeamInfoFooterView: UIView {
    private let dotContentView = UIView()

    private let dotLabel = UILabel().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray400.color
        $0.layer.cornerRadius = 2
        $0.clipsToBounds = true
    }

    private let descriptionLabel = WMLabel(
        text: "왁타버스 뮤직 팀에 속한 모든 팀원들은 부아내비 (부려먹는 게 아니라 내가 비빈 거다)라는 모토를 가슴에 새기고 일하고 있습니다.",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray500.color,
        font: .t7(weight: .light),
        lineHeight: UIFont.WMFontSystem.t7(weight: .light).lineHeight
    ).then {
        $0.numberOfLines = 0
        $0.preferredMaxLayoutWidth = APP_WIDTH() - 20 - 16 - 20
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TeamInfoFooterView {
    func addSubViews() {
        addSubviews(dotContentView, descriptionLabel)
        dotContentView.addSubview(dotLabel)
    }

    func setLayout() {
        dotContentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(16)
        }

        dotLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(4)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(dotContentView.snp.top)
            $0.leading.equalTo(dotContentView.snp.trailing)
        }
    }

    func configureUI() {}
}
