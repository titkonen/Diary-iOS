import UIKit

class DiaryDetailViewController: UIViewController {
    
    // MARK: - Properties
    var username: String = ""
    var otsikkoName: String = ""
    var otsikko: String?
    var paivanNimi = Date()
    
    var selectedContact = DiaryEntity()
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var bodyField: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //titleField?.text = otsikkoName
        titleField.text = selectedContact.otsikko
        usernameLabel?.text = username
        
        
    }
    
} // End of class

