//  File Name:This is my LocalStorage.swift
//  Description: Handling Gesture control
//  Author's name :..........Add Student's name here........
//  StudentID : ..........Add Student's ID here...........
//  Version info: 1.0

import Foundation
import UIKit

class LocalStorage {
    static let shared = LocalStorage()
    
    
    var isTodoListUpdate: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "isTodoListUpdate")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isTodoListUpdate")
        }
    }
    // Using Local storage to Save Data
    func saveDataInPersistent(toDoArr:[ToDoList]) {
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(toDoArr), forKey:"TodoList")
        isTodoListUpdate = true
    }
    
    func GetSavedItems() -> [ToDoList] {
        if let data = UserDefaults.standard.value(forKey:"TodoList") as? Data {
            do
            {
                return try PropertyListDecoder().decode(Array<ToDoList>.self, from: data)
            } catch {
                return [ToDoList]()
            }
        } else {
            return [ToDoList]()
        }
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 1,
            range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
}

// Adding alert to completed ToDo tasks
extension UIViewController {
    func displayAlertWithCompletion(title:String,message:String,control:[String],completion:@escaping (String)->()){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for str in control {
            let alertAction = UIAlertAction(title: str, style: .default, handler: { (action) in
                completion(str)
            })
            alertController.addAction(alertAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
