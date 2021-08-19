import UIKit
import CoreData

class ViewController: UIViewController {
  // MARK: - Properties
  lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
  }()
  
  lazy var coreDataStack = CoreDataStack(modelName: "Diary")

  //var walks: [Date] = []
  var currentDog: Tekstit?

  // MARK: - IBOutlets
  @IBOutlet var tableView: UITableView!


  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Lista"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
    let dogName = "Fido"
    let dogFetch: NSFetchRequest<Tekstit> = Tekstit.fetchRequest()
    dogFetch.predicate = NSPredicate(format: "%K == %@",
                                     #keyPath(Tekstit.otsikko), dogName)

    do {
      let results = try coreDataStack.managedContext.fetch(dogFetch)
      if results.isEmpty {
        // Fido not found, create Fido
        currentDog = Tekstit(context: coreDataStack.managedContext)
        currentDog?.otsikko = dogName
        coreDataStack.saveContext()
      } else {
        // Fido found, use Fido
        currentDog = results.first
      }
    } catch let error as NSError {
      print("Fetch error: \(error) description: \(error.userInfo)")
    }
    
  }
}

// MARK: - IBActions
extension ViewController {
  @IBAction func add(_ sender: UIBarButtonItem) {
    // Insert a new Walk entity into Core Data
     let kavely = Paivays(context: coreDataStack.managedContext)
    kavely.paivays = Date()

     // Insert the new Walk into the Dog's walks set
     if let tekstit = currentDog,
       let paivaykset = tekstit.paivaykset?.mutableCopy()
         as? NSMutableOrderedSet {
        paivaykset.add(kavely)
        tekstit.paivaykset = paivaykset
     }

     // Save the managed object context
     coreDataStack.saveContext()

     // Reload table view
     tableView.reloadData()
  }
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    currentDog?.paivaykset?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //let date = walks[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryListCell", for: indexPath)
    
    guard let kavely = currentDog?.paivaykset?[indexPath.row] as? Paivays,
        let walkDate = kavely.paivays as Date? else {
          return cell
      }
    
    cell.textLabel?.text = "Otsikko teksti"
    cell.detailTextLabel?.text = dateFormatter.string(from: walkDate)
    
    
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    "List of Ideas"
  }
  
  // MARK: DELETING
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

    // Get a reference to the Paivays you want to delete
    guard let paivaysToRemove =
      currentDog?.paivaykset?[indexPath.row] as? Paivays,
      editingStyle == .delete else {
        return
    }

    // Remove the Paivays from Core Dat
    coreDataStack.managedContext.delete(paivaysToRemove)

    // Saves new changed status to CoreData
    coreDataStack.saveContext()

    // if the save operation succeeds, you animate the table view to tell the user about the deletion.
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
  
}
