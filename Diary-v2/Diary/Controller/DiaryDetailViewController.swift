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
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var bodyField: UITextView!
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
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
