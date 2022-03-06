//
//  AddBirthdayVC.swift
//  BirthdayTracker
//
//  Created by Ramil Sharapov on 2022-01-31.
//

import UIKit
import CoreData
import UserNotifications

protocol AddBirthdayDelegate {
    func addBirthdayVC(_ addBirthdayVC: AddBirthdayVC, didAddBirthday: Birthday)
}

class AddBirthdayVC: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    
    var delegate: AddBirthdayDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthDatePicker.maximumDate = Date()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        let firstName = nameTxt.text ?? ""
        let lastname = lastNameTxt.text ?? ""
        let birthdayDate = birthDatePicker.date
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastname
        newBirthday.birthdate = birthdayDate
        newBirthday.birthdayId = UUID().uuidString
        
        delegate?.addBirthdayVC(self, didAddBirthday: newBirthday)
        
        if let uniqueID = newBirthday.birthdayId {
            print("birthdayID: \(uniqueID)")
        }
        
        do {
            try context.save()
            let message = "Today is \(firstName) + \(lastname) birthday"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthdayDate)
            dateComponents.hour = 9
            dateComponents.minute = 34
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            if let identifier = newBirthday.birthdayId {
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
                
            }
        } catch let error {
            print("There is \(error)")
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

