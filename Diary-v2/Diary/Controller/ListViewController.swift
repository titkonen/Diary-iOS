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
    
    
    // MARK: - Add Life Cycle
    override func viewDidLoad() {
      super.viewDidLoad()
      
      title = "The List2.1"
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

} // End of Main class


// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return diaryentity.count
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
    
    
} // End of Extensions
