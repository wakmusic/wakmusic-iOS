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
import DomainModule

public final class ArtistDetailViewController: UIViewController, ViewControllerFromStoryBoard, ContainerViewType {
    
    @IBOutlet weak var gradationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak public var contentView: UIView!
    
    private lazy var headerViewController: ArtistDetailHeaderViewController = {
        let header = ArtistDetailHeaderViewController.viewController()
        return header
    }()
    
    private lazy var contentViewController: ArtistMusicViewController = {
        let content = artistMusicComponent.makeView(model: model)
        return content
    }()

    var model: ArtistListEntity?
    var disposeBag: DisposeBag = DisposeBag()
    
    var artistMusicComponent: ArtistMusicComponent!

    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureHeader()
        configureContent()
    }
    
    public static func viewController(
        model: ArtistListEntity? = nil,
        artistMusicComponent: ArtistMusicComponent
    ) -> ArtistDetailViewController {
        let viewController = ArtistDetailViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        viewController.model = model
        viewController.artistMusicComponent = artistMusicComponent
        return viewController
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ArtistDetailViewController {
    private func configureUI() {
        backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)

        //TO-DO
//        gradationView
        
//        guard let model = self.model else { return }
//
//        let gradient = CAGradientLayer()
//
//        // frame을 잡아주고
//        gradient.frame = gradationView.bounds
//
//        // 섞어줄 색을 colors에 넣어준 뒤
//        gradient.colors = model.color.map { $0.first }.compactMap{ $0 }.map{ colorFromRGB($0, alpha: 0.6).cgColor }
//        
//        gradationView.layer.addSublayer(gradient)
    }
    
    private func configureHeader() {
        self.addChild(headerViewController)
        self.headerContentView.addSubview(headerViewController.view)
        headerViewController.didMove(toParent: self)

        headerViewController.view.snp.makeConstraints {
            $0.edges.equalTo(headerContentView)
        }
        
        guard let model = self.model else { return }
        headerViewController.update(model: model)
    }
    
    private func configureContent() {
        self.add(asChildViewController: contentViewController)
    }
}
