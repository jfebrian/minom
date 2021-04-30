//
//  TakeMinuteTableVC.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import UIKit

class TakeMinuteVC: UIViewController {

    var minutesLogic: MinutesLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.BackArrow, style: .done, target: self, action: #selector(saveAndGoBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Image.People, style: .done, target: self, action: #selector(viewParticipants))
    }
    
    @objc func saveAndGoBack() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func viewParticipants() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Setup User Interface
    
    func setupTitle(in cell: MinuteTitleCell) {
        guard let logic = minutesLogic else { fatalError("Can't find the meeting to show") }
        cell.titleLabel.text = logic.title
        cell.typeLabel.text = logic.type
        cell.startTimeLabel.text = logic.startTime
        cell.endTimeLabel.text = logic.endTime
        cell.dateLabel.text = logic.date
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
    }
    
}


// MARK: - Table View Data Source

extension TakeMinuteVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ID.titleCell, for: indexPath) as! MinuteTitleCell
            setupTitle(in: cell)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ID.buttonCell, for: indexPath) as! ButtonCell
            cell.action = {
                
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ID.itemCell, for: indexPath) as! MinuteItemCell
            return cell
        }
    }
}

extension TakeMinuteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 120 : 66
    }
}
