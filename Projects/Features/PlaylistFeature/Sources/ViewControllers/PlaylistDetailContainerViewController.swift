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
    
    
    
    init(reactor: PlaylistDetailContainerReactor, unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory,  myPlaylistDetailFactory: any MyPlaylistDetailFactory ) {
        
        self.unknownPlaylistDetailFactory = unknownPlaylistDetailFactory
        self.myPlaylistDetailFactory = myPlaylistDetailFactory
        
        super.init(reactor: reactor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
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
            .bind(with: self) { owner, _ in
                reactor.action.onNext(.viewDidLoad)
            }
        
    }
    
    
    override func bindState(reactor: PlaylistDetailContainerReactor) {
        super.bindState(reactor: reactor)
        
        let unknownPlaylistVC = unknownPlaylistDetailFactory.makeView(key: reactor.key)
        let myPlaylistVC = myPlaylistDetailFactory.makeView(key: reactor.key)
        
        
        let sharedState = reactor.state.share()
        
    
    
    }
}

