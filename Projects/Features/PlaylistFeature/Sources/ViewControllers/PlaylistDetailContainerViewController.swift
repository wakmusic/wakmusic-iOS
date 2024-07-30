import UIKit
import SnapKit
import Then
import BaseFeature
import Utility
import PlaylistFeatureInterface
import RxSwift

final class PlaylistDetailContainerViewController: UIViewController ,ContainerViewType {
    var contentView: UIView!
    
    private let key: String
    private let ownerId: String
    private let unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory
    private let myPlaylistDetailFactory:  any MyPlaylistDetailFactory
    private var disposeBag = DisposeBag()
    
    private lazy var unknownPlaylistVC = unknownPlaylistDetailFactory.makeView(key: key)
    private lazy var myPlaylistVC = myPlaylistDetailFactory.makeView(key: key)
    
    private let containerView: UIView = UIView()
    
    
    init(key: String, ownerId: String ,unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory,  myPlaylistDetailFactory: any MyPlaylistDetailFactory ) {
        
        self.key = key
        self.ownerId = ownerId
        self.unknownPlaylistDetailFactory = unknownPlaylistDetailFactory
        self.myPlaylistDetailFactory = myPlaylistDetailFactory
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView = containerView
        addViews()
        setLayout()
        configureUI()
    }
}

extension PlaylistDetailContainerViewController {
    
    private func addViews() {
        self.view.addSubviews(containerView)
    }
    
    private func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureUI() {
        PreferenceManager.$userInfo
            .bind(with: self) { owner, userInfo in
                
                guard let userInfo = userInfo else {
                    owner.add(asChildViewController: owner.unknownPlaylistVC)
                    return
                }
                
                if userInfo.decryptedID == owner.ownerId {
                    owner.add(asChildViewController: owner.myPlaylistVC)
                } else {
                    owner.add(asChildViewController: owner.unknownPlaylistVC)
                }
                
            }
            .disposed(by: disposeBag)
        
    }
}
