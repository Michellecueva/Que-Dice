//
//  ViewController.swift
//  Que Dice
//
//  Created by Michelle Cueva on 11/1/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInVC: UIViewController {
    
      let userFieldImage = UIImageView()
        lazy var titleLabel : UILabel = {
        let label = UILabel()
            label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            label.text = """
                        ¿Qué
                              Dice?
                        """
            label.font = UIFont(name: "Rockwell-Bold", size: 48.0)
            label.numberOfLines = 2
            label.addInterlineSpacing(spacingValue: 20)
            
        return label
    }()
        
        lazy var backgroundImageView: UIImageView = {
            let image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
              image.image = #imageLiteral(resourceName: "sunset.jpg")
              image.contentMode = .scaleToFill
              return image
          }()
        
        lazy var airplaneImage: UIImageView = {
            let image = UIImageView()
            image.image = #imageLiteral(resourceName: "airplane two")
            image.contentMode = .scaleToFill
            return image
        }()
        
        lazy var usernameField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Username"
            textField.borderStyle = .roundedRect
            textField.backgroundColor = .lightText
            return textField
        }()
        
        lazy var passwordField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Password"
            textField.borderStyle = .roundedRect
            textField.backgroundColor = .lightText
            return textField
        }()
        
        lazy var loginButton: UIButton = {
               let button = UIButton(type: .system)
               button.setTitle("Login", for: .normal)
               button.setTitleColor(.white, for: .normal)
               button.titleLabel?.font = UIFont(name: "Arial-Bold", size: 16)
               button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
               button.layer.cornerRadius = 5
               button.addTarget(self, action: #selector(tryLogin), for: .touchUpInside)
               button.isEnabled = true
               return button
           }()
           
           lazy var createAccountButton: UIButton = {
               let button = UIButton(type: .system)
               let attributedTitle = NSMutableAttributedString(
                   string: "Dont have an account?  ",
                   attributes: [
                       NSAttributedString.Key.font: UIFont(name: "Verdana", size: 14)!,
                       NSAttributedString.Key.foregroundColor: UIColor.white
                   ]
               )
               
               attributedTitle.append(NSAttributedString(
                   string: "Sign Up",
                   attributes: [
                       NSAttributedString.Key.font: UIFont(name: "Verdana-Bold", size: 14)!,
                       NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
                   ]
               ))
               
               button.setAttributedTitle(attributedTitle, for: .normal)
               button.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
               return button
           }()

        override func viewDidLoad() {
            super.viewDidLoad()
            setSubviews()
            setConstraints()
        }
        
        //MARK: Obj-C Methods
        
        @objc func showSignUp() {
            let signUpVC = SignUpVC()
            self.present(signUpVC, animated: true, completion: nil)
        }
        
        @objc func tryLogin() {
    //
    //           guard let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
    //               showErrorAlert(title: "Error", message: "Please fill out all fields.")
    //               return
    //           }
    //
    //
    //           guard email.isValidEmail else {
    //               showErrorAlert(title: "Error", message: "Please enter a valid email")
    //               return
    //           }
    //
    //           guard password.isValidPassword else {
    //               showErrorAlert(title: "Error", message: "Please enter a valid password. Passwords must have at least 8 characters.")
    //               return
    //           }
    //
    //           FirebaseAuthService.manager.loginUser(email: email, password: password) { [weak self] (result) in
    //               self?.handleLoginResponse(result: result)
    //           }
               
           }
        
    //MARK: UI Setup
        
        private func setSubviews() {
            self.view.addSubview(backgroundImageView)
            self.view.addSubview(titleLabel)
    //        self.view.addSubview(airplaneImage)
            self.view.addSubview(usernameField)
            self.view.addSubview(passwordField)
            self.view.addSubview(loginButton)
            self.view.addSubview(createAccountButton)
        }
        
        private func setConstraints() {
            setTitleLabelConstraints()
    //        setAirplaneImageConstraints()
            setUsernameFieldConstraints()
            setPasswordFieldConstraints()
            setLogInButtonConstraints()
            setCreateAccountButtonConstraints()
        }
        
        
        
        private func setTitleLabelConstraints() {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 120),
                titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        }
        
        private func setAirplaneImageConstraints() {
            airplaneImage.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                airplaneImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 120),
                airplaneImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                airplaneImage.widthAnchor.constraint(equalToConstant: 300)
            ])
        }
        
        private func setUsernameFieldConstraints() {
            usernameField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                usernameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
                usernameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                usernameField.widthAnchor.constraint(equalToConstant: 300),
                usernameField.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        private func setPasswordFieldConstraints() {
            passwordField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 30),
                passwordField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                passwordField.widthAnchor.constraint(equalToConstant: 300),
                passwordField.heightAnchor.constraint(equalToConstant: 50)
             ])
        }
    
    private func setLogInButtonConstraints() {
           loginButton.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
               loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
               loginButton.widthAnchor.constraint(equalToConstant: 300),
               loginButton.heightAnchor.constraint(equalToConstant: 50)
           ])
       }
       
       private func setCreateAccountButtonConstraints() {
           createAccountButton.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               createAccountButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30),
               createAccountButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
               createAccountButton.widthAnchor.constraint(equalToConstant: 300),
               createAccountButton.heightAnchor.constraint(equalToConstant: 50)
           ])
       }
}

