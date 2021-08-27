//
//  ContactListTableViewController.swift
//  ContactListApp
//
//  Created by Midhet Sulemani on 13/04/17.
//  Copyright © 2017 Midhet Sulemani. All rights reserved.
//

import UIKit
import CoreData

class ContactListTableViewController: UITableViewController {

    var allContacts: [Contact] = []
    
    let helper = CoreDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchAllContacts()
    }
    
    //Function to fetch all the contacts stored in the database
    
    func fetchAllContacts() {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do {
            if let contactList = try helper.context.fetch(fr) as? [Contact] {
                allContacts = contactList
                tableView.reloadData()
            }
        } catch {
            print("Could not read conatct fetcher")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allContacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ContactTableViewCell {
            //Cell configuration
            cell.showData(cellData: allContacts[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        if let contactFirstName = allContacts[indexPath.row].firstName {
            let predicate = NSPredicate(format: "firstName = %d",
                                        argumentArray: [contactFirstName])
            fetchRequest.predicate = predicate
        }
        
        do {
            if let contacts = try helper.context.fetch(fetchRequest) as? [Contact],
                let selectedContact = contacts.first {
                performSegue(withIdentifier: "gotoSingleContact", sender: selectedContact)
            }
        } catch {
            print("No contacts found")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoSingleContact" {
            if let nextVC = segue.destination as? DisplaySingleContactViewController,
                let selectedContact = sender as? Contact {
                nextVC.selectedContact = selectedContact
            }
        }
    }

}

//Custom Cell Class
class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    
    func showData(cellData: Contact) {
        name.text = "\(cellData.firstName ?? "") \(cellData.lastName ?? "")"
        contactNumber.text = String(cellData.contactNumber)
        emailAddress.text = cellData.emailId
    }
}
