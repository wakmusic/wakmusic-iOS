import SnapKit
import Then
import UIKit

public final class TogglePopupViewController: UIViewController {
    let dimmView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }

    let contentView = UIView().then {
        $0.layer.cornerRadius = 24
        $0.backgroundColor = .white
    }
    
    var titleString: String = ""
    var firstItemString: String = ""
    var secondItemString: String = ""
    var cancelButtonText: String = ""
    var confirmButtonText: String = ""
    var completion: (() -> Void)?
    var cancelCompletion: (() -> Void)?

    init(
        titleString: String,
        firstItemString: String,
        secondItemString: String,
        cancelButtonText: String = "취소",
        confirmButtonText: String = "확인",
        completion: (() -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) {
        super.init(nibName: nil, bundle: nil)
        self.titleString = titleString
        self.firstItemString = firstItemString
        self.secondItemString = secondItemString
        self.cancelButtonText = cancelButtonText
        self.confirmButtonText = confirmButtonText
        self.completion = completion
        self.cancelCompletion = cancelCompletion
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setLayout()
        configureUI()
    }
}

private extension TogglePopupViewController {
    func addViews() {
        self.view.addSubviews(
            contentView
        )
    }
    
    func setLayout() {
        contentView.snp.makeConstraints {
            $0.width.equalTo(335)
            $0.height.equalTo(322)
        }
    }
    
    func configureUI() {
        
    }
}
