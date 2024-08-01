import BaseFeature
import DesignSystem
import Foundation
import LogManager
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

final class TeamInfoContentViewController: UIViewController {
    private let tableView = UITableView().then {
        $0.register(TeamInfoListCell.self, forCellReuseIdentifier: "\(TeamInfoListCell.self)")
        $0.register(TeamInfoSectionView.self, forHeaderFooterViewReuseIdentifier: "\(TeamInfoSectionView.self)")
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.sectionHeaderTopPadding = 0
        $0.allowsSelection = false
    }

    private let warningView = WarningView(frame: .zero).then {
        $0.text = "팀 데이터가 없습니다."
        $0.isHidden = true
    }

    private let viewModel: TeamInfoContentViewModel
    lazy var input = TeamInfoContentViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(viewModel: TeamInfoContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("\(Self.self) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLayout()
        configureUI()
        outputBind()
        inputBind()
    }
}

private extension TeamInfoContentViewController {
    func outputBind() {
        output.dataSource
            .skip(1)
            .take(1)
            .bind(with: self, onNext: { owner, source in
                if owner.output.updateManager.value == nil {
                    owner.tableView.tableHeaderView = nil
                } else {
                    let header = TeamInfoHeaderView(frame: .init(x: 0, y: 0, width: APP_WIDTH(), height: 140))
                    header.update(entity: owner.output.updateManager.value)
                    owner.tableView.tableHeaderView = header
                }

                let footer = TeamInfoFooterView(frame: .init(x: 0, y: 0, width: APP_WIDTH(), height: 88))
                owner.tableView.tableFooterView = footer

                owner.warningView.isHidden = !source.isEmpty
                owner.tableView.isHidden = !owner.warningView.isHidden
                owner.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    func inputBind() {
        input.combineTeamList.onNext(())
    }
}

private extension TeamInfoContentViewController {
    func addSubviews() {
        view.addSubviews(tableView, warningView)
    }

    func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(output.type.value == .weeklyWM ? 100 : 104)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        warningView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(APP_WIDTH())
            $0.height.equalTo(tableView.frame.height / 3 * 2)
        }
    }

    func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension TeamInfoContentViewController: TeamInfoSectionViewDelegate {
    func toggleSection(header: TeamInfoSectionView, section: Int) {
        var newDataSource = output.dataSource.value
        newDataSource[section].model.isOpen = !newDataSource[section].model.isOpen
        output.dataSource.accept(newDataSource)
        header.rotate(isOpen: newDataSource[section].model.isOpen)
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

extension TeamInfoContentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return output.dataSource.value.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.dataSource.value[section].model.isOpen ?
            output.dataSource.value[section].model.members.count : 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let members = output.dataSource.value[indexPath.section].model.members
        return TeamInfoListCell.cellHeight(index: indexPath.row, totalCount: members.count)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "\(TeamInfoSectionView.self)"
        ) as? TeamInfoSectionView else {
            return nil
        }
        sectionView.delegate = self
        sectionView.update(
            section: section,
            title: output.dataSource.value[section].title,
            isOpen: output.dataSource.value[section].model.isOpen
        )
        return sectionView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(TeamInfoListCell.self)",
            for: indexPath
        ) as? TeamInfoListCell else {
            return UITableViewCell()
        }
        cell.update(
            entity: output.dataSource.value[indexPath.section].model.members[indexPath.row],
            index: indexPath.row,
            totalCount: output.dataSource.value[indexPath.section].model.members.count
        )
        return cell
    }
}
