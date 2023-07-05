//
//  BeforeLoginStorageViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/24.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import NaverThirdPartyLogin
import RxSwift
import RxRelay
import AuthenticationServices
import CommonFeature

public class LoginViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fakeView: UIView!
    
    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var naverLoginButton: UIButton!
    @IBOutlet weak var naverImageVIew: UIImageView!
    @IBOutlet weak var naverSuperView: UIView!
    
    @IBOutlet weak var googleImageView: UIImageView!
    @IBOutlet weak var googleSuperView: UIView!
    @IBOutlet weak var googleLoginButton: UIButton!

    @IBOutlet weak var appleImageView: UIImageView!
    @IBOutlet weak var appleSuperView: UIView!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    @IBOutlet weak var serviceButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    var viewModel: LoginViewModel!

    private lazy var input = LoginViewModel.Input(
        pressNaverLoginButton: PublishRelay(),
        pressAppleLoginButton: PublishRelay()
    )
    private lazy var output = viewModel.transform(from: input)

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
        configureLogin()
    }

    public static func viewController(viewModel:LoginViewModel) -> LoginViewController {
        let viewController = LoginViewController.viewController(storyBoardName: "SignIn", bundle: Bundle.module)
        viewController.viewModel = viewModel
        return viewController
    }
}

extension LoginViewController{
    private func bindRx(){
        output
            .showErrorToast
            .subscribe(onNext: { [weak self] (msg: String) in
            guard let self = self else { return }
            self.showToast(text: msg, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
        }).disposed(by: disposeBag)
    }

    private func configureLogin() {
        appleLoginButton.rx.tap
            .bind(to: input.pressAppleLoginButton)
            .disposed(by: disposeBag)

        naverLoginButton.rx.tap
            .bind(to: input.pressNaverLoginButton)
            .disposed(by: disposeBag)

        googleLoginButton.rx.tap.bind {
            GoogleLoginManager.shared.googleLoginRequest()
        }.disposed(by: disposeBag)
        
        serviceButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                let vc = ContractViewController.viewController(type: .service)
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: true)
            }).disposed(by: disposeBag)

        privacyButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                let vc = ContractViewController.viewController(type: .privacy)
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: true)
            }).disposed(by: disposeBag)
    }
}

public extension LoginViewController{
    func scrollToTop() {
        scrollView.setContentOffset(.zero, animated: true)
    }
}
