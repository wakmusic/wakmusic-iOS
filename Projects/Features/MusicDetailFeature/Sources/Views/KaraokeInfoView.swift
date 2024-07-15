import UIKit

private protocol KaraokeStateProtocol {
    func update(model: PlaylistModel.SongModel.KaraokeNumber)
}

final class KaraokeInfoView: UIView {

    private let stackView: UIStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    

    
    
    init() {
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KaraokeInfoView: KaraokeStateProtocol {
    func update(model: PlaylistModel.SongModel.KaraokeNumber) {
        
    }
    
    
}
