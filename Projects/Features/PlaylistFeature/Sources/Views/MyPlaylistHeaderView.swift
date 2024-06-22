import DesignSystem
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

public protocol MyPlaylistHeaderStateProtocol {
    func updateEditState(_ isEditing: Bool)
    func updateData(_ title: String, _ songCount: Int, _ thumnail: String)
}

protocol MyPlaylistHeaderActionProtocol {
    var editNickNameButtonDidTap: Observable<Void> { get }
}

final class MyPlaylistHeaderView: UIView {
    private var thumbnailImageView: UIImageView = UIImageView().then {
        #warning("나중에 이미지 제거")
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.PlayListTheme.theme0.image
    }

    private let containerView: UIView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray25.color.withAlphaComponent(0.4)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.white.cgColor
        $0.clipsToBounds = true
    }

    private var titleLabel: WMLabel = WMLabel(
        text: "테스트",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t3(weight: .bold)
    ).then {
        $0.numberOfLines = 0
    }

    let countLabel: WMLabel = WMLabel(
        text: "3곡",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color.withAlphaComponent(0.6),
        font: .t6_1(weight: .light)
    )

    let editNickNameButton: UIButton = UIButton().then {
        $0.backgroundColor = .red
        var image = DesignSystemAsset.Storage.nicknameEdit.image
        image.withTintColor(.red, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addView()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPlaylistHeaderView {
    private func addView() {
        self.addSubviews(thumbnailImageView, containerView)
        containerView.addSubviews(titleLabel, countLabel, editNickNameButton)
    }

    private func setLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.width.height.equalTo(140)
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
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

    #warning("모델 및 편집상태 전달하기")
}

extension MyPlaylistHeaderView: MyPlaylistHeaderStateProtocol {
    func updateData(_ title: String, _ songCount: Int, _ thumnail: String) {
        titleLabel.text = title
        countLabel.text = "\(songCount)곡"
        #warning("이미지 업데이트")
    }

    func updateEditState(_ isEditing: Bool) {
        editNickNameButton.isHidden = !isEditing
    }
}

extension Reactive: MyPlaylistHeaderActionProtocol where Base: MyPlaylistHeaderView {
    var editNickNameButtonDidTap: Observable<Void> {
        base.editNickNameButton.rx.tap.asObservable()
    }
}
