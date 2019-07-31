//
//  DetalleVC.swift
//  Movies
//
//  Created by Mauricio Caro on 7/26/19.
//  Copyright © 2019 Maccservice. All rights reserved.
//

import UIKit
import CoreData

class DetalleVC: UIViewController {

    
    var pelicula : Pelicula?
    var generos : String = ""
    @IBOutlet weak var posterIMG: UIImageView!
    @IBOutlet weak var tituloLBL: UILabel!
    
    @IBOutlet weak var favoritoBTN: UIButton!
    @IBOutlet weak var anoLBL: UILabel!
    @IBOutlet weak var generoLBL: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        self.title = "Movie"
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Coredata.shared.validMovie(titulo: pelicula!.titulo) == true{
            self.favoritoBTN.setImage(#imageLiteral(resourceName: "favorite_full_icon"), for: .normal)
            self.favoritoBTN.isEnabled = false
        }else{
            self.favoritoBTN.addTarget(self, action: #selector(self.favorite), for: .touchUpInside)
        }
        
        self.posterIMG.image = pelicula?.poster
        self.tituloLBL.text = pelicula?.titulo
        self.anoLBL.text = pelicula?.lanzamiento
        for a in pelicula!.generos{
            generos += " \(a),"
        }
        self.generoLBL.text =  generos
        self.descripcion.text = pelicula?.descripcion
        
        // Do any additional setup after loading the view.
    }
}

extension DetalleVC{
    
    @objc func favorite(){
        
        let favorito = Coredata.shared.newMovie(pelicula)
            favorito.setValue(self.generoLBL.text, forKey: "generos")
        if Herramientas.shared.lanzamientos.contains(pelicula!.lanzamiento) == false{
            Herramientas.shared.lanzamientos.append(pelicula!.lanzamiento)
        }
        Coredata.shared.guardar()
        
        self.favoritoBTN.setImage(#imageLiteral(resourceName: "favorite_full_icon"), for: .normal)
        self.favoritoBTN.isEnabled = false
    }
}
