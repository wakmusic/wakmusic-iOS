import UIKit
import SnapKit
import Then
import BaseFeature
import Utility
import PlaylistFeatureInterface
import RxSwift
import DesignSystem

final class PlaylistDetailContainerViewController: BaseReactorViewController<PlaylistDetailContainerReactor>, ContainerViewType {
    var contentView: UIView! = UIView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
    }
    private let unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory
    private let myPlaylistDetailFactory: any MyPlaylistDetailFactory
    private let key: String
    lazy var unknownPlaylistVC = unknownPlaylistDetailFactory.makeView(key: key)
    lazy var myPlaylistVC = myPlaylistDetailFactory.makeView(key: key)
    
    
    init(reactor: PlaylistDetailContainerReactor, key: String ,unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory,  myPlaylistDetailFactory: any MyPlaylistDetailFactory ) {
        self.key = key 
        self.unknownPlaylistDetailFactory = unknownPlaylistDetailFactory
        self.myPlaylistDetailFactory = myPlaylistDetailFactory
        
        super.init(reactor: reactor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addView() {
        super.addView()
        self.view.addSubviews(contentView)
    }
    
    
    override func setLayout() {
        super.setLayout()
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func bind(reactor: PlaylistDetailContainerReactor) {
        super.bind(reactor: reactor)
    
        PreferenceManager.$userInfo
            .bind(with: self) { owner, userInfo in
                
                owner.remove(asChildViewController: owner.children.first)
                
                if userInfo == nil {
                    owner.add(asChildViewController: owner.unknownPlaylistVC)
                } else {
                    reactor.action.onNext(.requestOwnerID)
                }
                 
              
            }
            .disposed(by: disposeBag)
        
    }
    
    
    override func bindState(reactor: PlaylistDetailContainerReactor) {
        super.bindState(reactor: reactor)
        
        let sharedState = reactor.state.share()
        
        
        sharedState.map(\.ownerID)
            .compactMap({ $0 })
            .distinctUntilChanged()
            .withLatestFrom(PreferenceManager.$userInfo){ ($0, $1) }
            .bind(with: self) { owner, info in
                
                let (ownerID, userInfo) = info
                
                guard let userInfo else { return }
                
                
                owner.remove(asChildViewController: owner.children.first)
                
                if ownerID == userInfo.decryptedID {
                    owner.add(asChildViewController: owner.myPlaylistVC)
                } else {
                    owner.add(asChildViewController: owner.unknownPlaylistVC)
                }
                
            }
            .disposed(by: disposeBag)
        
    
    }
}

