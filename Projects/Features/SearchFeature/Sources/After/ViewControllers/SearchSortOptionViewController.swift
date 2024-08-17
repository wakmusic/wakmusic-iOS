import BaseFeature
import RxCocoa
import RxSwift
import SearchDomainInterface
import SnapKit
import Then
import UIKit
import Utility

protocol SearchSortOptionDelegate: AnyObject {
    func updateSortType(_ type: SortType)
}

final class SearchSortOptionViewController: BaseViewController {
    weak var delegate: SearchSortOptionDelegate?

    private var disposeBag = DisposeBag()

    private let options: [SortType] = [.relevance, .latest, .oldest, .popular]

    private var selectedModel: SortType

    private lazy var dataSource: UITableViewDiffableDataSource<Int, SortType> =
        createDataSource()

    private lazy var tableView: UITableView = UITableView().then {
        $0.register(SearchSortOptionCell.self, forCellReuseIdentifier: SearchSortOptionCell.identifer)
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.delegate = self
    }

    init(selectedModel: SortType) {
        self.selectedModel = selectedModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLayout()
        configureUI()
        initSnapShot()
        bindAction()
    }
}

extension SearchSortOptionViewController {
    private func addSubviews() {
        self.view.addSubviews(tableView)
    }

    private func setLayout() {
        self.tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func configureUI() {
        self.view.backgroundColor = .white
        self.tableView.backgroundColor = .white
    }

    private func createDataSource() -> UITableViewDiffableDataSource<Int, SortType> {
        return UITableViewDiffableDataSource(tableView: tableView) { [
            weak self
        ] tableView, indexPath, _ -> UITableViewCell in
            guard let self, let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchSortOptionCell.identifer,
                for: indexPath
            ) as? SearchSortOptionCell else {
                return UITableViewCell()
            }
            cell.update(self.options[indexPath.row], self.selectedModel)
            cell.selectionStyle = .none
            return cell
        }
    }

    private func initSnapShot() {
        tableView.dataSource = dataSource

        var snapShot = NSDiffableDataSourceSnapshot<Int, SortType>()

        snapShot.appendSections([0])

        snapShot.appendItems(options, toSection: 0)

        dataSource.apply(snapShot)
    }

    private func bindAction() {
        tableView.rx.itemSelected
            .map(\.row)
            .bind(with: self) { owner, index in

                owner.dismiss(animated: true) {
                    owner.delegate?.updateSortType(owner.options[index])
                }
            }
            .disposed(by: disposeBag)
    }
}

extension SearchSortOptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
}
