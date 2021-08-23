import Foundation
import CoreData


extension DiaryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var leipateksti: String?
    @NSManaged public var luku: Int32
    @NSManaged public var otsikko: String?
    @NSManaged public var paivamaara: Date?

}

extension DiaryEntity : Identifiable {

}
