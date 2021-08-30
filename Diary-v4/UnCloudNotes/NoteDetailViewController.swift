import UIKit

protocol NoteDisplayable: AnyObject {
  var note: ViestitEntity? { get set }
}

class NoteDetailViewController: UIViewController, NoteDisplayable {
  
  // MARK: - Properties
  var note: ViestitEntity? {
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
    
    guard let showDate = note as? ViestitEntity,
      let showDateinList = showDate.paivamaara as Date? else {
        return
    }
    
    

    titleField.text = note.otsikko
    bodyField.text = note.leipis
    dateField.text = paivanMuotoilu.string(from: showDateinList)
    //noteCreateDate.text = note.dateCreated.description
  }
}
