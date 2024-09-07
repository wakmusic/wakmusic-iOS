import BaseFeature
import BaseFeatureInterface
import DesignSystem
import PlaylistFeatureInterface
import SnapKit
import Then
import UIKit
import Utility

final class PlaylistCoverOptionPopupViewController: BaseReactorViewController<PlaylistCoverOptionPopupReactor> {
    weak var delegate: PlaylistCoverOptionPopupDelegate?

    private let titleLabel: WMLabel = WMLabel(
        text: "표지",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t2(weight: .bold),
        alignment: .center
    )

    private let tableView: UITableView = UITableView().then {
        $0.isScrollEnabled = false
        $0.register(
            PlaylistCoverOptionTableViewCell.self,
            forCellReuseIdentifier: PlaylistCoverOptionTableViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.isHidden = true
    }

    private lazy var dataSource: UITableViewDiffableDataSource<Int, PlaylistCoverOptionModel> = createDataSoruce()

    init(reactor: PlaylistCoverOptionPopupReactor, delegate: PlaylistCoverOptionPopupDelegate) {
        self.delegate = delegate
        super.init(reactor: reactor)
    }

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
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(32)
            $0.height.equalTo(32)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(80 * 2)
        }
    }

    override func bindAction(reactor: PlaylistCoverOptionPopupReactor) {
        super.bindAction(reactor: reactor)
    }

    override func bindState(reactor: PlaylistCoverOptionPopupReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        sharedState.map(\.isLoading)
            .bind(with: self) { owner, isLoading in

                if isLoading {
                    owner.indicator.startAnimating()
                } else {
                    owner.indicator.stopAnimating()
                }

                owner.tableView.isHidden = isLoading
            }
            .disposed(by: disposeBag)

        sharedState.map(\.dataSource)
            .bind(with: self) { owner, dataSource in

                var snapShot = NSDiffableDataSourceSnapshot<Int, PlaylistCoverOptionModel>()
                snapShot.appendSections([0])

                snapShot.appendItems(dataSource, toSection: 0)

                owner.dataSource.apply(snapShot)
            }
            .disposed(by: disposeBag)
    }
}

extension PlaylistCoverOptionPopupViewController {
    func createDataSoruce() -> UITableViewDiffableDataSource<Int, PlaylistCoverOptionModel> {
        return UITableViewDiffableDataSource<
            Int,
            PlaylistCoverOptionModel
        >(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PlaylistCoverOptionTableViewCell.identifier,
                for: indexPath
            ) as? PlaylistCoverOptionTableViewCell else {
                return UITableViewCell()
            }

            cell.update(itemIdentifier)
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension PlaylistCoverOptionPopupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let identifier = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        self.dismiss(animated: true) {
            self.delegate?.didTap(indexPath.row, identifier.price)
        }
    }
}
