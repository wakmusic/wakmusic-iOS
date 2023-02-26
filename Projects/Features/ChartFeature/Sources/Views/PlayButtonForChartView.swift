import UIKit
import DesignSystem
import RxRelay
import RxSwift
import SnapKit
import Then

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

    private let allPlayButton = UIButton().then {
        $0.setTitle("전체재생", for: .normal)
        $0.setImage(DesignSystemAsset.Chart.shufflePlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    private let shufflePlayButton = UIButton().then {
        $0.setTitle("랜덤재생", for: .normal)
        $0.setImage(DesignSystemAsset.Chart.allPlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    private let updateTimeLabel = UILabel().then {
        $0.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        $0.textColor = DesignSystemAsset.GrayColor.gray600.color
    }
    private let updateTimeImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Chart.check.image
    }
//    @IBAction func pressAllPlay(_ sender: UIButton) {
//        delegate?.pressPlay(.allPlay)
//    }
//    @IBAction func pressSufflePlay(_ sender: UIButton) {
//        delegate?.pressPlay(.shufflePlay)
//    }

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
    private func setupView() {
        self.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        
        [
            allPlayButton,
            shufflePlayButton
        ].forEach {
            $0.backgroundColor = .white
            $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
            $0.setTitleColor(DesignSystemAsset.GrayColor.gray900.color, for: .normal)
            $0.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            self.addSubview($0)
        }

        [
            updateTimeImageView,
            updateTimeLabel
        ].forEach {
            self.addSubview($0)
        }
        
        allPlayButton.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.leading.equalTo(20)
            $0.height.equalTo(52)
            $0.trailing.equalTo(self.snp.centerX).inset(4)
        }
        shufflePlayButton.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(52)
            $0.leading.equalTo(self.snp.centerX).offset(4)
        }
        updateTimeImageView.snp.makeConstraints {
            $0.top.equalTo(80)
            $0.width.height.equalTo(18)
            $0.leading.equalTo(20)
        }
        updateTimeLabel.snp.makeConstraints {
            $0.top.equalTo(80)
            $0.height.equalTo(18)
            $0.leading.equalTo(38)
        }
    }
}
