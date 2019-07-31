//
//  FavoritosVC.swift
//  Movies
//
//  Created by Mauricio Caro on 7/27/19.
//  Copyright © 2019 Maccservice. All rights reserved.
//

import UIKit
import CoreData

class FavoritosVC: UIViewController {
    
    var movies : [Favorito] = []
    var filter : [Favorito] = []
    var filtro : NSPredicate?
    var FetchResultController : NSFetchedResultsController<Favorito>!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func removeBTN(_ sender: UIButton) {
        self.filtro = nil
        self.load()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.keyboardDismissMode = .onDrag
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        self.load()
        
    }
    
    }

extension FavoritosVC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filter.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        
        
        if let img = UIImage(data: (self.filter[indexPath.row].poster! as Data)){
        cell.posterIMG.image = img
        }
        
        cell.tituloLBL.text = self.filter[indexPath.row].titulo
        cell.lanzamientoLBL.text = self.filter[indexPath.row].lanzamiento
        cell.descripcionTXV.text = self.filter[indexPath.row].descripcion
        
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let borrar = UITableViewRowAction(style: .normal, title: "Unfavorite") { (action, index) in
            
           Coredata.shared.borrar(item: self.filter[index.row])
            
        }
        borrar.backgroundColor = UIColor.red
        
        return [borrar]
    }
}

extension FavoritosVC:NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .fade)
        @unknown default:
            fatalError()
        }
        self.movies = controller.fetchedObjects as! [Favorito]
        self.filter = self.movies
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

extension FavoritosVC:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else{
            self.filter = self.movies
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
        
        self.filter = self.movies.filter({ (film) -> Bool in
            if film.titulo!.lowercased().contains(searchText.lowercased()){
                return film.titulo!.lowercased().contains(searchText.lowercased())
            }else{
                return false
            }
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        self.view.endEditing(true)
    }
    
    
}

extension FavoritosVC{
    
    func load(){
        let fetch : NSFetchRequest<Favorito> = Favorito.fetchRequest()
        if self.filtro != nil {
            fetch.predicate = self.filtro!
        }
        fetch.sortDescriptors = [NSSortDescriptor(key: "titulo", ascending: true)]
        
        self.FetchResultController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: Coredata.shared.dataBaseCD, sectionNameKeyPath: nil, cacheName: nil)
        self.FetchResultController.delegate = self
        do {
            try self.FetchResultController.performFetch()
            self.movies = FetchResultController.fetchedObjects!
            self.filter = movies
        } catch let error as NSError {
            print("error al cargar la informacion",error)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func filters(_ segue : UIStoryboardSegue){
        
        self.load()
        self.tableView.reloadData()
    }
   
}
