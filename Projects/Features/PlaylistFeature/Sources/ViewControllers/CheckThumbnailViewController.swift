import UIKit
import BaseFeature
import SnapKit
import Then
import DesignSystem

final class CheckThumbnailViewController: UIViewController {

    private var wmNavigationbarView: WMNavigationBarView = WMNavigationBarView()

    fileprivate let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
            .withTintColor(DesignSystemAsset.BlueGrayColor.blueGray900.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func addViews() {
        
    }


}
