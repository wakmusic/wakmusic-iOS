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

public class ChartContentViewController: BaseViewController, ViewControllerFromStoryBoard,SongCartViewType {
    private let disposeBag = DisposeBag()
    private var viewModel: ChartContentViewModel!
    fileprivate lazy var input = ChartContentViewModel.Input()
    fileprivate lazy var output = viewModel.transform(from: input)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIncidator: UIActivityIndicatorView!
    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!
    
    private var containSongsComponent: ContainSongsComponent!

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        outputBind()
    }
    
    public static func viewController(
        viewModel: ChartContentViewModel,
        containSongsComponent:ContainSongsComponent
    ) -> ChartContentViewController {
        let viewController = ChartContentViewController.viewController(storyBoardName: "Chart", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.containSongsComponent = containSongsComponent
        return viewController
    }
}

extension ChartContentViewController {
    
    private func bind() {
        tableView.register(ChartContentTableViewCell.self, forCellReuseIdentifier: "chartContentTableViewCell")
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        output.dataSource
            .skip(1)
            .do(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.activityIncidator.stopAnimating()
                }
            })
            .bind(to: tableView.rx.items) { (tableView, index, model) -> UITableViewCell in
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "chartContentTableViewCell",
                    for: indexPath
                ) as? ChartContentTableViewCell else {
                    return UITableViewCell() }
                cell.update(model: model, index: index)
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map({$0.row})
            .bind(to:input.songTapped)
            .disposed(by: disposeBag)

    }
    
    private func configureUI() {
        view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.activityIncidator.startAnimating()
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
    }
    
    
    private func outputBind() {
        
       
        output.indexOfSelectedSongs
            .skip(1)
            .debug("indexOfSelectedSongs")
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .subscribe(onNext: { [weak self] (songs, dataSource) in
                guard let self = self else { return }
                
                DEBUG_LOG("AAA")
                switch songs.isEmpty {
                case true :
                    self.hideSongCart()
                case false:
                    self.showSongCart(
                        in: self.view,
                        type: .chartSong,
                        selectedSongCount: songs.count,
                        totalSongCount: dataSource.count,
                        useBottomSpace: false
                    )
                    self.songCartView?.delegate = self
                }
            }).disposed(by: disposeBag)
        
        output.songEntityOfSelectedSongs
            .filter{ !$0.isEmpty }
            .subscribe()
            .disposed(by: disposeBag)
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
        let view = PlayButtonForChartView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 102))
        view.setUpdateTime(updateTime: output.updateTime)
        view.delegate = self
        return view
    }
}

extension ChartContentViewController: PlayButtonForChartViewDelegate{
    public func pressPlay(_ event: PlayEvent) {
        DEBUG_LOG(event)
    }
}

extension ChartContentViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        switch type {
        case let .allSelect(flag):
            input.allSongSelected.onNext(flag)
        case .addSong:
            let songs: [String] = output.songEntityOfSelectedSongs.value.map { $0.id }
            let viewController = containSongsComponent.makeView(songs: songs)
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true) {
                self.input.allSongSelected.onNext(false)
            }
        case .addPlayList:
            return
        case .play:
            return
        case .remove:
            return
        }
    }
}
