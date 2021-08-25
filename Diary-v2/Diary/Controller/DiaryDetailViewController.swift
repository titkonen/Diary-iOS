import UIKit

protocol NoteDisplayable: class {
  var note: Note? { get set }
}

class DiaryDetailViewController: UIViewController, NoteDisplayable {
    
    // MARK: - Properties
    var note: Note? {
      didSet {
        updateDiaryContent()
      }
    }
    
    /// The username property that goes into the label
    var username:String = ""
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var bodyField: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        // Set the label text
        usernameLabel?.text = username
        
        updateDiaryContent()
    }
    
} // End of class

// MARK: - Internal
extension DiaryDetailViewController {
  func updateDiaryContent() {
    guard isViewLoaded,
      let note = note else {
        return
    }

    titleField.text = note.otsikko
    bodyField.text = note.leipateksti
  }
}
