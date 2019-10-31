//
//  SoundViewController.swift
//  Prox Alarm
//
//  Created by Robert Soto on 10/1/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit
import AVFoundation

protocol UpdateSoundDelegate {
    func didUpdateSound(controller: SoundViewController)
}

class SoundViewController: UIViewController {

    // MARK:- UI Components
    var soundView = SoundView()
    var tableView = UITableView()
    
    // MARK: - Variables
    var dataArray = ["alarm.mp3", "alarm-short.mp3", "cool-alarm.mp3", "eerie-chimes.mp3", "gentle-alarm.mp3", "twin-bell.mp3", "wecker-alarm.mp3"]
    let cellId = "SimpleCell"
    
    var sound = "alarm.mp3"
    
    var delegate: UpdateSoundDelegate! = nil
    
    var player: AVAudioPlayer?
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerTable()
        setUpNavBar()
        setUpValue()
    }
    
    override func loadView() {
        view = soundView
        tableView = soundView.tableView
    }
    
    // MARK: - Set up functions
    func registerTable() {
        tableView.register(SimpleTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
    }
    
    func setUpNavBar() {
        navigationItem.title = "Sound"
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(done))
        doneItem.tintColor = .orange
        navigationItem.rightBarButtonItem = doneItem
    }
    
    func setUpValue() {
        if let row = dataArray.firstIndex(of: sound) {
            let index = IndexPath(row: row, section: 0)
            tableView.selectRow(at: index, animated: true, scrollPosition: .middle)
        }
    }
    
    // MARK: - Functions
    @objc func done() {
        delegate.didUpdateSound(controller: self)
        navigationController?.popViewController(animated: true)
    }
    
    func playSound(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Tableview delegate methods
extension SoundViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            cellId, for: indexPath) as? SimpleTableViewCell {
            cell.leftLabel.text = dataArray[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sound = dataArray[indexPath.row]
        let name = sound.dropLast(4)
        playSound(name: String(name))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = UIScreen.main.bounds.width
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: width, height: 26)
        return view
    }
    
}
