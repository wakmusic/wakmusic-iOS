//
//  ProfilePopViewController.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import PanModal
import RxCocoa
import RxRelay
import RxSwift
import DesignSystem
import DomainModule

public struct ProfileResponseDTO {
    var type: FanType
    var isSelected: Bool
}

public final class ProfilePopViewController: UIViewController, ViewControllerFromStoryBoard {
    
    @IBOutlet weak var collectionVIewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dataLoadActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: ProfilePopViewModel!    
    var disposeBag = DisposeBag()
    var rowHeight:CGFloat = (( APP_WIDTH() - 70) / 4) * 2
    
    deinit {
        DEBUG_LOG("\(Self.self) deinit")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindRx()
    }
    
    public static func viewController(viewModel: ProfilePopViewModel) -> ProfilePopViewController {
        let viewController = ProfilePopViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ProfilePopViewController{
    
    private func configureUI(){
        
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        saveButton.setAttributedTitle(
            NSMutableAttributedString(
                string:"완료",
                attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                             .foregroundColor: DesignSystemAsset.GrayColor.gray25.color]
            ), for: .normal
        )
     
        self.dataLoadActivityIndicator.startAnimating()
        self.activityIndicator.color = .white
        self.collectionVIewHeight.constant = rowHeight  + 10
    }
    
    private func bindRx(){
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.output.dataSource
            .skip(1)
            .do(onNext: { [weak self] _ in
                self?.dataLoadActivityIndicator.stopAnimating()
            })
            .bind(to: collectionView.rx.items) { (collectionView: UICollectionView, index: Int, model: ProfileListEntity) -> UICollectionViewCell in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell",
                                                                    for: IndexPath(row: index, section: 0)) as? ProfileCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.update(model)
                return cell
                     
            }.disposed(by:disposeBag)
        
        collectionView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .withLatestFrom(viewModel.output.dataSource)
            .map{ (model) in
                let id: String = model.filter { $0.isSelected }.first?.id ?? "unknown"
                return id
            }
            .filter{ [weak self] (id) in
                guard let self = self else { return false }
                let currentProfile = Utility.PreferenceManager.userInfo?.profile ?? "unknown"
                guard currentProfile != id else {
                    self.showToast(text: "현재 설정 된 프로필 입니다. 다른 프로필을 선택해주세요.",
                                   font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
                    return false
                }
                return true
            }
            .do(onNext: { [weak self] _ in
                self?.activityIndicator.startAnimating()
                self?.saveButton.setAttributedTitle(
                    NSMutableAttributedString(
                        string:"",
                        attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                                     .foregroundColor: DesignSystemAsset.GrayColor.gray25.color]
                    ), for: .normal
                )
            })
            .bind(to: viewModel.input.setProfileRequest)
            .disposed(by: disposeBag)
        
        viewModel.output.setProfileResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (result) in
                guard let self = self else { return }
                
                self.activityIndicator.stopAnimating()
                self.saveButton.setAttributedTitle(
                    NSMutableAttributedString(
                        string:"완료",
                        attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                                     .foregroundColor: DesignSystemAsset.GrayColor.gray25.color]
                    ), for: .normal
                )
                
                if result.status == 200 {
                    self.dismiss(animated: true)
                    
                }else{
                    self.showToast(text: result.description, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
                }
                
            }).disposed(by: disposeBag)
                
        viewModel.output.collectionViewHeight
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (height) in
                guard let self = self else { return }
                self.collectionVIewHeight.constant = height
                self.panModalSetNeedsLayoutUpdate()
                self.panModalTransition(to: .longForm)
                self.view.layoutIfNeeded()
            }).disposed(by: disposeBag)
    }
}

extension ProfilePopViewController: PanModalPresentable {

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public var panModalBackgroundColor: UIColor {
        return colorFromRGB(0x000000, alpha: 0.4)
    }

    public var panScrollable: UIScrollView? {
      return nil
    }

    public var longFormHeight: PanModalHeight {   
        return PanModalHeight.contentHeight(collectionVIewHeight.constant + 190)
     }

    public var cornerRadius: CGFloat {
        return 24.0
    }

    public var allowsExtendedPanScrolling: Bool {
        return true
    }

    public var showDragIndicator: Bool {
        return false
    }
}

extension ProfilePopViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size:CGFloat = (APP_WIDTH() - 70) / 4
        return CGSize(width: size, height: size)
    }
    
    //행간 간격
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
    
    //아이템 사이 간격(좌,우)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
