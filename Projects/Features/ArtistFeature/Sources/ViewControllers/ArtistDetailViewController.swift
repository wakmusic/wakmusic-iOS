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
import ArtistDomainInterface

public final class ArtistDetailViewController: UIViewController, ViewControllerFromStoryBoard, ContainerViewType {
    
    @IBOutlet weak var gradationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var headerContentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak public var contentView: UIView!
    
    private lazy var headerViewController: ArtistDetailHeaderViewController = {
        let header = ArtistDetailHeaderViewController.viewController()
        return header
    }()
    
    private lazy var contentViewController: ArtistMusicViewController = {
        let content = artistMusicComponent.makeView(model: model)
        return content
    }()

    var gradientLayer = CAGradientLayer()
    var model: ArtistListEntity?
    var disposeBag: DisposeBag = DisposeBag()
    
    var artistMusicComponent: ArtistMusicComponent!
    
    private var maxHeaderHeight: CGFloat {
        let margin: CGFloat = 8.0 + 20.0
        let width = (140 * APP_WIDTH()) / 375.0
        let height = (180 * width) / 140.0
        return -(margin + height)
    }
    private let minHeaderHeight: CGFloat = 0
    private var previousScrollOffset: [CGFloat] = [0, 0, 0]

    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureHeader()
        configureContent()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientLayer.frame = self.gradationView.bounds
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
                
        let startAlpha: CGFloat = 0.6
        let value: CGFloat = 0.1
        let colors = Array(0...Int(startAlpha*10)).enumerated().map { (i, _) in
            return colorFromRGB(flatColor, alpha: startAlpha - (CGFloat(i) * value)).cgColor
        }
        
        gradientLayer.colors = colors
        gradationView.layer.addSublayer(gradientLayer)
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

extension ArtistDetailViewController {
    func scrollViewDidScrollFromChild(scrollView: UIScrollView, i: Int) {
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset[i]
        let absoluteTop: CGFloat = 0
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if scrollView.contentOffset.y < absoluteBottom {
            var newHeight = self.headerContentViewTopConstraint.constant
            
            if isScrollingDown {
                newHeight = max(self.maxHeaderHeight, self.headerContentViewTopConstraint.constant - abs(scrollDiff))
            }else if isScrollingUp {
                if scrollView.contentOffset.y <= abs(self.maxHeaderHeight) {
                    newHeight = min(self.minHeaderHeight, self.headerContentViewTopConstraint.constant + abs(scrollDiff))
                }
            }
            
            if newHeight != self.headerContentViewTopConstraint.constant {
                self.headerContentViewTopConstraint.constant = newHeight
                self.updateHeader()
            }
            self.view.layoutIfNeeded()
            self.previousScrollOffset[i] = scrollView.contentOffset.y
        }
    }
    
    private func updateHeader() {
        let openAmount = self.headerContentViewTopConstraint.constant + abs(self.maxHeaderHeight)
        let percentage = openAmount / abs(self.maxHeaderHeight)
        self.headerContentView.alpha = percentage
    }
}
