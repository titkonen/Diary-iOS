//
//  Diary+CoreDataProperties.swift
//  DogWalk
//
//  Created by Toni Itkonen on 19.8.2021.
//  Copyright © 2021 Razeware. All rights reserved.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var otsikko: String?
    @NSManaged public var leipateksti: String?
    @NSManaged public var luontipaiva: Date?
    @NSManaged public var valokuva: Data?

}

extension Diary : Identifiable {

}
