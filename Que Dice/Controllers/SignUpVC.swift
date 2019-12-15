//
//  signUpVCViewController.swift
//  Que Dice
//
//  Created by Michelle Cueva on 11/11/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    lazy var backgroundImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        image.image = #imageLiteral(resourceName: "sunset.jpg")
        image.contentMode = .scaleToFill
        return image
    }()
    
    lazy var titleLabel: UILabel = {
              let label = UILabel()
              label.numberOfLines = 0
        label.text = "Que Dice: Create Account"
//        """
//        Que Dice:
//
//          Create Account
//        """
              label.font = UIFont(name: "Rockwell-Bold", size: 28)
              label.textColor = .white
              label.backgroundColor = .clear
              label.textAlignment = .center
              return label
          }()
          
          lazy var emailTextField: UITextField = {
              let textField = UITextField()
              textField.placeholder = "Enter Email"
              textField.font = UIFont(name: "Verdana", size: 14)
              textField.backgroundColor = .lightText
              textField.borderStyle = .roundedRect
              textField.autocorrectionType = .no
              return textField
          }()
          
          lazy var passwordTextField: UITextField = {
              let textField = UITextField()
              textField.placeholder = "Enter Password"
              textField.font = UIFont(name: "Verdana", size: 14)
              textField.backgroundColor = .lightText
              textField.borderStyle = .roundedRect
              textField.autocorrectionType = .no
              textField.isSecureTextEntry = true
              return textField
          }()
          
          lazy var createButton: UIButton = {
              let button = UIButton(type: .system)
              button.setTitle("Create", for: .normal)
              button.setTitleColor(.white, for: .normal)
              button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
              button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
              button.layer.cornerRadius = 5
              button.addTarget(self, action: #selector(trySignUp), for: .touchUpInside)
              button.isEnabled = true
              return button
          }()
    
    lazy var stackView: UIStackView = {
            let stackView = UIStackView(
                arrangedSubviews: [
                    emailTextField,
                    passwordTextField,
                    createButton
                ]
            )
            stackView.axis = .vertical
            stackView.spacing = 30
            stackView.distribution = .fillEqually
            return stackView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        setConstraints()
    }
    
    //MARK: Obj-C Methods
    
    
    @objc func trySignUp() {
//        if !validateFields() {
//            return
//        }
//
//        let email = emailTextField.text!
//        let password = passwordTextField.text!
//        FirebaseAuthService.manager.createNewUser(email: email, password:password) { [weak self] (result) in
//            self?.handleCreateAccountResponse(result: result)
//        }
    }
    
    
    //MARK: UI Setup
    
    private func setSubviews() {
        self.view.addSubview(backgroundImageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(stackView)
    }
    
    private func setConstraints() {
        setTitleLabelConstraints()
        setupStackViewConstraints()
        
    }
    
     private func setTitleLabelConstraints() {
           
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
               titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
               titleLabel.widthAnchor.constraint(equalToConstant: 300),
               titleLabel.heightAnchor.constraint(equalToConstant: 100)
           ])
       }
    
    private func setupStackViewConstraints() {
           
           stackView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
               stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
               stackView.widthAnchor.constraint(equalToConstant: 300),
               stackView.heightAnchor.constraint(equalToConstant: 175)
           ])
       }

    
}
