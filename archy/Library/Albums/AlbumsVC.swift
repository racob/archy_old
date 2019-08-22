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
    
    var library = [Library]()
    let delegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! AlbumCell
        
        return cell
    }
}
