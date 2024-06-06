import DesignSystem
import Foundation
import LogManager
import UIKit
import LyricHighlightingFeatureInterface

extension LyricHighlightingViewController {
    func inputBind() {
        input.fetchLyric.onNext(())

        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .bind(to: input.didTapHighlighting)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .bind(to: input.didTapSaveButton)
            .disposed(by: disposeBag)
    }

    func outputBind() {
        output.updateSongTitle
            .bind(with: self) { owner, song in
                owner.songLabel.text = song
                owner.songLabel.setTextWithAttributes(alignment: .center)
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
            .do(onNext: { [indicator] _ in
                indicator.stopAnimating()
            })
            .bind(to: collectionView.rx.items) { collectionView, index, entity in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "\(LyricHighlightingCell.self)",
                    for: IndexPath(item: index, section: 0)
                ) as? LyricHighlightingCell else {
                    return UICollectionViewCell()
                }
                cell.update(entity: entity)
                return cell
            }
            .disposed(by: disposeBag)

        output.isStorable
            .bind(with: self) { owner, isStorable in
                let color = isStorable ?
                    DesignSystemAsset.PrimaryColorV2.point.color :
                    DesignSystemAsset.NewGrayColor.gray900.color
                owner.saveButtonContentView.backgroundColor = color
                let image = isStorable ?
                    DesignSystemAsset.LyricHighlighting.lyricHighlightSaveOn.image :
                    DesignSystemAsset.LyricHighlighting.lyricHighlightSaveOff.image
                owner.saveButton.setImage(image, for: .normal)
            }
            .disposed(by: disposeBag)

        output.goDecoratingScene
            .bind(with: self) { owner, model in
                let viewController = owner.lyricDecoratingComponent.makeView(
                    model: .init(
                        songID: model.songID,
                        title: model.title,
                        artist: model.artist,
                        highlightingItems: model.highlightingItems
                    )
                )
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
