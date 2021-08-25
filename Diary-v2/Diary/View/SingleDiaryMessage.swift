import Foundation
import CoreData
import UIKit

class Note: NSManagedObject {
  @NSManaged var otsikko: String
  @NSManaged var leipateksti: String
  @NSManaged var paivamaara: Date!
  @NSManaged var luku: NSNumber!
  
  override func awakeFromInsert() {
    super.awakeFromInsert()
    paivamaara = Date()
  }
  
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
    return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
  }
}
