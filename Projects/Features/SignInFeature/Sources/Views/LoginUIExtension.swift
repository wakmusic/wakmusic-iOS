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
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5],
                range: NSRange(location: 0, length: attr.string.count)
            )
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
        let appAttributedString = NSMutableAttributedString
            .init(string: "왁타버스 뮤직")
        
        appAttributedString.addAttributes([
            .font: DesignSystemFontFamily.Pretendard.medium.font(size: 20),
            .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
            .kern: -0.5],
            range: NSRange(location: 0, length: appAttributedString.string.count)
        )
        appNameLabel.attributedText = appAttributedString
        
        let descriptionAttributedString = NSMutableAttributedString
            .init(string: "페이지를 이용하기 위해 로그인이 필요합니다.")
        
        descriptionAttributedString.addAttributes([
            .font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
            .foregroundColor: DesignSystemAsset.GrayColor.gray600.color,
            .kern: -0.5],
            range: NSRange(location: 0, length: descriptionAttributedString.string.count)
        )
        descriptionLabel.attributedText = descriptionAttributedString
    }
}
