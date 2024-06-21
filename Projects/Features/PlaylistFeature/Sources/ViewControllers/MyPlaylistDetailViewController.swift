import UIKit
import SnapKit
import Then
import ReactorKit
import BaseFeature
import DesignSystem
import Utility

final class MyPlaylistDetailViewController: BaseReactorViewController<MyPlaylistDetailReactor> {
    
    private var wmNavigationbarView: WMNavigationBarView = WMNavigationBarView()
    
    private var lockButton: UIButton = UIButton().then {
        
        $0.setImage(DesignSystemAsset.Playlist.lock.image, for: .normal)
        $0.setImage(DesignSystemAsset.Playlist.unLock.image, for: .selected)
        
    }
    
    fileprivate let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
            .withTintColor(DesignSystemAsset.BlueGrayColor.blueGray900.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
    }
    
    private var moreButton: UIButton = UIButton().then {
        $0.setImage(DesignSystemAsset.MyInfo.more.image, for: .normal)
    }
    
    private var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
       
    }
    
    override func addView() {
        super.addView()
        self.view.addSubviews(wmNavigationbarView, tableView)
        wmNavigationbarView.setLeftViews([dismissButton])
        wmNavigationbarView.setRightViews([lockButton, moreButton])
    }
    
    override func setLayout() {
        super.setLayout()
        
        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(STATUS_BAR_HEGHIT())
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(wmNavigationbarView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }

    }
    
    override func configureUI() {
        super.configureUI()
        
    }



}
