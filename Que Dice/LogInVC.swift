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
        //Rockwell-Bold"
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
//        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .lightText
        textField.attributedPlaceholder = NSAttributedString(string: "Username",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textField.leftViewMode = .always
        let image = UIImage(systemName: "person")
        userFieldImage.image = image
        textField.leftView = userFieldImage
        return textField
    }()
    
    lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .lightText
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        setConstraints()
    }
    
    private func setSubviews() {
        self.view.addSubview(backgroundImageView)
        self.view.addSubview(titleLabel)
//        self.view.addSubview(airplaneImage)
        self.view.addSubview(usernameField)
        self.view.addSubview(passwordField)
    }
    
    private func setConstraints() {
        setTitleLabelConstraints()
//        setAirplaneImageConstraints()
        setUsernameFieldConstraints()
        setPasswordFieldConstraints()
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


}

