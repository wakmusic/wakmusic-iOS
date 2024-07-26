import ChartDomainInterface
import DesignSystem
import Kingfisher
import Lottie
import SnapKit
import Then
import UIKit
import Utility

final class YoutubeThumbnailCell: UICollectionViewCell {
    private let lottieView = LottieAnimationView(name: "Weekly_WM", bundle: DesignSystemResources.bundle).then {
        $0.loopMode = .loop
        $0.isHidden = true
    }

    private let thumbnailView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YoutubeThumbnailCell {
    private func addSubviews() {
        contentView.addSubviews(thumbnailView, lottieView)
    }

    private func setLayout() {
        thumbnailView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }

        lottieView.snp.makeConstraints {
            $0.centerX.equalTo(thumbnailView.snp.centerX)
            $0.top.equalTo(thumbnailView).offset(40)
            $0.width.height.equalTo(124)
        }
    }

    private func configureUI() {
        #warning("실제 도입 시 frame 변수 제거 고민")

        thumbnailView.layer.cornerRadius = frame.height * 50 / 292

        lottieView.play()
    }

    public func update(model: CurrentVideoEntity) {
        let url = WMImageAPI.fetchYoutubeThumbnailHD(id: model.id).toURL
        let subUrl = WMImageAPI.fetchYoutubeThumbnail(id: model.id).toURL

        thumbnailView.kf.setImage(with: url) { [lottieView, thumbnailView] result in

            switch result {
            case .failure:
                thumbnailView.kf.setImage(with: subUrl)
            case let .success(_):
                lottieView.isHidden = false
            }
        }
    }
}
