//
//  ArtistMusicContentViewController.swift
//  ArtistFeature
//
//  Created by KTH on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import RxSwift
import RxCocoa

class ArtistMusicContentViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allPlayButton: UIButton!
    @IBOutlet weak var shufflePlayButton: UIButton!
    
    var dataSource: BehaviorRelay<[Int]> = BehaviorRelay(value: [1,2,3,4,5,6,7,8,9,10])
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind()
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }
    
    public static func viewController() -> ArtistMusicContentViewController {
        let viewController = ArtistMusicContentViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        return viewController
    }
}

extension ArtistMusicContentViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        DEBUG_LOG("performDropWith")
        
        
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }

        DEBUG_LOG(destinationIndexPath)
    }
    
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let itemProvider = NSItemProvider(object: "1" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        var dropProposal = UITableViewDropProposal(operation: .cancel)
        
        DEBUG_LOG("destinationIndexPath: \(destinationIndexPath)")
        // Accept only one drag item.
        guard session.items.count == 1 else { return dropProposal }
        
        // The .move drag operation is available only for dragging within this app and while in edit mode.
        if tableView.hasActiveDrag {
//            if tableView.isEditing {
                dropProposal = UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//            }
        } else {
            // Drag is coming from outside the app.
            dropProposal = UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }

        
        return dropProposal
    }

}

extension ArtistMusicContentViewController {
    
    private func bind() {
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        dataSource
            .bind(to: tableView.rx.items) { (tableView, index, model) -> UITableViewCell in
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistMusicCell", for: indexPath) as? ArtistMusicCell else{
                    return UITableViewCell()
                }
                cell.update()
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withLatestFrom(dataSource) { ($0, $1) }
            .subscribe(onNext: { [weak self] (indexPath, model) in
                guard let `self` = self else { return }
//                self.tableView.deselectRow(at: indexPath, animated: true)
                let model = model[indexPath.row]
            }).disposed(by: disposeBag)

    }
    
    private func configureUI() {
        
        let allPlayAttributedString = NSMutableAttributedString.init(string: "전체재생")
        
        allPlayAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                               .foregroundColor: DesignSystemAsset.GrayColor.gray900.color],
                                              range: NSRange(location: 0, length: allPlayAttributedString.string.count))

        allPlayButton.setImage(DesignSystemAsset.Chart.allPlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
        allPlayButton.layer.cornerRadius = 8
        allPlayButton.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        allPlayButton.layer.borderWidth = 1
        allPlayButton.setAttributedTitle(allPlayAttributedString, for: .normal)
        
        let shufflePlayAttributedString = NSMutableAttributedString.init(string: "랜덤재생")
        
        shufflePlayAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                                   .foregroundColor: DesignSystemAsset.GrayColor.gray900.color],
                                                  range: NSRange(location: 0, length: shufflePlayAttributedString.string.count))
        
        shufflePlayButton.setImage(DesignSystemAsset.Chart.shufflePlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
        shufflePlayButton.layer.cornerRadius = 8
        shufflePlayButton.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        shufflePlayButton.layer.borderWidth = 1
        shufflePlayButton.setAttributedTitle(shufflePlayAttributedString, for: .normal)
        
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
    }
}

extension ArtistMusicContentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
