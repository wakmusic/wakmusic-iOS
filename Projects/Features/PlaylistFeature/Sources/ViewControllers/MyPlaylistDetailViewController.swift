import BaseFeature
import DesignSystem
import ReactorKit
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

final class MyPlaylistDetailViewController: BaseReactorViewController<MyPlaylistDetailReactor> {
    private var wmNavigationbarView: WMNavigationBarView = WMNavigationBarView()

    private var lockButton: UIButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Playlist.lock.image, for: .normal)
        $0.setImage(DesignSystemAsset.Playlist.unLock.image, for: .selected)
    }

    fileprivate let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
            .withTintColor(DesignSystemAsset.BlueGrayColor.blueGray900.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
    }

    private var moreButton: UIButton = UIButton().then {
        $0.setImage(DesignSystemAsset.MyInfo.more.image, for: .normal)
    }

    private var headerView: MyPlaylistHeaderView = MyPlaylistHeaderView(frame: .init(
        x: .zero,
        y: .zero,
        width: APP_WIDTH(),
        height: 140
    ))

    private lazy var tableView: UITableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(PlaylistTableViewCell.self, forCellReuseIdentifier: PlaylistTableViewCell.identifier)
        $0.tableHeaderView = headerView
        $0.separatorStyle = .none
    }

    private lazy var completeButton: RectangleButton = RectangleButton().then {
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setColor(isHighlight: true)
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .init(font: DesignSystemFontFamily.Pretendard.bold, size: 12)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }
    
    private let playbuttonGroupView = PlayButtonGroupView()
    lazy var dataSource: MyplaylistDetailDataSource = createDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        reactor?.action.onNext(.viewDidLoad)
    }

    override func addView() {
        super.addView()
        self.view.addSubviews(wmNavigationbarView, tableView)
        wmNavigationbarView.setLeftViews([dismissButton])
        wmNavigationbarView.setRightViews([lockButton, moreButton, completeButton])
    }

    override func setLayout() {
        super.setLayout()

        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(STATUS_BAR_HEGHIT())
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(wmNavigationbarView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        completeButton.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.height.equalTo(24)
            $0.bottom.equalToSuperview().offset(-5)
        }
    }

    override func configureUI() {
        super.configureUI()
    }

    override func bind(reactor: MyPlaylistDetailReactor) {
        super.bind(reactor: reactor)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: MyPlaylistDetailReactor) {
        super.bindAction(reactor: reactor)

        #warning("private 버튼 이벤트")

        moreButton.rx
            .tap
            .bind(with: self) { owner, _ in
                reactor.action.onNext(.changeEditingState)
            }
            .disposed(by: disposeBag)

        completeButton.rx
            .tap
            .bind(with: self) { owner, _ in
                reactor.action.onNext(.changeEditingState)
            }
            .disposed(by: disposeBag)

        headerView.rx.editNickNameButtonDidTap
            .bind(with: self) { owner, _ in
                DEBUG_LOG("탭 이름 변경 버튼")
            }
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: MyPlaylistDetailReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        sharedState.map(\.isEditing)
            .distinctUntilChanged()
            .bind(with: self) { owner, isEditing in
                owner.lockButton.isHidden = isEditing
                owner.moreButton.isHidden = isEditing
                owner.completeButton.isHidden = !isEditing
                owner.tableView.isEditing = isEditing
                owner.headerView.updateEditState(isEditing)
            }
            .disposed(by: disposeBag)

        sharedState.map(\.dataSource)
            .distinctUntilChanged()
            .bind(with: self) { owner, playlistDetail in
                var snapShot = owner.dataSource.snapshot()

                snapShot.appendItems(playlistDetail.songs)
                owner.dataSource.apply(snapShot)
            }
            .disposed(by: disposeBag)

        sharedState.map(\.isLoading)
            .distinctUntilChanged()
            .bind(with: self) { owner, isLoading in

                if isLoading {
                    owner.indicator.startAnimating()
                } else {
                    owner.indicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
    }
}

extension MyPlaylistDetailViewController {
    func createDataSource() -> MyplaylistDetailDataSource {
        let state = reactor?.currentState

        let dataSource = MyplaylistDetailDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            guard let isEditing = state?.isEditing, let cell = tableView.dequeueReusableCell(
                withIdentifier: PlaylistTableViewCell.identifier,
                for: indexPath
            ) as? PlaylistTableViewCell else {
                return UITableViewCell()
            }
            cell.setContent(song: itemIdentifier, index: indexPath.row, isEditing: isEditing)
            cell.selectionStyle = .none

            return cell
        }

        tableView.dataSource = dataSource

        var snapShot = dataSource.snapshot()
        snapShot.appendSections([0])

        dataSource.apply(snapShot)

        return dataSource
    }
}

extension MyPlaylistDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60.0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let reactor = reactor else {
            return nil
        }
        
        if reactor.currentState.dataSource.songs.isEmpty {
            return nil
        } else {
            return playbuttonGroupView
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let reactor = reactor else {
            return .zero
        }
        
        if reactor.currentState.dataSource.songs.isEmpty {
            return .zero
        } else {
            return CGFloat(52.0+22.0)
        }
    }
    
    
}

extension MyPlaylistDetailViewController: PlayButtonGroupViewDelegate {
    func play(_ event: PlayEvent) {
        
        #warning("재생 이벤트 넣기")
        switch event {
            
        case .allPlay:
            break
        case .shufflePlay:
            break
        }
        
    }
    
}
