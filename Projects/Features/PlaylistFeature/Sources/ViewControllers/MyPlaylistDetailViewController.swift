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
    
    private var headerView: MyPlaylistHeaderView = MyPlaylistHeaderView(frame: .init(x: .zero, y: .zero, width: APP_WIDTH(), height: 140))
    
    private lazy var tableView: UITableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(PlaylistTableViewCell.self, forCellReuseIdentifier: PlaylistTableViewCell.identifier)
        $0.tableHeaderView = headerView
    }
    
    private lazy var completeButton: RectangleButton = RectangleButton().then {
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setColor(isHighlight: true)
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .init(font: DesignSystemFontFamily.Pretendard.bold, size: 12)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
       
    }
    
    override func addView() {
        super.addView()
        self.view.addSubviews(wmNavigationbarView, tableView)
        wmNavigationbarView.setLeftViews([dismissButton])
        wmNavigationbarView.setRightViews([lockButton, moreButton,completeButton])
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
        
        completeButton.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.height.equalTo(24)
            $0.bottom.equalToSuperview().offset(-5)
        }

    }
    
    override func configureUI() {
        super.configureUI()
        
    }
    
    override func bind(reactor: MyPlaylistDetailReactor) {
        super.bind(reactor: reactor)
    }
    
    override func bindAction(reactor: MyPlaylistDetailReactor) {
        super.bindAction(reactor: reactor)
    }
    
    override func bindState(reactor: MyPlaylistDetailReactor) {
        super.bindState(reactor: reactor)
    }



}


