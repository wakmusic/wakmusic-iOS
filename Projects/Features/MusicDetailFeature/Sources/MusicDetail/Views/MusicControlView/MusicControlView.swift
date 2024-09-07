import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

private protocol MusicControlStateProtool {
    func updateTitle(title: String)
    func updateArtist(artist: String)
    func updateIsDisabledSingingRoom(isDisabled: Bool)
    func updateIsDisabledPrevButton(isDisabled: Bool)
    func updateIsDisabledNextButton(isDisabled: Bool)
}

private protocol MusicControlActionProtocol {
    var prevMusicButtonDidTap: Observable<Void> { get }
    var playMusicButtonDidTap: Observable<Void> { get }
    var nextMusicButtonDidTap: Observable<Void> { get }
    var singingRoomButtonDidTap: Observable<Void> { get }
    var lyricsButtonDidTap: Observable<Void> { get }
}

final class MusicControlView: UIView {
    private let titleLabel: WMFlowLabel = WMFlowLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.gray25.color,
        font: .t4(weight: .medium)
    )
    private let artistLabel: WMFlowLabel = WMFlowLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.gray100.color.withAlphaComponent(0.6),
        font: .t5(weight: .medium)
    )
    private let titleStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 8
    }

    fileprivate let prevMusicButton = UIButton().then {
        $0.setImage(DesignSystemAsset.MusicDetail.prev.image, for: .normal)
    }

    fileprivate let playMusicButton = UIButton().then {
        let playImage = DesignSystemAsset.MusicDetail.play.image
            .withTintColor(
                DesignSystemAsset.PrimaryColorV2.point.color,
                renderingMode: .alwaysOriginal
            )
        $0.setImage(playImage, for: .normal)
    }

    fileprivate let nextMusicButton = UIButton().then {
        $0.setImage(DesignSystemAsset.MusicDetail.next.image, for: .normal)
    }

    private let playStackView: UIStackView = UIStackView().then {
        $0.distribution = .equalCentering
        $0.axis = .horizontal
    }

    fileprivate let singingRoomButton = UIButton().then {
        $0.setImage(
            DesignSystemAsset.MusicDetail.singingRoom.image
                .withTintColor(DesignSystemAsset.NewGrayColor.gray600.color, renderingMode: .alwaysOriginal),
            for: .normal
        )
        $0.isEnabled = false
    }

    fileprivate let lyricsRoomButton = UIButton().then {
        $0.setImage(DesignSystemAsset.MusicDetail.lyrics.image, for: .normal)
    }

    private let musicInfoStackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
    }

    private var musicControlPanelGradientLayer: MusicControlGradientPanelLayer?
    private var playButtonGradientLayer: PlayMusicButtonGradientLayer?

    init() {
        super.init(frame: .zero)
        addView()
        setLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if musicControlPanelGradientLayer == nil {
            let musicControlPanelGradientLayer = MusicControlGradientPanelLayer(frame: self.bounds)
            self.musicControlPanelGradientLayer = musicControlPanelGradientLayer
            self.layer.addSublayer(musicControlPanelGradientLayer)
        }

        if playButtonGradientLayer == nil {
            playMusicButton.layoutIfNeeded()
            let playButtonGradientLayer = PlayMusicButtonGradientLayer(
                frame: playMusicButton.bounds,
                cornerRadius: playMusicButton.frame.height / 2
            )
            self.playButtonGradientLayer = playButtonGradientLayer
            playMusicButton.layer.addSublayer(playButtonGradientLayer)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MusicControlView {
    func addView() {
        titleStackView.addArrangedSubviews(titleLabel, artistLabel)

        playStackView.addArrangedSubviews(prevMusicButton, playMusicButton, nextMusicButton)

        musicInfoStackView.addArrangedSubviews(singingRoomButton, lyricsRoomButton)

        self.addSubviews(titleStackView, playStackView, musicInfoStackView)
    }

    func setLayout() {
        titleStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        playStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        playMusicButton.snp.makeConstraints {
            $0.size.equalTo(88)
        }

        musicInfoStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(36)
            $0.width.equalToSuperview().multipliedBy(3.0 / 5.0)
        }
    }
}

extension MusicControlView: MusicControlStateProtool {
    func updateTitle(title: String) {
        titleLabel.text = title
    }

    func updateArtist(artist: String) {
        artistLabel.text = artist
    }

    func updateIsDisabledSingingRoom(isDisabled: Bool) {
        let tintColor = isDisabled
            ? DesignSystemAsset.NewGrayColor.gray600.color
            : DesignSystemAsset.NewGrayColor.gray400.color

        let singingRoomImage = DesignSystemAsset.MusicDetail.singingRoom.image
            .withTintColor(tintColor, renderingMode: .alwaysOriginal)

        singingRoomButton.setImage(singingRoomImage, for: .normal)
        singingRoomButton.isEnabled = !isDisabled
    }

    func updateIsDisabledPrevButton(isDisabled: Bool) {
        let tintColor = isDisabled
            ? DesignSystemAsset.NewGrayColor.gray600.color
            : DesignSystemAsset.NewGrayColor.gray400.color

        let prevButtonImage = DesignSystemAsset.MusicDetail.prev.image
            .withTintColor(tintColor, renderingMode: .alwaysOriginal)

        prevMusicButton.setImage(prevButtonImage, for: .normal)
        prevMusicButton.isEnabled = !isDisabled
    }

    func updateIsDisabledNextButton(isDisabled: Bool) {
        let tintColor = isDisabled
            ? DesignSystemAsset.NewGrayColor.gray600.color
            : DesignSystemAsset.NewGrayColor.gray400.color

        let nextButtonImage = DesignSystemAsset.MusicDetail.next.image
            .withTintColor(tintColor, renderingMode: .alwaysOriginal)

        nextMusicButton.setImage(nextButtonImage, for: .normal)
        nextMusicButton.isEnabled = !isDisabled
    }
}

extension Reactive: MusicControlActionProtocol where Base: MusicControlView {
    var prevMusicButtonDidTap: Observable<Void> {
        base.prevMusicButton.rx.tap.asObservable()
    }

    var playMusicButtonDidTap: Observable<Void> {
        base.playMusicButton.rx.tap.asObservable()
    }

    var nextMusicButtonDidTap: Observable<Void> {
        base.nextMusicButton.rx.tap.asObservable()
    }

    var singingRoomButtonDidTap: Observable<Void> {
        base.singingRoomButton.rx.tap.asObservable()
    }

    var lyricsButtonDidTap: Observable<Void> {
        base.lyricsRoomButton.rx.tap.asObservable()
    }
}
