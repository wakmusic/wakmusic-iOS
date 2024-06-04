import BaseFeature
import DesignSystem
import UIKit
import Utility

final class WakmusicRecommendViewController: BaseReactorViewController<WakmusicRecommendReactor> {
    private let wmNavigationbarView = WMNavigationBarView().then{
        $0.setTitle("Hello")
    }
    private let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
        $0.setImage(dismissImage, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        reactor?.action.onNext(.viewDidLoad)
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
    
    override func bindAction(reactor: WakmusicRecommendReactor) {
        
        let sharedState = reactor.state.share(replay: 1)
        
    }
    
    
}
