//
//  TeamsTableVC.swift
//  Minom
//
//  Created by Joanda Febrian on 04/05/21.
//

import UIKit

class TeamsTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Teams"
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
