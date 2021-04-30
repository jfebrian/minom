//
//  RecentsViewController.swift
//  Minom
//
//  Created by Joanda Febrian on 28/04/21.
//

import UIKit

class RecentsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Minom"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}