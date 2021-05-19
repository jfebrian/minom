//
//  SettingsLogic.swift
//  Minom
//
//  Created by Joanda Febrian on 04/05/21.
//

import UIKit

class SettingsLogic {
    
    static let standard = SettingsLogic()
    
    let settingCategories = [
        SettingsCategory(title: "Preferences",
                         settings: ["Teams","Templates","App Theme"]),
        SettingsCategory(title: "Support", settings: ["Help","Send Feedback","Rate on App Store"]),
        SettingsCategory(title: "Information",
                         settings: ["Changelog","Licenses","About"])
    ]
    
    init() {
        
    }
    
    func vc(for indexPath: IndexPath) -> UIViewController? {
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            return nil
        case (1, 0):
            return TeamsTableVC()
        case (let x, let y):
            let vc = ComingSoonVC.standard
            vc.navigationItem.title = settingCategories[x-1].settings[y] // use enum instead to make it more faster when mapping the data
            return vc
        }
    }
    
}
