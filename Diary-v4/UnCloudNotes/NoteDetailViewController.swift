import UIKit

protocol NoteDisplayable: class {
  var note: Note? { get set }
}

class NoteDetailViewController: UIViewController, NoteDisplayable {
  
  // MARK: - Properties
  var note: Note? {
    didSet {
      updateNoteInfo()
    }
  }
  
  lazy var paivanMuotoilu: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
  }()

  // MARK: - IBOutlets
  @IBOutlet private var titleField: UILabel!
  @IBOutlet private var bodyField: UITextView!
    @IBOutlet weak var dateField: UILabel!
    
  // MARK: - View Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateNoteInfo()
  }
}

// MARK: - Internal
extension NoteDetailViewController {
  func updateNoteInfo() {
    guard isViewLoaded,
      let note = note else {
        return
    }
    
    guard let showDate = note as? Note,
      let showDateinList = showDate.dateCreated as Date? else {
        return
    }
    
    

    titleField.text = note.title
    bodyField.text = note.body
    dateField.text = paivanMuotoilu.string(from: showDateinList)
    //noteCreateDate.text = note.dateCreated.description
  }
}
