import UIKit
import CoreData

class ListViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    lazy var coreDataStack = CoreDataStack(modelName: "DiaryModel")
    var diaryentity = [DiaryEntity]()
    lazy var paivanMuotoilu: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      formatter.timeStyle = .medium
      return formatter
    }()
    
//    lazy var notes: NSFetchedResultsController<DiaryEntity> = {
//      let context = coreDataStack.managedContext
//      let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
//      request.sortDescriptors = [NSSortDescriptor(key: #keyPath(DiaryEntity.paivamaara), ascending: false)]
//
//      let notes = NSFetchedResultsController(
//        fetchRequest: request,
//        managedObjectContext: context,
//        sectionNameKeyPath: nil,
//        cacheName: nil)
//        notes.delegate = self
//      return notes
//    }()
    
    
    // MARK: - Add Life Cycle
    override func viewDidLoad() {
      super.viewDidLoad()

      title = "The List2.2"
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        do {
//          try viestit.performFetch()
//        } catch {
//          print("Error: \(error)")
//        }
        
        let lataaData: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(DiaryEntity.paivamaara), ascending: false)
        lataaData.sortDescriptors = [sortDescriptor]

        do {
          diaryentity = try coreDataStack.managedContext.fetch(lataaData)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    

    // MARK: - IB Actions
    
    @IBAction func refreshList(_ sender: UIBarButtonItem) {
        
        tableView.reloadData()
        
    }
    
    
    
    @IBAction func addContent(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New text", message: "leipiszz", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newDiaryContent = DiaryEntity(context: self.coreDataStack.managedContext)
            newDiaryContent.otsikko = textField.text!
            newDiaryContent.paivamaara = Date()
            
            // Save and Reload table view
            self.coreDataStack.saveContext()
            //self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(action)
        alert.addAction(cancelAction)

        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new text"
        }
        present(alert, animated: true, completion: nil)
        
        tableView.reloadData()
        
        
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Determine what the segue destination is
        if segue.destination is DiaryDetailViewController {
            let vc = segue.destination as? DiaryDetailViewController
            vc?.username = "Arthur Dent 22"
        }
    }
    

} // End of Main class


// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return diaryentity.count
//    let objects = notes.fetchedObjects
//    return objects?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewControllerCell", for: indexPath)
    
    guard let showDate = diaryentity[indexPath.row] as? DiaryEntity,
      let showDateinList = showDate.paivamaara as Date? else {
        return cell
    }
    
    cell.textLabel?.text = diaryentity[indexPath.row].otsikko
    cell.detailTextLabel?.text = paivanMuotoilu.string(from: showDateinList)
    
    return cell
  
  }
    
    // MARK: DELETING
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

      guard let contentToRemove = diaryentity[indexPath.row] as? DiaryEntity, editingStyle == .delete else {
          return
      }
        
      //when delete is tapped
      diaryentity.remove(at: indexPath.row)

      coreDataStack.managedContext.delete(contentToRemove)
      coreDataStack.saveContext()
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
} // End of Extensions 1

// MARK: - NSFetchedResultsControllerDelegate
extension ListViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    let wrapIndexPath: (IndexPath?) -> [IndexPath] = { $0.map { [$0] } ?? [] }

    switch type {
    case .insert:
      tableView.insertRows(at: wrapIndexPath(newIndexPath), with: .automatic)
    case .delete:
      tableView.deleteRows(at: wrapIndexPath(indexPath), with: .automatic)
    case .update:
      tableView.reloadRows(at: wrapIndexPath(indexPath), with: .none)
    default:
      break
    }
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
  }
}
