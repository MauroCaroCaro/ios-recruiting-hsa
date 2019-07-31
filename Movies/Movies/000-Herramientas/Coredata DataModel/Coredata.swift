//
//  Coredata.swift
//  Movies
//
//  Created by Mauricio Caro on 7/28/19.
//  Copyright © 2019 Maccservice. All rights reserved.
//

import Foundation
import CoreData

class Coredata {
    
    private static let _shared = Coredata()
    static var  shared : Coredata{
        return _shared
        
    }

    let dataBaseCD = AppDelegate().persistentContainer.viewContext
    var Generos : [Genre] = []
    var Favoritos : [Favorito] = []
    
    
        //llama al metodo guardar de coredata
    func guardar(){
        do{
            try self.dataBaseCD.save()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Saved"), object: nil)
        }catch{
            print(error)
        }
    }
    
        //borra un item de coredata
    func borrar(item: NSManagedObject ){
        self.dataBaseCD.delete(item)
        self.guardar()
    }
    
        //metodo para cargar datos de coredata
    func loadCoreData() {
        
        let requestFavorite : NSFetchRequest<Favorito> = Favorito.fetchRequest()
        let requestGenre : NSFetchRequest<Genre> = Genre.fetchRequest()
        
        do{
            self.Favoritos = try self.dataBaseCD.fetch(requestFavorite)
            self.Generos = try self.dataBaseCD.fetch(requestGenre)
        }catch{
            print("sin datos")
        }
    }
    
        //crea un nuevo favorito a partir de una pelicula
    func newMovie(_ pelicula: Pelicula?) -> Favorito{
        
        if pelicula == nil {
        return NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Favorito", in: self.dataBaseCD)!, insertInto: self.dataBaseCD) as! Favorito
        }else{
            let film =  NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Favorito", in: self.dataBaseCD)!, insertInto: self.dataBaseCD) as! Favorito
                film.setValue(pelicula?.id, forKey: "id")
                film.setValue(pelicula?.titulo, forKey: "titulo")
                film.setValue(pelicula?.lanzamiento, forKey: "lanzamiento")
                film.setValue(pelicula?.poster.jpegData(compressionQuality: 1.0), forKey: "poster")
                film.setValue(pelicula?.descripcion, forKey: "descripcion")
            return film
        }
    }
    
        //verifica si el titulo es ya un favorito y devuelve un Bool (true o false)
    func validMovie( titulo:String) -> Bool {
    
        var state:Bool!
        
        let entity = NSEntityDescription.entity(forEntityName: "Favorito", in: self.dataBaseCD)
        let request = NSFetchRequest<Favorito>()
            request.entity = entity
            request.predicate = NSPredicate(format: "titulo == %@", titulo)
        
        do {
            let valid = try self.dataBaseCD.count(for: request)
            if valid == 0{
                state = false
            }else{
                state = true
            }
        } catch  {
            print("sin conincidencias")
        }
        return state
    }
    
        // crea un nuevo genero
    func newGenre(id:Int,nombre:String) -> Genre{
        let genre = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Genre", in: self.dataBaseCD)!, insertInto: self.dataBaseCD) as! Genre
        genre.setValue(Int16(id), forKey: "id")
        genre.setValue(nombre, forKey: "nombre")
        
        return genre
    }
        // //verifica si el titulo es ya un genero y devuelve un Bool (true o false)
    func validGenre( titulo:String) -> Bool {
        
        var state:Bool!
        
        let entity = NSEntityDescription.entity(forEntityName: "Genre", in: self.dataBaseCD)
        let request = NSFetchRequest<Genre>()
        request.entity = entity
        request.predicate = NSPredicate(format: "nombre == %@", titulo)
        
        do {
            let valid = try self.dataBaseCD.count(for: request)
            if valid == 0{
                state = false
            }else{
                state = true
            }
        } catch  {
            print("sin conincidencias")
        }
        return state
    }
    
    func nameGenre(id:Int) -> String{
        var name:String!
        
        let entity = NSEntityDescription.entity(forEntityName: "Genre", in: self.dataBaseCD)
        let request = NSFetchRequest<Genre>()
            request.fetchLimit = 1
            request.entity = entity
            request.predicate = NSPredicate(format: "id == %i", id)
        do{
            name = try self.dataBaseCD.fetch(request).first?.nombre
        }catch{
            print("No arroja nombre por el id")
        }
        return name
    }
    
}
