//
//  LoginViewController.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/12/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // TODO: add activity indicator
    // TODO: show password as *
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-u")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.text = "insert login"
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.text = "insert password"
        textField.layer.borderWidth = 1.0
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
//        textField.textContentType = .password
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationsViewModel.shared.sessionDelegate = self
        LocationsViewModel.shared.errorDelegate = self
        view.backgroundColor = .white
        loginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        
        layoutView()
    }

    func layoutView() {
        let stackView = UIStackView(arrangedSubviews: [logoImageView, loginTextField, passwordTextField, loginButton])
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
        LocationsViewModel.shared.getUserData()
        LoadingOverlay.shared.showOverlay(view: view)
    }
}

extension LoginViewController: SessionCompletionDelegate, ErrorHandlerDelegate {
    func createdSuccessfully() {
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
