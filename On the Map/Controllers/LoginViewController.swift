//
//  LoginViewController.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/12/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-u")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = "email"
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        textField.delegate = self
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = "password"
        textField.isSecureTextEntry = true
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        textField.delegate = self
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("LOG IN", for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.textAlignment = .center
        return label
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.lightBlue, for: .normal)
        button.setTitle("Sign Up", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationsViewModel.shared.taskDelegate = self
        LocationsViewModel.shared.authenticationDelegate = self
        
        view.backgroundColor = .white
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
        layoutView()
        
    }

    func layoutView() {
    
        let signUpStackView = UIStackView(arrangedSubviews: [signUpLabel, signUpButton])
        signUpStackView.axis = .horizontal
        
        let stackView = UIStackView(arrangedSubviews: [logoImageView, loginTextField, passwordTextField, loginButton, signUpStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 5
        view.addSubview(stackView)
      
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            stackView.heightAnchor.constraint(equalToConstant: 150)
            ])
    }
    
    @objc func didTapLoginButton(_ sender: UIButton) {
        guard let email = loginTextField.text, let password = passwordTextField.text else {
            let alertController = UIAlertController(title: "Logging in", message: "Please fill in login or password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        LocationsViewModel.shared.createSession(email: email, password: password)
        LoadingOverlay.shared.showOverlay(view: view)
    }
    
    @objc func didTapSignUpButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
}

extension LoginViewController: NetworkTaskCompletionDelegate, AuthenticationCompletionDelegate {
    func completed() {
        LocationsViewModel.shared.getUserData()
    }
    
    func taskCompleted() {
        LoadingOverlay.shared.hideOverlayView()
        present(TabBarController(), animated: true)
    }
    
    func showError(message: String) {
        LoadingOverlay.shared.hideOverlayView()
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
