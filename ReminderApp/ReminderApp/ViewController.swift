//
//  ViewController.swift
//  ReminderApp
//
//  Created by Muhammet Eren on 12.05.2023.
//

import UserNotifications
import UIKit

class ViewController: UIViewController {
    @IBOutlet var table:UITableView!
    var models = [MyReminder]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    @IBAction func didTappAdd(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddViewController else {
            return
        }
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title,body, date in
            DispatchQueue.main
              .async {
                  self.navigationController?.popViewController(animated:  true)
                }
            let new = MyReminder(title: title, date: date, identifier: "id_\(title)")
            self.models.append(new )
            self.table.reloadData()
            
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.sound = .default
            content.body = body
            
            let targetDate = date
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: targetDate), repeats: false)
            let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger )
            UNUserNotificationCenter.current().add(request,withCompletionHandler: {error in
                if error != nil{
                    print("something went wrong ")
                }
            })
            
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func didTappTest(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound], completionHandler: {success,error in
            if success {
                self.scheduleTest()
            } else if error != nil{
                print("error occured")
            }
        })
        
    }
    func scheduleTest(){
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.sound = .default
        content.body = "My Long Body.My Long Body.My Long Body.My Long Body.My Long Body.My Long Body."
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger )
        UNUserNotificationCenter.current().add(request,withCompletionHandler: {error in
            if error != nil{
                print("something went wrong ")
            }
        })
        
    }


}



extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        models.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
}

struct MyReminder{
    let title:String
    let date:Date
    let identifier:String
}

