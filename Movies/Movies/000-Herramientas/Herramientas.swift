//
//  DatosBasicos.swift
//  iVirS
//
//  Created by Mauricio Caro Caro on 26-07-19.
//  Copyright © 2017 Mauricio Caro Caro. All rights reserved.
//



import UIKit
import CoreData


class Herramientas {
    
    private static let _shared = Herramientas()
    static var  shared : Herramientas{
        return _shared
    }
    
    let session = URLSession.shared
    let apiKey = "d3ad2e49a97260e0201e8fc9dd9f67b9"
    
    var movies  : [Pelicula] = []
    var filtros : [Pelicula] = []
    var generos : [Genre] = []
    var lanzamientos   : [String] = []
    var moreFilm = false
    var page = 0
    
    func loadGenre(){
        if let url = URL(string:"https://api.themoviedb.org/3/genre/movie/list?api_key=d3ad2e49a97260e0201e8fc9dd9f67b9&language=en-US"){
            let task = self.session.dataTask(with:url) {(data,_ , error) in
                if let datas = data{
                    do{
                        if let json = try JSONSerialization.jsonObject(with: datas, options: .mutableContainers) as? [String:AnyObject]{
                            if let array = json["genres"] as? NSArray{
                                for i in array{
                                    if let dict = i as? [String:AnyObject]{
                                        if let id = dict["id"] as? Int, let nombre = dict["name"] as? String {
                                            if Coredata.shared.validGenre(titulo: nombre) == false{
                                                let _ = Coredata.shared.newGenre(id: id, nombre: nombre)
                                                    Coredata.shared.guardar()
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }catch{
                        print("no se obtuvo los generos del servidor")
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func formatYear(_ fecha: String) -> String?{
        
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        guard let dia = formater.date(from: fecha) else {return nil}
        
        formater.dateFormat = "yyyy"
        let day = formater.string(from: dia) 
    
        return day
    }
    
    
}
