//
//  Pelicula.swift
//  Movies
//
//  Created by Mauricio Caro on 7/26/19.
//  Copyright © 2019 Maccservice. All rights reserved.
//

import UIKit

class Pelicula {

    var id: Int!
    var titulo : String!
    var poster : UIImage!
    var generos : [String] = []
    var descripcion : String!
    var lanzamiento : String!

    
    init(id:Int, titulo:String, poster:String, genero:NSArray, descripcion:String, lanzamiento:String){
        
        self.id = id
        self.titulo = titulo
        let task = Herramientas.shared.session.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w200/\(poster)")!) { (data, _, error) in
            if let dataImg = data{
                self.poster = UIImage(data: dataImg)
            }
        }
        task.resume()
        
        for i in genero{
            let name = Coredata.shared.nameGenre(id: i as! Int)
            self.generos.append(name)
        }
        self.descripcion = descripcion
        self.lanzamiento = lanzamiento
        
    }
}

extension Pelicula:Equatable,Comparable{
    static func == (lhs: Pelicula, rhs: Pelicula) -> Bool {
        return lhs.titulo == rhs.titulo 
    }
    
    static func < (lhs: Pelicula, rhs: Pelicula) -> Bool {
        return lhs.titulo < rhs.titulo
    }
    
    
}
