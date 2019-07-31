//
//  FiltrosVC.swift
//  Movies
//
//  Created by Mauricio Caro on 7/28/19.
//  Copyright © 2019 Maccservice. All rights reserved.
//

import UIKit
import CoreData

class FiltrosVC: UIViewController {

    
    var genero : String!
    var lanzamiento : String!
    var filtro : NSPredicate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var aplicarBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Filter"

        self.aplicarBTN.addTarget(self, action: #selector(aplicar), for: .touchUpInside)
    }
    
    @IBAction func filterOn(_ segue: UIStoryboardSegue){
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "filters"{
            if let destino = segue.destination as? FavoritosVC{
                destino.filtro = self.filtro
            }
        }
        
        if let destino = segue.destination as? GenerosVC{
            if self.tableView.indexPathForSelectedRow?.row == 0{
                destino.type = 0
            }else if self.tableView.indexPathForSelectedRow?.row == 1{
                destino.type = 1
            }
        }
    
    }
}

extension FiltrosVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Filter", for: indexPath)
        
        if indexPath.row == 0{
            cell.textLabel?.text = "Date"
            if self.lanzamiento != nil{
                cell.detailTextLabel?.text = self.lanzamiento
            }else{
                cell.detailTextLabel?.text = ""
            }
        }else if indexPath.row == 1{
            cell.textLabel?.text = "Genre"
            if self.genero != nil {
                cell.detailTextLabel?.text = self.genero
            }else{
                cell.detailTextLabel?.text = ""
            }
            
        }
        
        return cell
    }
}

extension FiltrosVC{
    
    @objc func aplicar(){
        
        if self.genero != nil && self.lanzamiento == nil{
            self.filtro = NSPredicate(format: "generos CONTAINS %@", self.genero)
        } else if lanzamiento != nil && self.genero == nil{
            self.filtro = NSPredicate(format: "lanzamiento =%@", lanzamiento)
        }else if genero != nil && self.lanzamiento != nil {
            self.filtro = NSPredicate(format: "lanzamiento =%@ AND generos CONTAINS %@", self.lanzamiento,self.genero)
        }
        
        
        
        self.performSegue(withIdentifier: "filters", sender: self)
        
    }
}
