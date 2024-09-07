import DesignSystem
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

private protocol MyPlaylistHeaderStateProtocol {
    func updateEditState(_ isEditing: Bool)
    func updateData(_ model: PlaylistDetailHeaderModel)
    func updateThumbnailFromGallery(_ data: Data)
    func updateThumbnailByDefault(_ url: String)
}

private protocol MyPlaylistHeaderActionProtocol {
    var editNickNameButtonDidTap: Observable<Void> { get }
    var cameraButtonDidTap: Observable<Void> { get }
}

final class MyPlaylistHeaderView: UIView {
    fileprivate let tapGestureRecognizer = UITapGestureRecognizer()

    private var thumbnailImageView: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }

    private let cameraContainerView: UIView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray900.color.withAlphaComponent(0.8)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private let cameraImageView: UIImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Storage.camera.image
        $0.contentMode = .scaleAspectFill
    }

    private let containerView: UIView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray25.color.withAlphaComponent(0.4)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.white.cgColor
        $0.clipsToBounds = true
    }

    private let titleLabel: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t3(weight: .bold),
        lineHeight: UIFont.WMFontSystem.t3(weight: .bold).lineHeight
    ).then {
        $0.numberOfLines = 0
    }

    let countLabel: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray600.color,
        font: .t6_1(weight: .light),
        lineHeight: UIFont.WMFontSystem.t6_1(weight: .light).lineHeight
    )

    let editNickNameButton: UIButton = UIButton().then {
        var image = DesignSystemAsset.Storage.storageEdit.image
        $0.setImage(image, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addView()
        setLayout()
        bindAction()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPlaylistHeaderView {
    private func addView() {
        self.addSubviews(thumbnailImageView, containerView, cameraContainerView)
        cameraContainerView.addSubviews(cameraImageView)
        containerView.addSubviews(titleLabel, countLabel, editNickNameButton)
    }

    private func setLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.width.height.equalTo(140)
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }

        cameraContainerView.snp.makeConstraints {
            $0.width.height.equalTo(140)
            $0.verticalEdges.horizontalEdges.equalTo(thumbnailImageView)
        }

        cameraImageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.center.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        countLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel.snp.leading)
        }

        editNickNameButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.leading.equalTo(countLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(countLabel.snp.centerY)
        }
    }

    private func bindAction() {
        cameraContainerView.addGestureRecognizer(tapGestureRecognizer)
        cameraImageView.isUserInteractionEnabled = true
    }
}

extension MyPlaylistHeaderView: MyPlaylistHeaderStateProtocol {
    func updateData(_ model: PlaylistDetailHeaderModel) {
        titleLabel.text = model.title
        countLabel.text = "\(model.songCount)곡"
        thumbnailImageView.kf.setImage(with: URL(string: model.image))
    }

    func updateEditState(_ isEditing: Bool) {
        editNickNameButton.isHidden = !isEditing
        cameraContainerView.isHidden = !isEditing
    }

    func updateThumbnailFromGallery(_ data: Data) {
        thumbnailImageView.image = UIImage(data: data)
    }

    func updateThumbnailByDefault(_ url: String) {
        thumbnailImageView.kf.setImage(with: URL(string: url))
    }
}

extension Reactive: MyPlaylistHeaderActionProtocol where Base: MyPlaylistHeaderView {
    var editNickNameButtonDidTap: Observable<Void> {
        base.editNickNameButton.rx.tap.asObservable()
    }

    var cameraButtonDidTap: Observable<Void> {
        base.tapGestureRecognizer.rx.event.map { _ in }.asObservable()
    }
}
