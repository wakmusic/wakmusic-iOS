import BaseFeature
import BaseFeatureInterface
import DesignSystem
import SnapKit
import Then
import UIKit
import Utility

protocol ThumbnailPopupDelegate: AnyObject {
    func didTap(_ model: ThumbnailOptionModel)
}

final class ThumbnailPopupViewController: BaseReactorViewController<ThumbnailPopupReactor> {
    weak var delegate: ThumbnailPopupDelegate?

    private let titleLabel: WMLabel = WMLabel(
        text: "표지",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t2(weight: .bold),
        alignment: .center
    )

    private let tableView: UITableView = UITableView().then {
        $0.register(ThumbnailOptionTableViewCell.self, forCellReuseIdentifier: ThumbnailOptionTableViewCell.identifier)
        $0.separatorStyle = .none
    }

    private lazy var dataSource: UITableViewDiffableDataSource<Int, ThumbnailOptionModel> = createDataSoruce()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        reactor?.action.onNext(.viewDidLoad)
    }

    override func addView() {
        super.addView()
        self.view.addSubviews(titleLabel, tableView)
    }

    override func setLayout() {
        super.setLayout()

        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(32)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
    }

    override func bindAction(reactor: ThumbnailPopupReactor) {
        super.bindAction(reactor: reactor)
    }

    override func bindState(reactor: ThumbnailPopupReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        sharedState.map(\.dataSource)
            .bind(with: self) { owner, dataSource in

                var snapShot = NSDiffableDataSourceSnapshot<Int, ThumbnailOptionModel>()
                snapShot.appendSections([0])

                snapShot.appendItems(dataSource, toSection: 0)

                owner.dataSource.apply(snapShot)
            }
            .disposed(by: disposeBag)
    }
}

extension ThumbnailPopupViewController {
    func createDataSoruce() -> UITableViewDiffableDataSource<Int, ThumbnailOptionModel> {
        return UITableViewDiffableDataSource<
            Int,
            ThumbnailOptionModel
        >(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ThumbnailOptionTableViewCell.identifier,
                for: indexPath
            ) as? ThumbnailOptionTableViewCell else {
                return UITableViewCell()
            }

            cell.update(itemIdentifier)
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension ThumbnailPopupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
