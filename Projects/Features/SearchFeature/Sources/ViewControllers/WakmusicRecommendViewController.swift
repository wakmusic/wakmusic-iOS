import BaseFeature
import DesignSystem
import UIKit
import Utility

final class WakmusicRecommendViewController: BaseReactorViewController<WakmusicRecommendReactor> {
    private let wmNavigationbarView = WMNavigationBarView()

    private let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
        //  .withTintColor(DesignSystemAsset.PrimaryColorV2.white.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }

    override func addView() {
        super.addView()
        self.view.addSubviews(wmNavigationbarView)
    }

    override func setLayout() {
        super.setLayout()

        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(STATUS_BAR_HEGHIT())
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
        wmNavigationbarView.setLeftViews([dismissButton])
    }
}
