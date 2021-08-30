import UIKit

class NoteImageTableViewCell: NoteTableViewCell {
  
  // MARK: - Properties
  override var note: ViestitEntity? {
    didSet {
      guard let note = note else { return }
      updateNoteInfo(note: note)
    }
  }
  
  // MARK: - IBOutlets
  @IBOutlet private var noteImage: UIImageView!
}

// MARK: - Internal
extension NoteImageTableViewCell {
  override func updateNoteInfo(note: ViestitEntity) {
    super.updateNoteInfo(note: note)
    
    ///This will update the UIImageView inside the NoteImageTableViewCell with the image from the note.
    noteImage.image = note.valokuva
  }
}
