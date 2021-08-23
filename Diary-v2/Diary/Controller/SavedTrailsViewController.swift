import UIKit
import CoreData

class SavedTrailsViewController: UITableViewController {

    var diaryentity = [DiaryEntity]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Context Layer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTrails()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryentity.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let aika = String(duration)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedTrailsCell", for: indexPath)

        cell.textLabel?.text = diaryentity[indexPath.row].otsikko
        cell.detailTextLabel?.text = String(diaryentity[indexPath.row].luku)
        return cell
    }
 

    // MARK: - Add New text
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New text", message: "leipiszz", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newTrails = DiaryEntity(context: self.context)
            newTrails.otsikko = textField.text!
            self.diaryentity.append(newTrails)
            self.saveTrails()
        }
        alert.addAction(action)
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
