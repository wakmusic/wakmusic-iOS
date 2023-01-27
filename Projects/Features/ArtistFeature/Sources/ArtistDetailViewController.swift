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
import HPParallaxHeader

class ArtistDetailViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var gradationImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var musicContentView: UIView!

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
        
        
    }
    
    private func configureUI() {
        
        gradationImageView.image = DesignSystemAsset.Artist.artistDetailBg.image
        backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)

        //Header
        let header = ArtistDetailHeaderViewController.viewController()
        self.addChild(header)
        self.headerContentView.addSubview(header.view)
        header.didMove(toParent: self)

        header.view.snp.makeConstraints {
            $0.edges.equalTo(headerContentView)
        }

        //Content
        let content = ArtistMusicViewController.viewController()
        self.addChild(content)
        self.musicContentView.addSubview(content.view)
        content.didMove(toParent: self)

        content.view.snp.makeConstraints {
            $0.edges.equalTo(musicContentView)
        }
    }
}
