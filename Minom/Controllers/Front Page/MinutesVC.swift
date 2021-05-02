//
//  MinutesViewController.swift
//  Minom
//
//  Created by Joanda Febrian on 28/04/21.
//

import UIKit

class MinutesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let meetingLogic = MeetingLogic.standard
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        tableView.backgroundColor = Color.BackgroundSecondary
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupNavBar() {
        navigationItem.title = "Minutes"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search Minutes"
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.textColor = .white
        
        let textField = searchController.searchBar.searchTextField
        let glassIconView = textField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
        glassIconView.tintColor = UIColor.white

        
        definesPresentationContext = true

    }
    
    private func filterContentForSearchText(_ searchText: String) {
        meetingLogic.searchMeetings(for: searchText)
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Add button pressed
    }
    
}

// MARK: - UITableViewDataSource

extension MinutesVC: UITableViewDataSource {
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return meetingLogic.numberOfMonths(isFiltering)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingLogic.numberOfMeetingsInMonth(section, isFiltering)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        let label = UILabel(frame: CGRect(x: 20, y: 14, width: tableView.frame.size.width - 40, height: 20))
        view.backgroundColor = Color.BackgroundSecondary
        label.text = meetingLogic.monthName(with: section, isFiltering)
        label.font = .systemFont(ofSize: 13)
        label.textColor = Color.LabelGrey
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return Custom.separator(width: tableView.frame.width)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.selectionStyle = .none
        cell.textLabel?.text = meetingLogic.meetingTitle(at: indexPath, isFiltering)
        cell.textLabel?.font = Font.LexendDeca(17)
        cell.textLabel?.textColor = Color.LabelJungle
        
        cell.detailTextLabel?.text = meetingLogic.meetingType(at: indexPath, isFiltering)
        cell.detailTextLabel?.font = Font.RobotoLight(14)
        cell.detailTextLabel?.textColor = Color.EmeraldGreen
        
        let image = UIImage(systemName: "chevron.right")
        let disclosureIndicator  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!));
        disclosureIndicator.image = image
        cell.accessoryView = disclosureIndicator
        cell.tintColor = Color.LabelJungle
        
        
        cell.addSubview(Custom.separator(width: tableView.frame.width))
        
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate

extension MinutesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = Storyboard.MinutesTaking
        let vc = sb.instantiateInitialViewController() as! TakeMinuteVC
        let meeting = meetingLogic.meeting(at: indexPath, isFiltering)
        vc.logic = MinutesLogic(for: meeting)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension MinutesVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
