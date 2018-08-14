//
//  ViewController.swift
//  KyleEthanCardGame
//
//  Created by Kyle on 8/1/18.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    //this is the array of card images displayed as cards in each cell, images are found in Assets.xcassets
    var firstCardImageArray:[String] = ["noCard", "noCard", "noCard", "noCard", "dennisLi"]
    var firstOpponentCardImageArray:[String] = ["noCard", "dennisLi", "dennisLi", "noCard", "dennisLi", "dennisLi", "dennisLi"]

    @IBOutlet weak var firstCardCollectionView: UICollectionView!{
        didSet{
            firstCardCollectionView.dragDelegate = self
            firstCardCollectionView.dragInteractionEnabled = true
            firstCardCollectionView.dropDelegate = self
        }
    }
    //drag function
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem]{
        if let draggedCard = (firstCardCollectionView.cellForItem(at: indexPath) as? myCell)?.cardImageView.image{
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: draggedCard as NSItemProviderWriting))//what is NSItemProviderWriting
            dragItem.localObject = draggedCard
            return [dragItem]
        }else{
            return []
        }
    }
    
    //MARK: So confused about NSItemProvriderReading.Type
//    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
//        return session.canLoadObjects(ofClass: NSItemProvider.self as! NSItemProviderReading.Type)
//    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)//moves card and inserts rather than copies
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath{
                if let draggedCard = item.dragItem.localObject as? NSItemProviderWriting{
                    if sourceIndexPath.section == destinationIndexPath.section {//can't place your own cards in opponent's section
                        collectionView.performBatchUpdates({
                            //sourceIndexPath.item returns index
                            if sourceIndexPath.section == 0{
                                moveCards(inArray: &firstCardImageArray, using: sourceIndexPath, using: destinationIndexPath)
                            }else if sourceIndexPath.section == 1{
                                moveCards(inArray: &firstOpponentCardImageArray, using: sourceIndexPath, using: destinationIndexPath)
                            }
                            firstCardCollectionView.deleteItems(at: [sourceIndexPath])//edits the actual view
                            firstCardCollectionView.insertItems(at: [destinationIndexPath])
                        })
                    }
                }
            }
        }
    }
    
    func moveCards(inArray array: inout Array<String>, using sourceIndexPath:IndexPath, using destinationIndexPath:IndexPath){
        let removedCard = array[sourceIndexPath.item]
        print(sourceIndexPath.item)
        array.remove(at: sourceIndexPath.item)//edits the array
        array.insert(removedCard, at: destinationIndexPath.item)
        print(array)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var lengthOfArray = -1 //this will not display anything if things fail below
        if section == 0{
            lengthOfArray = firstCardImageArray.count
        } else if section == 1{
            lengthOfArray = firstOpponentCardImageArray.count
        }
        return lengthOfArray
    }
    
    //what is in the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        
        //how to scale the image into the square UIimage box - FURTHER RESEARCH NEEDED
        cells.cardImageView.contentMode = .scaleToFill
        
        //every card in the cardImageArray is read and put into each cell
        if indexPath.section == 0 {
            cells.cardImageView.image = UIImage(named: firstCardImageArray[indexPath.row])
            cells.cardLabel.text = "Cool"
        }else if indexPath.section == 1{//second section
            cells.cardImageView.image = UIImage(named: firstOpponentCardImageArray[indexPath.row])
            cells.cardLabel.text = "beans"
        }
        
        return cells 
        //maybe try strategy from blog to display image
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let collectionViewFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionViewFooter", for: indexPath) as? CollectionViewFooter{
            collectionViewFooter.fightingInBetweenLabel.text = "Fight!"
            return collectionViewFooter
        }
        return UICollectionReusableView()
    }
    
}

