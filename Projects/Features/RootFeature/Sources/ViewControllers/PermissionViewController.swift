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

    @IBOutlet weak var deviceInfoImageView: UIImageView!
    @IBOutlet weak var deviceInfoLabel: UILabel!
    @IBOutlet weak var deviceInfoDescriptionLabel: UILabel!
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationDescriptionLabel: UILabel!
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
            Utility.PreferenceManager.shared.appPermissionChecked = true
        })
    }
}

private extension PermissionViewController {
    func configureUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        borderView.layer.cornerRadius = 24
        borderView.clipsToBounds = true

        setAttributedString(
            with: mainTitleLabel,
            text: "앱 접근 권한 안내",
            font: DesignSystemFontFamily.Pretendard.bold.font(size: 22),
            textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
            lineHeight: 32,
            alignment: .center
        )

        deviceInfoImageView.image = DesignSystemAsset.Permission.permissionDevice.image
        setAttributedString(
            with: deviceInfoLabel,
            text: "기기정보 (필수)",
            font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
            textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
            lineHeight: 24,
            alignment: .left
        )
        setSubAttributedString(with: deviceInfoLabel, target: "(필수)")

        deviceInfoDescriptionLabel.numberOfLines = 0
        setAttributedString(
            with: deviceInfoDescriptionLabel,
            text: "사용성 개선 및 오류 확인",
            font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
            textColor: DesignSystemAsset.BlueGrayColor.gray500.color,
            lineHeight: 22,
            alignment: .left
        )

        notificationImageView.image = DesignSystemAsset.Permission.permissionNotification.image
        setAttributedString(
            with: notificationLabel,
            text: "알림 (선택)",
            font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
            textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
            lineHeight: 24,
            alignment: .left
        )
        setSubAttributedString(with: notificationLabel, target: "(선택)")

        notificationDescriptionLabel.numberOfLines = 0
        setAttributedString(
            with: notificationDescriptionLabel,
            text: "알림 수신",
            font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
            textColor: DesignSystemAsset.BlueGrayColor.gray500.color,
            lineHeight: 22,
            alignment: .left
        )

        cameraImageView.image = DesignSystemAsset.Permission.permissionCamera.image
        setAttributedString(
            with: cameraLabel,
            text: "카메라 (선택)",
            font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
            textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
            lineHeight: 24,
            alignment: .left
        )
        setSubAttributedString(with: cameraLabel, target: "(선택)")

        cameraDescriptionLabel.numberOfLines = 0
        setAttributedString(
            with: cameraDescriptionLabel,
            text: "버그 제보 시 사진 촬영",
            font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
            textColor: DesignSystemAsset.BlueGrayColor.gray500.color,
            lineHeight: 22,
            alignment: .left
        )

        albumImageView.image = DesignSystemAsset.Permission.permissionAlbum.image
        setAttributedString(
            with: albumLabel,
            text: "앨범 (선택)",
            font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
            textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
            lineHeight: 24,
            alignment: .left
        )
        setSubAttributedString(with: albumLabel, target: "(선택)")

        albumDescriptionLabel.numberOfLines = 0
        setAttributedString(
            with: albumDescriptionLabel,
            text: "리스트 사진 변경, 가사 꾸미기, 버그 제보 시\n파일 첨부 또는 저장",
            font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
            textColor: DesignSystemAsset.BlueGrayColor.gray500.color,
            lineHeight: 22,
            alignment: .left
        )

        [firstDotLabel, secondDotLabel].forEach {
            $0.layer.cornerRadius = 2
            $0.clipsToBounds = true
        }

        firstDesciptionLabel.numberOfLines = 0
        setAttributedString(
            with: firstDesciptionLabel,
            text: "선택적 접근 권한은 서비스 사용 중 필요한 시점에 동의를 받고 있습니다. 허용하지 않으셔도 서비스 이용이 가능합니다.",
            font: DesignSystemFontFamily.Pretendard.light.font(size: 12),
            textColor: DesignSystemAsset.BlueGrayColor.gray500.color,
            lineHeight: 18,
            alignment: .left
        )

        secondDesciptionLabel.numberOfLines = 0
        setAttributedString(
            with: secondDesciptionLabel,
            text: "접근 권한 변경 방법 : 설정 > 왁타버스 뮤직",
            font: DesignSystemFontFamily.Pretendard.light.font(size: 12),
            textColor: DesignSystemAsset.BlueGrayColor.gray500.color,
            lineHeight: 18,
            alignment: .left
        )

        let confirmAttributedString = NSMutableAttributedString(
            string: "확인",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray25.color,
                .kern: -0.5
            ]
        )
        confirmButton.setAttributedTitle(confirmAttributedString, for: .normal)
        confirmButton.backgroundColor = DesignSystemAsset.PrimaryColor.point.color
        borderViewWidthConstraint.constant = APP_WIDTH() < 375 ? (APP_WIDTH() - 40.0) : 335.0
    }

    func setAttributedString(
        with label: UILabel,
        text: String,
        font: UIFont,
        textColor: UIColor,
        lineHeight: CGFloat,
        alignment: NSTextAlignment = .left
    ) {
        label.text = text
        label.font = font
        label.textColor = textColor
        label.setTextWithAttributes(lineHeight: lineHeight, kernValue: -0.5, alignment: alignment)
    }

    func setSubAttributedString(
        with label: UILabel,
        target text: String
    ) {
        guard let attributedString = label.attributedText else { return }
        let new = NSMutableAttributedString(attributedString: attributedString)
        let range = (attributedString.string as NSString).range(of: text)
        new.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color
            ],
            range: range
        )
        label.attributedText = new
    }
}
