import DesignSystem
import SnapKit
import Then
import UIKit
import Utility

public protocol PlaylistImageEditSheetDelegate: AnyObject {
    func didTap(_ type: PlaylistImageEditType)
}

public class PlaylistImageEditSheetView: UIView {
    public weak var delegate: PlaylistImageEditSheetDelegate?

    private let galleryButton: VerticalAlignButton = VerticalAlignButton(
        title: "앨범에서 고르기",
        image: DesignSystemAsset.Playlist.album.image,
        spacing: .zero,
        textColor: .white
    )

    private let defaultButton: VerticalAlignButton = VerticalAlignButton(
        title: "임시",
        image: DesignSystemAsset.Playlist.album.image,
        spacing: .zero,
        textColor: .white
    )

    private lazy var stackView: UIStackView = UIStackView(arrangedSubviews: [galleryButton, defaultButton]).then {
        $0.spacing = 0
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.backgroundColor = .clear
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        addViews()
        setLayout()
        addAction()
        self.backgroundColor = DesignSystemAsset.PrimaryColorV2.point.color
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlaylistImageEditSheetView {
    private func addViews() {
        self.addSubviews(stackView)
    }

    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
        }
    }

    private func addAction() {
        galleryButton.addAction { [weak self] in
            guard let self else { return }
            self.delegate?.didTap(.gallery)
        }

        defaultButton.addAction { [weak self] in
            guard let self else { return }
            self.delegate?.didTap(.default)
        }
    }
}
