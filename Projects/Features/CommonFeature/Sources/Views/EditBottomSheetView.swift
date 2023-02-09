//
//  EditBottomSheetView.swift
//  DesignSystem
//
//  Created by KTH on 2023/01/25.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem

protocol EditBottomSheetViewDelegate: AnyObject{
    func buttonTapped(type: EditBottomSheetType)
}

public class EditBottomSheetView: UIView {

    @IBOutlet weak var allSelectButton: UIButton!
    @IBOutlet weak var songAddButton: UIButton!
    @IBOutlet weak var playListAddButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
//    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var selectCountView: UIView!
    @IBOutlet weak var selectCountLabel: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
}

public extension EditBottomSheetView {
    
    private func setupView(){
        
        guard let view = Bundle.module.loadNibNamed("EditBottomSheetView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.layoutIfNeeded()
        self.addSubview(view)
        
        configureUI()
    }
    
    private func configureUI() {
                
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
        
        for index in 0..<titles.count {
            buttons[index].setImage(images[index], for: .normal)
            
            if buttons[index] == allSelectButton {
                buttons[index].setImage(DesignSystemAsset.PlayListEdit.checkOn.image, for: .selected)
            }
            
            let attributedString = NSMutableAttributedString.init(string: titles[index])
            attributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 12),
                                            .foregroundColor: DesignSystemAsset.GrayColor.gray25.color],
                                            range: NSRange(location: 0, length: attributedString.string.count))

            buttons[index].setAttributedTitle(attributedString, for: .normal)
            buttons[index].alignTextBelow(spacing: 0)
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

public extension EditBottomSheetView {
    func updateSelectedCount(value: Int) {
        self.selectCountView.isHidden = (value == 0)
        self.selectCountLabel.text = (value == 0) ? "" : "\(value)"
    }
}

enum EditBottomSheetType {
    case playListEdit
}
