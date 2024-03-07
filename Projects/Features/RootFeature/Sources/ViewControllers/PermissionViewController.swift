//
//  PermissionViewController.swift
//  RootFeature
//
//  Created by KTH on 2023/04/04.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import UIKit
import Utility

public class PermissionViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var borderViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var optionalPermissionLabel: UILabel!

    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var cameraDescriptionLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var albumDescriptionLabel: UILabel!

    @IBOutlet weak var firstDotLabel: UILabel!
    @IBOutlet weak var firstDesciptionLabel: UILabel!
    @IBOutlet weak var secondDotLabel: UILabel!
    @IBOutlet weak var secondDesciptionLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    public static func viewController() -> PermissionViewController {
        let viewController = PermissionViewController.viewController(storyBoardName: "Intro", bundle: Bundle.module)
        return viewController
    }

    @IBAction func confirmButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: {
            Utility.PreferenceManager.appPermissionChecked = true
        })
    }
}

extension PermissionViewController {
    private func configureUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.borderView.layer.cornerRadius = 24
        self.borderView.clipsToBounds = true

        let mainTitleAttributedString = NSMutableAttributedString(
            string: "앱 접근 권한 안내",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.bold.font(size: 22),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        self.mainTitleLabel.attributedText = mainTitleAttributedString

        let optionalAttributedString = NSMutableAttributedString(
            string: "선택적 접근 권한",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        self.optionalPermissionLabel.attributedText = optionalAttributedString

        self.cameraImageView.image = DesignSystemAsset.Permission.permissionCamera.image
        let cameraAttributedString = NSMutableAttributedString(
            string: "카메라",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        self.cameraLabel.attributedText = cameraAttributedString

        let cameraDescriptionAttributedString = NSMutableAttributedString(
            string: "버그 제보 시 사진 촬영을 위한 권한",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
                .foregroundColor: DesignSystemAsset.GrayColor.gray500.color,
                .kern: -0.5
            ]
        )
        self.cameraDescriptionLabel.attributedText = cameraDescriptionAttributedString

        self.albumImageView.image = DesignSystemAsset.Permission.permissionAlbum.image
        let albumAttributedString = NSMutableAttributedString(
            string: "앨범",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        self.albumLabel.attributedText = albumAttributedString

        let albumDescriptionAttributedString = NSMutableAttributedString(
            string: "버그 제보 시 파일 첨부를 위한 권한",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
                .foregroundColor: DesignSystemAsset.GrayColor.gray500.color,
                .kern: -0.5
            ]
        )
        self.albumDescriptionLabel.attributedText = albumDescriptionAttributedString

        self.firstDotLabel.layer.cornerRadius = 2
        self.firstDotLabel.clipsToBounds = true

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26

        let firstDescriptionAttributedString = NSMutableAttributedString(
            string: "선택적 접근 권한은 서비스 사용 중 필요한 시점에 동의를 받고 있습니다. 허용하지 않으셔도 서비스 이용이 가능합니다.",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.light.font(size: 12),
                .foregroundColor: DesignSystemAsset.GrayColor.gray500.color,
                .paragraphStyle: paragraphStyle,
                .kern: -0.5
            ]
        )
        self.firstDesciptionLabel.attributedText = firstDescriptionAttributedString

        self.secondDotLabel.layer.cornerRadius = 2
        self.secondDotLabel.clipsToBounds = true

        let secondDescriptionAttributedString = NSMutableAttributedString(
            string: "접근 권한 변경 방법 : 설정 > 왁타버스 뮤직",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.light.font(size: 12),
                .foregroundColor: DesignSystemAsset.GrayColor.gray500.color,
                .kern: -0.5
            ]
        )
        self.secondDesciptionLabel.attributedText = secondDescriptionAttributedString

        let confirmAttributedString = NSMutableAttributedString(
            string: "확인",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                .foregroundColor: DesignSystemAsset.GrayColor.gray25.color,
                .kern: -0.5
            ]
        )
        self.confirmButton.setAttributedTitle(confirmAttributedString, for: .normal)
        self.confirmButton.backgroundColor = DesignSystemAsset.PrimaryColor.point.color

        self.borderViewWidthConstraint.constant = APP_WIDTH() < 375 ? (APP_WIDTH() - 40.0) : 335.0
        self.view.layoutIfNeeded()
    }
}
