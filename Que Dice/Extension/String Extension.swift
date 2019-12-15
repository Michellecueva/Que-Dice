//
//  String Extension.swift
//  Que Dice
//
//  Created by Michelle Cueva on 11/3/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

extension UILabel {

    func addInterlineSpacing(spacingValue: CGFloat) {

        guard let textString = text else { return }

        let attributedString = NSMutableAttributedString(string: textString)

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = spacingValue

        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))

        attributedText = attributedString
    }

}

extension String {
    var isValidEmail: Bool {
        
        // this pattern requires that an email use the following format:
        // [something]@[some domain].[some tld]
        let validEmailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", validEmailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        
        //this pattern requires that a password has at least one capital letter, one number, one lower case letter, and is at least 8 characters long
        //let validPasswordRegEx =  "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        
        //this pattern requires that a password be at least 8 characters long
        let validPasswordRegEx =  "[A-Z0-9a-z!@#$&*.-]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", validPasswordRegEx)
        return passwordPredicate.evaluate(with: self)
    }
    
    var dateFormatForString: String {
        var formattedString = ""
        
        let dateString = self
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.date(from: dateString)
        if let date = date {
            formatter.dateFormat = "MM/dd/yyyy  h:mm a"
            formattedString = formatter.string(from: date)
        }
        
        return formattedString
    }
}
