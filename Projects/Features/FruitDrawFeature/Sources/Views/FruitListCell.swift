import DesignSystem
import UIKit
import UserDomainInterface

public protocol FruitListCellDelegate: AnyObject {
    func itemSelected(item: FruitEntity)
}

public final class FruitListCell: UICollectionViewCell {
    private let supportImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.noteSupport.image
    }

    private let noteStackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    private let firstNoteImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DesignSystemAsset.FruitDraw.unidentifiedNote.image
    }

    private let secondNoteImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DesignSystemAsset.FruitDraw.unidentifiedNote.image
    }

    private let thirdNoteImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DesignSystemAsset.FruitDraw.unidentifiedNote.image
    }

    private var items: [FruitEntity] = []
    public weak var delegate: FruitListCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setLayout()
        addTapGestureRecognizers()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FruitListCell {
    func update(model: [FruitEntity]) {
        self.items = model
        let notes = [firstNoteImageView, secondNoteImageView, thirdNoteImageView]
        notes.forEach { $0.alpha = 0 }

        for i in 0 ..< model.count {
            notes[i].alpha = 1
            if model[i].quantity == -1 {
                notes[i].image = DesignSystemAsset.FruitDraw.unidentifiedNote.image
            } else {
                notes[i].kf.setImage(with: URL(string: model[i].imageURL))
            }
        }
    }
}

private extension FruitListCell {
    func addSubViews() {
        contentView.addSubviews(supportImageView, noteStackView)
        noteStackView.addArrangedSubview(firstNoteImageView)
        noteStackView.addArrangedSubview(secondNoteImageView)
        noteStackView.addArrangedSubview(thirdNoteImageView)
    }

    func setLayout() {
        supportImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }

        noteStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview()
        }
    }

    func addTapGestureRecognizers() {
        [firstNoteImageView, secondNoteImageView, thirdNoteImageView].forEach {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
            $0.addGestureRecognizer(gesture)
            $0.isUserInteractionEnabled = true
        }
    }

    @objc private func imageViewTapped(_ sender: UITapGestureRecognizer) {
        if let tappedImageView = sender.view {
            if tappedImageView == firstNoteImageView, items[0].quantity != -1 {
                delegate?.itemSelected(item: items[0])
            } else if tappedImageView == secondNoteImageView, items[1].quantity != -1 {
                delegate?.itemSelected(item: items[1])
            } else if tappedImageView == thirdNoteImageView, items[2].quantity != -1 {
                delegate?.itemSelected(item: items[2])
            }
        }
    }
}
