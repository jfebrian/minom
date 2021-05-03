//
//  SettingsViewController.swift
//  Minom
//
//  Created by Joanda Febrian on 28/04/21.
//

import UIKit

class SettingsTableVC: UITableViewController {

    let settingCategories = [
        SettingsCategory(title: "User Preferences",
                         settings: ["User Information","Teams","App Theme"]),
        SettingsCategory(title: "Support", settings: ["Help","Send Feedback","Rate on App Store"]),
        SettingsCategory(title: "About Minom",
                         settings: ["Change Logs","Licenses","About"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingCategories.count + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == settingCategories.count {
            return UIScreen.main.bounds.height
        }
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        view.backgroundColor = Color.BackgroundSecondary
        
        if section < settingCategories.count {
            let label = UILabel(frame: CGRect(x: 20, y: 14, width: tableView.frame.size.width - 40, height: 20))
            label.text = settingCategories[section].title.uppercased()
            label.font = .systemFont(ofSize: 13)
            label.textColor = Color.LabelGrey
            view.addSubview(label)
        }
        
        return view
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == settingCategories.count {
            return 0
        }
        return settingCategories[section].settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = settingCategories[indexPath.section].settings[indexPath.row]
        cell.textLabel?.font = Font.LexendDeca(17)
        cell.textLabel?.textColor = Color.LabelJungle
        
        let image = Image.RightChevron
        let checkmark  = UIImageView(frame: CGRect(x:0, y:0, width: image.size.width, height: image.size.height))
        checkmark.image = image
        cell.tintColor = Color.LabelJungle
        cell.accessoryView = checkmark
        return cell
    }
}

struct SettingsCategory {
    let title: String
    let settings: [String]
}
