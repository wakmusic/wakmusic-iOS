import DesignSystem
import RxCocoa
import RxSwift
import Then
import UIKit
import Utility

@MainActor
private protocol MusicToolbarStateProtocol {
    func updateViews(views: Int)
    func updateIsLike(likes: Int, isLike: Bool)
}

private protocol MusicToolbarActionProtocol {
    var likeButtonDidTap: Observable<Void> { get }
    var musicPickButtonDidTap: Observable<Void> { get }
    var playlistButtonDidTap: Observable<Void> { get }
}

final class MusicToolbarView: UIStackView {
    fileprivate let heartButton = MusicHeartButton()
    private let viewsButton = VerticalAlignButton(
        title: "0",
        image: DesignSystemAsset.MusicDetail.views.image
    ).then {
        $0.isEnabled = false
    }

    fileprivate let musicPickButton = VerticalAlignButton(
        title: "노래담기",
        image: DesignSystemAsset.MusicDetail.musicPick.image
    )
    fileprivate let playlistButton = VerticalAlignButton(
        title: "재생목록",
        image: DesignSystemAsset.MusicDetail.playlist.image
    )

    init() {
        super.init(frame: .zero)
        self.addArrangedSubviews(heartButton, viewsButton, musicPickButton, playlistButton)
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.alignment = .top
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = .init(top: 4, left: 0, bottom: 0, right: 0)
        self.backgroundColor = DesignSystemAsset.NewGrayColor.gray900.color
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let lineBorder = CALayer()
        lineBorder.backgroundColor = DesignSystemAsset.NewGrayColor.gray700.color.cgColor
        lineBorder.frame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        self.layer.addSublayer(lineBorder)
    }
}

extension MusicToolbarView: MusicToolbarStateProtocol {
    func updateViews(views: Int) {
        viewsButton.setTitle("\(views.toUnitNumber)", for: .normal)
    }

    func updateIsLike(likes: Int, isLike: Bool) {
        heartButton.setTitle("\(likes.toUnitNumber)", for: .normal)
        heartButton.setIsLike(isLike: isLike, animated: false)
    }
}

extension Reactive: @preconcurrency MusicToolbarActionProtocol where Base: MusicToolbarView {
    var likeButtonDidTap: Observable<Void> {
        base.heartButton.rx.tap.asObservable()
    }

    var musicPickButtonDidTap: Observable<Void> {
        base.musicPickButton.rx.tap.asObservable()
    }

    var playlistButtonDidTap: Observable<Void> {
        base.playlistButton.rx.tap.asObservable()
    }
}
