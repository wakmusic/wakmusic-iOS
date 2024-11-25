import BaseFeature
import BaseFeatureInterface
import DesignSystem
import PlaylistFeatureInterface
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

final class PlaylistDetailContainerViewController: BaseReactorViewController<PlaylistDetailContainerReactor>,
                                                   @preconcurrency ContainerViewType {
    var contentView: UIView! = UIView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
    }

    private var wmNavigationbarView: WMNavigationBarView = WMNavigationBarView()
    private let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
            .withTintColor(DesignSystemAsset.BlueGrayColor.blueGray900.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
    }

    private let unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory
    private let myPlaylistDetailFactory: any MyPlaylistDetailFactory
    private let textPopupFactory: any TextPopupFactory
    private let key: String
    lazy var unknownPlaylistVC = unknownPlaylistDetailFactory.makeView(key: key)
    lazy var myPlaylistVC = myPlaylistDetailFactory.makeView(key: key)

    init(
        reactor: PlaylistDetailContainerReactor,
        key: String,
        unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory,
        myPlaylistDetailFactory: any MyPlaylistDetailFactory,
        textPopupFactory: any TextPopupFactory
    ) {
        self.key = key
        self.unknownPlaylistDetailFactory = unknownPlaylistDetailFactory
        self.myPlaylistDetailFactory = myPlaylistDetailFactory
        self.textPopupFactory = textPopupFactory

        super.init(reactor: reactor)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func addView() {
        super.addView()
        self.view.addSubviews(contentView, wmNavigationbarView)
        wmNavigationbarView.setLeftViews([dismissButton])
    }

    override func setLayout() {
        super.setLayout()
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
    }

    override func bind(reactor: PlaylistDetailContainerReactor) {
        super.bind(reactor: reactor)

        PreferenceManager.shared.$userInfo
            .map(\.?.ID)
            .distinctUntilChanged()
            .bind(with: self) { owner, userInfo in

                owner.remove(asChildViewController: owner.children.first)

                if userInfo == nil {
                    reactor.action.onNext(.clearOwnerID)
                    owner.add(asChildViewController: owner.unknownPlaylistVC)
                } else {
                    reactor.action.onNext(.requestOwnerID)
                }
            }
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: PlaylistDetailContainerReactor) {
        super.bindAction(reactor: reactor)
        dismissButton.rx
            .tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: PlaylistDetailContainerReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        sharedState.map(\.isLoading)
            .distinctUntilChanged()
            .bind(with: self) { owner, isLoading in
                if isLoading {
                    owner.indicator.startAnimating()
                    owner.wmNavigationbarView.isHidden = false
                } else {
                    owner.indicator.stopAnimating()
                    owner.wmNavigationbarView.isHidden = true
                }
            }.disposed(by: disposeBag)

        sharedState.map(\.ownerID)
            .distinctUntilChanged()
            .compactMap { $0 }
            .withLatestFrom(PreferenceManager.shared.$userInfo) { ($0, $1) }
            .bind(with: self) { owner, info in

                let (ownerID, userInfo) = info

                guard let userInfo else { return }

                owner.remove(asChildViewController: owner.children.first)

                if ownerID == userInfo.decryptedID {
                    owner.add(asChildViewController: owner.myPlaylistVC)
                } else {
                    owner.add(asChildViewController: owner.unknownPlaylistVC)
                }
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$detectedNotFound)
            .compactMap { $0 }
            .bind(with: self) { owner, _ in
                let vc = owner.textPopupFactory.makeView(
                    text: "존재하지 않거나 비공개된 리스트입니다.",
                    cancelButtonIsHidden: true,
                    confirmButtonText: "확인",
                    cancelButtonText: nil,
                    completion: {
                        owner.navigationController?.popViewController(animated: true)
                    },
                    cancelCompletion: nil
                )

                owner.showBottomSheet(content: vc, dismissOnOverlayTapAndPull: false) // 드래그로 닫기 불가
            }
            .disposed(by: disposeBag)
    }
}
