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
        distances = ["5 m", "10 m", "15 m", "20 m"]
        totalVideos = [3, 5, 8, 2]
        covers = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.blue]
        albumTable.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: "tableCell")
        albumTable.delegate = self
        albumTable.dataSource = self

        // Do any additional setup after loading the view.
    }
    func loadVideoLibrary() {
        guard let managedContext = delegate?.persistentContainer.viewContext else { return }
        library = [Library]()
        
        do {
            library = try managedContext.fetch(Library.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AlbumsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return distances?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! AlbumCell
        
        guard let covers = covers, let distances = distances, let totalVideos = totalVideos else { return UITableViewCell() }
        
        cell.imageVideo.backgroundColor = covers[indexPath.row]
        cell.titleLabel.text = distances[indexPath.row]
        cell.totalLabel.text = String(totalVideos[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(VideosVC(), animated: true)
    }
}
