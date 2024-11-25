//
//  EditSheetView.swift
//  CommonFeature
//
//  Created by KTH on 2023/03/17.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import UIKit
import Utility

@MainActor
public protocol EditSheetViewDelegate: AnyObject {
    func buttonTapped(type: EditSheetSelectType)
}

public enum EditSheetSelectType {
    case edit
    case share
    case profile
    case nickname
}

public class EditSheetView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var nicknameButton: UIButton!

    public weak var delegate: EditSheetViewDelegate?
    public var type: EditSheetType = .playList

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    convenience init(type: EditSheetType) {
        self.init()
        self.type = type
        self.setupView()
    }

    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }

    @IBAction func buttonAction(_ sender: Any) {
        guard let button = sender as? UIButton else { return }

        if button == editButton {
            delegate?.buttonTapped(type: .edit)

        } else if button == shareButton {
            delegate?.buttonTapped(type: .share)

        } else if button == profileButton {
            delegate?.buttonTapped(type: .profile)

        } else if button == nicknameButton {
            delegate?.buttonTapped(type: .nickname)
        }
    }
}

public extension EditSheetView {
    private func setupView() {
        guard let view = Bundle.module.loadNibNamed("EditSheetView", owner: self, options: nil)?.first as? UIView
        else { return }
        view.frame = self.bounds
        view.layoutIfNeeded()
        addSubview(view)
        configureType()
        configureUI()
    }

    private func configureType() {
        switch self.type {
        case .playList:
            editButton.isHidden = false
            shareButton.isHidden = false
            profileButton.isHidden = true
            nicknameButton.isHidden = true

        case .profile:
            editButton.isHidden = true
            shareButton.isHidden = true
            profileButton.isHidden = false
            nicknameButton.isHidden = false
        }
    }

    private func configureUI() {
        contentView.backgroundColor = DesignSystemAsset.PrimaryColor.point.color
        let titles: [String] = ["편집", "공유하기", "프로필 변경", "닉네임 수정"]

        let images: [UIImage] = [
            DesignSystemAsset.PlayListEdit.playlistEdit.image,
            DesignSystemAsset.PlayListEdit.playlistShare.image,
            DesignSystemAsset.Storage.profileEdit.image,
            DesignSystemAsset.Storage.nicknameEdit.image
        ]

        let buttons: [UIButton] = [
            editButton,
            shareButton,
            profileButton,
            nicknameButton
        ]

        guard titles.count == images.count,
              titles.count == buttons.count else { return }

        for i in 0 ..< titles.count {
            buttons[i].setImage(images[i], for: .normal)
            let attributedString = NSMutableAttributedString.init(string: titles[i])
            attributedString.addAttributes(
                [
                    .font: DesignSystemFontFamily.Pretendard.medium.font(size: 12),
                    .foregroundColor: DesignSystemAsset.GrayColor.gray25.color,
                    .kern: -0.5
                ],
                range: NSRange(location: 0, length: attributedString.string.count)
            )

            buttons[i].setAttributedTitle(attributedString, for: .normal)
            buttons[i].alignTextBelow(spacing: 0)
        }
    }
}
