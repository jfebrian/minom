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
    
    var fileName: String = "audioFile.m4a"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.BackArrow, style: .done, target: self, action: #selector(saveAndGoBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Image.People, style: .done, target: self, action: #selector(viewParticipants))
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupRecorder() {
        let audioFilename = getDocumentDirectory().appendingPathComponent(fileName)
        let recordSetting = [
            AVFormatIDKey : kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey : 2,
            AVSampleRateKey : 44100.2 ] as [String : Any]
        
        do {
            soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            print("Error setupping audio recorder, \(error.localizedDescription)")
        }
    }
    
    func setupPlayer() {
        let audioFilename = getDocumentDirectory().appendingPathComponent(fileName)
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            print("Error setupping audio player, \(error.localizedDescription)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        pauseButton.isHidden = true
        playButton.isHidden = false
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
//        soundRecorder.record()
        recordButton.isHidden = true
        stopRecordButton.isHidden = false
    }
    
    @IBAction func stopRecordPressed(_ sender: UIButton) {
//        soundRecorder.stop()
        let alert = UIAlertController(title: "Stop Recording", message: "You can not resume your recording after stopping it, are you sure you want to it?", preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(no)
        let yes = UIAlertAction(title: "Yes", style: .default) { action in
            self.recordButtonsView.isHidden = true
            self.audioButtonsView.isHidden = false
            self.pauseButton.isHidden = true
        }
        alert.addAction(yes)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        playButton.isHidden = true
        pauseButton.isHidden = false
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        playButton.isHidden = false
        pauseButton.isHidden = true
    }
    
    func setupBottomBar() {
        bottomBar.layer.borderWidth = 0.5
        bottomBar.layer.borderColor = Color.Grey.cgColor
        stopRecordButton.isHidden = true
        audioButtonsView.isHidden = true
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

extension TakeMinuteVC: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
}
