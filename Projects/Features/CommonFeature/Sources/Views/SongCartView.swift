//
//  EditBottomSheetView.swift
//  DesignSystem
//
//  Created by KTH on 2023/01/25.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import Utility

public protocol SongCartViewDelegate: AnyObject{
    func buttonTapped(type: SongCartSelectType)
}

public enum SongCartSelectType {
    case allSelect(flag: Bool)   // 전체선택
    case addSong                 // 노래담기
    case addPlayList             // 재생목록추가
    case play                    // 재생
    case remove                  // 삭제
}

public class SongCartView: UIView {

    @IBOutlet weak var allSelectView: UIView!
    @IBOutlet weak var allSelectImageView: UIImageView!
    @IBOutlet weak var allSelectLabel: UILabel!
    @IBOutlet weak var allSelectButton: UIButton!
    @IBOutlet weak var songAddButton: UIButton!
    @IBOutlet weak var playListAddButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var selectCountView: UIView!
    @IBOutlet weak var selectCountViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectCountLabel: UILabel!
    @IBOutlet weak var bottomSpaceView: UIView!
    @IBOutlet weak var bottomSpaceViewHeight: NSLayoutConstraint!
    
    public weak var delegate: SongCartViewDelegate?
    public var type: SongCartType = .playList
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    convenience init(type: SongCartType) {
        self.init()
        self.type = type
        self.setupView()
    }
    
    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        
        guard let button = sender as? UIButton else { return }
        
        if button == allSelectButton { //전체선택
            allSelectButton.isSelected = !allSelectButton.isSelected
            allSelectImageView.image = allSelectButton.isSelected ? DesignSystemAsset.PlayListEdit.checkOn.image : DesignSystemAsset.PlayListEdit.checkOff.image
            allSelectLabel.text = allSelectButton.isSelected ? "전체선택해제" : "전체선택"
            delegate?.buttonTapped(type: .allSelect(flag: allSelectButton.isSelected))
            
        }else if button == songAddButton { //노래담기
            guard Utility.PreferenceManager.userInfo != nil else {
                showLoginPopup()
                return
            }
            delegate?.buttonTapped(type: .addSong)

        }else if button == playListAddButton { //재생목록추가
            delegate?.buttonTapped(type: .addPlayList)

        }else if button == playButton { //재생
            delegate?.buttonTapped(type: .play)

        }else if button == removeButton { //삭제
            guard Utility.PreferenceManager.userInfo != nil else {
                showLoginPopup()
                return
            }
            delegate?.buttonTapped(type: .remove)
        }
    }
}

public extension SongCartView {

    private func setupView(){
        guard let view = Bundle.module.loadNibNamed("SongCartView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.layoutIfNeeded()
        addSubview(view)
        configureType()
        configureUI()
    }
    
    private func configureType() {
        
        switch self.type {
            
        case .playList:
            allSelectView.isHidden = false
            songAddButton.isHidden = false
            playListAddButton.isHidden = true
            playButton.isHidden = true
            removeButton.isHidden = false
            
        case .chartSong, .artistSong, .WMPlayList:
            allSelectView.isHidden = false
            songAddButton.isHidden = false
            playListAddButton.isHidden = false
            playButton.isHidden = false
            removeButton.isHidden = true

        case .likeSong, .myPlayList:
            allSelectView.isHidden = false
            songAddButton.isHidden = false
            playListAddButton.isHidden = false
            playButton.isHidden = true
            removeButton.isHidden = false
            
        case .myList:
            allSelectView.isHidden = false
            songAddButton.isHidden = true
            playListAddButton.isHidden = false
            playButton.isHidden = true
            removeButton.isHidden = false
            
        case .searchSong:
            allSelectView.isHidden = true
            songAddButton.isHidden = false
            playListAddButton.isHidden = false
            playButton.isHidden = false
            removeButton.isHidden = true
        }
    }
    
    private func configureUI() {
        
        selectCountView.backgroundColor = .white
        selectCountView.layer.cornerRadius = selectCountView.frame.width / 2
        selectCountView.clipsToBounds = true
        
        selectCountLabel.font = DesignSystemFontFamily.Pretendard.bold.font(size: 18)
        selectCountLabel.text = "1"
        selectCountLabel.textColor = DesignSystemAsset.PrimaryColor.point.color

        let titles: [String] = ["전체선택", "노래담기", "재생목록추가", "재생", "삭제"]
        
        let images: [UIImage] = [DesignSystemAsset.PlayListEdit.checkOff.image,
                                 DesignSystemAsset.PlayListEdit.musicAdd.image,
                                 DesignSystemAsset.PlayListEdit.playlistAdd.image,
                                 DesignSystemAsset.PlayListEdit.playlistPlay.image,
                                 DesignSystemAsset.PlayListEdit.delete.image]
        
        let buttons: [UIButton] = [allSelectButton,
                                   songAddButton,
                                   playListAddButton,
                                   playButton,
                                   removeButton]
        
        guard titles.count == images.count,
              titles.count == buttons.count else { return }
        
        for i in 0..<titles.count {
            if buttons[i] == allSelectButton {
                allSelectImageView.image = DesignSystemAsset.PlayListEdit.checkOff.image
                let attributedString = NSMutableAttributedString.init(string: "전체선택")
                attributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 12),
                                                .foregroundColor: DesignSystemAsset.GrayColor.gray25.color,
                                                .kern: -0.5],
                                                range: NSRange(location: 0, length: attributedString.string.count))
                allSelectLabel.attributedText = attributedString

            }else{
                buttons[i].setImage(images[i], for: .normal)
                let attributedString = NSMutableAttributedString.init(string: titles[i])
                attributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 12),
                                                .foregroundColor: DesignSystemAsset.GrayColor.gray25.color,
                                                .kern: -0.5],
                                                range: NSRange(location: 0, length: attributedString.string.count))
                buttons[i].setAttributedTitle(attributedString, for: .normal)
                buttons[i].alignTextBelow(spacing: -2)
            }
        }
        
        bottomSpaceView.backgroundColor = DesignSystemAsset.PrimaryColor.point.color
        bottomSpaceViewHeight.constant = SAFEAREA_BOTTOM_HEIGHT()
        layoutIfNeeded()
    }
    
    func updateCount(value: Int) {
        self.selectCountView.isHidden = (value == 0)
        self.selectCountLabel.text = (value == 0) ? "" : "\(value)"
        self.selectCountViewLeadingConstraint.constant = value >= 1000 ? 8 : 20
        self.layoutIfNeeded()
    }
    
    func updateAllSelect(isAll: Bool) {
        self.allSelectButton.isSelected = isAll
        self.allSelectImageView.image = self.allSelectButton.isSelected ? DesignSystemAsset.PlayListEdit.checkOn.image : DesignSystemAsset.PlayListEdit.checkOff.image
        self.allSelectLabel.text = self.allSelectButton.isSelected ? "전체선택해제" : "전체선택"
    }
    
    func updateBottomSpace(isUse: Bool) {
        self.bottomSpaceView.isHidden = isUse ? false : true
    }
}

extension SongCartView {
    private func showLoginPopup() {
        let viewController = TextPopupViewController.viewController(text: "로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?", cancelButtonIsHidden: false, completion: { () in
            NotificationCenter.default.post(name: .movedTab, object: 4)
        })
        guard let parent = self.parentViewController() else { return }
        parent.showPanModal(content: viewController)
    }
}
