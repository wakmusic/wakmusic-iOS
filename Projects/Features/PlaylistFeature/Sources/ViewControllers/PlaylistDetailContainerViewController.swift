import UIKit
import SnapKit
import Then
import BaseFeature
import Utility
import PlaylistFeatureInterface
import RxSwift

final class PlaylistDetailContainerViewController: BaseReactorViewController<PlaylistDetailContainerReactor>, ContainerViewType {
    var contentView: UIView! = UIView()
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
                
                guard let userInfo else {
                    owner.add(asChildViewController: owner.unknownPlaylistVC)
                    return
                }
                DEBUG_LOG("CHILD \(owner.children)")
                reactor.action.onNext(.requestOwnerId)
              
            }
            .disposed(by: disposeBag)
        
    }
    
    
    override func bindState(reactor: PlaylistDetailContainerReactor) {
        super.bindState(reactor: reactor)
        
        let sharedState = reactor.state.share()
        
        
        sharedState.map(\.ownerId)
            .compactMap({ $0 })
            .bind(with: self) { owner, ownerId in
                
                guard let userInfo = PreferenceManager.userInfo else { return }
                
                owner.remove(asChildViewController: owner.children.first)
                
                if ownerId == userInfo.decryptedID {
                    owner.add(asChildViewController: owner.myPlaylistVC)
                } else {
                    owner.add(asChildViewController: owner.unknownPlaylistVC)
                }
                
                DEBUG_LOG("CHILD \(owner.children)")
            }
            .disposed(by: disposeBag)
        
//        sharedState.map(\.isLoading)
//            .distinctUntilChanged()
//            .bind(with: self) { owner, isLoading in
//                owner.contentView.isHidden = isLoading
//            }
//            .disposed(by: disposeBag)
        
    
    
    }
}

