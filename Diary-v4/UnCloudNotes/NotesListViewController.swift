import UIKit
import CoreData

class NotesListViewController: UITableViewController {
  
  // MARK: - Properties
  private lazy var stack = CoreDataStack(modelName: "ViestitDataModel")

  private lazy var notes: NSFetchedResultsController<ViestitEntity> = {
    let context = self.stack.managedContext
    let request: NSFetchRequest<ViestitEntity> = ViestitEntity.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: #keyPath(ViestitEntity.paivamaara), ascending: false)]

    let notes = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil)
    notes.delegate = self
    return notes
  }()
  
  var noteEntity = [ViestitEntity]()
  var fetchedResultsController: NSFetchedResultsController<ViestitEntity> = NSFetchedResultsController()

  // MARK: - View Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    do {
      try notes.performFetch()
    } catch {
      print("Error: \(error)")
    }

    tableView.reloadData()
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let navController = segue.destination as? UINavigationController,
      let viewController = navController.topViewController as? UsesCoreDataObjects {
        viewController.managedObjectContext = stack.savingContext
    }

    if let detailView = segue.destination as? NoteDisplayable,
      let selectedIndex = tableView.indexPathForSelectedRow {
        detailView.note = notes.object(at: selectedIndex)
    }
  }
}

// MARK: - IBActions
extension NotesListViewController {
  @IBAction func unwindToNotesList(_ segue: UIStoryboardSegue) {
    print("Unwinding to Notes List")

    stack.saveContext()
  }
}

// MARK: - UITableViewDataSource
extension NotesListViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let objects = notes.fetchedObjects
    return objects?.count ?? 0

    //return noteEntity.count
    //return (noteEntity.count - 1)
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let note = notes.object(at: indexPath)
    let cell: NoteTableViewCell
     if note.valokuva == nil {
       cell = tableView.dequeueReusableCell(
         withIdentifier: "NoteCell",
         for: indexPath
       ) as! NoteTableViewCell
     } else {
       cell = tableView.dequeueReusableCell(
         withIdentifier: "NoteCellWithImage",
         for: indexPath
       ) as! NoteImageTableViewCell
     }

     cell.note = note
     return cell
    
//    let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
//    cell.note = notes.object(at: indexPath)
//    return cell
  }
  
  // MARK: DELETING
//  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//    true
//  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

//        guard let contentToRemove = notes.object(at: indexPath), editingStyle == .delete else {
//            return
//        }
//
//        noteEntity.remove(at: indexPath.row)
//        stack.managedContext.delete(contentToRemove)
//        stack.savingContext
//        tableView.deleteRows(at: [indexPath], with: .automatic)
    
//    guard case(.delete) = editingStyle else {
//      return
//    }
    
    
    
//    let surfJournalEntry = fetchedResultsController.object(at: indexPath)
//    let surfJournalEntry = notes.object(at: indexPath)
//    stack.managedContext.delete(surfJournalEntry)
//    stack.savingContext
    //tableView.deleteRows(at: [indexPath], with: .automatic)
    
//    guard let contentToRemove = noteEntity[indexPath.row] as? Note, editingStyle == .delete else {
//        return
//    }
//
//    //when delete is tapped
//    noteEntity.remove(at: indexPath.row)
//
//    //coreDataStack.managedContext.delete(contentToRemove)
//    //coreDataStack.saveContext()
//    stack.managedContext.delete(contentToRemove)
//    stack.savingContext
//    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
}

// MARK: - NSFetchedResultsControllerDelegate
extension NotesListViewController: NSFetchedResultsControllerDelegate {
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
