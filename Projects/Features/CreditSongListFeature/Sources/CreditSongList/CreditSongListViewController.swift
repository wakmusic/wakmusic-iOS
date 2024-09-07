import BaseFeature
import CreditSongListFeatureInterface
import DesignSystem
import LogManager
import RxSwift
import SnapKit
import UIKit
import Utility

final class CreditSongListViewController: BaseReactorViewController<CreditSongListReactor> {
    private let creditProfileGradientContainerView = UIView().then {
        $0.alpha = 0.6
    }

    private let wmNavigationBar = WMNavigationBarView()
    private let dismissButton = UIButton(type: .system).then {
        $0.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        $0.tintColor = .black
    }

    private let creditProfileView = CreditProfileView()
    private let creditSongListTabViewController: UIViewController
    private var creditSongListTabView: UIView { creditSongListTabViewController.view }

    private var creditProfileViewTopConstraint: NSLayoutConstraint?
    private var minusCreditProfileViewMaxHeight: CGFloat = 0
    private var scrollHistory: [Int: CGFloat] = [:]

    private var profileGradientLayer: CAGradientLayer?

    init(
        reactor: Reactor,
        creditSongListTabFactory: any CreditSongListTabFactory
    ) {
        self.creditSongListTabViewController = creditSongListTabFactory.makeViewController(
            workerName: reactor.workerName
        )
        super.init(reactor: reactor)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let log = CommonAnalyticsLog.viewPage(pageName: .creditSongList)
        LogManager.analytics(log)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if profileGradientLayer == nil {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                DesignSystemAsset.BlueGrayColor.blueGray900.color.cgColor,
                DesignSystemAsset.BlueGrayColor.blueGray900.color.withAlphaComponent(0.0).cgColor
            ]
            gradientLayer.frame = creditProfileGradientContainerView.bounds
            creditProfileGradientContainerView.layer.addSublayer(gradientLayer)
            profileGradientLayer = gradientLayer
        }

        if minusCreditProfileViewMaxHeight == 0, creditProfileView.frame.height != 0 {
            minusCreditProfileViewMaxHeight = -creditProfileView.frame.height
        }
    }

    override func addView() {
        addChild(creditSongListTabViewController)
        view.addSubviews(creditSongListTabView)
        creditSongListTabViewController.didMove(toParent: self)

        view.addSubviews(creditProfileGradientContainerView, wmNavigationBar, creditProfileView)
        wmNavigationBar.setLeftViews([dismissButton])
    }

    override func setLayout() {
        creditProfileGradientContainerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(210)
        }

        wmNavigationBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(STATUS_BAR_HEGHIT())
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }

        creditProfileViewTopConstraint = creditProfileView.topAnchor.constraint(
            equalTo: wmNavigationBar.bottomAnchor,
            constant: 8
        )
        creditProfileViewTopConstraint?.isActive = true

        creditProfileView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        creditSongListTabView.snp.makeConstraints {
            $0.top.equalTo(creditProfileView.snp.bottom).offset(24)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    override func configureUI() {
        view.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
    }

    override func configureNavigation() {}

    override func bindAction(reactor: CreditSongListReactor) {
        self.rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        dismissButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: CreditSongListReactor) {
        let sharedState = reactor.state.share()

        sharedState.map(\.profile)
            .bind(with: creditProfileView) { view, entity in
                view.updateProfile(entity: entity)
            }
            .disposed(by: disposeBag)

        CreditSongListScopedState.shared.creditSongTabItemScrolledObservable
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, scrollView in
                owner.songListDidScroll(scrollView: scrollView)
            }
            .disposed(by: disposeBag)
    }
}

private extension CreditSongListViewController {
    func songListDidScroll(scrollView: UIScrollView) {
        guard let creditProfileViewTopConstraint else { return }

        let scrollDiff = scrollView.contentOffset.y - scrollHistory[
            scrollView.hash,
            default: scrollView.contentOffset.y
        ]
        let absoluteTop: CGFloat = 0
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom

        if scrollView.contentOffset.y < absoluteBottom {
            var newHeight = creditProfileViewTopConstraint.constant

            if isScrollingDown {
                newHeight = max(
                    minusCreditProfileViewMaxHeight,
                    creditProfileViewTopConstraint.constant - abs(scrollDiff)
                )
            } else if isScrollingUp {
                if scrollView.contentOffset.y <= abs(minusCreditProfileViewMaxHeight) {
                    newHeight = min(
                        8,
                        creditProfileViewTopConstraint.constant + abs(scrollDiff)
                    )
                }
            }

            if newHeight != creditProfileViewTopConstraint.constant {
                creditProfileViewTopConstraint.constant = newHeight

                let openAmount = creditProfileViewTopConstraint.constant + abs(minusCreditProfileViewMaxHeight)
                let percentage = openAmount / abs(minusCreditProfileViewMaxHeight)
                creditProfileView.alpha = percentage

                self.view.layoutIfNeeded()
            }

            scrollHistory[scrollView.hash] = scrollView.contentOffset.y
        }
    }
}
