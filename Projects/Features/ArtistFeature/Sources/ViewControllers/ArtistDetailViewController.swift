import ArtistDomainInterface
import BaseFeatureInterface
import DesignSystem
import LogManager
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import SignInFeatureInterface
import UIKit
import Utility

public final class ArtistDetailViewController: UIViewController, ViewControllerFromStoryBoard, @preconcurrency ContainerViewType {
    @IBOutlet weak var gradationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var subscriptionButton: UIButton!
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var headerContentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet public weak var contentView: UIView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    private lazy var headerViewController: ArtistDetailHeaderViewController = {
        let header = ArtistDetailHeaderViewController.viewController()
        return header
    }()

    private var contentViewController: ArtistMusicViewController?

    private let gradientLayer = CAGradientLayer()
    private var artistMusicComponent: ArtistMusicComponent!
    private var textPopupFactory: TextPopupFactory!
    private var signInFactory: SignInFactory!

    private var viewModel: ArtistDetailViewModel!
    private lazy var input = ArtistDetailViewModel.Input()
    private lazy var output = viewModel.transform(from: input)
    private let disposeBag = DisposeBag()

    private var maxHeaderHeight: CGFloat {
        let margin: CGFloat = 8.0 + 20.0
        let width = (140 * APP_WIDTH()) / 375.0
        let height = (180 * width) / 140.0
        return -(margin + height)
    }

    private let minHeaderHeight: CGFloat = 0
    private var previousScrollOffset: [CGFloat] = [0, 0, 0]

    deinit {
        LogManager.printDebug("\(Self.self) Deinit")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        outputBind()
        inputBind()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogManager.analytics(ArtistAnalyticsLog.viewPage(pageName: "artist_detail"))
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientLayer.frame = self.gradationView.bounds
    }

    public static func viewController(
        viewModel: ArtistDetailViewModel,
        artistMusicComponent: ArtistMusicComponent,
        textPopupFactory: TextPopupFactory,
        signInFactory: SignInFactory
    ) -> ArtistDetailViewController {
        let viewController = ArtistDetailViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.artistMusicComponent = artistMusicComponent
        viewController.textPopupFactory = textPopupFactory
        viewController.signInFactory = signInFactory
        return viewController
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

private extension ArtistDetailViewController {
    func outputBind() {
        output.dataSource
            .filter { $0 != nil }
            .compactMap { $0 }
            .bind(with: self) { owner, entity in
                owner.configureGradation(model: entity)
                owner.configureHeader(model: entity)
                owner.configureContent(model: entity)
                owner.activityIndicator.stopAnimating()
            }
            .disposed(by: disposeBag)

        output.isSubscription
            .skip(1)
            .bind { [subscriptionButton] isSubscription in
                subscriptionButton?.isHidden = false
                subscriptionButton?.isSelected = isSubscription
            }
            .disposed(by: disposeBag)

        output.showLogin
            .bind(with: self) { owner, entry in
                let viewController = owner.textPopupFactory.makeView(
                    text: "로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?",
                    cancelButtonIsHidden: false,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        let log = CommonAnalyticsLog.clickLoginButton(entry: entry)
                        LogManager.analytics(log)
                        let loginVC = owner.signInFactory.makeView()
                        loginVC.modalPresentationStyle = .fullScreen
                        owner.present(loginVC, animated: true)
                    },
                    cancelCompletion: {}
                )
                owner.showBottomSheet(content: viewController)
            }
            .disposed(by: disposeBag)

        output.showToast
            .bind(with: self) { owner, message in
                owner.showToast(text: message, options: [.tabBar])
            }
            .disposed(by: disposeBag)

        output.occurredError
            .bind(with: self) { owner, message in
                owner.showBottomSheet(
                    content: owner.textPopupFactory.makeView(
                        text: message,
                        cancelButtonIsHidden: true,
                        confirmButtonText: "확인",
                        cancelButtonText: nil,
                        completion: {
                            owner.navigationController?.popViewController(animated: true)
                        },
                        cancelCompletion: nil
                    ),
                    dismissOnOverlayTapAndPull: false
                )
            }
            .disposed(by: disposeBag)

        output.showWarningNotification
            .bind(with: self) { owner, _ in
                let viewController = owner.textPopupFactory.makeView(
                    text: "기기 알림이 꺼져있습니다.\n설정에서 알림을 켜주세요.",
                    cancelButtonIsHidden: false,
                    confirmButtonText: "설정 바로가기",
                    cancelButtonText: "확인",
                    completion: {
                        guard let openSettingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(openSettingsURL)
                    },
                    cancelCompletion: {}
                )
                owner.showBottomSheet(content: viewController)
            }
            .disposed(by: disposeBag)
    }

    func inputBind() {
        input.fetchArtistDetail.onNext(())
        input.fetchArtistSubscriptionStatus.onNext(())

        subscriptionButton.rx.tap
            .throttle(.milliseconds(1000), latest: false, scheduler: MainScheduler.instance)
            .bind(to: input.didTapSubscription)
            .disposed(by: disposeBag)
    }

    func configureUI() {
        backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        subscriptionButton.setImage(DesignSystemAsset.Artist.subscriptionOff.image, for: .normal)
        subscriptionButton.setImage(DesignSystemAsset.Artist.subscriptionOn.image, for: .selected)
        subscriptionButton.isHidden = true
        activityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.startAnimating()
    }

    func configureGradation(model: ArtistEntity) {
        let flatColor: String = model.personalColor
        guard !flatColor.isEmpty else { return }

        let startAlpha: CGFloat = 0.6
        let value: CGFloat = 0.1
        let colors = Array(0 ... Int(startAlpha * 10)).enumerated().map { i, _ in
            return colorFromRGB(flatColor, alpha: startAlpha - (CGFloat(i) * value)).cgColor
        }

        gradientLayer.colors = colors
        gradationView.layer.addSublayer(gradientLayer)
    }

    func configureHeader(model: ArtistEntity) {
        self.addChild(headerViewController)
        self.headerContentView.addSubview(headerViewController.view)
        headerViewController.didMove(toParent: self)

        headerViewController.view.snp.makeConstraints {
            $0.edges.equalTo(headerContentView)
        }
        headerViewController.update(model: model)
    }

    func configureContent(model: ArtistEntity) {
        contentViewController = artistMusicComponent.makeView(model: model)
        self.add(asChildViewController: contentViewController)
    }
}

extension ArtistDetailViewController {
    func scrollViewDidScrollFromChild(scrollView: UIScrollView, i: Int) {
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset[i]
        let absoluteTop: CGFloat = 0
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom

        if scrollView.contentOffset.y < absoluteBottom {
            var newHeight = self.headerContentViewTopConstraint.constant

            if isScrollingDown {
                newHeight = max(self.maxHeaderHeight, self.headerContentViewTopConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                if scrollView.contentOffset.y <= abs(self.maxHeaderHeight) {
                    newHeight = min(
                        self.minHeaderHeight,
                        self.headerContentViewTopConstraint.constant + abs(scrollDiff)
                    )
                }
            }

            if newHeight != self.headerContentViewTopConstraint.constant {
                self.headerContentViewTopConstraint.constant = newHeight
                self.updateHeader()
            }
            self.view.layoutIfNeeded()
            self.previousScrollOffset[i] = scrollView.contentOffset.y
        }
    }

    private func updateHeader() {
        let openAmount = self.headerContentViewTopConstraint.constant + abs(self.maxHeaderHeight)
        let percentage = openAmount / abs(self.maxHeaderHeight)
        self.headerContentView.alpha = percentage
    }
}
