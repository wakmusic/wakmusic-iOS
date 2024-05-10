import UIKit
import SnapKit
import Then
import DesignSystem
import Utility
import RxCocoa
import RxSwift

class LoginWarningView: UIView {

    var disposeBag = DisposeBag()
    
    var completion: (() -> Void)
    
    var imageView: UIImageView = UIImageView().then {
        
        $0.image = DesignSystemAsset.Search.warning.image
    }
    
    var label: UILabel = UILabel().then {
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
        $0.text = "로그인을 해주세요."
        $0.textAlignment = .center
    }
    
    var button: UIButton = UIButton().then {
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.blueGray600.color, for: .normal)
        
        $0.layer.cornerRadius = 8
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray400.color
        $0.clipsToBounds = true
    }
    
  
    init(complection: @escaping (() -> Void)){
        self.completion = complection
        super.init(frame: .zero)
        
        self.addSubview(imageView)
        self.addSubview(label)
        self.addSubview(button)
        
        configureUI()
        
        button.rx
            .tap
            .withUnretained(self)
            .bind { (owner,_) in
                owner.completion()
            }
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoginWarningView {
    private func configureUI() {
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.height.equalTo(154)
            $0.top.equalTo(label.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
}
