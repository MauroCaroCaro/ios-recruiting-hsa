//
//  ViewController.swift
//  Movies
//
//  Created by Mauricio Caro on 7/26/19.
//  Copyright © 2019 Maccservice. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    
    var page = 0
    var moreFilm = false
    var searching = false
    var errorView = UIView()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Herramientas.shared.loadGenre()
        
        //request al server
        self.loadFromServer()
        Coredata.shared.loadCoreData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.insertSubview(self.errorView, at: 0)
        
        
        
        
        self.errorView.backgroundColor = UIColor.blue
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.collectionView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino =  segue.destination as? DetalleVC{
            
            if let index = self.collectionView.indexPathsForSelectedItems?.first{
                destino.pelicula = Herramientas.shared.filtros[index.item]
            }
        }
        if let destino = segue.source as? DetalleVC{
            destino.hidesBottomBarWhenPushed = false
        }
    }
}

extension HomeVC:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searching = true
        guard !searchText.isEmpty else{
            self.errorView.removeFromSuperview()
            Herramientas.shared.filtros = Herramientas.shared.movies
            self.searching = false
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            return
        }
        
        Herramientas.shared.filtros = Herramientas.shared.movies.filter({ (film) -> Bool in
            if film.titulo.lowercased().contains(searchText.lowercased()){
                self.errorView.removeFromSuperview()
                return film.titulo.lowercased().contains(searchText.lowercased())
            }else{
                return false
            }
        })
        
        if Herramientas.shared.filtros.count == 0{
            
            
            
           
            
            
            self.view.layoutSubviews()
            print("error view añadido")
            
           
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            self.searching = false
            }
        self.view.endEditing(true)
    }
    
    
}

extension HomeVC:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Herramientas.shared.filtros.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! movieCell
        cell.tituloLBL.text = Herramientas.shared.filtros[indexPath.item].titulo
        cell.posterIMG.image = Herramientas.shared.filtros[indexPath.item].poster
        return cell
    }
    
    
}

extension HomeVC:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.searching == false{
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            
            if offsetY > contentHeight - scrollView.frame.height {
                
                if !moreFilm {
                    
                    self.loadFromServer()
                }
            }
        }
    }
    
}

extension HomeVC{
    
    func loadFromServer(){
        self.moreFilm = true
        self.page += 1
        if let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(Herramientas.shared.apiKey)&language=en-US&page=\(self.page)"){
            let task = Herramientas.shared.session.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do{
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]{
                            if let resultados = json["results"] as? NSArray{
                                for pelicula in resultados{
                                    if let dataInfo = pelicula as? [String:AnyObject]{
                                        if let id = dataInfo["id"] as? Int, let titulo = dataInfo["title"] as? String, let poster = dataInfo["poster_path"] as? String, let generos = dataInfo["genre_ids"] as? NSArray, let descripcion = dataInfo["overview"] as? String{
                                            
                                            if let fecha = Herramientas.shared.formatYear((dataInfo["release_date"] as? String)!) {
                                                let film = Pelicula(id: id,titulo: titulo,poster: poster,genero: generos,descripcion: descripcion, lanzamiento: fecha )
                                             
                                                Herramientas.shared.filtros.append(film)
                                                Herramientas.shared.movies.append(film)
                                            }
                                        }
                                    }
                                }
                                DispatchQueue.main.async { self.moreFilm = false }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { self.collectionView.reloadData() })
                            }
                        }
                    }catch{
                        print("error al parsear los datos de la app")
                    }
                }
            }
            task.resume()
        }
    }
}
