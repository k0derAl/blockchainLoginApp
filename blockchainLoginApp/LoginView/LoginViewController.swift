

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    private lazy var loginNameTextField: UITextField = {
        $0.placeholder = "Enter your name"
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.gray.cgColor
        return $0
    }(UITextField())
    
    private lazy var passworTextField: UITextField = {
        $0.placeholder = "Enter your password"
        $0.isSecureTextEntry = true
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.gray.cgColor
        return $0
    }(UITextField())
    
    private lazy var loginButton: UIButton = {
        $0.setTitle("Login", for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .systemGreen
        $0.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    var viewModel: LoginViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureLoginButton()
        configurePasswordTextField()
        configureLoginNameTextField()
        
    }
    
    @objc private func loginAction() {
        viewModel?.login(password: passworTextField.text ?? "" , name: loginNameTextField.text ?? "", completion: { _ in
            
        })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .faceUp {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    fileprivate func configureLoginNameTextField() {
        view.addSubview(loginNameTextField)
        
        loginNameTextField.snp.makeConstraints { make in
            make.bottom.equalTo(passworTextField.snp.top).offset(-60)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    fileprivate func configurePasswordTextField() {
        view.addSubview(passworTextField)
        
        passworTextField.snp.makeConstraints { make in
            make.bottom.equalTo(loginButton.snp.top).offset(-60)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    fileprivate func configureLoginButton() {
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    
}
