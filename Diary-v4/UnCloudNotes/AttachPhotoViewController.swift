import UIKit

class AttachPhotoViewController: UIViewController {
  // MARK: - Properties
  var note: ViestitEntity?
  lazy var imagePicker: UIImagePickerController = {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    picker.delegate = self
    self.addChild(picker)
    return picker
  }()

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    addChild(imagePicker)
    view.addSubview(imagePicker.view)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    imagePicker.view.frame = view.bounds
  }
}

// MARK: - UIImagePickerControllerDelegate
extension AttachPhotoViewController: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    
//    guard let note = ViestitEntity.self else {
//      return
//    }
    
    let note2 = ViestitEntity()

    note2.valokuva = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    _ = navigationController?.popViewController(animated: true)
  
  }
  
  
}

// MARK: - UINavigationControllerDelegate
extension AttachPhotoViewController: UINavigationControllerDelegate {
}

// MARK: - NoteDisplayable
extension AttachPhotoViewController: NoteDisplayable {
}
