//
//  ArtistDetailHeaderViewController.swift
//  ArtistFeature
//
//  Created by KTH on 2023/01/21.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import RxSwift
import RxCocoa
import DomainModule

class ArtistDetailHeaderViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var descriptionView: UIView!

    //Description Front
    @IBOutlet weak var descriptionFrontView: UIView!
    @IBOutlet weak var descriptionFrontButton: UIButton!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistGroupLabel: UILabel!
    @IBOutlet weak var artistIntroLabel: UILabel!
    
    //Description Back
    @IBOutlet weak var descriptionBackView: UIView!
    @IBOutlet weak var descriptionBackButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var introTitleLabel: UILabel!
    @IBOutlet weak var introDescriptionLabel: UILabel!
    
    var disposeBag: DisposeBag = DisposeBag()
    var isBack: Bool = false

    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bind()
    }

    public static func viewController() -> ArtistDetailHeaderViewController {
        let viewController = ArtistDetailHeaderViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        return viewController
    }
}

extension ArtistDetailHeaderViewController {
    
    func update(model: ArtistListEntity) {
        
        let artistName: String = model.name
        let artistEngName: String = model.ID.capitalizingFirstLetter
        
        var artistNameAttributedString = NSMutableAttributedString(
            string: artistName + " " + artistEngName,
            attributes: [.font: DesignSystemFontFamily.Pretendard.bold.font(size: 24),
                         .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                         .kern: -0.5]
        )
        let artistNameRange = (artistNameAttributedString.string as NSString).range(of: artistName)

        let artistEngNameRange = (artistNameAttributedString.string as NSString).range(of: artistEngName)
        
        artistNameAttributedString.addAttributes(
            [.font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
            .foregroundColor: DesignSystemAsset.GrayColor.gray900.color.withAlphaComponent(0.6),
            .kern: -0.5],
            range: artistEngNameRange
        )
        
        let availableWidth: CGFloat = APP_WIDTH() - (((140 * APP_WIDTH()) / 375.0) + 109.0)
        let prepareWidth: CGFloat = artistNameAttributedString.width(containerHeight: 36)
        
        artistNameAttributedString.addAttributes(
            [.font: DesignSystemFontFamily.Pretendard.bold.font(size: availableWidth >= prepareWidth ? 24 : 20)],
            range: artistNameRange
        )

        self.artistNameLabel.attributedText = artistNameAttributedString
        
        self.artistGroupLabel.text = model.group
        self.artistIntroLabel.text = model.title
        self.artistIntroLabel.lineBreakMode = .byCharWrapping
        
        self.introTitleLabel.text = "소개글"
        self.introDescriptionLabel.text = model.description
        
        artistImageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchArtistWithSquare(id: model.ID, version: model.imageSquareVersion).toString),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
    }
    
    private func bind() {
        
        let mergeObservable = Observable.merge(descriptionFrontButton.rx.tap.map { _ in () },
                                               descriptionBackButton.rx.tap.map { _ in () })

        mergeObservable
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.flip()
            }).disposed(by: disposeBag)

    }
    
    private func flip() {
        
        if self.isBack {
            self.isBack = false
            self.descriptionFrontView.isHidden = self.isBack
            self.descriptionBackView.isHidden = !self.descriptionFrontView.isHidden
            
            UIView.transition(with: self.descriptionView,
                              duration: 0.3,
                              options: .transitionFlipFromLeft,
                              animations: nil,
                              completion: { _ in
            })

        }else{
            self.isBack = true
            self.descriptionFrontView.isHidden = self.isBack
            self.descriptionBackView.isHidden = !self.descriptionFrontView.isHidden

            UIView.transition(with: self.descriptionView,
                              duration: 0.3,
                              options: .transitionFlipFromRight,
                              animations: nil,
                              completion: { _ in
            })
        }
    }
    
    private func configureUI() {
        
        artistImageView.image = DesignSystemAsset.Artist.guseguDetail.image
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

        artistIntroLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        artistIntroLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        artistIntroLabel.textAlignment = .left
        
        introTitleLabel.font = DesignSystemFontFamily.Pretendard.bold.font(size: 14)
        introTitleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        introDescriptionLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        introDescriptionLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        introDescriptionLabel.textAlignment = .left

        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -3)
    }
}
