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
    
    private var logic = MinutesCreationLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSaveButton()
        setupDates()
        setupPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupButtonLabels()
    }
    
    // MARK: - Setup User Interface
    
    private func setupButtonLabels() {
        meetingTypeLabel.text = logic.selectedType?.name ?? "Meeting Type"
        participantNumberLabel.layer.masksToBounds = true
        participantNumberLabel.layer.cornerRadius = participantNumberLabel.frame.height * 0.5
        participantNumberLabel.text = "  \(logic.numberOfParticipants())  "
        titleTextField.clearButtonMode = .whileEditing
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
        case is SetParticipantsTableVC:
            let destination = segue.destination as! SetParticipantsTableVC
            destination.logic = self.logic
        case is SetMeetingAgendaVC:
            break
        default:
            break
        }
    }
    
}
