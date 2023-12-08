//
//  QnAViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/29.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import Tabman
import Pageboy
import DesignSystem
import RxSwift
import NVActivityIndicatorView

public final class FaqViewController: TabmanViewController, ViewControllerFromStoryBoard {
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    @IBAction func pressBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil //스와이프로 뒤로가기
    }
    
    var disposeBag = DisposeBag()
    var viewModel:FaqViewModel!
    var faqContentComponent:FaqContentComponent!
    lazy var input = FaqViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
    var viewControllers:[UIViewController] = []

    public static func viewController(viewModel:FaqViewModel,faqContentComponent:FaqContentComponent) -> FaqViewController {
        let viewController = FaqViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.faqContentComponent = faqContentComponent
        return viewController
    }
}

extension FaqViewController {
    
    private func configureUI(){
        self.backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.activityIndicator.type = .circleStrokeSpin
        self.activityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        self.activityIndicator.startAnimating()
        
        //탭바 설정
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        
        // 배경색
        bar.backgroundView.style = .flat(color: colorFromRGB(0xF0F3F6))
        
        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .intrinsic
        bar.layout.transitionStyle = .progressive
        
        // 버튼 글씨 커스텀
        bar.buttons.customize { (button) in
            button.tintColor = DesignSystemAsset.GrayColor.gray400.color
            button.selectedTintColor = DesignSystemAsset.GrayColor.gray900.color
            button.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
            button.selectedFont = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        }
        
        // indicator
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = DesignSystemAsset.PrimaryColor.point.color
        bar.indicator.overscrollBehavior = .compress
        addBar(bar, dataSource: self, at: .custom(view: tabBarView,layout: nil))
        
        //회색 구분선 추가
        bar.layer.addBorder([.bottom], color:DesignSystemAsset.GrayColor.gray300.color.withAlphaComponent(0.4), height: 1)
    }
    
    func bindRx(){
        
        output.dataSource
            .skip(1)
            .do(onNext: { [weak self] (_, _) in
                self?.activityIndicator.stopAnimating()
            })
            .subscribe { [weak self] (categories, qna) in
                guard let self = self else{
                    return
                }
                guard let comp = self.faqContentComponent else{
                    return
                }

                self.viewControllers  = categories.enumerated().map { (i,c) in
                    if i == 0 {
                        return comp.makeView(dataSource: qna)
                    }else {
                        return comp.makeView(dataSource:  qna.filter({
                            $0.category.replacingOccurrences(of: " ", with: "") == c.replacingOccurrences(of: " ", with: "")
                        }))
                    }
                }
                self.reloadData()
            }.disposed(by: disposeBag)
    }
}

extension  FaqViewController:PageboyViewControllerDataSource, TMBarDataSource {
    public func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        DEBUG_LOG(self.viewControllers.count)
        return self.viewControllers.count
    }
    
    public func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    public func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        nil
    }
    
    public func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        return TMBarItem(title: output.dataSource.value.0[index])
    }
}
