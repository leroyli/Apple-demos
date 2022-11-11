//
//  TimerController.swift
//  iOS-Clock
//
//  Created by Leroy on 2022/11/7.
//

import UIKit

enum CircleTimerState {
    case started
    case paused
    case resumed
}

class TimerController: UIViewController {
    var timer = TimerObject()
    var timerProgressView = TimerProgressView()
    var circleTimerState: CircleTimerState?
    var count = (0, 0, 0)
    var timerCount = 0 {
        didSet {
            if timerCount == 0 {
                timerCount = 0
                timer.invalidate()
                cancelAction()
                UserNotification.addTimerNotification()
            }
        }
    }

    let hours = Array(0...23)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    
    lazy var pickerView: UIPickerView = {
        let v = UIPickerView.init(frame: .zero)
        return v
    }()
    
    lazy var startPauseButton: UIButton = {
        let b = UIButton(type: .custom)
        b.backgroundColor = UIColor.init(red: 23/255.0, green: 51/255.0, blue: 25/255.0, alpha: 1.0)
        b.setTitle("Start", for: .normal)
        let fontColor = UIColor.init(red: 84/255.0, green: 172/255.0, blue: 86/255.0, alpha: 1.0)
        b.setTitleColor(fontColor, for: .normal)
        b.layer.cornerRadius = 38
        return b
    }()
    
    lazy var cancelButton: UIButton = {
        let b = UIButton(type: .custom)
        b.backgroundColor = UIColor.init(red: 29/255.0, green: 29/255.0, blue: 31/255.0, alpha: 1.0)
        let fontColor = UIColor.init(red: 74/255.0, green: 74/255.0, blue: 77/255.0, alpha: 1.0)
        b.setTitleColor(fontColor, for: .normal)
        b.setTitle("Cancel", for: .normal)
        b.layer.cornerRadius = 38
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return b
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        circleTimerState = .none
        setUpTimerCircleView()
        timerProgressView.isHidden = true
        timerProgressView.alpha = 0
        pickerView.alpha = 1
    }
    
    func setupUI() {
        view.backgroundColor = .black
        view.addSubview(pickerView)
        view.addSubview(startPauseButton)
        view.addSubview(cancelButton)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(count.1, inComponent: 1, animated: false)
        pickerView.selectRow(count.2, inComponent: 2, animated: false)
        
        startPauseButton.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        pickerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.height.equalTo(240)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(6)
            make.top.equalTo(self.pickerView.snp.bottom).offset(5)
            make.width.height.equalTo(76)
        }
        
        startPauseButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(6)
            make.top.equalTo(self.pickerView.snp.bottom).offset(5)
            make.width.height.equalTo(76)
        }
    }
    
    func setUpTimerCircleView() {
        view.insertSubview(timerProgressView, at: 0)

        timerProgressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(100)
            make.height.equalTo(200)
        }
    }
    
    @objc func startAction() {
        timerProgressView.progressCircle.duration = timerCount
        
        updateTimerEndTime()
        
        if circleTimerState == nil {
            circleTimerState = .started
            timerProgressView.progressCircle.startCircleAnimation()
        }

        switch circleTimerState {
        case .started:
            circleTimerState = .paused
            
            startPauseButton.changeColor(to: .systemOrange, "Pause")
            cancelButton.isEnabled = true
            
            timer.startTimer(timeIntervar: 1, selector: #selector(fireTimer), target: self)
            
        case .paused:
            
            startPauseButton.changeColor(to: .systemGreen, "Resume")
            cancelButton.isEnabled = true
            
            timerProgressView.timeView.timerEndView.bellImageView.tintColor = .systemGray3.withAlphaComponent(0.5)
            timerProgressView.timeView.timerEndView.timerEndLabel.textColor = .label.withAlphaComponent(0.5)
            
            timer.invalidate()
            circleTimerState = .resumed
            
        case .resumed:
            
            startPauseButton.changeColor(to: .systemOrange, "Pause")
            timer.startTimer(timeIntervar: 1, selector: #selector(fireTimer), target: self)
            
            updateTimerEndTime()
            timerProgressView.timeView.timerEndView.timerEndLabel.text = timerEndTime(time: count)
            
            timerProgressView.isHidden = true
            pickerView.isHidden = false
            
            timerProgressView.timeView.timerEndView.bellImageView.tintColor = .systemGray3.withAlphaComponent(1)
            timerProgressView.timeView.timerEndView.timerEndLabel.textColor = .label.withAlphaComponent(1)
            
            circleTimerState = .paused
        case .none:
            startPauseButton.changeColor(to: .systemGreen, "Start")
            cancelButton.isEnabled = false
            
            circleTimerState = .started
        }
        
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.timerProgressView.isHidden = false
            self?.timerProgressView.alpha = 1
            self?.pickerView.alpha = 0
            self?.pickerView.isHidden = true
        }
    }
    
    @objc func cancelAction() {
        // after canceling timer and starting again, time label was incorect
        timerCount = tupleOfSecondsToSeconds(count)
        timerProgressView.timeView.timeLabel.text = tupleOfSecondsToString(count)
        
        
        updateTimerEndTime()
        
        timer.invalidate()
        circleTimerState = .none
        
        switch circleTimerState {
        case .none:
            cancelButton.isEnabled = false
        default:
            cancelButton.isEnabled = true
        }
        
        startPauseButton.changeColor(to: .systemGreen, "Start")
                
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.timerProgressView.isHidden = true
            self?.pickerView.isHidden = false
            
            self?.timerProgressView.alpha = 0
            self?.pickerView.alpha = 1
        }
    }
    
    func updateTimerEndTime() {
        let currentTime = CurrentTime.shared
        currentTime.updateTime()
        
        timerProgressView.timeView.timerEndView.timerEndLabel.text = timerEndTime(time: count)
    }
    
    @objc func fireTimer() {
        timerCount -= 1
        
        timerProgressView.timeView.timeLabel.text = timerCount.timerSecondsToString()
    }

}

extension TimerController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hours.count
        }
        return minutes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = String(row)
        label.textAlignment = .center
        var typeStr: String = "Hour"
        if component == 0 { typeStr = "Hour" }
        else if component == 1 { typeStr = "Minute" }
        else { typeStr = "Second" }
        label.text = "\(row) \(typeStr)"
                
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0: count.0 = hours[row]
        case 1: count.1 = minutes[row]
        case 2: count.2 = seconds[row]
        default: break
        }
                
        timerCount = tupleOfSecondsToSeconds(count)
        timerProgressView.timeView.timeLabel.text = tupleOfSecondsToString(count)
        
        if timerCount == 0 {
            startPauseButton.isDisabled(true)
        } else if timerCount > 0 {
            startPauseButton.isDisabled(false)
        }
    }
}
