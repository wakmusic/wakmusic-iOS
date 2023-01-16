//
//  ArtistDetailViewController.swift
//  ArtistFeature
//
//  Created by KTH on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import RxSwift
import RxCocoa

class ArtistDetailViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var gradationImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var musicContentView: UIView!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionFrontView: UIView!
    @IBOutlet weak var descriptionBackView: UIView!
    @IBOutlet weak var descriptionFrontButton: UIButton!
    @IBOutlet weak var descriptionBackButton: UIButton!
    
    //Label
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var isBack: Bool = false
    var disposeBag: DisposeBag = DisposeBag()
    
    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind()
    }
    
    public static func viewController() -> ArtistDetailViewController {
        let viewController = ArtistDetailViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        return viewController
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ArtistDetailViewController {
    
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
        
        gradationImageView.image = DesignSystemAsset.Artist.artistDetailBg.image
        backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        artistImageView.image = DesignSystemAsset.Artist.guseguDetail.image
        
        descriptionFrontButton.setImage(DesignSystemAsset.Artist.documentOff.image, for: .normal)
        descriptionBackButton.setImage(DesignSystemAsset.Artist.documentOn.image, for: .normal)
        
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.borderColor = colorFromRGB(0xFCFCFD).cgColor
        descriptionView.layer.cornerRadius = 8
        
        descriptionFrontView.isHidden = false
        descriptionBackView.isHidden = true
        
        //ArtistName
        let artistName: String = "고세구"
        let artistEngName: String = "Gosegu"
        
        let artistNameAttributedString = NSMutableAttributedString(string: artistName + " " + artistEngName,
                                                                    attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold),
                                                                                 .foregroundColor: colorFromRGB(0x101828)])
        
        let artistEngNameRange = (artistNameAttributedString.string as NSString).range(of: artistEngName)

        artistNameAttributedString.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .light),
                                                  .foregroundColor: colorFromRGB(0x101828)],
                                                  range: artistEngNameRange)

        self.artistNameLabel.attributedText = artistNameAttributedString
        
        let viewController = ArtistMusicViewController.viewController()
        self.addChild(viewController)
        self.musicContentView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        viewController.view.snp.makeConstraints {
            $0.edges.equalTo(musicContentView)
        }
        
        self.view.layoutIfNeeded()
    }
}
