import UIKit
import CoreData

class DiaryListVC: UITableViewController {

    // MARK: - Properties
    lazy var coreDataStack = CoreDataStack(modelName: "DiaryModel")
    var diaryentity = [DiaryEntity]()
    lazy var paivanMuotoilu: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      formatter.timeStyle = .medium
      return formatter
    }()
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Context Layer
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "The Diary 2"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let lataaData: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
       
        do {
            let latausTulos = try coreDataStack.managedContext.fetch(lataaData)
            diaryentity = latausTulos
        } catch let error as NSError {
          print("Fetch error: \(error) description: \(error.userInfo)")
        }
        
    }
  

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryentity.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedTrailsCell", for: indexPath)

        guard let showDate = diaryentity[indexPath.row] as? DiaryEntity,
          let showDateinList = showDate.paivamaara as Date? else {
            return cell
        }
        
        cell.textLabel?.text = diaryentity[indexPath.row].otsikko
        
        cell.detailTextLabel?.text = paivanMuotoilu.string(from: showDateinList)
        
        //cell.detailTextLabel?.text = String(diaryentity[indexPath.row].luku)
        return cell
    }
 

    // MARK: - Add New text
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New text", message: "leipiszz", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            guard self.coreDataStack.managedContext != nil else {
                    fatalError("No Managed Object Context Available")
                }
            
            let newDiaryContent = DiaryEntity(context: self.coreDataStack.managedContext)
            newDiaryContent.otsikko = textField.text!
            newDiaryContent.paivamaara = Date()
            
            do {
                try self.coreDataStack.managedContext.save()
            } catch let error as NSError {
                print("Error saving context \(error)")
            }

            // Reload table view
            self.tableView.reloadData()
            
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(action)
        alert.addAction(cancelAction)

        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new text"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
//    // MARK: - CRUD SAVE
//    func saveTrails() {
//
//         do {
//            try context.save()
//         } catch {
//            print("Error saving context \(error)")
//         }
//         tableView.reloadData()
//    }
//
//    // MARK: - CRUD LOAD
//    func loadTrails() {
//
//        let request : NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: #keyPath(DiaryEntity.paivamaara), ascending: false)
//        request.sortDescriptors = [sortDescriptor]
//
//        do {
//            diaryentity = try context.fetch(request)
//        } catch {
//            print("Error Fetching data from context \(error)")
//        }
//        tableView.reloadData()
//    }

    

   
} // End of main class
