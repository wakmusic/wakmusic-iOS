import BaseFeature
import DesignSystem
import LogManager
import SnapKit
import Then
import UIKit

final class CheckThumbnailViewController: UIViewController {
    private var wmNavigationbarView: WMNavigationBarView = WMNavigationBarView()

    fileprivate let backButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
            .withTintColor(DesignSystemAsset.BlueGrayColor.blueGray900.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
    }

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        addViews()
        setLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

private extension CheckThumbnailViewController {
    func addViews() {
        view.addSubview(wmNavigationbarView)
        wmNavigationbarView.setLeftViews([backButton])
        backButton.addAction { [weak self] () in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    func setLayout() {
        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
}

extension CheckThumbnailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
