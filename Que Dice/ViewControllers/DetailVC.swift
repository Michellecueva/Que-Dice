//
//  DetailVC.swift
//  Que Dice
//
//  Created by Michelle Cueva on 12/11/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var image: UIImage!
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView(frame: self.view.frame)
        imageView.backgroundColor = .gray
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(userImageView)
        userImageView.image = image
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
