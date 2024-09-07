import BaseFeature
import DesignSystem
import LogManager
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import SafariServices
import SnapKit
import Then
import UIKit
import Utility

public class LoginViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

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
    @IBOutlet weak var copyrightLabel: UILabel!

    private let loadingContentView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
        $0.isHidden = true
    }

    private let activityIndicator = NVActivityIndicatorView(frame: .zero).then {
        $0.color = .white
        $0.type = .circleStrokeSpin
    }

    private var viewModel: LoginViewModel!
    private lazy var input = viewModel.input
    private lazy var output = viewModel.output
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLayout()
        configureUI()
        inputBind()
        outputBind()
    }

    public static func viewController(viewModel: LoginViewModel) -> LoginViewController {
        let viewController = LoginViewController.viewController(storyBoardName: "SignIn", bundle: Bundle.module)
        viewController.viewModel = viewModel
        return viewController
    }
}

private extension LoginViewController {
    func outputBind() {
        output.showToast
            .bind(with: self) { owner, message in
                owner.showToast(
                    text: message,
                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
                )
            }
            .disposed(by: disposeBag)

        output.dismissLoginScene
            .bind(with: self) { owner, provider in
                if provider == .google {
                    owner.dismiss(animated: true, completion: {
                        owner.dismiss(animated: true)
                    })
                } else {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)

        output.showLoading
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, show in
                owner.loadingContentView.isHidden = !show
                if show {
                    owner.activityIndicator.startAnimating()
                } else {
                    owner.activityIndicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
    }

    func inputBind() {
        closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        naverLoginButton.rx.tap
            .do(onNext: {
                let log = SigninAnalyticsLog.clickSocialLoginButton(type: .naver)
                LogManager.analytics(log)
            })
            .bind(to: input.didTapNaverLoginButton)
            .disposed(by: disposeBag)

        googleLoginButton.rx.tap
            .bind {
                let log = SigninAnalyticsLog.clickSocialLoginButton(type: .google)
                LogManager.analytics(log)
                GoogleLoginManager.shared.googleLoginRequest()
            }
            .disposed(by: disposeBag)

        appleLoginButton.rx.tap
            .do(onNext: {
                let log = SigninAnalyticsLog.clickSocialLoginButton(type: .apple)
                LogManager.analytics(log)
            })
            .bind(to: input.didTapAppleLoginButton)
            .disposed(by: disposeBag)

        serviceButton.rx.tap
            .bind(with: self) { owner, _ in
                let log = SigninAnalyticsLog.clickTermsOfServiceButton
                LogManager.analytics(log)

                let vc = ContractViewController.viewController(type: .service)
                vc.modalPresentationStyle = .fullScreen
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)

        privacyButton.rx.tap
            .bind(with: self) { owner, _ in
                let log = SigninAnalyticsLog.clickPrivacyPolicyButton
                LogManager.analytics(log)

                let vc = ContractViewController.viewController(type: .privacy)
                vc.modalPresentationStyle = .fullScreen
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

private extension LoginViewController {
    func addSubviews() {
        view.addSubview(loadingContentView)
        loadingContentView.addSubview(activityIndicator)
    }

    func setLayout() {
        loadingContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(30)
        }
    }

    func configureUI() {
        configureLoginButtonUI()
        configureServiceUI()
    }

    func configureLoginButtonUI() {
        let loginAttributedString: [NSMutableAttributedString] = [
            NSMutableAttributedString.init(string: "네이버로 로그인하기"),
            NSMutableAttributedString.init(string: "구글로 로그인하기"),
            NSMutableAttributedString.init(string: "애플로 로그인하기")
        ]

        for attr in loginAttributedString {
            attr.addAttributes(
                [
                    .font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                    .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                    .kern: -0.5
                ],
                range: NSRange(location: 0, length: attr.string.count)
            )
        }

        let superViewArr: [UIView] = [naverSuperView, googleSuperView, appleSuperView]
        for sv in superViewArr {
            sv.backgroundColor = .white.withAlphaComponent(0.4)
            sv.layer.cornerRadius = 12
            sv.layer.borderColor = DesignSystemAsset.BlueGrayColor.gray200.color.cgColor
            sv.layer.borderWidth = 1
        }

        naverImageVIew.image = DesignSystemAsset.Signup.naver.image
        naverLoginButton.setAttributedTitle(loginAttributedString[0], for: .normal)
        googleImageView.image = DesignSystemAsset.Signup.google.image
        googleLoginButton.setAttributedTitle(loginAttributedString[1], for: .normal)
        appleImageView.image = DesignSystemAsset.Signup.apple.image
        appleLoginButton.setAttributedTitle(loginAttributedString[2], for: .normal)
    }

    func configureServiceUI() {
        view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)
        appLogoImageView.image = DesignSystemAsset.Logo.applogo.image

        let appAttributedString = NSMutableAttributedString
            .init(string: "왁타버스 뮤직")

        appAttributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 20),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                .kern: -0.5
            ],
            range: NSRange(location: 0, length: appAttributedString.string.count)
        )
        appNameLabel.attributedText = appAttributedString

        let descriptionAttributedString = NSMutableAttributedString
            .init(string: "페이지를 이용하기 위해 로그인이 필요합니다.")

        descriptionAttributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray600.color,
                .kern: -0.5
            ],
            range: NSRange(location: 0, length: descriptionAttributedString.string.count)
        )
        descriptionLabel.attributedText = descriptionAttributedString

        let servicePrivacyButtons: [UIButton] = [serviceButton, privacyButton]
        let termsAttributedString: [NSMutableAttributedString] = [
            NSMutableAttributedString.init(string: "서비스 이용약관"),
            NSMutableAttributedString.init(string: "개인정보 처리방침")
        ]
        for attr in termsAttributedString {
            attr.addAttributes(
                [
                    .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                    .foregroundColor: DesignSystemAsset.BlueGrayColor.gray600.color,
                    .kern: -0.5
                ],
                range: NSRange(location: 0, length: attr.string.count)
            )
        }
        servicePrivacyButtons[0].setAttributedTitle(termsAttributedString[0], for: .normal)
        servicePrivacyButtons[1].setAttributedTitle(termsAttributedString[1], for: .normal)

        for btn in servicePrivacyButtons {
            btn.layer.cornerRadius = 8
            btn.layer.borderColor = DesignSystemAsset.BlueGrayColor.gray300.color.cgColor
            btn.layer.borderWidth = 1
            btn.clipsToBounds = true
        }

        versionLabel.text = "버전 정보 " + APP_VERSION()
        versionLabel.textColor = DesignSystemAsset.BlueGrayColor.gray400.color
        versionLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        versionLabel.setTextWithAttributes(kernValue: -0.5)
        versionLabel.textAlignment = .center

        copyrightLabel.text = "Copyright 2024. WAKTAVERS MUSIC. All rights reserved."
        copyrightLabel.textColor = DesignSystemAsset.BlueGrayColor.gray400.color
        copyrightLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        copyrightLabel.setTextWithAttributes(kernValue: -0.5)
        copyrightLabel.textAlignment = .center
        copyrightLabel.numberOfLines = 0
    }
}
