//
//  LoginViewController.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/12/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import Reachability
import FBSDKCoreKit
import FBSDKLoginKit

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
        textField.layer.borderColor = UIColor.gray.cgColor
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
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.delegate = self
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("LOG IN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightBlue
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        return button
    }()
    
    lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.text = "Don't have an account?"
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.lightBlue, for: .normal)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    lazy var facebookButton = FBLoginButton()
    let reachability = Reachability()!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Observing internet connection
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setups delegates of view model
        LocationsViewModel.shared.authenticationDelegate = self
        LocationsViewModel.shared.taskDelegate = self
        LocationsViewModel.shared.errorDelegate = self
        
        view.backgroundColor = .white
        
        setupButtons()
        layoutView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if LocationsViewModel.shared.isFacebookLogin {
            present(TabBarController(), animated: false)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    private func setupButtons() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
        facebookButton.delegate = self
    }

    // MARK: View constraints
    private func layoutView() {
        let signUpStackView = UIStackView(arrangedSubviews: [signUpLabel, signUpButton])
        signUpStackView.axis = .horizontal
        
        let stackView = UIStackView(arrangedSubviews: [logoImageView, loginTextField, passwordTextField, loginButton, signUpStackView, facebookButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
      
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            stackView.heightAnchor.constraint(equalToConstant: 240)
            ])
    }
    
    // MARK: Network connection is changed
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            showError(message: "No internet connection")
        }
    }
    
    //  MARK: Login Button
    // Checks for empty textfields and creates a session
    @objc func didTapLoginButton(_ sender: UIButton) {
        
        guard !loginTextField.text!.isEmpty, !passwordTextField.text!.isEmpty else {
            showError(message: "Please fill your email or password")
            return
        }
        
        // Create a session with user credentials
        LocationsViewModel.shared.createSession(email: loginTextField.text!, password: passwordTextField.text!)
        LoadingOverlay.shared.showOverlay(view: view)
    }
    
    // MARK: Sign Up Button
    @objc func didTapSignUpButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
}

extension LoginViewController: NetworkTaskCompletionDelegate, AuthenticationCompletionDelegate, ErrorPresenterDelegate {

    func showError(message: String) {
        LoadingOverlay.shared.hideOverlayView()
       
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

    
    // When authentication is completed, starts to retrieve user data
    func authenticated() {
        LocationsViewModel.shared.getUserData()
    }
    
    func taskCompleted() {
        LoadingOverlay.shared.hideOverlayView()
        present(TabBarController(), animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        LocationsViewModel.shared.deleteSession()
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let error = error else {
            LocationsViewModel.shared.isFacebookLogin = true
            present(TabBarController(), animated: true)
            return
        }
        
        showError(message: error.localizedDescription)
        
    }
    
}
