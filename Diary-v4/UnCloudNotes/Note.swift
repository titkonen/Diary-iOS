import Foundation
import CoreData
import UIKit

class ViestitEntity: NSManagedObject {
  @NSManaged var otsikko: String
  @NSManaged var leipis: String
  @NSManaged var paivamaara: Date!
  @NSManaged var luku: NSNumber!
  @NSManaged var valokuva: UIImage?
  
  override func awakeFromInsert() {
    super.awakeFromInsert()
    paivamaara = Date()
  }
  
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<ViestitEntity> {
    return NSFetchRequest<ViestitEntity>(entityName: "ViestitEntity")
  }
}
