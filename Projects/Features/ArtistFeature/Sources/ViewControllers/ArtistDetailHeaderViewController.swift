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
        
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.borderColor = DesignSystemAsset.GrayColor.gray25.color.cgColor
        descriptionView.layer.cornerRadius = 8
        
        descriptionFrontView.isHidden = false
        descriptionBackView.isHidden = true
        
        //ArtistName
        let artistName: String = "고세구"
        let artistEngName: String = "Gosegu"
        
        let artistNameAttributedString = NSMutableAttributedString(string: artistName + " " + artistEngName,
                                                                    attributes: [.font: DesignSystemFontFamily.Pretendard.bold.font(size: 24),
                                                                                 .foregroundColor: DesignSystemAsset.GrayColor.gray900.color])
        let artistEngNameRange = (artistNameAttributedString.string as NSString).range(of: artistEngName)
        artistNameAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
                                                  .foregroundColor: DesignSystemAsset.GrayColor.gray900.color],
                                                  range: artistEngNameRange)
        self.artistNameLabel.attributedText = artistNameAttributedString
        
        self.artistGroupLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        self.artistGroupLabel.textColor = DesignSystemAsset.GrayColor.gray900.color

        self.artistIntroLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        self.artistIntroLabel.textColor = DesignSystemAsset.GrayColor.gray900.color

        self.introTitleLabel.font = DesignSystemFontFamily.Pretendard.bold.font(size: 14)
        self.introTitleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color

        self.introDescriptionLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.introDescriptionLabel.textColor = DesignSystemAsset.GrayColor.gray900.color

        self.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -3)
    }
}
