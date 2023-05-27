//
//  LoginView + UI.swift
//  SignInFeature
//
//  Created by 김대희 on 2023/03/13.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import Utility

extension LoginViewController {
    public func configureUI() {
        appLogoImageView.image = DesignSystemAsset.Logo.applogo.image
        appNameLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 20)
        descriptionLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 14)

        configureOAuthLogin()
        configureService()
    }

    private func configureOAuthLogin() {
        let loginAttributedString:[NSMutableAttributedString] = [
            NSMutableAttributedString.init(string: "네이버로 로그인하기"),
            NSMutableAttributedString.init(string: "구글로 로그인하기"),
            NSMutableAttributedString.init(string: "애플로 로그인하기")
        ]
        
        for attr in loginAttributedString{
            attr.addAttributes([
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color],
                range: NSRange(location: 0, length: attr.string.count))
        }

        let superViewArr:[UIView] = [naverSuperView,googleSuperView,appleSuperView]
        for sv in superViewArr {
            sv.backgroundColor = .white.withAlphaComponent(0.4)
            sv.layer.cornerRadius = 12
            sv.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
            sv.layer.borderWidth = 1
        }

        naverImageVIew.image = DesignSystemAsset.Signup.naver.image
        naverLoginButton.setAttributedTitle(loginAttributedString[0], for: .normal)
        googleImageView.image = DesignSystemAsset.Signup.google.image
        googleLoginButton.setAttributedTitle(loginAttributedString[1], for: .normal)
        appleImageView.image = DesignSystemAsset.Signup.apple.image
        appleLoginButton.setAttributedTitle(loginAttributedString[2], for: .normal)
    }
    private func configureService() {
        let serviceAttributedString = NSMutableAttributedString
            .init(string: "서비스 이용약관")
        
        serviceAttributedString.addAttributes([
            .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
            .foregroundColor: DesignSystemAsset.GrayColor.gray600.color],
            range: NSRange(location: 0, length: serviceAttributedString.string.count))
        
        let privacyAttributedString = NSMutableAttributedString
            .init(string: "개인정보처리방침")
        
        privacyAttributedString.addAttributes([
            .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
            .foregroundColor: DesignSystemAsset.GrayColor.gray600.color],
            range: NSRange(location: 0, length: privacyAttributedString.string.count)
        )
    }
}
