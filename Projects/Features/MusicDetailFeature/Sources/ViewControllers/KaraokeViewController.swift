import BaseFeature
import DesignSystem
import UIKit
import Utility

final class KaraokeViewController: BaseViewController {
    private var ky: Int?
    private var tj: Int?

    private let titleLabel: WMLabel = WMLabel(
        text: "노래방",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t2(weight: .bold),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t2(weight: .bold).lineHeight
    )

    private let karaokeInfoView: KaraokeInfoView = KaraokeInfoView()

    private let confirmButton: UIButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .setFont(.t4(weight: .medium))
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = DesignSystemAsset.PrimaryColorV2.point.color
    }

    init(ky: Int?, tj: Int?) {
        self.ky = ky
        self.tj = tj

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setLayout()
        configureUI()
        bindAction()
    }
}

extension KaraokeViewController {
    private func addViews() {
        self.view.addSubviews(titleLabel, karaokeInfoView, confirmButton)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(32)
        }

        karaokeInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalTo(karaokeInfoView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    private func configureUI() {
        self.view.backgroundColor = .white
        karaokeInfoView.update(ky: ky, tj: tj)
    }

    private func bindAction() {
        confirmButton.addAction { [weak self] in

            guard let self else { return }

            self.dismiss(animated: true)
        }
    }
}
