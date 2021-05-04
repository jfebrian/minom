//
//  SettingsViewController.swift
//  Minom
//
//  Created by Joanda Febrian on 28/04/21.
//

import UIKit

class SettingsTableVC: UITableViewController {
    
    let logic = SettingsLogic.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return logic.settingCategories.count + 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == logic.settingCategories.count + 1{
            return tableView.bounds.height - (40 * 4) - (44 * 10) - (tabBarController?.tabBar.bounds.height ?? 0)
        }
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        view.backgroundColor = Color.BackgroundSecondary
        
        if section < logic.settingCategories.count + 1 {
            let label = UILabel(frame: CGRect(x: 20, y: 14, width: tableView.frame.size.width - 40, height: 20))
            label.text = section == 0 ? "USER INFORMATION" : logic.settingCategories[section - 1].title.uppercased()
            label.font = .systemFont(ofSize: 13)
            label.textColor = Color.LabelGrey
            view.addSubview(label)
        } else {
            let label = UILabel(frame: CGRect(x: 0, y: 14, width: tableView.frame.size.width, height: 20))
            label.textAlignment = .center
            let dictionary = Bundle.main.infoDictionary!
            let version = dictionary["CFBundleShortVersionString"] as! String
            let build = dictionary["CFBundleVersion"] as! String
            label.text = "MINOM \(version) (\(build))"
            label.font = .systemFont(ofSize: 13)
            label.textColor = Color.LabelGrey
            view.addSubview(label)
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == logic.settingCategories.count + 1{
            return 0
        } else if section == 0 {
            return 1
        }
        return logic.settingCategories[section - 1].settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section > 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = logic.settingCategories[indexPath.section - 1].settings[indexPath.row]
            cell.textLabel?.font = Font.LexendDeca(17)
            cell.textLabel?.textColor = Color.LabelJungle
            
            let image = Image.RightChevron
            let checkmark  = UIImageView(frame: CGRect(x:0, y:0, width: image.size.width, height: image.size.height))
            checkmark.image = image
            cell.tintColor = Color.LabelJungle
            cell.accessoryView = checkmark
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameCell
            cell.nameTextField.text = UserDefaults.standard.string(forKey: "UserName")
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = logic.vc(for: indexPath) {
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

struct SettingsCategory {
    let title: String
    let settings: [String]
}
