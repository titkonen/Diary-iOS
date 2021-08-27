import UIKit
import CoreData

class CreateNoteViewController: UIViewController, UsesCoreDataObjects {
  // MARK: - Properties
  var managedObjectContext: NSManagedObjectContext?
  lazy var note: Note? = {
    guard let context = self.managedObjectContext else { return nil }
    return Note(context: context)
  }()

  // MARK: - IBOutlets
  @IBOutlet private var titleField: UITextField!
  @IBOutlet private var bodyField: UITextView!
  @IBOutlet private var attachPhotoButton: UIButton!
  @IBOutlet private var attachedPhoto: UIImageView!

  // MARK: - View Life Cycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    titleField.becomeFirstResponder()
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let nextViewController = segue.destination as? NoteDisplayable else { return }

    nextViewController.note = note
  }
}

// MARK: - IBActions
extension CreateNoteViewController {
  @IBAction func saveNote() {
    guard let note = note,
      let managedObjectContext = managedObjectContext else {
        return
    }

    managedObjectContext.performAndWait {
      note.title = titleField.text ?? ""
      note.body = bodyField.text ?? ""

      do {
        try managedObjectContext.save()
      } catch let error as NSError {
        print("Error saving \(error)", terminator: "")
      }
    }

    performSegue(withIdentifier: "unwindToNotesList", sender: self)
  }
}

// MARK: - UITextFieldDelegate
extension CreateNoteViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    saveNote()
    textField.resignFirstResponder()
    return false
  }
}

// MARK: - UITextViewDelegate
extension CreateNoteViewController: UITextViewDelegate {
}
