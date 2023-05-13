//
//  ContainSongsViewController.swift
//  CommonFeature
//
//  Created by yongbeomkwak on 2023/03/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import BaseFeature
import Utility
import DesignSystem
import RxSwift
import NVActivityIndicatorView

public final class ContainSongsViewController: BaseViewController,ViewControllerFromStoryBoard{
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var songCountLabel: UILabel!
    
    var multiPurposePopComponent : MultiPurposePopComponent!
    var disposeBag = DisposeBag()
    var viewModel:ContainSongsViewModel!
    lazy var input = ContainSongsViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
    deinit { DEBUG_LOG("❌ \(Self.self) Deinit") }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
    }
    
    public static func viewController(
        multiPurposePopComponent: MultiPurposePopComponent,
        viewModel: ContainSongsViewModel
    ) -> ContainSongsViewController {
        let viewController = ContainSongsViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        viewController.multiPurposePopComponent = multiPurposePopComponent
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ContainSongsViewController {
    
    private func bindRx() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        closeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true)
        })
        .disposed(by: disposeBag)
        
        output.dataSource
            .skip(1)
            .do(onNext: { [weak self] model in
                guard let self = self else {
                    return
                }
                let window: UIWindow? = UIApplication.shared.windows.first
                let safeAreaInsetsTop: CGFloat = window?.safeAreaInsets.top ?? 0
                let safeAreaInsetsBottom: CGFloat = window?.safeAreaInsets.bottom ?? 0
                
                let space = APP_HEIGHT() - 48 - 16 - 24 - 12 - 52 - 12 -  safeAreaInsetsTop - safeAreaInsetsBottom
                let height = space / 3  * 2
                
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: height))
                warningView.text = "내 리스트가 없습니다."
                self.tableView.tableFooterView = model.isEmpty ?  warningView : nil
                self.indicator.stopAnimating()
            })
            .bind(to: tableView.rx.items){ (tableView,index,model) -> UITableViewCell in
                let bgView = UIView()
                bgView.backgroundColor = DesignSystemAsset.GrayColor.gray200.color.withAlphaComponent(0.6)
                
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "CurrentPlayListTableViewCell",
                    for: IndexPath(row: index, section: 0)) as? CurrentPlayListTableViewCell
                else {
                    return UITableViewCell()
                }
            
                cell.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
                cell.selectedBackgroundView = bgView
                cell.update(model: model)
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withLatestFrom(output.dataSource){ ($0, $1) }
            .map{ (indexPath, models) -> String in
                return models[indexPath.row].key
            }
            .bind(to: input.containSongWithKey)
            .disposed(by: disposeBag)
                
        output.showToastMessage
            .subscribe(onNext: { [weak self] (text:String) in
                guard let self = self else {return}
                self.showToast(text: text, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
                NotificationCenter.default.post(name: .playListRefresh, object: nil) // 플리목록창 이름 변경하기 위함
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.playListRefresh)
            .map{ _ in () }
            .bind(to: input.playListLoad)
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        closeButton.setImage(DesignSystemAsset.Navigation.close.image, for: .normal)
        
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        subTitleLabel.font =  DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        subTitleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        songCountLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        songCountLabel.textColor = DesignSystemAsset.PrimaryColor.point.color
        
        songCountLabel.text = "\(viewModel.songs.count)곡"
        
        indicator.type = .circleStrokeSpin
        indicator.color = DesignSystemAsset.PrimaryColor.point.color
        indicator.startAnimating()
    }
}

extension ContainSongsViewController : UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ContainPlayListHeaderView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 140))
        header.delegate = self
        return header
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
}

extension ContainSongsViewController : ContainPlayListHeaderViewDelegate {
    public func action() {
        let vc = multiPurposePopComponent.makeView(type: .creation)
        self.showPanModal(content: vc)
    }
}
