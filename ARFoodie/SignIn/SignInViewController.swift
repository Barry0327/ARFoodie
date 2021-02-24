//
//  SignInViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/5.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase
import IHProgressHUD
import RxSwift

class SignInViewController: NiblessViewController {
    let viewModel: SignInViewModel
    let disposeBag: DisposeBag = DisposeBag()

//    var rootView: SignInRootView {
//        return view as! SignInRootView
//    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init()
    }
}
// MARK: - View life cycle
extension SignInViewController {
    override func loadView() {
        self.view = SignInRootView(viewModel: viewModel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        rootView.emailTextField.delegate = self
//        rootView.passwordTextField.delegate = self
        observerKeyboard()
        hideKeyboardWhenTappedAround()
        bindToViewModel()
        view.backgroundColor = UIColor.flatWatermelonDark()
    }
}
// MARK: - Methods
extension SignInViewController {
    func observerKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(notifiction:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(notificiton:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func bindToViewModel() {
        viewModel.signInActivityIndicatorAnimating
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { animate in
                switch animate {
                case true: IHProgressHUD.show()
                case false: IHProgressHUD.dismiss()
                }
            })
            .disposed(by: disposeBag)
        viewModel.errorMessage
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] error in
                let alert = UIAlertController(title: error.title,
                                              message: error.message,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        viewModel.signInView
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] view in
                switch view {
                case .main:
                    self.performSegue(withIdentifier: "FinishLogin", sender: self)
                case .register:
                    self.performRegisterViewController()
                case .userPolicy:
                    self.performUserPolicyPage()
                case .userPrivacy:
                    self.performPrivacyPolicyPage()
                }
            })
            .disposed(by: disposeBag)
    }

    func performUserPolicyPage() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard
            let userPrivacyVC = storyboard.instantiateViewController(
                withIdentifier: "UserPolicyViewController"
                ) as? UserPolicyViewController
            else { fatalError("Please check the ID for UserPolicyViewController")}
        let navigationCTL = UINavigationController(rootViewController: userPrivacyVC)
        self.present(navigationCTL, animated: true, completion: nil)
    }

    func performPrivacyPolicyPage() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard
            let userPrivacyVC = storyboard.instantiateViewController(
                withIdentifier: "PrivacyPolicyViewController"
                ) as? PrivacyPolicyViewController
            else { fatalError("Please check the ID for PrivacyPolicyViewController")}

        let navigationCTL = UINavigationController(rootViewController: userPrivacyVC)
        self.present(navigationCTL, animated: true, completion: nil)
    }

    func performRegisterViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            self.present(registerVC, animated: true, completion: nil)
        }
    }
}
// MARK: - TextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField {
//        case rootView.emailTextField:
//            rootView.passwordTextField.becomeFirstResponder()
//        default:
//            viewModel.signIn()
//        }
//        return false
//    }
}
