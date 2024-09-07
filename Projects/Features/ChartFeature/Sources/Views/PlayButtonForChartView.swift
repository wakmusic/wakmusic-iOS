import DesignSystem
import RxRelay
import RxSwift
import SnapKit
import Then
import UIKit

public enum PlayEvent {
    case allPlay
    case shufflePlay
}

public protocol PlayButtonForChartViewDelegate: AnyObject {
    func pressPlay(_ event: PlayEvent)
}

public final class PlayButtonForChartView: UIView {
    public weak var delegate: PlayButtonForChartViewDelegate?
    private let disposeBag = DisposeBag()

    private let allPlayButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Chart.allPlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
        let attributedString = NSMutableAttributedString(string: "전체재생")
        attributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5
            ],
            range: NSRange(location: 0, length: attributedString.string.count)
        )
        $0.setAttributedTitle(attributedString, for: .normal)
    }

    private let shufflePlayButton = UIButton().then {
        $0.setTitle("랜덤재생", for: .normal)
        $0.setImage(DesignSystemAsset.Chart.shufflePlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
        let attributedString = NSMutableAttributedString(string: "랜덤재생")
        attributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5
            ],
            range: NSRange(location: 0, length: attributedString.string.count)
        )
        $0.setAttributedTitle(attributedString, for: .normal)
    }

    private let updateTimeLabel = WMLabel(
        text: "업데이트",
        textColor: DesignSystemAsset.GrayColor.gray600.color,
        font: .t7(weight: .light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t7().lineHeight,
        kernValue: -0.5
    )

    private let updateTimeImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Chart.check.image
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.bind()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    public func setUpdateTime(updateTime: BehaviorRelay<String>) {
        let attributedString = NSMutableAttributedString(string: updateTime.value)
        attributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.light.font(size: 12),
                .foregroundColor: DesignSystemAsset.GrayColor.gray600.color,
                .kern: -0.5
            ],
            range: NSRange(location: 0, length: attributedString.string.count)
        )
        updateTimeLabel.attributedText = attributedString
    }
}

extension PlayButtonForChartView {
    private func setupView() {
        self.backgroundColor = DesignSystemAsset.GrayColor.gray100.color

        [
            allPlayButton,
            shufflePlayButton
        ].forEach {
            $0.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            $0.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.withAlphaComponent(0.7).cgColor
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
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
            $0.trailing.equalTo(self.snp.centerX).offset(-4)
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

    private func bind() {
        allPlayButton.rx.tap.bind {
            self.delegate?.pressPlay(.allPlay)
        }.disposed(by: disposeBag)

        shufflePlayButton.rx.tap.bind {
            self.delegate?.pressPlay(.shufflePlay)
        }.disposed(by: disposeBag)
    }
}
