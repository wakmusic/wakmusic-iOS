//
//  ArtistDetailHeaderViewController.swift
//  ArtistFeature
//
//  Created by KTH on 2023/01/21.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import ArtistDomainInterface
import DesignSystem
import RxCocoa
import RxSwift
import UIKit
import Utility

class ArtistDetailHeaderViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var descriptionView: UIView!

    /// Description Front
    @IBOutlet weak var descriptionFrontView: UIView!
    @IBOutlet weak var descriptionFrontButton: UIButton!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistNameLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var artistGroupLabel: UILabel!
    @IBOutlet weak var artistIntroLabel: UILabel!
    @IBOutlet weak var artistIntroLabelBottomConstraint: NSLayoutConstraint!

    /// Description Back
    @IBOutlet weak var descriptionBackView: UIView!
    @IBOutlet weak var descriptionBackButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var introTitleLabel: UILabel!
    @IBOutlet weak var introDescriptionLabel: UILabel!

    var disposeBag: DisposeBag = DisposeBag()

    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }

    public static func viewController() -> ArtistDetailHeaderViewController {
        let viewController = ArtistDetailHeaderViewController.viewController(
            storyBoardName: "Artist",
            bundle: Bundle.module
        )
        return viewController
    }
}

extension ArtistDetailHeaderViewController {
    func update(model: ArtistListEntity) {
        let artistName: String = model.name
        let artistEngName: String = model.artistId.capitalizingFirstLetter
        let artistNameAttributedString = NSMutableAttributedString(
            string: artistName + " " + artistEngName,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.bold.font(size: 24),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5
            ]
        )

        let artistNameRange = (artistNameAttributedString.string as NSString).range(of: artistName)
        let artistEngNameRange = (artistNameAttributedString.string as NSString).range(of: artistEngName)

        artistNameAttributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color.withAlphaComponent(0.6),
                .kern: -0.5
            ],
            range: artistEngNameRange
        )

        let margin: CGFloat = 104.0
        let availableWidth: CGFloat = APP_WIDTH() - (((140 * APP_WIDTH()) / 375.0) + margin)
        let artistNameWidth: CGFloat = artistNameAttributedString.width(containerHeight: 36)

        DEBUG_LOG("availableWidth: \(availableWidth)")
        DEBUG_LOG("\(model.name): \(artistNameWidth)")

        artistNameAttributedString.addAttributes(
            [.font: DesignSystemFontFamily.Pretendard.bold.font(size: availableWidth >= artistNameWidth ? 24 : 20)],
            range: artistNameRange
        )

        self.artistNameLabelHeight.constant =
        (availableWidth >= artistNameWidth) ? 36 :
        ceil(artistNameAttributedString.height(containerWidth: availableWidth))

        self.artistNameLabel.attributedText = artistNameAttributedString

        self.artistGroupLabel.text = model.group + (model.graduated ? " · 졸업" : "")

        let artistIntroParagraphStyle = NSMutableParagraphStyle()
        artistIntroParagraphStyle.lineHeightMultiple = (APP_WIDTH() < 375) ? 0 : 1.44

        let artistIntroAttributedString = NSMutableAttributedString(
            string: model.title,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .paragraphStyle: artistIntroParagraphStyle,
                .kern: -0.5
            ]
        )
        self.artistIntroLabel.lineBreakMode = .byCharWrapping
        self.artistIntroLabel.attributedText = artistIntroAttributedString
        self.artistIntroLabelBottomConstraint.constant = (APP_WIDTH() < 375) ? 0 : 16

        self.introTitleLabel.text = "소개글"
        let artistIntroDescriptionParagraphStyle = NSMutableParagraphStyle()
        artistIntroDescriptionParagraphStyle.lineHeightMultiple = 1.26

        let artistIntroDescriptionAttributedString = NSMutableAttributedString(
            string: model.description,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.light.font(size: 12),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .paragraphStyle: artistIntroDescriptionParagraphStyle,
                .kern: -0.5
            ]
        )
        self.introDescriptionLabel.attributedText = artistIntroDescriptionAttributedString

        let originImageURLString: String = WMImageAPI.fetchArtistWithSquare(
            id: model.artistId,
            version: model.imageSquareVersion
        ).toString
        let encodedImageURLString: String = originImageURLString
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? originImageURLString
        artistImageView.kf.setImage(
            with: URL(string: encodedImageURLString),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
        self.view.layoutIfNeeded()
    }
}

private extension ArtistDetailHeaderViewController {
    func bind() {
        let mergeObservable = Observable.merge(
            descriptionFrontButton.rx.tap.map { _ in () },
            descriptionBackButton.rx.tap.map { _ in () }
        )

        mergeObservable
            .bind(with: self) { owner, _ in
                owner.flipArtistIntro()
            }
            .disposed(by: disposeBag)
    }

    func flipArtistIntro() {
        descriptionFrontView.isHidden = descriptionFrontView.isHidden ? false : true
        descriptionBackView.isHidden = !descriptionFrontView.isHidden

        UIView.transition(
            with: descriptionView,
            duration: 0.3,
            options: descriptionFrontView.isHidden ? .transitionFlipFromRight : .transitionFlipFromLeft,
            animations: nil,
            completion: { _ in
            }
        )
    }

    func configureUI() {
        descriptionFrontButton.setImage(DesignSystemAsset.Artist.documentOff.image, for: .normal)
        descriptionBackButton.setImage(DesignSystemAsset.Artist.documentOn.image, for: .normal)

        descriptionView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.borderColor = DesignSystemAsset.GrayColor.gray25.color.cgColor
        descriptionView.layer.cornerRadius = 8

        descriptionFrontView.isHidden = false
        descriptionBackView.isHidden = true

        artistGroupLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        artistGroupLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        artistGroupLabel.setTextWithAttributes(kernValue: -0.5)

        artistIntroLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        artistIntroLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        artistIntroLabel.textAlignment = .left

        introTitleLabel.font = DesignSystemFontFamily.Pretendard.bold.font(size: 14)
        introTitleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        introTitleLabel.setTextWithAttributes(kernValue: -0.5)

        introDescriptionLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        introDescriptionLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        introDescriptionLabel.textAlignment = .left
        introDescriptionLabel.lineBreakMode = .byWordWrapping
        introDescriptionLabel.setTextWithAttributes(kernValue: -0.5)

        scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -3)
    }
}
