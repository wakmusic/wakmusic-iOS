import UIKit
import DesignSystem
import SnapKit
import Then

private protocol KaraokeStateProtocol {
    func update(model: PlaylistModel.SongModel.KaraokeNumber)
}

final class KaraokeInfoView: UIView {

    
    private let kyKaraokeView: KaraokeContentView = KaraokeContentView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray50.color
    }
    private let tyKaraokeView: KaraokeContentView = KaraokeContentView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray50.color
    }
    

    private lazy var stackView: UIStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 8
        
        $0.addArrangedSubviews(kyKaraokeView, tyKaraokeView)
    }
    
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        addViews()
        setLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.addSubviews(stackView)
    }
    
    private  func setLayout() {
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
    }
    
}

extension KaraokeInfoView: KaraokeStateProtocol {
    func update(model: PlaylistModel.SongModel.KaraokeNumber) {
                
        kyKaraokeView.update(number: model.ky, kind: .KY)
        tyKaraokeView.update(number: model.tj, kind: .TJ)
        
    }
    
    
}
