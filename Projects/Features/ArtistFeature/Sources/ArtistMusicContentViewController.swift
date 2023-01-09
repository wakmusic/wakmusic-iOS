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
import HomeFeature

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
    }

    public static func viewController() -> ArtistMusicContentViewController {
        let viewController = ArtistMusicContentViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        return viewController
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
                self.tableView.deselectRow(at: indexPath, animated: true)
                let model = model[indexPath.row]
            }).disposed(by: disposeBag)

    }
    
    private func configureUI() {
        
        allPlayButton.setImage(DesignSystemAsset.Chart.allPlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
        allPlayButton.layer.cornerRadius = 8
        allPlayButton.layer.borderColor = colorFromRGB(0xE4E7EC).cgColor
        allPlayButton.layer.borderWidth = 1
        
        shufflePlayButton.setImage(DesignSystemAsset.Chart.shufflePlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
        shufflePlayButton.layer.cornerRadius = 8
        shufflePlayButton.layer.borderColor = colorFromRGB(0xE4E7EC).cgColor
        shufflePlayButton.layer.borderWidth = 1
    }
}

extension ArtistMusicContentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
