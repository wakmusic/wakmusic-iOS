import ArtistDomainInterface
import DesignSystem
import LogManager
import RxCocoa
import RxSwift
import UIKit
import Utility

public final class ArtistDetailViewController: UIViewController, ViewControllerFromStoryBoard, ContainerViewType {
    @IBOutlet weak var gradationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var subscriptionButton: UIButton!
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var headerContentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet public weak var contentView: UIView!

    private lazy var headerViewController: ArtistDetailHeaderViewController = {
        let header = ArtistDetailHeaderViewController.viewController()
        return header
    }()

    private lazy var contentViewController: ArtistMusicViewController = {
        let content = artistMusicComponent.makeView(model: viewModel.model)
        return content
    }()

    private let gradientLayer = CAGradientLayer()
    private var artistMusicComponent: ArtistMusicComponent!

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
        configureHeader()
        configureContent()
        bind()
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
        artistMusicComponent: ArtistMusicComponent
    ) -> ArtistDetailViewController {
        let viewController = ArtistDetailViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.artistMusicComponent = artistMusicComponent
        return viewController
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

private extension ArtistDetailViewController {
    func bind() {
        output.isSubscription
            .skip(1)
            .bind(to: subscriptionButton.rx.isSelected)
            .disposed(by: disposeBag)

        output.showToast
            .bind(with: self) { owner, message in
                owner.showToast(
                    text: message,
                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
                    verticalOffset: 56 + 10
                )
            }
            .disposed(by: disposeBag)

        input.fetchArtistSubscriptionStatus.onNext(())

        subscriptionButton.rx.tap
            .throttle(.milliseconds(1000), latest: false, scheduler: MainScheduler.instance)
            .bind(to: input.subscriptionArtist)
            .disposed(by: disposeBag)
    }

    func configureUI() {
        backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        subscriptionButton.setImage(DesignSystemAsset.Artist.subscriptionOff.image, for: .normal)
        subscriptionButton.setImage(DesignSystemAsset.Artist.subscriptionOn.image, for: .selected)

        let model = viewModel.model
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

    func configureHeader() {
        self.addChild(headerViewController)
        self.headerContentView.addSubview(headerViewController.view)
        headerViewController.didMove(toParent: self)

        headerViewController.view.snp.makeConstraints {
            $0.edges.equalTo(headerContentView)
        }

        let model = viewModel.model
        headerViewController.update(model: model)
    }

    func configureContent() {
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
