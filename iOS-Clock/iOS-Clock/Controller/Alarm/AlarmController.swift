//
//  AlarmController.swift
//  iOS-Clock
//
//  Created by Leroy on 2022/11/7.
//

import UIKit

class AlarmController: UIViewController {
    
    var alarmStore = AlarmStore(){
        didSet{
            alarmTableView.reloadData()
        }
    }
    
    //MARK: - UI
    let alarmTableView:UITableView = {
        let myTable = UITableView(frame: .zero, style: .grouped)
        myTable.separatorStyle = .singleLine
        myTable.register(AlarmListTableViewCell.self, forCellReuseIdentifier: "alarm")
        myTable.backgroundColor = .black
        myTable.backgroundView?.backgroundColor = .black
        return myTable
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        alarmTableView.dataSource = self
        alarmTableView.delegate = self
        setupNavigation()
        setViews()
        setLayouts()
    }
    
    //MARK: - setViews
    func setViews(){
        self.view.addSubview(alarmTableView)
    }
    
    //MARK: - setLayouts
    func setLayouts(){
        
        alarmTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - setup Navegation
    func setupNavigation(){
        navigationItem.title = "Alarm"
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAlarm))
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white]
        navigationItem.rightBarButtonItem?.tintColor = .orange
        editButtonItem.tintColor = .orange
    }
    
    //editButton
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        alarmTableView.setEditing(editing, animated: true)
    }
    
    @objc func addAlarm(){
        alarmStore.isEdit = false
        let vc = AddAlarmController()
        vc.saveAlarmDataDelegate = self
        let addAlarmNav = UINavigationController(rootViewController: vc)
        present(addAlarmNav, animated: true, completion: nil)
    }
    
}

//MARK: - tableView
extension AlarmController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmStore.alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarm", for: indexPath) as? AlarmListTableViewCell else {return UITableViewCell()}
        let alarm = alarmStore.alarms[indexPath.row]
        
        cell.backgroundColor = .black
        cell.textLabel?.text = alarm.date.toString(format: "HH:mm")
        cell.detailTextLabel?.text = alarm.noteLabel
        cell.lightSwitch.isHidden = alarmTableView.isEditing ? true : false
        cell.lightSwitch.isOn = alarm.isOn
        
        cell.callBackSwitchState = {isOn in
            self.alarmStore.isSwitch(indexPath.row, isOn)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            alarmStore.remove(indexPath.row)
        }
    }
}

extension AlarmController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alarmStore.isEdit = true
        let vc = AddAlarmController()
        vc.saveAlarmDataDelegate = self
        let alarm = alarmStore.alarms[indexPath.row]
        vc.alarm = alarm
        vc.tempIndexRow = indexPath.row
        let addAlarmNC = UINavigationController(rootViewController: vc)
        present(addAlarmNC, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

//MARK: - saveAlarm
extension AlarmController:SaveAlarmInfoDelegate{
    func saveAlarmInfo(alarmData: AlarmInfo, index: Int) {
        if alarmStore.isEdit == false{
            alarmStore.append(alarmData)
        }else{
            alarmStore.edit(alarmData, index)
        }
    }
}

protocol SaveAlarmInfoDelegate:AnyObject{
    func saveAlarmInfo(alarmData:AlarmInfo, index: Int)
}


extension AlarmController{
    enum AlarmSection:Int, CaseIterable{
        case wakeup = 0, other
    }
}
