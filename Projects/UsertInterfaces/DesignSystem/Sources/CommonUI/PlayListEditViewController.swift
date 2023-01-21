//
//  PlayListEditViewController.swift
//  DesignSystem
//
//  Created by KTH on 2023/01/17.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import PanModal

protocol PlayListEditViewDelegate: AnyObject{
    func buttonTapped(type: PlayListEditType)
}

public final class PlayListEditViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var allSelectButton: UIButton!
    @IBOutlet weak var songAddButton: UIButton!
    @IBOutlet weak var playListAddButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var selectCountView: UIView!
    @IBOutlet weak var selectCountLabel: UILabel!
    
    weak var delegate: PlayListEditViewDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    public static func viewController() -> PlayListEditViewController {
        let viewController = PlayListEditViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        return viewController
    }
    
    @IBAction func allSelectButtonAction(_ sender: Any) {
        DEBUG_LOG("allSelectButtonAction")
        
        self.allSelectButton.isSelected = !self.allSelectButton.isSelected
        
        let attributedString = NSMutableAttributedString.init(string: self.allSelectButton.isSelected ? "전체선택해제" : "전체선택")
        attributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 12),
                                        .foregroundColor: DesignSystemAsset.GrayColor.gray25.color],
                                        range: NSRange(location: 0, length: attributedString.string.count))
        
        self.allSelectButton.setAttributedTitle(attributedString, for: .normal)
        self.allSelectButton.alignTextBelow(spacing: 0)
    }
}

enum PlayListEditType {
    case playListEdit
}

public extension PlayListEditViewController {
    
    func updateSelectedCount(value: Int) {
        self.selectCountView.isHidden = (value == 0)
        self.selectCountLabel.text = (value == 0) ? "" : "\(value)"
    }
}

extension PlayListEditViewController {
    
    private func configureUI() {
        
//        circleImageView.image = DesignSystemAsset.PlayListEdit.shadowCircle.image
        
        selectCountView.backgroundColor = .white
        selectCountView.layer.cornerRadius = selectCountView.frame.width / 2
        selectCountView.clipsToBounds = true
        
        selectCountLabel.font = DesignSystemFontFamily.Pretendard.bold.font(size: 18)
        selectCountLabel.text = "1"
        selectCountLabel.textColor = DesignSystemAsset.PrimaryColor.point.color

        let titles: [String] = ["전체선택", "노래담기", "재생목록추가", "재생", "삭제", "편집", "공유하기"]
        
        let images: [UIImage] = [DesignSystemAsset.PlayListEdit.checkOff.image,
                                 DesignSystemAsset.PlayListEdit.musicAdd.image,
                                 DesignSystemAsset.PlayListEdit.playlistAdd.image,
                                 DesignSystemAsset.PlayListEdit.playlistPlay.image,
                                 DesignSystemAsset.PlayListEdit.delete.image,
                                 DesignSystemAsset.PlayListEdit.playlistEdit.image,
                                 DesignSystemAsset.PlayListEdit.playlistShare.image]
        
        let buttons: [UIButton] = [allSelectButton,
                                   songAddButton,
                                   playListAddButton,
                                   playButton,
                                   removeButton,
                                   editButton,
                                   shareButton]
        
        guard titles.count == images.count,
              titles.count == buttons.count else { return }
        
        for i in 0..<titles.count {
            buttons[i].setImage(images[i], for: .normal)
            
            if buttons[i] == allSelectButton {
                buttons[i].setImage(DesignSystemAsset.PlayListEdit.checkOn.image, for: .selected)
            }
            
            let attributedString = NSMutableAttributedString.init(string: titles[i])
            attributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 12),
                                            .foregroundColor: DesignSystemAsset.GrayColor.gray25.color],
                                            range: NSRange(location: 0, length: attributedString.string.count))

            buttons[i].setAttributedTitle(attributedString, for: .normal)
            buttons[i].alignTextBelow(spacing: 0)
        }
        
        allSelectButton.isHidden = false
        songAddButton.isHidden = false
        playListAddButton.isHidden = false
        playButton.isHidden = false
        removeButton.isHidden = true
        editButton.isHidden = true
        shareButton.isHidden = true
    }
}

extension PlayListEditViewController: PanModalPresentable {

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    public var panModalBackgroundColor: UIColor {
        return .clear
    }

    public var panScrollable: UIScrollView? {
      return nil
    }

    public var longFormHeight: PanModalHeight {
         return .contentHeight(56 + 16)
     }

    public var cornerRadius: CGFloat {
        return 0
    }

    public var allowsExtendedPanScrolling: Bool {
        return true
    }

    public var showDragIndicator: Bool {
        return false
    }
    
    public var isUserInteractionEnabled: Bool {
        return true
    }
}
