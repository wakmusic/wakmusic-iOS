import ArtistDomainInterface
import DesignSystem
import LogManager
import RxCocoa
import RxSwift
import UIKit
import Utility

class ArtistDetailHeaderViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var flipButton: UIButton!

    /// Description Front
    @IBOutlet weak var descriptionFrontView: UIView!
    @IBOutlet weak var descriptionFrontButton: UIButton!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistNameLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var artistGroupLabel: UILabel!
    @IBOutlet weak var artistIntroLabel: UILabel!

    /// Description Back
    @IBOutlet weak var descriptionBackView: UIView!
    @IBOutlet weak var descriptionBackButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var introTitleLabel: UILabel!
    @IBOutlet weak var introDescriptionLabel: UILabel!

    var disposeBag: DisposeBag = DisposeBag()
    private var model: ArtistEntity?

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
    func update(model: ArtistEntity) {
        self.model = model
        let artistKrName: String = model.krName
        let artistEnName: String = model.enName
        let artistNameAttributedString = NSMutableAttributedString(
            string: artistKrName + " " + artistEnName,
            attributes: [
                .font: UIFont.WMFontSystem.t1(weight: .bold).font,
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                .kern: -0.5
            ]
        )

        let artistKrNameRange = (artistNameAttributedString.string as NSString).range(of: artistKrName)
        let artistEnNameRange = (artistNameAttributedString.string as NSString).range(of: artistEnName)

        artistNameAttributedString.addAttributes(
            [
                .font: UIFont.WMFontSystem.t6(weight: .light).font,
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color.withAlphaComponent(0.6),
                .kern: -0.5
            ],
            range: artistEnNameRange
        )

        let margin: CGFloat = 104.0
        let availableWidth: CGFloat = APP_WIDTH() - (((140 * APP_WIDTH()) / 375.0) + margin)
        let artistNameWidth: CGFloat = artistNameAttributedString.width(containerHeight: 36)

        DEBUG_LOG("availableWidth: \(availableWidth)")
        DEBUG_LOG("\(model.krName): \(artistNameWidth)")

        if availableWidth >= artistNameWidth {
            artistNameAttributedString.addAttributes(
                [.font: UIFont.WMFontSystem.t1(weight: .bold).font],
                range: artistKrNameRange
            )
        } else {
            if model.krName.count >= 9 { // ex: 김치만두번영택사스가, 캘리칼리 데이비슨
                artistNameAttributedString.addAttributes(
                    [.font: UIFont.WMFontSystem.t4(weight: .bold).font],
                    range: artistKrNameRange
                )
            } else {
                artistNameAttributedString.addAttributes(
                    [.font: UIFont.WMFontSystem.t3(weight: .bold).font],
                    range: artistKrNameRange
                )
            }
        }

        artistNameLabelHeight.constant = (availableWidth >= artistNameWidth) ?
            36 : ceil(artistNameAttributedString.height(containerWidth: availableWidth))
        artistNameLabel.attributedText = artistNameAttributedString

        artistGroupLabel.text = (model.id == "woowakgood") ?
            "" : model.groupName + (model.graduated ? " · 졸업" : "")
        artistGroupLabel.setTextWithAttributes(
            lineHeight: UIFont.WMFontSystem.t6(weight: .medium).lineHeight,
            lineBreakMode: .byCharWrapping
        )

        artistIntroLabel.text = model.title
        artistIntroLabel.setTextWithAttributes(
            lineHeight: UIFont.WMFontSystem.t6(weight: .medium).lineHeight,
            lineBreakMode: .byWordWrapping,
            hangulWordPriority: true
        )

        introDescriptionLabel.text = model.description
        introDescriptionLabel.setTextWithAttributes(
            lineHeight: UIFont.WMFontSystem.t7(weight: .light).lineHeight,
            lineBreakMode: .byCharWrapping
        )

        let encodedImageURLString: String = model.squareImage
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? model.squareImage

        artistImageView.kf.setImage(
            with: URL(string: encodedImageURLString),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
    }
}

private extension ArtistDetailHeaderViewController {
    func bind() {
        let mergeObservable = Observable.merge(
            descriptionFrontButton.rx.tap.map { _ in () },
            descriptionBackButton.rx.tap.map { _ in () },
            flipButton.rx.tap.map { _ in () }
        )

        mergeObservable
            .bind(with: self) { owner, _ in
                LogManager.analytics(
                    ArtistAnalyticsLog.clickArtistDescriptionButton(artist: owner.model?.id ?? "")
                )
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
        descriptionView.layer.borderColor = DesignSystemAsset.BlueGrayColor.gray25.color.cgColor
        descriptionView.layer.cornerRadius = 8

        descriptionFrontView.isHidden = false
        descriptionBackView.isHidden = true

        artistGroupLabel.font = UIFont.WMFontSystem.t6(weight: .medium).font
        artistGroupLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        artistGroupLabel.numberOfLines = 1

        artistIntroLabel.font = UIFont.WMFontSystem.t6(weight: .medium).font
        artistIntroLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        artistIntroLabel.numberOfLines = 0

        introTitleLabel.text = "소개글"
        introTitleLabel.font = UIFont.WMFontSystem.t6(weight: .bold).font
        introTitleLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        introTitleLabel.setTextWithAttributes(kernValue: -0.5)

        introDescriptionLabel.font = UIFont.WMFontSystem.t7(weight: .light).font
        introDescriptionLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        introDescriptionLabel.numberOfLines = 0

        scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -3)
    }
}
