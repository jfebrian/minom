//
//  NavigationController.swift
//  Minom
//
//  Created by Joanda Febrian on 28/04/21.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Color.MenuJungle
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: Font.LexendDeca(17)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: Font.LexendDeca(34)]

        let navBar = navigationBar
        navBar.tintColor = .white
        navBar.standardAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
    }
}
