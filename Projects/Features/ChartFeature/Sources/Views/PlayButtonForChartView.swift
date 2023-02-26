import UIKit
import DesignSystem
import RxRelay
import RxSwift

public enum PlayEvent {
    case allPlay
    case shufflePlay
}

public protocol PlayButtonForChartViewDelegate: AnyObject {
   func pressPlay(_ event:PlayEvent)
}

public final class PlayButtonForChartView: UIView {
    public weak var delegate:PlayButtonForChartViewDelegate?
    private let disposeBag = DisposeBag()

    @IBOutlet weak var allPlayButton: UIButton!
    @IBOutlet weak var shufflePlayButton: UIButton!
    @IBOutlet weak var updateTimeLabel: UILabel!
    
    @IBAction func pressAllPlay(_ sender: UIButton) {
        delegate?.pressPlay(.allPlay)
    }
    @IBAction func pressSufflePlay(_ sender: UIButton) {
        delegate?.pressPlay(.shufflePlay)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    public func setUpdateTime(updateTime: BehaviorRelay<String>) {
        updateTime
            .bind(to: updateTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension PlayButtonForChartView {
    private func setupView(){
        guard let view = Bundle.module.loadNibNamed("PlayButtonForChartView", owner: self, options: nil)?.first as? UIView else { return }
        view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        view.frame = self.bounds
        view.layoutIfNeeded()
        self.addSubview(view)

        let allPlayAttributedString = NSMutableAttributedString.init(string: "전체재생")
        
        allPlayAttributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color
            ],
            range: NSRange(location: 0, length: allPlayAttributedString.string.count)
        )

        allPlayButton.setImage(DesignSystemAsset.Chart.allPlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
        allPlayButton.layer.cornerRadius = 8
        allPlayButton.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        allPlayButton.layer.borderWidth = 1

        updateTimeLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        
        let shufflePlayAttributedString = NSMutableAttributedString.init(string: "랜덤재생")
        
        shufflePlayAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                                   .foregroundColor: DesignSystemAsset.GrayColor.gray900.color],
                                                  range: NSRange(location: 0, length: shufflePlayAttributedString.string.count))
        
        shufflePlayButton.setImage(DesignSystemAsset.Chart.shufflePlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
        shufflePlayButton.layer.cornerRadius = 8
        shufflePlayButton.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        shufflePlayButton.layer.borderWidth = 1

        allPlayButton.setAttributedTitle(allPlayAttributedString, for: .normal)
        shufflePlayButton.setAttributedTitle(shufflePlayAttributedString, for: .normal)
        view.layoutIfNeeded()
    }
}
