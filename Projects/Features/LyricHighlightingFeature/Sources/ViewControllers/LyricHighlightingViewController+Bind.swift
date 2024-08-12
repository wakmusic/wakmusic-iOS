import DesignSystem
import Foundation
import LogManager
import LyricHighlightingFeatureInterface
import UIKit

extension LyricHighlightingViewController {
    func inputBind() {
        input.fetchLyric.onNext(())

        collectionView.rx.itemSelected
            .bind(to: input.didTapHighlighting)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        completeButton.rx.tap
            .bind(to: input.didTapSaveButton)
            .disposed(by: disposeBag)
    }

    func outputBind() {
        output.updateInfo
            .bind(with: self, onNext: { owner, info in
                owner.songLabel.text = info.title
                owner.songLabel.setTextWithAttributes(kernValue: -0.5, alignment: .center)
                owner.artistLabel.text = info.artist
                owner.artistLabel.setTextWithAttributes(kernValue: -0.5, alignment: .center)
            })
            .disposed(by: disposeBag)

        output.updateProvider
            .bind(to: writerLabel.rx.text)
            .disposed(by: disposeBag)

        output.dataSource
            .skip(1)
            .do(onNext: { [indicator, warningView, collectionView, writerLabel] model in
                indicator.stopAnimating()
                warningView.isHidden = !model.isEmpty
                collectionView.isHidden = !warningView.isHidden
                writerLabel.isHidden = !warningView.isHidden
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
            .map { !$0 }
            .bind(to: completeButton.rx.isHidden)
            .disposed(by: disposeBag)

        output.goDecoratingScene
            .bind(with: self) { owner, model in
                let viewController = owner.lyricDecoratingComponent.makeView(model: model)
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)

        output.showToast
            .bind(with: self) { owner, message in
                owner.showToast(
                    text: message,
                    options: [.tabBar],
                    backgroundThema: .light
                )
            }
            .disposed(by: disposeBag)
    }
}
