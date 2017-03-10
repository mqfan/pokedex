//
//  CategoryViewController.swift
//  PokedexLab
//
//  Created by SAMEER SURESH on 2/25/17.
//  Copyright © 2017 iOS Decal. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pokemonArray: [Pokemon]?
    var cachedImages: [Int:UIImage] = [:]
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return collectionView.numberOfItems(inSection: section)
        return pokemonArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! TableCell
        let pokemon = pokemonArray?[indexPath.row]
        
        if let image = cachedImages[indexPath.row] {
            cell.pokemonPic.image = image // may need to change this!
        } else {
            let url = URL(string: (pokemon?.imageUrl)!)!
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            self.cachedImages[indexPath.row] = image
                            cell.pokemonPic.image = UIImage(data: imageData) // may need to change this!
                            
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code")
                    }
                }
            }
            downloadPicTask.resume()
        }
        
        cell.pokemonName.text = pokemon?.name
        cell.pokemonStats.text = "\(pokemon?.attack)/\(pokemon?.defense)/\(pokemon?.health)"
        cell.pokemonNumber.text = "\(pokemon?.number)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        
        performSegue(withIdentifier: "segue2", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = segue.destination as? PokemonInfoViewController {
            dest.pokemon = pokemonArray?[(selectedIndexPath?.row)!]
            dest.image = cachedImages[(selectedIndexPath?.row)!]
        }
    }


}
