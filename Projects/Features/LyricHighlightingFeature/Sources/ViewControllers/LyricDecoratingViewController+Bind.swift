import DesignSystem
import Foundation
import LogManager
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
                LogManager.analytics(
                    LyricHighlightingAnalyticsLog.clickLyricDecoratingCompleteButton(
                        type: "save",
                        id: owner.output.updateSongID.value,
                        bg: owner.output.dataSource.value.filter { $0.isSelected }.first?.name ?? ""
                    )
                )
                owner.requestPhotoLibraryPermission()
            }
            .disposed(by: disposeBag)

        shareButton.rx.tap
            .bind(with: self) { owner, _ in
                LogManager.analytics(
                    LyricHighlightingAnalyticsLog.clickLyricDecoratingCompleteButton(
                        type: "share",
                        id: owner.output.updateSongID.value,
                        bg: owner.output.dataSource.value.filter { $0.isSelected }.first?.name ?? ""
                    )
                )
                let activityViewController = UIActivityViewController(
                    activityItems: [owner.decorateShareContentView.asImage(size: .init(width: 960, height: 960))],
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
            .bind(with: self, onNext: { owner, song in
                owner.songTitleLabel.text = song
                owner.songTitleLabel.setTextWithAttributes(kernValue: -0.5, alignment: .center)
            })
            .disposed(by: disposeBag)

        output.updateArtist
            .bind(with: self, onNext: { owner, artist in
                owner.artistLabel.text = artist
                owner.artistLabel.setTextWithAttributes(kernValue: -0.5, alignment: .center)
            })
            .disposed(by: disposeBag)

        output.updateDecoratingImage
            .filter { !$0.isEmpty }
            .map { URL(string: $0) }
            .compactMap { $0 }
            .bind(with: self) { owner, url in
                owner.decorateImageView.kf.setImage(
                    with: url,
                    placeholder: nil,
                    options: [.transition(.fade(0.2))]
                ) { result in
                    switch result {
                    case .success:
                        break
                    case let .failure(error):
                        owner.showToast(
                            text: error.localizedDescription,
                            font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
                        )
                    }
                }
            }
            .disposed(by: disposeBag)

        output.dataSource
            .skip(1)
            .do(onNext: { [indicator, saveButton, shareButton] source in
                indicator.stopAnimating()
                saveButton.isEnabled = !source.isEmpty
                shareButton.isEnabled = saveButton.isEnabled
            })
            .bind(to: collectionView.rx.items) { collectionView, index, model in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "\(LyricDecoratingCell.self)",
                    for: IndexPath(item: index, section: 0)
                ) as? LyricDecoratingCell else {
                    return UICollectionViewCell()
                }
                cell.update(model: model)
                return cell
            }
            .disposed(by: disposeBag)

        output.highlightingItems
            .filter { !$0.isEmpty }
            .map { lyric in
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
                return attributedString
            }
            .bind(to: highlightingLyricLabel.rx.attributedText)
            .disposed(by: disposeBag)

        output.occurredError
            .bind(with: self) { owner, message in
                owner.showBottomSheet(
                    content: owner.textPopUpFactory.makeView(
                        text: message,
                        cancelButtonIsHidden: true,
                        confirmButtonText: "확인",
                        cancelButtonText: nil,
                        completion: {
                            owner.navigationController?.popViewController(animated: true)
                        },
                        cancelCompletion: nil
                    ),
                    dismissOnOverlayTapAndPull: false
                )
            }
            .disposed(by: disposeBag)
    }
}
