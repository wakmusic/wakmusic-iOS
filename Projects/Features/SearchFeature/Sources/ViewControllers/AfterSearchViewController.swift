//
//  AfterSearchContentViewController.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import DesignSystem
import NVActivityIndicatorView
import Pageboy
import RxSwift
import SongsDomainInterface
import Tabman
import UIKit
import Utility

public final class AfterSearchViewController: TabmanViewController, ViewControllerFromStoryBoard, SongCartViewType {
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var fakeView: UIView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!

    var viewModel: AfterSearchViewModel!
    var afterSearchContentComponent: AfterSearchContentComponent!
    var containSongsComponent: ContainSongsComponent!
    let disposeBag = DisposeBag()

    private var viewControllers: [UIViewController] = [
        UIViewController(),
        UIViewController(),
        UIViewController(),
        UIViewController()
    ]
    lazy var input = AfterSearchViewModel.Input()
    lazy var output = viewModel.transform(from: input)

    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!
    let playState = PlayState.shared

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollToPage(.at(index: 0), animated: false)
    }

    public static func viewController(
        afterSearchContentComponent: AfterSearchContentComponent,
        containSongsComponent: ContainSongsComponent,
        viewModel: AfterSearchViewModel
    ) -> AfterSearchViewController {
        let viewController = AfterSearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.afterSearchContentComponent = afterSearchContentComponent
        viewController.containSongsComponent = containSongsComponent
        return viewController
    }
    deinit {
        DEBUG_LOG("❌ \(Self.self)")
    }
}

extension AfterSearchViewController {
    private func configureUI() {
        self.fakeView.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.indicator.type = .circleStrokeSpin
        self.indicator.color = DesignSystemAsset.PrimaryColor.point.color
        self.dataSource = self // dateSource
        let bar = TMBar.ButtonBar()

        // 배경색
        bar.backgroundView.style = .flat(color: .clear)

        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .progressive

        // 버튼 글씨 커스텀
        bar.buttons.customize { button in
            button.tintColor = DesignSystemAsset.GrayColor.gray400.color
            button.selectedTintColor = DesignSystemAsset.GrayColor.gray900.color
            button.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
            button.selectedFont = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        }

        // indicator
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = DesignSystemAsset.PrimaryColor.point.color
        bar.indicator.overscrollBehavior = .compress
        addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: nil))
        bar.layer.addBorder(
            [.bottom],
            color: DesignSystemAsset.GrayColor.gray300.color.withAlphaComponent(0.4),
            height: 1
        )
    }

    private func bindRx() {
        output.dataSource
            .skip(1)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else {
                    return
                }
                guard let comp = self.afterSearchContentComponent else {
                    return
                }
                self.viewControllers = [
                    comp.makeView(type: .all, dataSource: result[0]),
                    comp.makeView(type: .song, dataSource: result[1]),
                    comp.makeView(type: .artist, dataSource: result[2]),
                    comp.makeView(type: .remix, dataSource: result[3])
                ]
                self.indicator.stopAnimating()
                self.reloadData()
            })
            .disposed(by: disposeBag)

        output.isFetchStart
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.indicator.startAnimating()
                guard let child = self.viewControllers.first as? AfterSearchContentViewController else {
                    return
                }
                child.tableView.isHidden = true // 검색 시작 시 테이블 뷰 숨김
            })
            .disposed(by: disposeBag)

        output.songEntityOfSelectedSongs
            .skip(1)
            .subscribe(onNext: { [weak self] (songs: [SongEntity]) in
                guard let self = self else { return }
                if !songs.isEmpty {
                    self.showSongCart(
                        in: self.view,
                        type: .searchSong,
                        selectedSongCount: songs.count,
                        totalSongCount: 100,
                        useBottomSpace: false
                    )
                    self.songCartView.delegate = self
                } else {
                    self.hideSongCart()
                }
            })
            .disposed(by: disposeBag)
    }

    func clearSongCart() {
        self.output.songEntityOfSelectedSongs.accept([])
        self.viewControllers.forEach { vc in
            guard let afterContentVc = vc as? AfterSearchContentViewController else {
                return
            }
            afterContentVc.input.deSelectedAllSongs.accept(())
        }
    }
}

extension AfterSearchViewController: PageboyViewControllerDataSource, TMBarDataSource {
    public func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
    }

    public func viewController(
        for pageboyViewController: Pageboy.PageboyViewController,
        at index: Pageboy.PageboyViewController.PageIndex
    ) -> UIViewController? {
        viewControllers[index]
    }

    public func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController
        .Page? {
        nil
    }

    public func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "전체")
        case 1:
            return TMBarItem(title: "노래")
        case 2:
            return TMBarItem(title: "가수")
        case 3:
            return TMBarItem(title: "조교")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
}

extension AfterSearchViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        switch type {
        case .allSelect(_):
            return

        case .addSong:
            let songs: [String] = output.songEntityOfSelectedSongs.value.map { $0.id }
            let viewController = containSongsComponent.makeView(songs: songs)
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true) { [weak self] in
                guard let self = self else { return }
                self.clearSongCart()
            }

        case .addPlayList:
            let songs = output.songEntityOfSelectedSongs.value
            playState.appendSongsToPlaylist(songs)
            self.clearSongCart()

        case .play:
            let songs = output.songEntityOfSelectedSongs.value
            playState.loadAndAppendSongsToPlaylist(songs)
            self.clearSongCart()

        case .remove:
            return
        }
    }
}

extension AfterSearchViewController {
    func scrollToTop() {
        let current: Int = self.currentIndex ?? 0
        let searchContent = self.viewControllers.compactMap { $0 as? AfterSearchContentViewController }
        guard searchContent.count > current else { return }
        searchContent[current].scrollToTop()
    }
}
