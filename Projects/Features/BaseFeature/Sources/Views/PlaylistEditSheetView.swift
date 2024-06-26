import DesignSystem
import SnapKit
import Then
import UIKit
import Utility

public protocol PlaylistEditSheetDelegate: AnyObject {
    func didTap(_ type: PlaylistEditType)
}

public class PlaylistEditSheetView: UIView {
    public weak var delegate: PlaylistEditSheetDelegate?

    private let editButton: VerticalAlignButton = VerticalAlignButton(
        title: "편집",
        image: DesignSystemAsset.PlayListEdit.playlistEdit.image,
        titleColor: .white,
        spacing: .zero
    )

    private let shareButton: VerticalAlignButton = VerticalAlignButton(
        title: "공유하기",
        image: DesignSystemAsset.PlayListEdit.playlistShare.image,
        titleColor: .white,
        spacing: .zero
    )

    private lazy var stackView: UIStackView = UIStackView(arrangedSubviews: [editButton, shareButton]).then {
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

extension PlaylistEditSheetView {
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
        editButton.addAction { [weak self] in
            guard let self else { return }
            self.delegate?.didTap(.edit)
        }

        shareButton.addAction { [weak self] in
            guard let self else { return }
            self.delegate?.didTap(.share)
        }
    }
}
