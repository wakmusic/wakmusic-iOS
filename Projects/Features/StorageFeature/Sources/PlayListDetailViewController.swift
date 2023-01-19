//
//  PlayListDetailViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//
import UIKit
import Utility
import DesignSystem
import RxRelay
import RxSwift
import RxCocoa
import RxDataSources

public enum PlayListType{
    case custom
    case wmRecommand
}


typealias PlayListSectionModel = SectionModel<PlayListType,SongInfoDTO>

public class PlayListDetailViewController: UIViewController,ViewControllerFromStoryBoard {
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var playListImage: UIImageView!
    @IBOutlet weak var playListNameLabel: UILabel!
    @IBOutlet weak var playListCountLabel: UILabel!
    @IBOutlet weak var editPlayListNameButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editStateLabel: UILabel!
    @IBOutlet weak var playListInfoView: UIView!
    
    var disposeBag = DisposeBag()
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    var dataSource: BehaviorRelay<[PlayListSectionModel]> = BehaviorRelay(value:[PlayListSectionModel.init(model: .wmRecommand, items: [SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12")])])
    
//    var dataSource: BehaviorRelay<[PlayListSectionModel]> = BehaviorRelay(value:[])
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 숨기기
        configureUI()

        // Do any additional setup after loading the view.
    }
    
    
    public static func viewController() -> PlayListDetailViewController {
        let viewController = PlayListDetailViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        return viewController
    }
    
}


extension PlayListDetailViewController{
    
    private func configureUI(){
        
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        tableView.backgroundColor = .clear
        
        
        self.completeButton.isHidden = true
        self.editStateLabel.isHidden = true
        
        
        self.editPlayListNameButton.setImage(DesignSystemAsset.Storage.storageEdit.image, for: .normal)
        
        
        self.playListImage.image = DesignSystemAsset.PlayListTheme.theme0.image
        
        self.backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        self.moreButton.setImage(DesignSystemAsset.Storage.more.image, for: .normal)
        
        
        self.completeButton.titleLabel?.text = "완료"
        self.completeButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 12)
        self.completeButton.layer.cornerRadius = 4
        self.completeButton.layer.borderColor =  DesignSystemAsset.PrimaryColor.point.color.cgColor
        self.completeButton.layer.borderWidth = 1
        self.completeButton.backgroundColor = .clear
    
        
        self.editStateLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        
        
        self.playListCountLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 14)
        self.playListCountLabel.textColor =  DesignSystemAsset.GrayColor.gray900.color.withAlphaComponent(0.6) // opacity 60%
        
        self.playListNameLabel.font  = DesignSystemFontFamily.Pretendard.bold.font(size: 20)
        
        
        playListInfoView.layer.borderWidth = 1
        playListInfoView.layer.borderColor = colorFromRGB(0xFCFCFD).cgColor
        playListInfoView.layer.cornerRadius = 8
        
        bindRx()
        
        
    }
    
    
    private func bindRx()
    {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(UINib(nibName:"SongListCell", bundle: DesignSystemResources.bundle), forCellReuseIdentifier: "SongListCell")
        
        //xib로 만든 UI를 컬렉션 뷰에서 사용하기 위해서는 등록이 필요
        //다른 모듈 시 번들 변경 Bundle.module 사용 X
        
        dataSource
            .debug("TEXT")
            .do(onNext: { [weak self] model in
                
                guard let self = self else {
                    return
                }
                
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT()/3))
                warningView.text = "플레이리스트에 곡이 없습니다."
                
                
                self.tableView.tableHeaderView = model.isEmpty ?  warningView : nil
            })
            .bind(to: tableView.rx.items(dataSource: createDatasource()))
        .disposed(by: disposeBag)
        
        
        
      
    }
    
    func createDatasource() -> RxTableViewSectionedReloadDataSource<PlayListSectionModel>{

        let datasource = RxTableViewSectionedReloadDataSource<PlayListSectionModel>(configureCell: { [weak self] (datasource, tableView, indexPath, model) -> UITableViewCell in

            guard let self = self else { return UITableViewCell() }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell", for: indexPath) as? SongListCell else{
                return UITableViewCell()
            }
            let bgView = UIView()
            bgView.backgroundColor = DesignSystemAsset.GrayColor.gray200.color
            
            //cell.update(model)
            cell.selectedBackgroundView = bgView
            
            return cell


        }, titleForHeaderInSection: { (datasource, sectionNumber) -> String? in
            return nil
        })

        return datasource
    }
    
    public func update(_ pt:PlayListType)
    {
        //self.playListImage.image = DesignSystemAsset.RecommendPlayList.dummyPlayList.image
        
        //self.moreButton.isHidden = k == .wmRecommand
       
        
        
    }
    
    
    
}
   
    



extension PlayListDetailViewController:UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
    
        let view = PlayButtonGroupView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 80))
        
        //view.delegate? = self
        
        
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 80
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    
}
