//
//  RecentsViewController.swift
//  Minom
//
//  Created by Joanda Febrian on 28/04/21.
//

import UIKit

class RecentsVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyCardView: UIView!
    private let meetingLogic = MeetingLogic.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recents"
        setupView()
        meetingLogic.selectRecent(at: 13)
        collectionView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: ID.calendarCell)
        scrollToEnd()
    }
    
    func scrollToEnd() {
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: NSIndexPath(row: 14 - 1, section: 0) as IndexPath, at: .right, animated: false)
    }
    
    func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: (view.frame.width - 8 * 7) / 7.5, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        emptyCardView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    @IBAction func emptyButtonPressed(_ sender: UIButton) {
        let sb = Storyboard.MeetingCreation
        let vc = sb.instantiateInitialViewController()!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Collection View Protocols

extension RecentsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meetingLogic.recentDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID.calendarCell, for: indexPath) as! CalendarCell
        cell.dateLabel.text = meetingLogic.recentDate(at: indexPath)
        cell.dayLabel.text = meetingLogic.recentDay(at: indexPath)
        cell.selected(meetingLogic.isSelectedRecent(at: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        meetingLogic.selectRecent(at: indexPath.row)
        collectionView.reloadData()
        tableView.reloadData()
    }
    
}

// MARK: - Table View Protocols

extension RecentsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = meetingLogic.selectedCount()
        if count == 0 {
            tableView.isHidden = true
            return 0
        } else {
            tableView.isHidden = false
            tableView.backgroundView = nil
            return count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != meetingLogic.selectedCount() {
            let cell = tableView.dequeueReusableCell(withIdentifier: ID.meetingCell, for: indexPath) as! MeetingCell
            let meeting = meetingLogic.recentMeeting(at: indexPath)
            cell.titleLabel.text = meeting.title
            cell.typeLabel.text = meeting.type?.name ?? "No Meeting Type"
            cell.startTimeLabel.text = meetingLogic.startTime(for: meeting)
            cell.endTimeLabel.text = meetingLogic.endTime(for: meeting)
            let participantInfo = meetingLogic.participantInfo(for: meeting)
            let participantLabels = cell.participantLabels()
            for i in 0...participantInfo.0.count - 1 {
                guard i < 6 else { break }
                participantLabels[i].isHidden = false
                participantLabels[i].text = participantInfo.0[i]
            }
            if let left = participantInfo.1 {
                cell.moreParticipantLabel.isHidden = false
                cell.moreParticipantLabel.text = "and \(left) more participants..."
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ID.newMeetingButtonCell, for: indexPath) as! NewMeetingButtonCell
            cell.action = {
                let sb = Storyboard.MeetingCreation
                let vc = sb.instantiateInitialViewController()!
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != meetingLogic.selectedCount() {
            let sb = Storyboard.MinutesTaking
            let vc = sb.instantiateInitialViewController() as! TakeMinuteVC
            let meeting = meetingLogic.recentMeeting(at: indexPath)
            vc.logic = MinutesLogic(for: meeting)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
