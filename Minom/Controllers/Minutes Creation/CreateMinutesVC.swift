//
//  MinutesCreationViewController.swift
//  Minom
//
//  Created by Joanda Febrian on 29/04/21.
//

import UIKit

class CreateMinutesVC: UIViewController {

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerImage: UIImageView!
    @IBOutlet weak var clockImage: UIImageView!
    
    @IBOutlet weak var meetingTypeLabel: UILabel!
    @IBOutlet weak var participantNumberLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var agendaLabel: UILabel!
    
    private var logic = MinutesCreationLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Meeting"
        setupSaveButton()
        setupDates()
        setupPicker()
        titleTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupButtonLabels()
        updatePicker()
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Setup User Interface
    
    private func setupButtonLabels() {
        meetingTypeLabel.text = logic.selectedType?.name ?? "Meeting Type"
        participantNumberLabel.layer.masksToBounds = true
        participantNumberLabel.layer.cornerRadius = participantNumberLabel.frame.height * 0.5
        participantNumberLabel.text = "  \(logic.numberOfParticipants())  "
        titleTextField.clearButtonMode = .whileEditing
        agendaLabel.text = logic.getAgenda() == "" ? "No meeting agenda" : logic.getAgenda()
        
    }
    
    private func setupSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
    }
    
    private func setupPicker() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }
    
    private func updatePicker() {
        let state = logic.startTimeSelected
        pickerImage.image = state ? Image.DatePickerBackground : Image.DatePickerBackgroundReverse
        clockImage.tintColor = state ? .white : Color.JungleGreen
        startDateLabel.textColor = state ? .white : Color.JungleGreen
        startTimeLabel.textColor = state ? .white : Color.JungleGreen
        endDateLabel.textColor = state ? Color.JungleGreen : .white
        endTimeLabel.textColor = state ? Color.JungleGreen : .white
        datePicker.setDate(state ? logic.startDate : logic.endDate, animated: true)
    }
    
    private func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupDates() {
        startDateLabel.text = logic.startDateString
        endDateLabel.text = logic.endDateString
        startTimeLabel.text = logic.startTime
        endTimeLabel.text = logic.endTime
    }
    
    // MARK: - User Input Functions
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        logic.updateDates(with: datePicker.date)
        setupDates()
    }
    
    @objc func saveButtonPressed(){
        if let title = titleTextField.text, !title.isEmpty {
            logic.setTitle(with: title)
        }
        let status: (valid: Bool, alert: String, message: String) = logic.meetingValidation()
        if status.valid {
            logic.finishMeetingCreation()
            let sb = Storyboard.MinutesTaking
            let vc = sb.instantiateInitialViewController() as! TakeMinuteVC
            let meeting = logic.meeting
            vc.logic = MinutesLogic(for: meeting)
            vc.creationLogic = logic
            navigationController?.pushViewController(vc, animated: true)
        } else {
            alert(title: status.alert, message: status.message)
        }
    }
    
    @IBAction func togglePickerPressed(_ sender: UIButton) {
        logic.togglePicker(sender.tag)
        updatePicker()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case is SetMeetingTypeTableVC:
            let destination = segue.destination as! SetMeetingTypeTableVC
            destination.logic = self.logic
        case is ParticipantsTableVC:
            let destination = segue.destination as! ParticipantsTableVC
            destination.logic = self.logic
        case is SetMeetingAgendaVC:
            let destination = segue.destination as! SetMeetingAgendaVC
            destination.logic = self.logic
        default:
            break
        }
    }
}

extension CreateMinutesVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}
