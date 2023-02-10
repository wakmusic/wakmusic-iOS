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

        guard let model = self.model else { return }

        let flatColor: String = model.color.first?.first ?? ""
        
        guard !flatColor.isEmpty else { return }
        
        let layer = CAGradientLayer()
        layer.frame = gradationView.bounds
        
        let startAlpha: CGFloat = 0.6
        let value: CGFloat = 0.1
        let colors = Array(0...6).enumerated().map { (i, _) in
            return colorFromRGB(flatColor, alpha: startAlpha - (CGFloat(i) * value)).cgColor
        }
        
        layer.colors = colors
        gradationView.layer.addSublayer(layer)
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
