import Foundation
import CoreData


extension Tekstit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tekstit> {
        return NSFetchRequest<Tekstit>(entityName: "Tekstit")
    }

    @NSManaged public var otsikko: String?
    @NSManaged public var leipateksti: String?
    @NSManaged public var valokuva: Data?
    @NSManaged public var paivaykset: NSOrderedSet?

}

// MARK: Generated accessors for paivaykset
extension Tekstit {

    @objc(insertObject:inPaivayksetAtIndex:)
    @NSManaged public func insertIntoPaivaykset(_ value: Paivays, at idx: Int)

    @objc(removeObjectFromPaivayksetAtIndex:)
    @NSManaged public func removeFromPaivaykset(at idx: Int)

    @objc(insertPaivaykset:atIndexes:)
    @NSManaged public func insertIntoPaivaykset(_ values: [Paivays], at indexes: NSIndexSet)

    @objc(removePaivayksetAtIndexes:)
    @NSManaged public func removeFromPaivaykset(at indexes: NSIndexSet)

    @objc(replaceObjectInPaivayksetAtIndex:withObject:)
    @NSManaged public func replacePaivaykset(at idx: Int, with value: Paivays)

    @objc(replacePaivayksetAtIndexes:withPaivaykset:)
    @NSManaged public func replacePaivaykset(at indexes: NSIndexSet, with values: [Paivays])

    @objc(addPaivayksetObject:)
    @NSManaged public func addToPaivaykset(_ value: Paivays)

    @objc(removePaivayksetObject:)
    @NSManaged public func removeFromPaivaykset(_ value: Paivays)

    @objc(addPaivaykset:)
    @NSManaged public func addToPaivaykset(_ values: NSOrderedSet)

    @objc(removePaivaykset:)
    @NSManaged public func removeFromPaivaykset(_ values: NSOrderedSet)

}

extension Tekstit : Identifiable {

}
