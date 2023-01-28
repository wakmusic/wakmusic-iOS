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

class ArtistDetailViewController: UIViewController, ViewControllerFromStoryBoard, ContainerViewType {
    
    @IBOutlet weak var gradationImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    private lazy var headerViewController: ArtistDetailHeaderViewController = {
        let header = ArtistDetailHeaderViewController.viewController()
        return header
    }()
    
    private lazy var contentViewController: ArtistMusicViewController = {
        let content = ArtistMusicViewController.viewController()
        return content
    }()

    var disposeBag: DisposeBag = DisposeBag()
    
    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureHeader()
        configureContent()
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
    private func configureUI() {
        gradationImageView.image = DesignSystemAsset.Artist.artistDetailBg.image
        backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
    }
    
    private func configureHeader() {
        self.addChild(headerViewController)
        self.headerContentView.addSubview(headerViewController.view)
        headerViewController.didMove(toParent: self)

        headerViewController.view.snp.makeConstraints {
            $0.edges.equalTo(headerContentView)
        }
    }
    
    private func configureContent() {
        self.add(asChildViewController: contentViewController)
    }
}
