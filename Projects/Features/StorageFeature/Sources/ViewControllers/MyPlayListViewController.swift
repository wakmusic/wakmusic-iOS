//
//  MyPlayListViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import RxSwift
import RxRelay
import RxCocoa
import DesignSystem
import PanModal
import BaseFeature
import CommonFeature
import DomainModule
import RxDataSources

public typealias MyPlayListSectionModel = SectionModel<Int, PlayListEntity>

public final class MyPlayListViewController: BaseViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tableView: UITableView!

    var multiPurposePopComponent:MultiPurposePopComponent!
    var playListDetailComponent :PlayListDetailComponent!
    var viewModel:MyPlayListViewModel!
    
    lazy var input = MyPlayListViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        inputBindRx()
        outputBindRx()
    }
    
    public static func viewController(
        viewModel: MyPlayListViewModel,
        multiPurposePopComponent: MultiPurposePopComponent,
        playListDetailComponent: PlayListDetailComponent
    ) -> MyPlayListViewController {
        let viewController = MyPlayListViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.multiPurposePopComponent = multiPurposePopComponent
        viewController.playListDetailComponent = playListDetailComponent
        return viewController
    }
}

extension MyPlayListViewController{
    
    private func inputBindRx() {
        
        input.showConfirmModal.subscribe(onNext: { [weak self] in
            guard let self = self else{
                return
            }
            let vc = TextPopupViewController.viewController(
                text: "변경된 내용을 저장할까요?",
                cancelButtonIsHidden: false,
                completion: {
                self.input.runEditing.onNext(())
                                             
            },cancelCompletion: {
                self.input.cancelEdit.onNext(())
            })
            self.showPanModal(content: vc)
        }).disposed(by: disposeBag)
            
        output.showErrorToast.subscribe(onNext: { [weak self] (message: String) in
            guard let self = self else{
                return
            }
            self.showToast(
                text: message,
                font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
            )
        }).disposed(by: disposeBag)
                                
        NotificationCenter.default.rx.notification(.playListRefresh)
            .map({_ in () })
            .bind(to: input.playListLoad)
            .disposed(by: disposeBag)
    }

    private func outputBindRx() {
        
        output.state
            .skip(1)
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else{
                    return
                }
                if state.isEditing == false && state.force == false { // 정상적인 편집 완료 이벤트
                    self.input.runEditing.onNext(())
                }
                
                guard let parent = self.parent?.parent as? AfterLoginViewController else{
                    return
                }
                
                // 탭맨 쪽 편집 변경
                let isEdit: Bool = state.isEditing
                parent.output.state.accept(EditState(isEditing: isEdit, force: true))
                self.tableView.setEditing(isEdit, animated: true)
                self.tableView.visibleCells.forEach { $0.isEditing = isEdit }
            })
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        output.dataSource
            .skip(1)
            .do(onNext: { [weak self] model in
                guard let self = self else {
                    return
                }
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT()/3))
                warningView.text = "내 리스트가 없습니다."
                
                let items = model.first?.items ?? []
                self.tableView.tableFooterView = items.isEmpty ?  warningView : nil
            })
            .bind(to: tableView.rx.items(dataSource: createDatasources()))
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .withLatestFrom(output.dataSource){ ($0,$1) }
            .subscribe(onNext: { [weak self] (indexPath, models) in
                guard let self  = self else{
                    return
                }
                guard let model =  models.first?.items[indexPath.row] else {
                    return
                }
                let vc = self.playListDetailComponent.makeView(id: String(model.key) , type: .custom)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        tableView.rx.itemMoved
            .asObservable()
            .subscribe(onNext: { [weak self] (sourceIndexPath, destinationIndexPath) in
                guard let `self` = self else { return }

                self.input.sourceIndexPath.accept(sourceIndexPath)
                self.input.destinationIndexPath.accept(destinationIndexPath)
                
                var curr = self.output.dataSource.value.first?.items ?? []
                
                let tmp = curr[self.input.sourceIndexPath.value.row]
                curr.remove(at: self.input.sourceIndexPath.value.row)
                curr.insert(tmp, at: self.input.destinationIndexPath.value.row)

                let newModel = [MyPlayListSectionModel(model: 0, items: curr)]
                self.output.dataSource.accept(newModel)
                
            }).disposed(by: disposeBag)
    }
    
    private func createDatasources() -> RxTableViewSectionedReloadDataSource<MyPlayListSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<MyPlayListSectionModel>(configureCell: { [weak self] (datasource, tableView, indexPath, model) -> UITableViewCell in
            guard let self = self else { return UITableViewCell() }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPlayListTableViewCell",for: IndexPath(row: indexPath.row, section: 0)) as? MyPlayListTableViewCell
            else { return UITableViewCell() }
            
            cell.update(model: model, isEditing: self.output.state.value.isEditing)
            return cell
            
        }, canEditRowAtIndexPath: { (_, _) -> Bool in
            return true
        }, canMoveRowAtIndexPath: { (_, _) -> Bool in
            return true
        })
        return datasource
    }
}

extension MyPlayListViewController:UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MyPlayListHeaderView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 140))
        header.delegate = self
        return self.output.state.value.isEditing ? nil : header
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.output.state.value.isEditing ? 0 : 140
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none // 편집모드 시 왼쪽 버튼을 숨기려면 .none을 리턴합니다.
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false // 편집모드 시 셀의 들여쓰기를 없애려면 false를 리턴합니다.
    }
}

extension MyPlayListViewController:MyPlayListHeaderViewDelegate{
    public func action(_ type: PurposeType) {
        let vc =  multiPurposePopComponent.makeView(type: type)
        self.showPanModal(content: vc)
    }    
}
