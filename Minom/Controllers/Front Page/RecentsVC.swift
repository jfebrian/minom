//
//  RecentsViewController.swift
//  Minom
//
//  Created by Joanda Febrian on 28/04/21.
//

import UIKit

class RecentsVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCollectionView()
        collectionView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: ID.calendarCell)
        scrollToEnd()
    }
    
    func scrollToEnd() {
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: NSIndexPath(row: 14 - 1, section: 0) as IndexPath, at: .right, animated: false)
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width / 8.5, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupNavBar() {
        navigationItem.title = "Minom"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Collection View Protocols

extension RecentsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID.calendarCell, for: indexPath) as! CalendarCell
        cell.dateLabel.text = "\(indexPath.row + 1)"
        cell.selected(indexPath.row == 14 - 1)
        return cell
    }
    
}
