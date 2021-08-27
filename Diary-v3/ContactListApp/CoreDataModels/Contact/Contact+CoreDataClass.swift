import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    
    convenience init(first: String, last: String, email: String, phone: Int64, context: NSManagedObjectContext) {
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entity(forEntityName: "Contact", in: context) {
            self.init(entity: ent, insertInto: context)
            self.firstName = first
            self.lastName = last
            self.emailId = email
            self.contactNumber = phone
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
