//
//  ComingSoonVC.swift
//  Minom
//
//  Created by Joanda Febrian on 04/05/21.
//

import UIKit

class ComingSoonVC: UIViewController {

    static let standard = ComingSoonVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.BackgroundSecondary
        setupLabel()
    }
    
    func setupLabel() {
        let screen = UIScreen.main.bounds
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screen.width * 0.75, height: screen.height))
        label.numberOfLines = 0
        label.center = view.center
        label.textAlignment = .center
        label.font = Font.LexendDeca(24)
        label.textColor = Color.LabelJungle
        label.text = "This section is coming soon."
        view.addSubview(label)
    }

}
