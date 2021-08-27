import UIKit
import CoreData

class ListViewController: UIViewController, NSFetchedResultsControllerDelegate {

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

    var allContacts: [DiaryEntity] = []

    
    // MARK: - Add Life Cycle
    override func viewDidLoad() {
      super.viewDidLoad()

      title = "Diary 2.3"
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DiaryEntity")
            if let contactFirstName = diaryentity[indexPath.row].otsikko {
                let predicate = NSPredicate(format: "otsikko = %d",
                                            argumentArray: [contactFirstName])
                fetchRequest.predicate = predicate
            }

            do {
                if let contacts = try coreDataStack.managedContext.fetch(fetchRequest) as? [DiaryEntity],
                    let selectedContact = contacts.first {
                    performSegue(withIdentifier: "showDetailView", sender: selectedContact)
                }
            } catch {
                print("No contacts found")
            }
    }
    
    // MARK: - Navigation
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
            if segue.identifier == "showDetailView" {
                        if let nextVC = segue.destination as? DiaryDetailViewController,
                            let selectedContact = sender as? DiaryEntity {
                            nextVC.selectedContact = selectedContact
                            nextVC.username = "Pööadsadsad"
                        }
            }
            
//            if segue.destination is DiaryDetailViewController {
//                let destination = segue.destination as? DiaryDetailViewController
//                destination?.username = "Arthur Dent 22"
//                //destination?.otsikkoName = "This is otsikko!!!"
//                destination?.otsikkoName = "This is otsikko!!!"
//                //destination?.otsikkoName = paivanMuotoilu.string(from: showDateinList)
//            }
            
//            switch segue.identifier! {
//               case "MyShowDetailSegue":
//                let destination : DiaryDetailViewController = segue.destination as! DiaryDetailViewController
//
//                   //destinationController.delegate = self // you will need this if you're using a delegate to make updates back in the original controller
//
//                destination?.otsikko = otsikko
//
//               default:
//                   break
//            }
            
    
        }
    

    

} // End of Main class





// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
  
    // MARK: TONI TEMP
    
    
    
    
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
    
    //let employee = fetchedResultController.object(at: indexPath)
    
    //cell.textLabel?.text = employee.otsikko
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

