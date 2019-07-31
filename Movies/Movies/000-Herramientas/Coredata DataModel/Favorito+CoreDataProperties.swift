//
//  Favorito+CoreDataProperties.swift
//  Movies
//
//  Created by Mauricio Caro on 7/28/19.
//  Copyright © 2019 Maccservice. All rights reserved.
//
//

import Foundation
import CoreData


extension Favorito {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorito> {
        return NSFetchRequest<Favorito>(entityName: "Favorito")
    }

    @NSManaged public var descripcion: String?
    @NSManaged public var generos: String?
    @NSManaged public var id: Int16
    @NSManaged public var lanzamiento: String?
    @NSManaged public var poster: NSData?
    @NSManaged public var titulo: String?

}
