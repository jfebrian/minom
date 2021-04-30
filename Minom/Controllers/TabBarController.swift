//
//  TabBarController.swift
//  Minom
//
//  Created by Joanda Febrian on 28/04/21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
    }
    
    private func setupTabBar() {
        tabBar.barTintColor = Color.MenuJungle
        tabBar.tintColor = .white
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: Font.RobotoMedium(10)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .selected)

    }
}
