//
//  Paivays+CoreDataProperties.swift
//  DogWalk
//
//  Created by Toni Itkonen on 19.8.2021.
//  Copyright © 2021 Razeware. All rights reserved.
//
//

import Foundation
import CoreData


extension Paivays {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Paivays> {
        return NSFetchRequest<Paivays>(entityName: "Paivays")
    }

    @NSManaged public var paivays: Date?
    @NSManaged public var tekstit: NSOrderedSet?

}

// MARK: Generated accessors for tekstit
extension Paivays {

    @objc(insertObject:inTekstitAtIndex:)
    @NSManaged public func insertIntoTekstit(_ value: Tekstit, at idx: Int)

    @objc(removeObjectFromTekstitAtIndex:)
    @NSManaged public func removeFromTekstit(at idx: Int)

    @objc(insertTekstit:atIndexes:)
    @NSManaged public func insertIntoTekstit(_ values: [Tekstit], at indexes: NSIndexSet)

    @objc(removeTekstitAtIndexes:)
    @NSManaged public func removeFromTekstit(at indexes: NSIndexSet)

    @objc(replaceObjectInTekstitAtIndex:withObject:)
    @NSManaged public func replaceTekstit(at idx: Int, with value: Tekstit)

    @objc(replaceTekstitAtIndexes:withTekstit:)
    @NSManaged public func replaceTekstit(at indexes: NSIndexSet, with values: [Tekstit])

    @objc(addTekstitObject:)
    @NSManaged public func addToTekstit(_ value: Tekstit)

    @objc(removeTekstitObject:)
    @NSManaged public func removeFromTekstit(_ value: Tekstit)

    @objc(addTekstit:)
    @NSManaged public func addToTekstit(_ values: NSOrderedSet)

    @objc(removeTekstit:)
    @NSManaged public func removeFromTekstit(_ values: NSOrderedSet)

}

extension Paivays : Identifiable {

}
