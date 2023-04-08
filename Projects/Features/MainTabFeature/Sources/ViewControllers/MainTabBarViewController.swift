//
//  MainTabBarViewController.swift
//  MainTabFeature
//
//  Created by KTH on 2023/01/13.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import SnapKit
import BaseFeature
import HomeFeature
import SearchFeature
import ArtistFeature
import ChartFeature
import StorageFeature
import CommonFeature
import RxSwift
import RxCocoa

public final class MainTabBarViewController: BaseViewController, ViewControllerFromStoryBoard, ContainerViewType {

    @IBOutlet weak public var contentView: UIView!

    private lazy var viewControllers: [UIViewController] = {
        return [
            homeComponent.makeView().wrapNavigationController,
            chartComponent.makeView().wrapNavigationController,
            searchComponent.makeView().wrapNavigationController,
            artistComponent.makeView().wrapNavigationController,
            storageComponent.makeView().wrapNavigationController
        ]
    }()

    var viewModel: MainTabBarViewModel!
    private var previousIndex: Int?
    private var selectedIndex: Int = Utility.PreferenceManager.startPage ?? 0
    private var disposeBag: DisposeBag = DisposeBag()
    
    private var homeComponent: HomeComponent!
    private var chartComponent: ChartComponent!
    private var searchComponent: SearchComponent!
    private var artistComponent: ArtistComponent!
    private var storageComponent: StorageComponent!
    private var noticePopupComponent: NoticePopupComponent!

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    public static func viewController(
        viewModel: MainTabBarViewModel,
        homeComponent: HomeComponent,
        chartComponent: ChartComponent,
        searchComponent: SearchComponent,
        artistComponent: ArtistComponent,
        storageCompoent: StorageComponent,
        noticePopupComponent: NoticePopupComponent
    ) -> MainTabBarViewController {
        let viewController = MainTabBarViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.homeComponent = homeComponent
        viewController.chartComponent = chartComponent
        viewController.searchComponent = searchComponent
        viewController.artistComponent = artistComponent
        viewController.storageComponent = storageCompoent
        viewController.noticePopupComponent = noticePopupComponent
        return viewController
    }
}

extension MainTabBarViewController {
    private func bind() {
        viewModel.output
            .dataSource
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .subscribe(onNext: { (owner, model) in
                let viewController = owner.noticePopupComponent.makeView(model: model)
            }).disposed(by: disposeBag)

    }
    
    private func configureUI() {
        let startPage: Int = Utility.PreferenceManager.startPage ?? 0
        add(asChildViewController: viewControllers[startPage])
    }
    
    func updateContent(previous: Int, current: Int) {
        
        Utility.PreferenceManager.startPage = current
        
        remove(asChildViewController: viewControllers[previous])
        add(asChildViewController: viewControllers[current])
        
        self.previousIndex = previous
        self.selectedIndex = current
    }
    
    func forceUpdateContent(for index: Int) {
        
        Utility.PreferenceManager.startPage = index

        if let previous = self.previousIndex{
            remove(asChildViewController: viewControllers[previous])
        }
        add(asChildViewController: viewControllers[index])
        
        self.previousIndex = self.selectedIndex
        self.selectedIndex = index
    }
}

extension MainTabBarViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
