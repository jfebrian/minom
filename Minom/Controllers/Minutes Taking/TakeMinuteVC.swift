//
//  TakeMinuteTableVC.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import UIKit

class TakeMinuteVC: UIViewController {

    var logic: MinutesLogic?
    var creationLogic: MinutesCreationLogic?
    @IBOutlet weak var bottomBar: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.BackArrow, style: .done, target: self, action: #selector(saveAndGoBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Image.People, style: .done, target: self, action: #selector(viewParticipants))
    }
    
    func setupBottomBar() {
        bottomBar.layer.borderWidth = 0.5
        bottomBar.layer.borderColor = Color.Grey.cgColor
    }
    
    @objc func saveAndGoBack() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func viewParticipants() {
        let vc = Storyboard.ID.ViewParticipants as! ParticipantsTableVC
        vc.minutesLogic = logic
        vc.logic = creationLogic ?? MinutesCreationLogic()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        tableView.reloadData()
    }
    
    // MARK: - Setup User Interface
    
    func setupTitle(in cell: MinuteTitleCell) {
        guard let logic = logic else { fatalError("Can't find the meeting to show") }
        cell.titleLabel.text = logic.title
        cell.typeLabel.text = logic.type
        cell.startTimeLabel.text = logic.startTime
        cell.endTimeLabel.text = logic.endTime
        cell.dateLabel.text = logic.date
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
        logic?.recordAudio()
    }
    
}


// MARK: - Table View Data Source

extension TakeMinuteVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + (logic?.numberOfItems ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ID.titleCell, for: indexPath) as! MinuteTitleCell
            setupTitle(in: cell)
            return cell
        } else if indexPath.row == 1 + (logic?.numberOfItems ?? 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: ID.buttonCell, for: indexPath) as! ButtonCell
            cell.action = {
                let vc = Storyboard.ID.MeetingItem as! MeetingItemVC
                vc.minutesLogic = self.logic
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ID.itemCell, for: indexPath) as! MinuteItemCell
            cell.titleLabel.text = logic?.itemTitle(at: indexPath)
            return cell
        }
    }
}

extension TakeMinuteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 120 : 66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let lastRow = 1 + (logic?.numberOfItems ?? 0)
        
        if row != 0, row != lastRow {
            let vc = Storyboard.ID.MeetingItem as! MeetingItemVC
            vc.minutesLogic = logic
            vc.minuteItem = logic?.item(at: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
