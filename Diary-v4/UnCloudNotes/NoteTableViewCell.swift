import UIKit

class NoteTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  var note: ViestitEntity? {
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
  func updateNoteInfo(note: ViestitEntity) {
    
    guard let showDate = note as? ViestitEntity,
      let showDateinList = showDate.paivamaara as Date? else {
        return
    }
    
    noteTitle.text = note.otsikko
//    noteCreateDate.text = note.dateCreated.description
    noteCreateDate.text = paivanMuotoilu.string(from: showDateinList)
    
  }
}
