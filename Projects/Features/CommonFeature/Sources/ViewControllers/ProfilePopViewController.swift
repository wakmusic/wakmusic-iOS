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

public struct ProfileResponseDTO {
    var type: FanType
    var isSelected: Bool
}

public final class ProfilePopViewController: UIViewController, ViewControllerFromStoryBoard {
    
    @IBOutlet weak var collectionVIewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: ProfilePopViewModel!
    var completion: (() -> Void)?
    var dataSource: BehaviorRelay<[ProfileResponseDTO]> = {
        let currentFanType = FanType(rawValue: Utility.PreferenceManager.userInfo?.profile ?? "") ?? .panchi
        let dataSource = BehaviorRelay.init(
            value: [
                ProfileResponseDTO(type: .panchi, isSelected: currentFanType == .panchi),
                ProfileResponseDTO(type: .ifari, isSelected: currentFanType == .ifari),
                ProfileResponseDTO(type: .dulgi, isSelected: currentFanType == .dulgi),
                ProfileResponseDTO(type: .bat, isSelected: currentFanType == .bat),
                ProfileResponseDTO(type: .segyun, isSelected: currentFanType == .segyun),
                ProfileResponseDTO(type: .gorani, isSelected: currentFanType == .gorani),
                ProfileResponseDTO(type: .jupock, isSelected: currentFanType == .jupock),
                ProfileResponseDTO(type: .ddong, isSelected: currentFanType == .ddong)
            ]
        )
        return dataSource
    }()
    
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
    
    public static func viewController(viewModel: ProfilePopViewModel, completion: (() -> Void)? = nil) -> ProfilePopViewController {
        let viewController = ProfilePopViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.completion = completion
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
     
        self.activityIndicator.color = .white
        self.collectionVIewHeight.constant = rowHeight  + 10
    }
    
    private func bindRx(){
        
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        dataSource.bind(to: collectionView.rx.items) { (collectionView: UICollectionView, index: Int, model: ProfileResponseDTO) -> UICollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: IndexPath(row: index, section: 0)) as? ProfileCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.update(model)
            return cell
                     
        }.disposed(by:disposeBag)
        
        collectionView.rx.itemSelected
            .withLatestFrom(dataSource){($0,$1)}
            .map{ (indexPath: IndexPath, dataSource: [ProfileResponseDTO]) -> [ProfileResponseDTO] in
                var newModel = dataSource
                guard let index = newModel.firstIndex(where:{$0.isSelected}) else {
                    return dataSource
                }
                
                newModel[index].isSelected = false  //이전 선택 false
                newModel[indexPath.row].isSelected = true //현재 선택 true
                return newModel
            }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
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
            .withLatestFrom(dataSource)
            .map{ (model) in
                let fanType: FanType = model.filter { $0.isSelected }.first?.type ?? .panchi
                return fanType
            }
            .bind(to: viewModel.input.setProfileRequest)
            .disposed(by: disposeBag)
        
        viewModel.output.resultDescription
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

                let isCompleted: Bool = result.isEmpty
                
                if isCompleted {
                    self.dismiss(animated: true)
                    
                }else{
                    self.showToast(text: result, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
                }
                
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
    
   
        return PanModalHeight.contentHeight( rowHeight + 190 )
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
