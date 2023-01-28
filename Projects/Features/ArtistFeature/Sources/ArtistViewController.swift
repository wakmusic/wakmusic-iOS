import UIKit
import Utility
import DesignSystem
import RxSwift
import RxCocoa

public final class ArtistViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var disposeBag: DisposeBag = DisposeBag()
    var dataSource: BehaviorRelay<[ArtistListDTO]> = BehaviorRelay(value: [])

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    public static func viewController() -> ArtistViewController {
        let viewController = ArtistViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        return viewController
    }
}

extension ArtistViewController {
    
    private func bind() {
        
        let models = [ArtistListDTO(name: "우왁굳", image: DesignSystemAsset.Artist.woowakgood.image),
                      ArtistListDTO(name: "아이네", image: DesignSystemAsset.Artist.ine.image),
                      ArtistListDTO(name: "징버거", image: DesignSystemAsset.Artist.jingburger.image),
                      ArtistListDTO(name: "릴파", image: DesignSystemAsset.Artist.lilpa.image),
                      ArtistListDTO(name: "주르르", image: DesignSystemAsset.Artist.jururu.image),
                      ArtistListDTO(name: "고세구", image: DesignSystemAsset.Artist.gosegu.image),
                      ArtistListDTO(name: "비챤", image: DesignSystemAsset.Artist.viichan.image),
                      ArtistListDTO(name: "우왁굳", image: DesignSystemAsset.Artist.woowakgood.image),
                      ArtistListDTO(name: "아이네", image: DesignSystemAsset.Artist.ine.image),
                      ArtistListDTO(name: "징버거", image: DesignSystemAsset.Artist.jingburger.image),
                      ArtistListDTO(name: "릴파", image: DesignSystemAsset.Artist.lilpa.image),
                      ArtistListDTO(name: "주르르", image: DesignSystemAsset.Artist.jururu.image),
                      ArtistListDTO(name: "고세구", image: DesignSystemAsset.Artist.gosegu.image),
                      ArtistListDTO(name: "비챤", image: DesignSystemAsset.Artist.viichan.image),
                      ArtistListDTO(name: "우왁굳", image: DesignSystemAsset.Artist.woowakgood.image),
                      ArtistListDTO(name: "아이네", image: DesignSystemAsset.Artist.ine.image),
                      ArtistListDTO(name: "징버거", image: DesignSystemAsset.Artist.jingburger.image),
                      ArtistListDTO(name: "릴파", image: DesignSystemAsset.Artist.lilpa.image),
                      ArtistListDTO(name: "주르르", image: DesignSystemAsset.Artist.jururu.image),
                      ArtistListDTO(name: "고세구", image: DesignSystemAsset.Artist.gosegu.image),
                      ArtistListDTO(name: "비챤", image: DesignSystemAsset.Artist.viichan.image),
                      ArtistListDTO(name: "우왁굳", image: DesignSystemAsset.Artist.woowakgood.image)]
        
        Observable.just(models)
            .map({ (model) in
                guard !model.isEmpty else { return model }
                var newModel = model

                if model.count == 1 {
                    let hiddenItem: ArtistListDTO = ArtistListDTO(name: "", image: UIImage(), isHiddenItem: true)
                    newModel.append(hiddenItem)
                    return newModel

                } else {
                    newModel.swapAt(0, 1)
                }

                return newModel
            })
            .bind(to: dataSource)
            .disposed(by: disposeBag)

        dataSource
            .bind(to: collectionView.rx.items) { (collectionView, index, model) -> UICollectionViewCell in
                let indexPath = IndexPath(item: index, section: 0)
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistListCell",
                                                                    for: indexPath) as? ArtistListCell else {
                    return UICollectionViewCell()
                }
                cell.update(model: model)
                return cell
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .withLatestFrom(dataSource) { ($0, $1) }
            .do(onNext: { [weak self] (indexPath, _) in
                guard let `self` = self,
                      let cell = self.collectionView.cellForItem(at: indexPath) as? ArtistListCell else { return }
                cell.animateSizeDownToUp(timeInterval: 0.3)
            })
            .delay(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ [weak self] (indexPath, dataSource) in
                guard let `self` = self else { return }

                let model = dataSource[indexPath.row]
                DEBUG_LOG(model)
                let viewController = ArtistDetailViewController.viewController()
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }).disposed(by: disposeBag)


    }
    
    private func configureUI() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        let sideSpace: CGFloat = 20.0
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 15, left: sideSpace, bottom: 15, right: sideSpace)
//        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 8 // 열 사이의 간격
        layout.headerHeight = 15.0
        layout.footerHeight = 50.0
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
    }
}

extension ArtistViewController: WaterfallLayoutDelegate {

    public func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let originWidth: CGFloat = 106.0
        let originHeight: CGFloat = 130.0
        let rate: CGFloat = originHeight/max(1.0, originWidth)

        let sideSpace: CGFloat = 8.0
        let width: CGFloat = APP_WIDTH() - ((sideSpace * 2.0) + 40.0)
        let spacingWithNameHeight: CGFloat = 4.0 + 24.0 + 40.0
        let imageHeight: CGFloat = width * rate
        
        switch indexPath.item {
        case 0:
            return CGSize(width: width, height: (imageHeight) + (width / 2) + spacingWithNameHeight)

        case 2:
            return CGSize(width: width, height: (imageHeight) + (width / 2) + spacingWithNameHeight)

        default:
            return CGSize(width: width, height: (imageHeight) + spacingWithNameHeight)
        }
    }

    public func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 3, distributionMethod: .balanced)
    }
}
