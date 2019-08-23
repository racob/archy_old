//
//  VideosVC.swift
//  archy
//
//  Created by Eibiel Sardjanto on 22/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import UIKit

class VideosVC: UIViewController {

    @IBOutlet weak var videoCV: UICollectionView!
    @IBOutlet weak var noVideosLabel: UILabel!
    
    var library: [Library]?
    var covers : [UIColor]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        covers = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.black, UIColor.blue, UIColor.gray]
        videoCV.register(UINib(nibName: "VideosCell", bundle: nil), forCellWithReuseIdentifier: "videosCell")
        videoCV.delegate = self
        videoCV.dataSource = self

        // Do any additional setup after loading the view.
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

extension VideosVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let library = library else { return 0 }
//        return library.count
        return covers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videosCell", for: indexPath) as! VideosCell
        
//        guard let library = library else { return cell }
//        let data = library[indexPath.row]
//        let video = data.video_path
//        cell.videoImage.setupPreview(withPath: video!)
        
        guard let covers = covers else { return UICollectionViewCell() }
        
        cell.videoImage.backgroundColor = covers[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = ( self.videoCV.frame.width - 20 )/3
        let cellHeight = cellWidth*1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    
}
