//  File Name: This is my EditToDoVC.swift
//  Description: Handling Gesture control
//  Author's name :..........Add Student's name here........
//  StudentID : ..........Add Student's ID here...........
//  Version info: 1.0

import UIKit

class EditToDoVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    // variables
    var Index = IndexPath()
    var toDoDict = ToDoList()
    var callbackforUpdateTodo:((ToDoList?,IndexPath,Bool,Bool) -> Void)?
    @IBOutlet weak var PickerSelectDate: UIDatePicker!
    @IBOutlet weak var ViwPicker: UIView!
    @IBOutlet weak var txtFieldTaskName: UITextField!
    @IBOutlet weak var TxtViewLongDesc: UITextView!
    @IBOutlet weak var SwitchDueDate: UISwitch!
    @IBOutlet weak var SwitchIsCompleted: UISwitch!
    @IBOutlet weak var ViwNotes: UIView!
    @IBOutlet weak var ViwDue: UIView!
    @IBOutlet weak var ViwIsComplete: UIView!
    @IBOutlet weak var ViwSave: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnStoreTodoAct: UIButton!
    
    var placeholderLabel : UILabel!
    var dateStr = ""
    var iscomplete = Bool()
    var isdue = Bool()
    var isAddNew = Bool()
    var isAnyModification = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpUIForAddNewTodo(visible: isAddNew)
    }
    
    // Setting up the UI
    func setupUI() {
        print(toDoDict)
        TxtViewLongDesc.layer.borderColor = UIColor.gray.cgColor
        TxtViewLongDesc.layer.borderWidth = 0.2
        TxtViewLongDesc.layer.cornerRadius = 5.0
        iscomplete = toDoDict.isComplete ?? false
        isdue = toDoDict.isDueDate ?? false
        dateStr = toDoDict.strDate ?? ""
        txtFieldTaskName.text = toDoDict.shorTitle ?? ""
        SwitchDueDate.setOn(toDoDict.isDueDate ?? false, animated: false)
        SwitchIsCompleted.setOn(toDoDict.isComplete ?? false, animated: false)
        TxtViewLongDesc.textColor = UIColor.lightGray
        btnStoreTodoAct.setTitle("\(isAddNew ? "Save" : "Update")", for: .normal)
        if toDoDict.isComplete ?? false {
            ViwPicker.isHidden = true
        } else if toDoDict.isDueDate ?? false == false {
            ViwPicker.isHidden = true
        }
        if toDoDict.longDesc ?? "" == "" {
            TxtViewLongDesc.text = "Description of your Todo task \nNotes can also be added here."
            TxtViewLongDesc.textColor = UIColor.lightGray
        } else {
            TxtViewLongDesc.text = toDoDict.longDesc ?? ""
            TxtViewLongDesc.textColor = UIColor.black
        }
        if let strdate = toDoDict.strDate, strdate != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM d,yyyy"
            PickerSelectDate.date = dateFormatter.date(from: strdate) ?? Date()
        }
        txtFieldTaskName.becomeFirstResponder()
    }
    
    func setUpUIForAddNewTodo(visible:Bool)
    {
        ViwDue.isHidden = visible
        ViwIsComplete.isHidden = visible
        ViwSave.isHidden = visible
        btnDelete.isHidden = visible
    }
    
    @IBAction func BtnEditAct(_ sender: Any) {
        displayAlertWithCompletion(title: "ToDo!", message: "Do you wish to \(isAddNew ? "save" : "update") the task.", control: ["Cancel","\(isAddNew ? "Save" : "Update")"]) { str in
            if str ==  "Save" || str == "Update" {
                self.saveTodo()
            }
        }
    }

    func saveTodo() {
        toDoDict = ToDoList.init(shorTitle: txtFieldTaskName.text, longDesc: TxtViewLongDesc.text, isComplete: iscomplete, isDueDate:isdue , strDate: dateStr)
        callbackforUpdateTodo?(toDoDict,Index,false,true)
        self.navigationController?.popViewController(animated: true)
    }
  
    @IBAction func BtnDeleteAct(_ sender: Any) {
        displayAlertWithCompletion(title: "ToDo!", message: "This action is permanent \nAre sure wish to delete this task.", control: ["Cancel","Delete"]) { str in
            if str == "Delete" {
                self.callbackforUpdateTodo?(self.toDoDict,self.Index,true,false)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func BtnBackAct(_ sender: Any){
        if isAnyModification {
            displayAlertWithCompletion(title: "ToDo!", message: "Do you wish to discard the changes.", control: ["Cancel","Save"]) { str in
                if str == "Save" {
                    self.saveTodo()
                }
            }
        } else {
            self.callbackforUpdateTodo?(self.toDoDict,self.Index,self.isAddNew,false)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Date picker
    @IBAction func PickerChangeDateAct(_ sender: UIDatePicker) {
        self.isAnyModification = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d,yyyy"
        dateStr = dateFormatter.string(from: sender.date)
    }
    
    // Complete and Incomplete ToDo task Switch action
    @IBAction func CompelteSwitchAct(_ sender: UISwitch) {
        self.isAnyModification = true
        if sender.isOn {
            ViwPicker.isHidden = true
            SwitchDueDate.setOn(false, animated: true)
            iscomplete = true
            isdue = false
        } else {
            iscomplete = false
        }
    }
    
    // Setting the Due date
    @IBAction func DueSwitchAct(_ sender: UISwitch) {
        self.isAnyModification = true
        if sender.isOn {
            ViwPicker.isHidden = false
            SwitchIsCompleted.setOn(false, animated: true)
            iscomplete = false
            isdue = true
        } else {
            ViwPicker.isHidden = true
            isdue = false
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            self.isAnyModification = true
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Description of the Todo task \nNotes can also be added here."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            self.isAnyModification = true
            setUpUIForAddNewTodo(visible: false)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
