import UIKit

class NoteTableViewCell: UITableViewCell {
  // MARK: - Properties
  var note: Note? {
    didSet {
      guard let note = note else { return }
      updateNoteInfo(note: note)
    }
  }
  
  lazy var paivanMuotoilu: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
  }()

  // MARK: - IBOutlets
  @IBOutlet private var noteTitle: UILabel!
  @IBOutlet private var noteCreateDate: UILabel!
}

// MARK: - Internal
@objc extension NoteTableViewCell {
  func updateNoteInfo(note: Note) {
    
    guard let showDate = note as? Note,
      let showDateinList = showDate.dateCreated as Date? else {
        return
    }
    
    noteTitle.text = note.title
//    noteCreateDate.text = note.dateCreated.description
    noteCreateDate.text = paivanMuotoilu.string(from: showDateinList)
    
  }
}
