import BaseFeature
import BaseFeatureInterface
import DesignSystem
import LogManager
import PlaylistFeatureInterface
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

final class CheckThumbnailViewController: BaseReactorViewController<CheckThumbnailReactor> {
    weak var delegate: CheckThumbnailDelegate?

    private let textPopUpFactory: any TextPopUpFactory
    private let limit: Double = 10.0

    private var wmNavigationbarView: WMNavigationBarView = WMNavigationBarView().then {
        $0.setTitle("앨범에서 고르기")
    }

    fileprivate let backButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
            .withTintColor(DesignSystemAsset.BlueGrayColor.blueGray900.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
    }

    private var thumnailContainerView: UIView = UIView()

    private lazy var thumbnailImageView: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = 32
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.isHidden = true // 로딩 끝난 후 해제
    }

    private var guideLineSuperView: UIView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        $0.isHidden = true // 로딩 끝난 후 해제
    }

    private let guideLineTitleLabel: WMLabel = WMLabel(
        text: "유의사항",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray600.color,
        font: .t5(weight: .medium)
    )

    #warning("코스트 포함해서 가이드라인을 외부에서 주입해야함 ")

    private lazy var guideLineStackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.distribution = .fill
    }

    private let confirmButton: UIButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .setFont(.t4(weight: .medium))
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = DesignSystemAsset.PrimaryColorV2.point.color
    }

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    init(reactor: CheckThumbnailReactor, textPopUpFactory: any TextPopUpFactory, delegate: any CheckThumbnailDelegate) {
        self.delegate = delegate
        self.textPopUpFactory = textPopUpFactory

        super.init(reactor: reactor)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        reactor?.action.onNext(.viewDidLoad)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    override func addView() {
        super.addView()

        view.addSubviews(wmNavigationbarView, thumnailContainerView, guideLineSuperView)
        wmNavigationbarView.setLeftViews([backButton])
        thumnailContainerView.addSubviews(thumbnailImageView)
        guideLineSuperView.addSubviews(guideLineTitleLabel, guideLineStackView, confirmButton)
    }

    override func setLayout() {
        super.setLayout()

        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }

        thumnailContainerView.snp.makeConstraints {
            $0.top.equalTo(wmNavigationbarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(thumbnailImageView.snp.width)
            $0.center.equalToSuperview()
        }

        guideLineSuperView.snp.makeConstraints {
            $0.top.equalTo(thumnailContainerView.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }

        guideLineTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }

        guideLineStackView.snp.makeConstraints {
            $0.top.equalTo(guideLineTitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalTo(guideLineStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    override func bindState(reactor: CheckThumbnailReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        sharedState.map(\.isLoading)
            .withLatestFrom(sharedState.map(\.imageData)) { ($0, $1) }
            .bind(with: self) { owner, info in

                let (isLoading, data) = info

                if isLoading {
                    owner.indicator.startAnimating()
                } else {
                    owner.indicator.stopAnimating()
                }

                owner.thumbnailImageView.image = UIImage(data: data)
                owner.thumbnailImageView.isHidden = isLoading
                owner.guideLineSuperView.isHidden = isLoading

        
                if Double(data.count).megabytes > owner.limit {
                    let textPopupVC = owner.textPopUpFactory.makeView(
                        text: "업로드에 실패했습니다.\n파일당 10MB까지 업로드할 수 있습니다.",
                        cancelButtonIsHidden: true,
                        confirmButtonText: nil,
                        cancelButtonText: nil, completion: {
                            owner.dismiss(animated: true)
                        }, cancelCompletion: nil
                    )

                    owner.wmNavigationbarView.isHidden = true
                    owner.thumnailContainerView.isHidden = true
                    owner.guideLineSuperView.isHidden = true
                    owner.showBottomSheet(content: textPopupVC)
                }
            }
            .disposed(by: disposeBag)

        sharedState.map(\.guideLines)
            .distinctUntilChanged()
            .bind(with: self) { owner, guideLines in

                if guideLines.isEmpty {
                    return
                }

                owner.generateGuideView(guideLines: guideLines).forEach { view in
                    owner.guideLineStackView.addArrangedSubviews(view)
                }
            }
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: CheckThumbnailReactor) {
        super.bindAction(reactor: reactor)


        backButton.rx
            .tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        confirmButton.rx
            .tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true, completion: {
                    owner.delegate?.receive(reactor.currentState.imageData)
                })
            }
            .disposed(by: disposeBag)
        
        
        
    }
}

extension CheckThumbnailViewController {
    func generateGuideView(guideLines: [String]) -> [UIView] {
        var views: [UIView] = []

        for gl in guideLines {
            var label: WMLabel = WMLabel(
                text: "\(gl)",
                textColor: DesignSystemAsset.BlueGrayColor.gray500.color,
                font: .t7(weight: .light),
                alignment: .left,
                lineHeight: 18
            ).then {
                $0.numberOfLines = 0
            }

            let containerView: UIView = UIView()
            let imageView = UIImageView(image: DesignSystemAsset.Playlist.grayDot.image).then {
                $0.contentMode = .scaleAspectFit
            }
            containerView.addSubviews(imageView, label)

            imageView.snp.makeConstraints {
                $0.size.equalTo(16)
                $0.leading.top.equalToSuperview()
            }
            label.snp.makeConstraints {
                $0.leading.equalTo(imageView.snp.trailing)
                $0.top.trailing.bottom.equalToSuperview()
            }

            views.append(containerView)
        }

        return views
    }
}

extension CheckThumbnailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
