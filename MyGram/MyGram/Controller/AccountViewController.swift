//
//  AccountViewController.swift
//  MyGram
//
//  Created by Никита Шляхов on 27.06.2022.
//

import UIKit
import Foundation

class AccountViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var folowersLabel: UILabel!
    @IBOutlet weak var folowingLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let paddings: CGFloat = 20
    let countOfRowInLine: CGFloat = 3
    let cellSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func getCellSize() -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 2 * paddings - countOfRowInLine * cellSpacing) / 3.0,
                      height: (UIScreen.main.bounds.width - 2 * paddings - countOfRowInLine * cellSpacing) / 3.0)
    }
    
}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPhotosCell", for: indexPath)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return getCellSize()
    }
    
    
}
