import UIKit
import CoreData

class DiaryListVC: UITableViewController {

    // MARK: - Properties
    var diaryentity = [DiaryEntity]()
    lazy var paivanMuotoilu: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      formatter.timeStyle = .medium
      return formatter
    }()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Context Layer
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

//        title = "The List"
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//
        loadTrails()
    }
  
    // TEST THIS LATER FOR FETCHING
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryentity.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let aika = String(duration)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedTrailsCell", for: indexPath)

        guard let kavely = diaryentity[indexPath.row] as? DiaryEntity,
          let walkDate = kavely.paivamaara as Date? else {
            return cell
        }
        
        cell.textLabel?.text = diaryentity[indexPath.row].otsikko
        
        cell.detailTextLabel?.text = paivanMuotoilu.string(from: walkDate)
        
        //cell.detailTextLabel?.text = String(diaryentity[indexPath.row].luku)
        return cell
    }
 

    // MARK: - Add New text
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New text", message: "leipiszz", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newDiaryContent = DiaryEntity(context: self.context)
            newDiaryContent.otsikko = textField.text!
            newDiaryContent.paivamaara = Date()
            self.diaryentity.append(newDiaryContent)
            self.saveTrails()
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
    
    // MARK: - CRUD Functions
    
    func saveTrails() {
         
         do {
            try context.save()
         } catch {
            print("Error saving context \(error)")
         }
         tableView.reloadData()
    }
    
    func loadTrails() {
        
        let request : NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        
        do {
            diaryentity = try context.fetch(request)
        } catch {
            print("Error Fetching data from context \(error)")
        }
        tableView.reloadData()
    }

    

   
}
