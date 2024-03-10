//
//  MainTabBarViewController.swift
//  MainTabFeature
//
//  Created by KTH on 2023/01/13.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import ArtistFeature
import BaseFeature
import ChartFeature
import CommonFeature
import DesignSystem
import NoticeDomainInterface
import HomeFeature
import RxCocoa
import RxSwift
import SearchFeature
import SnapKit
import StorageFeature
import UIKit
import Utility

public final class MainTabBarViewController: BaseViewController, ViewControllerFromStoryBoard, ContainerViewType {
    @IBOutlet public weak var contentView: UIView!

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
    private var noticeComponent: NoticeComponent!
    private var noticeDetailComponent: NoticeDetailComponent!

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override public func viewDidDisappear(_ animated: Bool) {
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
        noticePopupComponent: NoticePopupComponent,
        noticeComponent: NoticeComponent,
        noticeDetailComponent: NoticeDetailComponent
    ) -> MainTabBarViewController {
        let viewController = MainTabBarViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.homeComponent = homeComponent
        viewController.chartComponent = chartComponent
        viewController.searchComponent = searchComponent
        viewController.artistComponent = artistComponent
        viewController.storageComponent = storageCompoent
        viewController.noticePopupComponent = noticePopupComponent
        viewController.noticeComponent = noticeComponent
        viewController.noticeDetailComponent = noticeDetailComponent
        return viewController
    }
}

extension MainTabBarViewController {
    private func bind() {
        viewModel.output
            .dataSource
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .subscribe(onNext: { owner, model in
                let viewController = owner.noticePopupComponent.makeView(model: model)
                viewController.delegate = owner
                owner.showPanModal(content: viewController)
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

        if let previous = self.previousIndex {
            remove(asChildViewController: viewControllers[previous])
        }
        add(asChildViewController: viewControllers[index])

        self.previousIndex = self.selectedIndex
        self.selectedIndex = index
    }

    func equalHandleTapped(for index: Int) {
        guard let navigationController = self.viewControllers[index] as? UINavigationController else { return }
        if let home = navigationController.viewControllers.first as? HomeViewController {
            home.equalHandleTapped()
        } else if let chart = navigationController.viewControllers.first as? ChartViewController {
            chart.equalHandleTapped()
        } else if let search = navigationController.viewControllers.first as? SearchViewController {
            search.equalHandleTapped()
        } else if let artist = navigationController.viewControllers.first as? ArtistViewController {
            artist.equalHandleTapped()
        } else if let storage = navigationController.viewControllers.first as? StorageViewController {
            storage.equalHandleTapped()
        }
    }
}

extension MainTabBarViewController: NoticePopupViewControllerDelegate {
    public func noticeTapped(model: FetchNoticeEntity) {
        let viewController = noticeDetailComponent.makeView(model: model)
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
}

extension MainTabBarViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
