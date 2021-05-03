//
//  MeetingCell.swift
//  Minom
//
//  Created by Joanda Febrian on 03/05/21.
//

import UIKit

class MeetingCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var participant1: UILabel!
    @IBOutlet weak var participant2: UILabel!
    @IBOutlet weak var participant3: UILabel!
    @IBOutlet weak var participant4: UILabel!
    @IBOutlet weak var participant5: UILabel!
    @IBOutlet weak var participant6: UILabel!
    @IBOutlet weak var moreParticipantLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCard()
    }
    
    func setupCard() {
        cardView.layer.cornerRadius = 10.0
        cardView.layer.borderWidth = 0.5
        cardView.layer.borderColor = Color.Grey.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func participantLabels() -> [UILabel] {
        return [
            participant1, participant2, participant3, participant4, participant5, participant6
        ]
    }

}
