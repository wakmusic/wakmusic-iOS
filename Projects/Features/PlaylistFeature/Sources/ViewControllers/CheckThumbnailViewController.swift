import BaseFeature
import DesignSystem
import LogManager
import SnapKit
import Then
import UIKit
import Utility
import PlaylistFeatureInterface


final class CheckThumbnailViewController: UIViewController {
    
    weak var delegate: CheckThumbnailDelegate?
    
    private var wmNavigationbarView: WMNavigationBarView = WMNavigationBarView().then {
        $0.setTitle("앨범에서 고르기")
    }
    
    fileprivate let backButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
            .withTintColor(DesignSystemAsset.BlueGrayColor.blueGray900.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
    }
    
    private var imageData: Data?
    
    private lazy var thumbnailImageView: UIImageView = UIImageView().then {
        let image = UIImage(data: imageData ?? Data())
        $0.layer.cornerRadius = 32
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.image = image
        $0.backgroundColor = .yellow
    }
    
    private var guideLineSuperView: UIView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
    }
        
    private let guideLineTitleLabel: WMLabel = WMLabel(text: "유의사항" ,textColor: DesignSystemAsset.BlueGrayColor.blueGray600.color,font: .t5(weight: .medium))

    private let guideLines: [String] = ["이미지를 변경하면 음표 열매 3개를 소모합니다.", "너무 큰 이미지는 서버에 과부화가 올 수있으니 어쩌고asjdajsdjasdjasdjadja", "skdaskdkasdkp[asdkp[akdak[k[k"]
    
    private lazy var  guideLineStackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
        $0.distribution = .fillEqually

        let padding = NSTextAttachment()
       
        for gl in guideLines {
            var label: WMLabel = WMLabel(text: "", textColor: DesignSystemAsset.BlueGrayColor.gray500.color ,font: .t7(weight: .light)).then {
                $0.numberOfLines = 0
            }
            
            let attributedString = NSMutableAttributedString(string: gl)
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = DesignSystemAsset.Playlist.grayDot.image
            imageAttachment.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
            attributedString.insert(NSAttributedString(attachment: imageAttachment), at: 0)
            
            label.attributedText = attributedString
            
            $0.addArrangedSubview(label)

        }
        
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
    
    init(delegate: any CheckThumbnailDelegate, imageData: Data) {
        self.imageData = imageData
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setLayout()
        bindAction()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

private extension CheckThumbnailViewController {
    func addViews() {
        view.addSubviews(wmNavigationbarView, thumbnailImageView, guideLineSuperView)
        wmNavigationbarView.setLeftViews([backButton])
        
        guideLineSuperView.addSubviews(guideLineTitleLabel, guideLineStackView ,confirmButton)

    }

    func setLayout() {
        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        let max = APP_WIDTH() - 40
        
        thumbnailImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(wmNavigationbarView.snp.bottom).offset(66)
            $0.height.equalTo(max)
        }
        
        guideLineSuperView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(83)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
        guideLineTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        guideLineStackView.snp.makeConstraints {
            $0.top.equalTo(guideLineTitleLabel.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(15)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(guideLineStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func bindAction() {
        backButton.addAction { [weak self] () in
            self?.navigationController?.popViewController(animated: true)
        }
        
        confirmButton.addAction { [weak self] () in
          
            guard let data = self?.imageData else {
                return
            }
            
            self?.dismiss(animated: true, completion: {
                self?.delegate?.receive(data)
            })
        }
    }
}

extension CheckThumbnailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
