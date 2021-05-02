//
//  TakeMinuteTableVC.swift
//  Minom
//
//  Created by Joanda Febrian on 30/04/21.
//

import UIKit
import AVFoundation

class TakeMinuteVC: UIViewController {

    var logic: MinutesLogic?
    var creationLogic: MinutesCreationLogic?
    
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var recordButtonsView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var audioButtonsView: UIView!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var controlSlider: UISlider!
    @IBOutlet weak var audioTimeLabel: UILabel!
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBottomBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.BackArrow, style: .done, target: self, action: #selector(saveAndGoBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Image.People, style: .done, target: self, action: #selector(viewParticipants))
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupRecorder() {
        guard let logic = self.logic else { fatalError("Minutes taking logic not found") }
        let audioFilename = getDocumentDirectory().appendingPathComponent(logic.fileName)
        let recordSetting = [
            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue,
            AVNumberOfChannelsKey : 1,
            AVSampleRateKey : 12000 ]
        
        do {
            soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            print("Error setupping audio recorder, \(error.localizedDescription)")
        }
    }
    
    func setupPlayer() {
        
        guard let logic = self.logic else { fatalError("Minutes taking logic not found") }
        
        let audioFilename = getDocumentDirectory().appendingPathComponent(logic.fileName)
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilename, fileTypeHint: AVFileType.m4a.rawValue)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            print("Error setupping audio player, \(error.localizedDescription)")
        }
    }
    
    func setupView() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordButton.isEnabled = true
                    } else {
                        self.recordButton.isEnabled = false
                    }
                }
            }
        } catch {
            print("Error setting up recording session, \(error.localizedDescription)")
        }
    }
    
    func setupAudioButtons() {
        setupPlayer()
        recordButtonsView.isHidden = true
        audioButtonsView.isHidden = false
        pauseButton.isHidden = true
        controlSlider.value = 0
        controlSlider.maximumValue = Float(soundPlayer.duration)
        audioTimeLabel.text = "00.00"
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
    }
    
    func setupRecordButtons() {
        setupRecorder()
        recordButtonsView.isHidden = false
        audioButtonsView.isHidden = true
        stopRecordButton.isHidden = true
    }
    
    func setupBottomBar() {
        guard let logic = self.logic else { fatalError("Minutes taking logic not found") }
        bottomBar.layer.borderWidth = 0.5
        bottomBar.layer.borderColor = Color.Grey.cgColor
        if logic.meeting.audioExist {
            setupAudioButtons()
        } else {
            setupRecordButtons()
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        logic?.finishRecording()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        pauseButton.isHidden = true
        playButton.isHidden = false
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
        soundRecorder.record()
        recordButton.isHidden = true
        stopRecordButton.isHidden = false
    }
    
    @IBAction func stopRecordPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Stop Recording", message: "You can not resume your recording after stopping it, are you sure you want to it?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let stop = UIAlertAction(title: "Stop", style: .default) { action in
            self.soundRecorder.stop()
            self.soundRecorder = nil
            self.setupAudioButtons()
        }
        alert.addAction(stop)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        soundPlayer.play()
        updateTime()
        playButton.isHidden = true
        pauseButton.isHidden = false
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        soundPlayer.stop()
        updateTime()
        playButton.isHidden = false
        pauseButton.isHidden = true
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        soundPlayer.stop()
        soundPlayer.currentTime = TimeInterval(controlSlider.value)
        soundPlayer.prepareToPlay()
        soundPlayer.play()
    }
    
    @IBAction func goBackward(_ sender: UIButton) {
        soundPlayer.stop()
        let time = TimeInterval(soundPlayer.currentTime - 10)
        soundPlayer.currentTime = time < 0 ? 0 : time
        soundPlayer.prepareToPlay()
        soundPlayer.play()
    }
    
    @IBAction func goForward(_ sender: UIButton) {
        soundPlayer.stop()
        let time = TimeInterval(soundPlayer.currentTime + 10)
        let duration = soundPlayer.duration
        soundPlayer.currentTime = time >= duration ? duration - 1 : time
        soundPlayer.prepareToPlay()
        soundPlayer.play()
    }
    
    
    @objc func updateSlider() {
        controlSlider.value = Float(soundPlayer.currentTime)
    }
    
    @objc func updateTime() {
        let currentTime = Int(soundPlayer.currentTime)
//        let duration = Int(soundPlayer.duration)
//        let total = currentTime - duration
//        let totalString = String(total)
        
        let minutes = currentTime/60
        var seconds = currentTime - minutes / 60
        if minutes > 0 {
            seconds = seconds - 60 * minutes
        }
        
        audioTimeLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
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
    
}


// MARK: - Table View Data Source

extension TakeMinuteVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + (logic?.numberOfItems ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ID.titleCell, for: indexPath) as! MinuteTitleCell
            setupTitle(in: cell)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ID.itemCell, for: indexPath) as! MinuteItemCell
            cell.titleLabel.text = "Meeting Agenda"
            return cell
        } else if indexPath.row == 2 + (logic?.numberOfItems ?? 0){
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
        let lastRow = 2 + (logic?.numberOfItems ?? 0)
        
        if row > 1, row != lastRow {
            let vc = Storyboard.ID.MeetingItem as! MeetingItemVC
            vc.minutesLogic = logic
            vc.minuteItem = logic?.item(at: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        } else if row == 0 {
            let vc = Storyboard.MeetingCreation.instantiateInitialViewController() as! CreateMinutesVC
            vc.logic = creationLogic ?? MinutesCreationLogic(with: logic?.meeting)
            navigationController?.pushViewController(vc, animated: true)
        } else if row == 1 {
            let vc = Storyboard.ID.MeetingAgenda as! SetMeetingAgendaVC
            vc.logic = creationLogic ?? MinutesCreationLogic(with: logic?.meeting)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension TakeMinuteVC: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
}
