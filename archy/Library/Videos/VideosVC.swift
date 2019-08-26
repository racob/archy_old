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
    var selectedCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.selectedCategory
        
        covers = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.black, UIColor.blue, UIColor.gray]
        videoCV.register(UINib(nibName: "VideosCell", bundle: nil), forCellWithReuseIdentifier: "videosCell")
        videoCV.delegate = self
        videoCV.dataSource = self
        if covers == nil {
            noVideosLabel.isHidden = false
        } else {
            noVideosLabel.isHidden  = true
        }

        if covers == nil {
            self.noVideosLabel.isHidden = false
        }else{
            self.noVideosLabel.isHidden = true
        }
    }

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(PreviewVC(), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = ( self.videoCV.frame.width - 20 )/3
        let cellHeight = cellWidth*1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
