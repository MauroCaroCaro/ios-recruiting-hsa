//
//  Genre+CoreDataProperties.swift
//  Movies
//
//  Created by Mauricio Caro on 7/28/19.
//  Copyright © 2019 Maccservice. All rights reserved.
//
//

import Foundation
import CoreData


extension Genre {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Genre> {
        return NSFetchRequest<Genre>(entityName: "Genre")
    }

    @NSManaged public var id: Int16
    @NSManaged public var nombre: String?

}
