import UIKit
import CommonFeature
import Utility
import DesignSystem
import PanModal
import BaseFeature
import RxSwift
import RxCocoa

public final class HomeViewController: BaseViewController, ViewControllerFromStoryBoard {

    var viewModel: HomeViewModel!
    private lazy var input = HomeViewModel.Input()
    private lazy var output = viewModel.transform(from: input)
    var disposeBag = DisposeBag()

    @IBOutlet weak var backgroundTopImageView: UIImageView!
    
    //mainTitle
    @IBOutlet weak var mainTitleView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainTitleImageView: UIImageView!
    @IBOutlet weak var mainTitleAllButton: UIButton!//전체듣기
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var mainBlurView: UIVisualEffectView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        inputBind()
        outputBind()
    }

    func initView() {
        
        backgroundTopImageView.image = DesignSystemAsset.Home.gradationBg.image
        
        mainTitleView.backgroundColor = .white.withAlphaComponent(0.4)
        mainTitleView.layer.cornerRadius = 12
        mainBlurView.layer.cornerRadius = 12
        mainBlurView.layer.borderWidth = 1
        mainBlurView.layer.borderColor = UIColor.white.cgColor

        let mainTitleLabelAttributedString = NSMutableAttributedString(
            string: "왁뮤차트 TOP100",
            attributes: [.font: DesignSystemFontFamily.Pretendard.bold.font(size: 16),
                         .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                         .kern: -0.5]
        )
        mainTitleLabel.attributedText = mainTitleLabelAttributedString

        let mainTitleAllButtonAttributedString = NSMutableAttributedString(
            string: "전체듣기",
            attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                         .foregroundColor: DesignSystemAsset.GrayColor.gray25.color,
                         .kern: -0.5]
        )
        mainTitleAllButton.setAttributedTitle(mainTitleAllButtonAttributedString, for: .normal)
        mainTitleImageView.image = DesignSystemAsset.Search.searchArrowRight.image
    }
    
    public static func viewController(viewModel: HomeViewModel) -> HomeViewController {
        let viewController = HomeViewController.viewController(storyBoardName: "Home", bundle: Bundle.module)
        viewController.viewModel = viewModel
        return viewController
    }
}
extension HomeViewController {
    
    private func inputBind() {
                
        mainTableView.rx.setDelegate(self).disposed(by: disposeBag)

        mainTableView.rx.itemSelected
            .map { "\($0.row)" }
            .bind(to: mainTitleLabel.rx.text)//input.newSongButtonTapped
            .disposed(by: disposeBag)
    }
    
    private func outputBind() {
        
        output.chartRanking
            .skip(1)
            .do(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
//                    self.activityIncidator.stopAnimating()
                }
            })
            .bind(to: mainTableView.rx.items) { (tableView, index, model) -> UITableViewCell in
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMainTitleTableViewCell", for: indexPath) as? HomeMainTitleTableViewCell else{
                    return UITableViewCell()
                }
                cell.update(model: model, index: indexPath.row)
                return cell
            }.disposed(by: disposeBag)
    }
    
    private func configureUI() {
//        self.activityIncidator.startAnimating()
//        self.mainTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
//        self.mainTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
    }
}

extension HomeViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}


//        let recommendView = RecommendPlayListView(frame: CGRect(x: 0,
//                                                                y: 0,
//                                                                width: APP_WIDTH(),
//                                                                height: RecommendPlayListView.getViewHeight(model: dataSource)))
//        recommendView.dataSource = dataSource
//        recommendView.delegate = self

//extension HomeViewController: RecommendPlayListViewDelegate {
//    public func itemSelected(model: RecommendPlayListDTO) {
//        DEBUG_LOG(model)
//    }
//}
