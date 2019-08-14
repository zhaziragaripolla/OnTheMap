//
//  LoginViewController.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/12/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var loginTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.text = "insert login"
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.text = "insert password"
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("LOG IN", for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    let networkManager = NetworkManager()
    let requestProvider = RequestProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png"))
        loginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        
        layoutView()
    }

    func layoutView() {

        let stackView = UIStackView(arrangedSubviews: [loginTextField, passwordTextField, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 5
        view.addSubview(stackView)
      
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            stackView.heightAnchor.constraint(equalToConstant: 90)
            ])
     
    }
    
    @objc func didTapLoginButton(_ sender: UIButton) {
        let request = requestProvider.createSession(login: "zhumabayeva97@gmail.com", password: "Tools003")

        networkManager.makeRequest(request, responseType: UdacityResponse.self, isSkippingChars: true, callback: { result in
            switch result {
            case .success(let response):
                print(response.account.key)
            case .failure(let error):
                print(error)
                break
            }
            
        })
            
    }
    
    
}

