//
//  AlbumsVC.swift
//  archy
//
//  Created by Eibiel Sardjanto on 22/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import UIKit

class AlbumsVC: UIViewController {
    
    @IBOutlet weak var albumTable: UITableView!
    
    //core data
    var library = [Library]()
    let delegate = UIApplication.shared.delegate as? AppDelegate

    //data dummy
    var distances : [String]?
    var totalVideos : [Int]?
    var covers : [UIColor]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Library"        
        
        distances = ["5 meters", "10 meters", "15 meters", "20 meters"]
        totalVideos = [0, 1, 0, 0]
        covers = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.blue]
        albumTable.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: "tableCell")
        albumTable.delegate = self
        albumTable.dataSource = self
    }
    
    func loadVideoLibrary() {
        guard let managedContext = delegate?.persistentContainer.viewContext else { return }
        self.library = [Library]()
        
        do {
            self.library = try managedContext.fetch(Library.fetchRequest())
        } catch {
            print(error)
        }
    }
    
}

extension AlbumsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return distances?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! AlbumCell
        
        guard let covers = covers, let distances = distances, let totalVideos = totalVideos else { return UITableViewCell() }
        
        if totalVideos[indexPath.row] == 0 {
            cell.imageVideo.backgroundColor = .lightGray
        }else{
            cell.imageVideo.backgroundColor = covers[indexPath.row]
        }
        cell.titleLabel.text = distances[indexPath.row]
        cell.totalLabel.text = String(totalVideos[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var isEmpty: Bool = true
        if self.totalVideos![indexPath.row] > 0 {
            isEmpty = false
        }
        let selectedCategory = self.distances?[indexPath.row] ?? ""
        let vc = VideosVC()
        vc.selectedCategory = selectedCategory
        vc.isEmpty = isEmpty
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
