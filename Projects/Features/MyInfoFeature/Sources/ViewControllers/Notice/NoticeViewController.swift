import BaseFeature
import DesignSystem
import LogManager
import MyInfoFeatureInterface
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import UIKit
import Utility

public final class NoticeViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var indicator: NVActivityIndicatorView!

    private var noticeDetailFactory: NoticeDetailFactory!
    private var viewModel: NoticeViewModel!
    private lazy var input = NoticeViewModel.Input()
    private lazy var output = viewModel.transform(from: input)
    private let disposeBag = DisposeBag()

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        outputBind()
        inputBind()
    }

    public static func viewController(
        viewModel: NoticeViewModel,
        noticeDetailFactory: NoticeDetailFactory
    ) -> NoticeViewController {
        let viewController = NoticeViewController.viewController(storyBoardName: "Notice", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.noticeDetailFactory = noticeDetailFactory
        return viewController
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

private extension NoticeViewController {
    func inputBind() {
        input.fetchNotice.onNext(())

        tableView.rx.itemSelected
            .do(onNext: { [tableView] indexPath in
                tableView?.deselectRow(at: indexPath, animated: true)
            })
            .bind(to: input.didTapList)
            .disposed(by: disposeBag)
    }

    func outputBind() {
        output.dataSource
            .skip(1)
            .do(onNext: { [indicator, tableView] model in
                indicator?.stopAnimating()
                let space = APP_HEIGHT() - 48 - STATUS_BAR_HEGHIT() - SAFEAREA_BOTTOM_HEIGHT()
                let height = space / 3 * 2
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: height))
                warningView.text = "공지사항이 없습니다."
                tableView?.tableFooterView = model.isEmpty ? warningView : UIView(frame: CGRect(
                    x: 0,
                    y: 0,
                    width: APP_WIDTH(),
                    height: 56
                ))
            })
            .bind(to: tableView.rx.items) { tableView, index, model -> UITableViewCell in
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "NoticeListCell",
                    for: indexPath
                ) as? NoticeListCell else {
                    return UITableViewCell()
                }
                cell.update(model: model)
                cell.updateVisibleIndicator(visible: !model.isRead)
                return cell
            }
            .disposed(by: disposeBag)

        output.goNoticeDetailScene
            .bind(with: self) { owner, model in
                let log = NoticeAnalyticsLog.clickNoticeItem(id: "\(model.id)", location: "notice")
                LogManager.analytics(log)

                let viewController = owner.noticeDetailFactory.makeView(model: model)
                viewController.modalPresentationStyle = .fullScreen
                owner.present(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }

    func configureUI() {
        view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)

        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)

        let attributedString: NSAttributedString = NSAttributedString(
            string: "공지사항",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        titleStringLabel.attributedText = attributedString

        indicator.type = .circleStrokeSpin
        indicator.color = DesignSystemAsset.PrimaryColor.point.color
        indicator.startAnimating()
    }
}

extension NoticeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
