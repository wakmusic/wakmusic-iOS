//
//  AfterSearchContentViewController.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import Pageboy
import Tabman
import RxSwift
import DomainModule
import CommonFeature



public final class AfterSearchViewController: TabmanViewController, ViewControllerFromStoryBoard,SongCartViewType  {

    @IBOutlet weak var tabBarView: UIView!
    
    @IBOutlet weak var fakeView: UIView!
    
    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!

    
    

    var viewModel:AfterSearchViewModel!
    var afterSearchContentComponent:AfterSearchContentComponent!
    var containSongsComponent:ContainSongsComponent!
    
    let disposeBag = DisposeBag()
    
    
    private var viewControllers: [UIViewController] = [UIViewController(),UIViewController(),UIViewController(),UIViewController()]
    lazy var input = AfterSearchViewModel.Input()
     lazy var output = viewModel.transform(from: input)
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollToPage(.at(index: 0), animated: false)

    }
    

    public static func viewController(afterSearchContentComponent:AfterSearchContentComponent,containSongsComponent:ContainSongsComponent,viewModel:AfterSearchViewModel) -> AfterSearchViewController {
        let viewController = AfterSearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        
        viewController.viewModel = viewModel
        viewController.afterSearchContentComponent = afterSearchContentComponent
        viewController.containSongsComponent = containSongsComponent
     
        
        
        return viewController
    }

}

extension AfterSearchViewController {
    
    private func configureUI() {
        self.fakeView.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.dataSource = self //dateSource
        let bar = TMBar.ButtonBar()
        
        // 배경색
        bar.backgroundView.style = .flat(color:.clear)
        
        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .progressive
        
        
        // 버튼 글씨 커스텀
        bar.buttons.customize { (button) in
            button.tintColor = DesignSystemAsset.GrayColor.gray400.color
            button.selectedTintColor = DesignSystemAsset.GrayColor.gray900.color
            button.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
            button.selectedFont = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        }
        
        // indicator
        bar.indicator.weight = .custom(value: 3)
        bar.indicator.tintColor = DesignSystemAsset.PrimaryColor.point.color
        bar.indicator.overscrollBehavior = .compress
        addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: nil))
        
        bar.layer.addBorder([.bottom], color:DesignSystemAsset.GrayColor.gray300.color.withAlphaComponent(0.4), height: 1)


    
        bindRx()

        
    }
    
    private func bindRx(){
        
        output.dataSource
            .skip(1)
            .subscribe(onNext: { [weak self] result in
            
            guard let self = self else{
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
                
            self.reloadData()
            
            
        })
        .disposed(by: disposeBag)
        
        
        output.isFetchStart
            .subscribe(onNext: { [weak self] _ in
            
            guard let self = self else{
                return
            }
                
            guard let child = self.viewControllers.first as? AfterSearchContentViewController else {
                return
            }
           
                child.tableView.isHidden = true // 검색 시작 시 테이블 뷰 숨김
            
            

        })
        .disposed(by: disposeBag)
        
        
        output.songEntityOfSelectedSongs
            .subscribe(onNext: { [weak self] (songs:[SongEntity])  in
                
                guard let self = self else {return}
                
                if !songs.isEmpty  {
                    self.showSongCart(in: self.view,
                                      type: .searchSong,
                                      selectedSongCount: songs.count,
                                      totalSongCount: 100,
                                      useBottomSpace: false)
                    self.songCartView.delegate = self
                } else {
                    self.hideSongCart()
                }
                
                
            })
            .disposed(by: disposeBag)

    }
    

}


extension AfterSearchViewController: PageboyViewControllerDataSource, TMBarDataSource {
    public func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
    }
    
    public func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    public func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
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
            
        case .allSelect(flag: _):
            return
        case .addSong:
            let songs: [String] = output.songEntityOfSelectedSongs.value.map { $0.id }
            let viewController = containSongsComponent.makeView(songs: songs)
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true){ [weak self] in
                
                guard let self = self else{return}
                
                self.output.songEntityOfSelectedSongs.accept([])
                
                self.viewControllers.forEach({ vc in
                    
                    guard let afterContentVc = vc as? AfterSearchContentViewController else {
                        
                       
                        return
                    }
                    
                    afterContentVc.input.deSelectedAllSongs.accept(())
                    
                })
            }
            
        case .addPlayList:
            return
        case .play:
            return
        case .remove:
            return
        }

    }
    
    
}
