//
//  ViewController.swift
//  KyleEthanCardGame
//
//  Created by Kyle on 8/1/18.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //this is the array of card images displayed as cards in each cell, images are found in Assets.xcassets
    let cardImageArray:[String] = ["noCard", "noCard", "noCard", "noCard", "dennisLi", "noCard", "noCard", "noCard", "noCard", "noCard", "noCard", "noCard"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    //what is in the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        
        //how to scale the image into the square UIimage box - FURTHER RESEARCH NEEDED
        cells.cardImageView.contentMode = .scaleToFill
        
        //every card in the cardImageArray is read and put into each cell
        cells.cardImageView.image = UIImage(named: cardImageArray[indexPath.row])
        return cells
        //maybe try strategy from blog to display image
    }
}

