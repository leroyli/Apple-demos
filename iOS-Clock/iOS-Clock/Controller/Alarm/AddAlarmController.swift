//
//  AddAlarmController.swift
//  iOS-Clock
//
//  Created by Leroy on 2022/11/7.
//

import UIKit

class AddAlarmController: UIViewController {
    
    var contentItems: [ContentItem] {
        [
            .days(alarm.repeatDay),
            .label(alarm.note),
            .sounds("None"),
            .snooze(false)
        ]
    }
    
    var alarm = AlarmInfo(){
        didSet{
            datePicker.date = alarm.date
            tableView.reloadData()
        }
    }
    
    //MARK: - UI
    let datePicker:UIDatePicker = {
        let myPicker = UIDatePicker()
        myPicker.datePickerMode = .time
        myPicker.locale = Locale(identifier: "NL")
        myPicker.preferredDatePickerStyle = .wheels
        return myPicker
    }()
    
    let tableView:UITableView = {
        let myTable = UITableView()
        myTable.layer.cornerRadius = 10
        myTable.isScrollEnabled = false
        myTable.register(AddAlarmTableViewCell.self, forCellReuseIdentifier: AddAlarmTableViewCell.identifier)
        myTable.register(AddAlarmButtonTableViewCell.self, forCellReuseIdentifier: AddAlarmButtonTableViewCell.identifier)
        
        return myTable
    }()
    
    var tempIndexRow:Int = 0
    
    weak var saveAlarmDataDelegate: SaveAlarmInfoDelegate?
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemGroupedBackground
        overrideUserInterfaceStyle = .dark
        setupUI()
        setupNavigation()
    }
    
    
    //MARK: - setupUI
    func setupUI(){
        
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(datePicker)
        self.view.addSubview(tableView)
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(view).offset(48)
            make.width.equalTo(view)
        }

        tableView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(datePicker.snp.bottom).offset(42)
            make.height.equalTo(200)
        }
    }
    
    //MARK: - setup Navigation
    func setupNavigation(){
        navigationItem.title = "Add Alarm"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white]
        navigationItem.rightBarButtonItem?.tintColor = .orange
        navigationItem.leftBarButtonItem?.tintColor = .orange
    }
    
    @objc func cancelButton(){
        self.dismiss(animated: true)
    }
    
    @objc func saveButton(){
        alarm.date = datePicker.date
        UserNotification.addNotificationRequest(alarm: alarm)
        saveAlarmDataDelegate?.saveAlarmInfo(alarmData: alarm, index: tempIndexRow)
        self.dismiss(animated: true)
    }

    
}

extension AddAlarmController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = contentItems[indexPath.row]
        let title = item.title
        switch item {
        case .snooze(let bool):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddAlarmButtonTableViewCell.identifier, for: indexPath) as? AddAlarmButtonTableViewCell else{ return UITableViewCell() }
            cell.titleLabel.text = title
            cell.mySwitch.isOn = bool
            return cell
        case .label(let string), .days(let string), .sounds(let string):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddAlarmTableViewCell.identifier, for: indexPath) as? AddAlarmTableViewCell else{ return UITableViewCell() }
            cell.titleLabel.text = title
            cell.contentLabel.text = string
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = contentItems[indexPath.row]
        switch item {
        case .days:
            let repeatVC = RepeatAlarmController()
            repeatVC.repeatDelegate = self
            repeatVC.selectDays = alarm.selectDays
            self.navigationController?.pushViewController(repeatVC, animated: true)
        case .label:
            let labelVC = AlarmLabelController()
            labelVC.textField.text = alarm.note
            labelVC.labelDelegate = self
            self.navigationController?.pushViewController(labelVC, animated: true)
        default:
            break
        }
    }
    //tableView??????
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension AddAlarmController:UpdateAlarmLabelDelegate{
    func updateAlarmLabel(alarmLabelText: String) {
        alarm.note = alarmLabelText
    }
}

extension AddAlarmController:UpdateRepeatLabelDelegate{
    
    func updateRepeatLabel(selectedDay: Set<Day>) {
        alarm.selectDays = selectedDay
    }
}


//MARK: - protocol??????delegate??????
protocol UpdateAlarmLabelDelegate:AnyObject{
    func updateAlarmLabel(alarmLabelText: String)
}

protocol UpdateRepeatLabelDelegate:AnyObject{
    func updateRepeatLabel(selectedDay:Set<Day>)
}



extension AddAlarmController {
    
    enum ContentItem {
        case days(String), label(String), sounds(String), snooze(Bool)
        
        var title: String {
            switch self {
            case .label: return "Label"
            case .sounds: return "Sounds"
            case .snooze: return "Snooze"
            case .days: return "Days"
            }
        }
    }
    
}
