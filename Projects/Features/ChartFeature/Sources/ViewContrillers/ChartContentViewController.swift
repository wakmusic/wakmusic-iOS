import UIKit
import Utility
import DesignSystem
import RxSwift
import RxCocoa
import BaseFeature
import CommonFeature
import DataMappingModule
import DomainModule
import SnapKit
import Then

public class ChartContentViewController: BaseViewController, ViewControllerFromStoryBoard {
    private let disposeBag = DisposeBag()
    private var viewModel: ChartContentViewModel!
    fileprivate lazy var input = ChartContentViewModel.Input()
    fileprivate lazy var output = viewModel.transform(from: input)

    private let updateTimeLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.GrayColor.gray600.color
        $0.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
    }
    private let updateTimeImage = UIImageView().then {
        $0.image = DesignSystemAsset.Chart.check.image
    }
    private let tableView = UITableView().then {
        $0.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        $0.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
    }
    private let activityIncidator =  UIActivityIndicatorView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    public static func viewController(
        viewModel: ChartContentViewModel
    ) -> ChartContentViewController {
        let viewController = ChartContentViewController.viewController(storyBoardName: "Chart", bundle: Bundle.module)
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ChartContentViewController {
    
    private func bind() {
        tableView.register(ChartContentTableViewCell.self, forCellReuseIdentifier: "chartContentTableViewCell")
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

//        output.dataSource
//            .skip(1)
//            .do(onNext: { [weak self] _ in
//                guard let `self` = self else { return }
//                DispatchQueue.main.async {
//                    self.activityIncidator.stopAnimating()
//                }
//            })
//            .bind(to: tableView.rx.items) { (tableView, index, model) -> UITableViewCell in
//                let indexPath: IndexPath = IndexPath(row: index, section: 0)
//                guard let cell = tableView.dequeueReusableCell(
//                    withIdentifier: "chartContentTableViewCell",
//                    for: indexPath
//                ) as? ChartContentTableViewCell else { return UITableViewCell() }
//                cell.update(model: model, index: index)
//                return cell
//            }.disposed(by: disposeBag)
//
//        tableView.rx.itemSelected
//            .withLatestFrom(output.dataSource) { ($0, $1) }
//            .subscribe(onNext: { [weak self] (indexPath, _) in
//                guard let `self` = self else { return }
//                self.tableView.deselectRow(at: indexPath, animated: true)
//            }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        self.activityIncidator.startAnimating()
        [
            tableView,
            activityIncidator
        ].forEach {
            view.addSubview($0)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            $0.horizontalEdges.equalTo(0)
            $0.bottom.equalTo(0)
        }
    }
}

extension ChartContentViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 102
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = PlayButtonForChartView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 102))
        let view = PlayButtonGroupView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 102))
//        view.setUpdateTime(updateTime: output.updateTime)
        view.delegate = self
        return view
    }
}

extension ChartContentViewController: PlayButtonGroupViewDelegate{
    public func pressPlay(_ event: CommonFeature.PlayEvent) {
        DEBUG_LOG(event)
    }
}
//extension ChartContentViewController: PlayButtonForChartViewDelegate{
//    public func pressPlay(_ event: PlayEvent) {
//        DEBUG_LOG(event)
//    }
//}
