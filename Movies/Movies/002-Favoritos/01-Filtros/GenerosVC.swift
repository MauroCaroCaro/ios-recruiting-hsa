//
//  GenerosVC.swift
//  Movies
//
//  Created by Mauricio Caro on 7/28/19.
//  Copyright © 2019 Maccservice. All rights reserved.
//

import UIKit
import CoreData


class GenerosVC: UIViewController {
    
    var type = 0
    var lanzamiento : String?
    var generos : [String] = []
    var lanzamientos : [String] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for film in Coredata.shared.Favoritos{
            if self.lanzamientos.contains(film.lanzamiento!) == false{
                self.lanzamientos.append(film.lanzamiento!)
                self.lanzamientos.sort{$0 > $1}
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name: NSNotification.Name(rawValue: "Saved"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? FiltrosVC{
            if let selection = self.tableView.indexPathForSelectedRow{
                if self.type == 0{
                    destino.lanzamiento = self.lanzamientos[selection.row]
                }else if self.type == 1 {
                destino.genero = Coredata.shared.Generos[selection.row].nombre
                }
            }
        }
    }
}
extension GenerosVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 1{
            return Coredata.shared.Generos.count
        }else if type == 0{
            return self.lanzamientos.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath)
        
        if type == 1 {
            cell.textLabel?.text = Coredata.shared.Generos[indexPath.row].nombre
        } else {
            cell.textLabel?.text = self.lanzamientos[indexPath.row]
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "filterOn", sender: self)
        
    }
}
extension GenerosVC{
    
    @objc func reload(){
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
