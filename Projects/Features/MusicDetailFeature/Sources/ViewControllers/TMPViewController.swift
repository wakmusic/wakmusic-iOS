import UIKit
import Then
import SnapKit
import Utility

final class TMPViewController: UIViewController {
    
    
    var button: UIButton = UIButton().then {
        $0.backgroundColor = .red
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
        
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
        
        
        
        let karaokeModel = PlaylistModel.SongModel.KaraokeNumber(tj: 84250, ky: 84250)
        
        let vc = KaraokeViewController(karaoke: karaokeModel)
        
        
        button.addAction {
            self.showBottomSheet(content: vc, size: .fixed(268 + SAFEAREA_BOTTOM_HEIGHT()))
        }
    }
}
