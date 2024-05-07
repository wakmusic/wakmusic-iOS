import BaseFeature
import BaseFeatureInterface
import DesignSystem
import NVActivityIndicatorView
import Pageboy
import RxSwift
import SongsDomainInterface
import Tabman
import UIKit
import Utility
import ReactorKit


public final class AfterSearchViewController: TabmanViewController, ViewControllerFromStoryBoard, StoryboardView, SongCartViewType {
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var fakeView: UIView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!

    var afterSearchContentComponent: AfterSearchContentComponent!
    var containSongsFactory: ContainSongsFactory!
    public var disposeBag = DisposeBag()

    

    private var viewControllers: [UIViewController] = [
        UIViewController(),
        UIViewController(),
        UIViewController(),
        UIViewController()
    ]

    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!
    let playState = PlayState.shared

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollToPage(.at(index: 0), animated: false)
        self.indicator.startAnimating()
    }

    public static func viewController(
        afterSearchContentComponent: AfterSearchContentComponent,
        containSongsFactory: ContainSongsFactory,
        reactor: AfterSearchReactor
    ) -> AfterSearchViewController {
        let viewController = AfterSearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        viewController.afterSearchContentComponent = afterSearchContentComponent
        viewController.containSongsFactory = containSongsFactory
        viewController.reactor = reactor
        return viewController
    }

    deinit {
        DEBUG_LOG("❌ \(Self.self)")
    }
    
    public func bind(reactor: AfterSearchReactor) {
        bindState(reacotr: reactor)
        bindAction(reactor: reactor)
        
    }
}

extension AfterSearchViewController {
        
    func bindState(reacotr: AfterSearchReactor) {
        
        let currentState = reacotr.state.share(replay:2)
        
        //TODO: Content쪽 tableView처리
        currentState.map(\.dataSource)
            .withUnretained(self)
            .bind(onNext: { (owner,dataSource) in
                
                guard let comp = owner.afterSearchContentComponent else {
                    return
                }
                
                if dataSource.isEmpty {
                    return
                }
                
                
                owner.viewControllers = [
                    comp.makeView(type: .all, dataSource: dataSource[0]),
                    comp.makeView(type: .song, dataSource: dataSource[1]),
                    comp.makeView(type: .artist, dataSource: dataSource[2]),
                    comp.makeView(type: .remix, dataSource: dataSource[3])
                ]
                owner.indicator.stopAnimating()
                owner.reloadData()
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindAction(reactor: AfterSearchReactor) {
        
        
        
    }
    
    
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

//    private func bindRx() {
//
//        output.isFetchStart
//            .subscribe(onNext: { [weak self] _ in
//                guard let self = self else {
//                    return
//                }
//                self.indicator.startAnimating()
//                guard let child = self.viewControllers.first as? AfterSearchContentViewController else {
//                    return
//                }
//                child.tableView.isHidden = true // 검색 시작 시 테이블 뷰 숨김
//            })
//            .disposed(by: disposeBag)
//
//        output.songEntityOfSelectedSongs
//            .skip(1)
//            .subscribe(onNext: { [weak self] (songs: [SongEntity]) in
//                guard let self = self else { return }
//                if !songs.isEmpty {
//                    self.showSongCart(
//                        in: self.view,
//                        type: .searchSong,
//                        selectedSongCount: songs.count,
//                        totalSongCount: 100,
//                        useBottomSpace: false
//                    )
//                    self.songCartView.delegate = self
//                } else {
//                    self.hideSongCart()
//                }
//            })
//            .disposed(by: disposeBag)
//    }

//    func clearSongCart() {
//        self.output.songEntityOfSelectedSongs.accept([])
//        self.viewControllers.forEach { vc in
//            guard let afterContentVc = vc as? AfterSearchContentViewController else {
//                return
//            }
//            afterContentVc.input.deSelectedAllSongs.accept(())
//        }
//    }
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
//            let songs: [String] = output.songEntityOfSelectedSongs.value.map { $0.id }
//            let viewController = containSongsFactory.makeView(songs: songs)
//            viewController.modalPresentationStyle = .overFullScreen
//            self.present(viewController, animated: true) { [weak self] in
//                guard let self = self else { return }
//                self.clearSongCart()
//            }
            break

        case .addPlayList:
//            let songs = output.songEntityOfSelectedSongs.value
//            playState.appendSongsToPlaylist(songs)
//            self.clearSongCart()
            break
        case .play:
//            let songs = output.songEntityOfSelectedSongs.value
//            playState.loadAndAppendSongsToPlaylist(songs)
//            self.clearSongCart()
            break

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
