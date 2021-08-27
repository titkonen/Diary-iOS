import UIKit
import CoreData

class AddNewContactViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var contactTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    
    var negativeHeight: CGFloat = 0
    var contactToDisplay = Contact()
    
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        
        let helper = CoreDataHelper()
        
        guard let newContact = NSEntityDescription.insertNewObject(
            forEntityName: "Contact",
            into: helper.context) as? Contact else { return }
        
        newContact.firstName = firstNameTF.text
        newContact.lastName = lastNameTF.text
        newContact.emailId = emailTF.text
        newContact.contactNumber = Int64(contactTF.text ?? "0") ?? 0
        
        do {
            try helper.context.save()
            print("saved contact")
        }
        catch
        {
            print("error in saving context")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTF.delegate = self
        contactTF.delegate = self
        lastNameTF.delegate = self
        firstNameTF.delegate = self
    }

}

extension AddNewContactViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyboardWillHideField(height: negativeHeight)
        negativeHeight = 0
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShowField(height: CGFloat) {
        if self.view.tag == 0 {
            self.view.frame.origin.y -= height
            self.view.tag = 1
        }
    }
    
    func keyboardWillHideField(height: CGFloat) {
        if self.view.tag == 1 {
            self.view.frame.origin.y += height
            self.view.tag = 0
        }
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 3 {
            
            if negativeHeight < 20 {
                
                negativeHeight = 20
            }
            
            keyboardWillShowField(height: 20)
        }
        else if textField.tag == 4 {
            
            negativeHeight = 120
            keyboardWillShowField(height: 120)
        }
    }
}
