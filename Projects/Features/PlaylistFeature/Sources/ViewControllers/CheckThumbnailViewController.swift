import BaseFeature
import DesignSystem
import LogManager
import PlaylistFeatureInterface
import SnapKit
import Then
import UIKit
import Utility
import RxCocoa
import RxSwift

final class CheckThumbnailViewController: BaseReactorViewController<CheckThumbnailReactor> {
    weak var delegate: CheckThumbnailDelegate?

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

    init(reactor: CheckThumbnailReactor,delegate: any CheckThumbnailDelegate) {
        self.delegate = delegate

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
        
        
        sharedState.map(\.imageData)
            .distinctUntilChanged()
            .bind(with: self) { owner, data in
                
                owner.thumbnailImageView.image = UIImage(data: data)
                
                if Double(data.count).megabytes > owner.limit {
                    
                    owner.showToast(text: "\(Int(owner.limit))MB를 넘었습니다.", font: .setFont(.t6(weight: .light)))
                    #warning("비활성화 디자인")
                    owner.confirmButton.isEnabled = false
                
                } else {
                    owner.confirmButton.isEnabled = true
                }
                
            }
            .disposed(by: disposeBag)
        
        
        sharedState.map(\.isLoading)
            .distinctUntilChanged()
            .bind(with: self) { owner, isLoading in
                
                if isLoading {
                    owner.indicator.startAnimating()
                } else {
                    owner.indicator.stopAnimating()
                }
                
                owner.thumbnailImageView.isHidden = isLoading
                owner.guideLineSuperView.isHidden = isLoading
                
            }
            .disposed(by: disposeBag)
        
        sharedState.map(\.guideLines)
            .distinctUntilChanged()
            .bind(with: self) { owner, guideLines in
                
                if guideLines.isEmpty  {
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
        
        backButton.addAction { [weak self] () in
            self?.navigationController?.popViewController(animated: true)
        }

//        confirmButton.addAction { [weak self] () in
//
//            guard let data = self? else {
//                return
//            }
//
//            self?.dismiss(animated: true, completion: {
//                self?.delegate?.receive(data)
//            })
//        }
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
