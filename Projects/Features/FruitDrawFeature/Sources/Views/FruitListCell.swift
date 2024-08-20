import DesignSystem
import UIKit
import UserDomainInterface
import Utility

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

    private let firstNoteContentView = UIView()
    private let secondNoteContentView = UIView()
    private let thirdNoteContentView = UIView()

    private let firstNoteImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let firstNoteShadowImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DesignSystemAsset.FruitDraw.noteShadow.image
    }

    private let secondNoteImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let secondNoteShadowImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DesignSystemAsset.FruitDraw.noteShadow.image
    }

    private let thirdNoteImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let thirdNoteShadowImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DesignSystemAsset.FruitDraw.noteShadow.image
    }

    private var items: [FruitEntity] = []
    weak var delegate: FruitListCellDelegate?

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
    func update(
        model: [FruitEntity],
        floor: Int,
        totalCount: Int
    ) {
        self.items = model
        let notes = [firstNoteImageView, secondNoteImageView, thirdNoteImageView]
        let shadows = [firstNoteShadowImageView, secondNoteShadowImageView, thirdNoteShadowImageView]
        notes.forEach { $0.alpha = 0 }
        shadows.forEach { $0.alpha = 0 }

        for i in 0 ..< model.count {
            notes[i].alpha = 1
            shadows[i].alpha = 1

            if model[i].quantity == -1 {
                notes[i].image = totalCount > 15 ?
                    DesignSystemAsset.FruitDraw.unidentifiedNote.image :
                    floorToImage(with: floor)
            } else {
                notes[i].kf.setImage(
                    with: URL(string: model[i].imageURL),
                    placeholder: nil,
                    options: [.transition(.fade(0.2))]
                )
            }
        }
    }
}

private extension FruitListCell {
    func addTapGestureRecognizers() {
        [firstNoteImageView, secondNoteImageView, thirdNoteImageView].forEach {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedNoteImageView(_:)))
            $0.addGestureRecognizer(gesture)
            $0.isUserInteractionEnabled = true
        }
    }

    @objc private func tappedNoteImageView(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view {
            if imageView == firstNoteImageView {
                delegate?.itemSelected(item: items[0])
            } else if imageView == secondNoteImageView {
                delegate?.itemSelected(item: items[1])
            } else if imageView == thirdNoteImageView {
                delegate?.itemSelected(item: items[2])
            }
        }
    }

    func floorToImage(with floor: Int) -> UIImage {
        switch floor {
        case 0:
            return DesignSystemAsset.FruitDraw.unidentifiedNote1st.image
        case 1:
            return DesignSystemAsset.FruitDraw.unidentifiedNote2nd.image
        case 2:
            return DesignSystemAsset.FruitDraw.unidentifiedNote3rd.image
        case 3:
            return DesignSystemAsset.FruitDraw.unidentifiedNote4th.image
        case 4:
            return DesignSystemAsset.FruitDraw.unidentifiedNote5th.image
        default:
            return DesignSystemAsset.FruitDraw.unidentifiedNote.image
        }
    }
}

private extension FruitListCell {
    func addSubViews() {
        contentView.addSubviews(supportImageView, noteStackView)

        firstNoteContentView.addSubviews(firstNoteShadowImageView, firstNoteImageView)
        secondNoteContentView.addSubviews(secondNoteShadowImageView, secondNoteImageView)
        thirdNoteContentView.addSubviews(thirdNoteShadowImageView, thirdNoteImageView)

        noteStackView.addArrangedSubview(firstNoteContentView)
        noteStackView.addArrangedSubview(secondNoteContentView)
        noteStackView.addArrangedSubview(thirdNoteContentView)
    }

    func setLayout() {
        supportImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(APP_WIDTH() - 40)
            $0.height.equalTo(26)
        }

        [firstNoteShadowImageView, secondNoteShadowImageView, thirdNoteShadowImageView].forEach {
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(supportImageView.snp.bottom).offset(-11)
            }
        }

        [firstNoteImageView, secondNoteImageView, thirdNoteImageView].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }

        noteStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-15)
        }
    }
}
