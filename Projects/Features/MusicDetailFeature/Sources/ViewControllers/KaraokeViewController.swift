import Foundation
import BaseFeature
import DesignSystem

final class KaraokeViewController: BaseViewController {
    
    private let karaoke: PlaylistModel.SongModel.KaraokeNumber
    
    private let titleLabel: WMLabel = WMLabel(
        text: "노래방",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t2(weight: .bold),
        alignment: .center
    )
    
    
    init(karaoke: PlaylistModel.SongModel.KaraokeNumber) {
        
        self.karaoke = karaoke
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setLayout()
        
    }
}

extension KaraokeViewController {
    private func addViews() {
        self.view.addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(32)
        }
    }
    
}
