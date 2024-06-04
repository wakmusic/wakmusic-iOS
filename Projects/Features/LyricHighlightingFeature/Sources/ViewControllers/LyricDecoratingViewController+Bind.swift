import DesignSystem
import Foundation
import RxCocoa
import RxSwift
import UIKit

extension LyricDecoratingViewController {
    func inputBind() {
        input.fetchBackgroundImage.onNext(())

        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .do(onNext: { [collectionView] indexPath in
                collectionView.scrollToItem(
                    at: indexPath,
                    at: .centeredHorizontally,
                    animated: true
                )
            })
            .bind(to: input.didTapBackground)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .bind(with: self) { owner, _ in
                let activityViewController = UIActivityViewController(
                    activityItems: [owner.decorateShareContentView.asImage],
                    applicationActivities: nil
                )
                activityViewController.popoverPresentationController?.sourceRect = CGRect(
                    x: owner.view.bounds.midX,
                    y: owner.view.bounds.midY,
                    width: 0,
                    height: 0
                )
                activityViewController.popoverPresentationController?.permittedArrowDirections = []
                owner.present(activityViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }

    func outputBind() {
        output.updateSongTitle
            .bind(with: self) { owner, song in
                owner.songTitleLabel.text = song
                owner.songTitleLabel.setTextWithAttributes(alignment: .center)
            }
            .disposed(by: disposeBag)

        output.updateArtist
            .bind(with: self) { owner, artist in
                owner.artistLabel.text = artist
                owner.artistLabel.setTextWithAttributes(alignment: .center)
            }
            .disposed(by: disposeBag)

        output.dataSource
            .skip(1)
            .do(onNext: { [decorateImageView, indicator] entities in
                decorateImageView.backgroundColor = entities.filter { $0.isSelected }.first?
                    .imageColor ?? DesignSystemAsset.PrimaryColorV2.point.color
                indicator.stopAnimating()
            })
            .bind(to: collectionView.rx.items) { collectionView, index, model in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "\(LyricDecoratingCell.self)",
                    for: IndexPath(item: index, section: 0)
                ) as? LyricDecoratingCell else {
                    return UICollectionViewCell()
                }
                cell.update(model: model, index: index)
                return cell
            }
            .disposed(by: disposeBag)

        output.highlightingItems
            .filter { !$0.isEmpty }
            .bind(with: self) { owner, lyric in
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                style.lineSpacing = 8
                let attributedString = NSMutableAttributedString(
                    string: lyric,
                    attributes: [
                        .font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                        .foregroundColor: UIColor.white,
                        .kern: -0.5,
                        .paragraphStyle: style
                    ]
                )
                owner.highlightingLyricLabel.attributedText = attributedString
            }
            .disposed(by: disposeBag)
    }
}
