//
//  MinutesCreationViewController.swift
//  Minom
//
//  Created by Joanda Febrian on 29/04/21.
//

import UIKit

class MinutesCreationViewController: UIViewController {

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerImage: UIImageView!
    @IBOutlet weak var clockImage: UIImageView!
    
    var logic = MinutesCreationLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSaveButton()
        setupDates()
        setupPicker()
    }
    
    // MARK: - Setup User Interface
    
    func setupSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
    }
    
    func setupPicker() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }
    
    func updatePicker() {
        let state = logic.startTimeSelected
        pickerImage.image = state ? Image.DatePickerBackground : Image.DatePickerBackgroundReverse
        clockImage.tintColor = state ? .white : Color.JungleGreen
        startDateLabel.textColor = state ? .white : Color.JungleGreen
        startTimeLabel.textColor = state ? .white : Color.JungleGreen
        endDateLabel.textColor = state ? Color.JungleGreen : .white
        endTimeLabel.textColor = state ? Color.JungleGreen : .white
        datePicker.setDate(state ? logic.startDate : logic.endDate, animated: true)
    }
    
    func setupDates() {
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
    
    @IBAction func meetingTypeButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func participantsButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func meetingAgendaButtonPressed(_ sender: UIButton) {
        
    }
    
}
