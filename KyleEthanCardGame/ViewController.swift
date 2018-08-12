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
    var cardImageArray:[String] = ["noCard", "noCard", "noCard", "noCard", "dennisLi", "noCard", "noCard", "noCard", "noCard", "noCard", "noCard", "noCard"]

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
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: draggedCard as NSItemProviderWriting))
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
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath{
                if let draggedCard = item.dragItem.localObject as? NSItemProviderWriting{
                    collectionView.performBatchUpdates({
                        //the reason for sourceIndexPath[1] is because sourceIndexPath is an array [section, item], i just care about the item which is the second item of the array
                        let removedCard = cardImageArray[sourceIndexPath[1]]
                        cardImageArray.remove(at: sourceIndexPath.item)
                        cardImageArray.insert(removedCard, at: destinationIndexPath.item)
                        print(cardImageArray)
                        firstCardCollectionView.deleteItems(at: [sourceIndexPath])
                        firstCardCollectionView.insertItems(at: [destinationIndexPath])
                    })
                }
            }
        }
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
        cells.cardLabel.text = "Cool"
        return cells 
        //maybe try strategy from blog to display image
    }
}

