//
//  ViewController.swift
//  Collection View
//
//  Created by Student on 11/2/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{


    @IBOutlet var longPressureGesture: UILongPressGestureRecognizer!
    @IBOutlet weak var collectionView: UICollectionView!
    
     var people = [Person]()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    let picker = UIImagePickerController()
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem)
    {
        addNewPerson()
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem)
    {
        takePicture()
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addNewPerson()
        let defaults = UserDefaults.standard
        //pulls out data from disk 
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth / 3.2, height: screenHeight / 4.2)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
        
        
        if let savedPeople = defaults.object(forKey: "people") as? Data
        {
            people = NSKeyedUnarchiver.unarchiveObject(with: savedPeople) as! [Person]
            //convert data back into an object 
        }
    }
    
    @IBAction func longTapPressed(_ sender: AnyObject)
    {
        handleGesture(gesture: longPressureGesture)
    }
    
    
    func takePicture()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.save()
            present(picker, animated: true, completion: nil)
        }
    }
    
    func addNewPerson()
    {
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func getDocumentDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        guard let image2 = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        let image2Name = UUID().uuidString
        let image2Path = getDocumentDirectory().appendingPathComponent(image2Name)
        
        
        if let jpegData = UIImageJPEGRepresentation(image, 80)
        {
            try? jpegData.write(to: imagePath)
        }
        
        if let jpegData = UIImageJPEGRepresentation(image, 80)
        {
            try? jpegData.write(to: image2Path)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView?.reloadData()
        
        dismiss(animated: true)
    }
    
    func handleGesture(gesture: UILongPressGestureRecognizer)
    {
        switch(gesture.state)
        {
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {break}
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        //<#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell
        
        let person = people[indexPath.item]
        
        cell.myLabel.text = person.name
        
        let path = getDocumentDirectory().appendingPathComponent(person.image)
        cell.myImage.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    func save()
    {
        //NSKeyArchiver convert our array into a data object
        let savedData = NSKeyedArchiver.archivedData(withRootObject: people)
        
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "people")
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let questionController = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: .alert)
        
        let person = people[indexPath.item]
        questionController.addAction(UIAlertAction(title: "Rename person", style: .default, handler:
            { (action:UIAlertAction!) -> Void in
            
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self, ac] _ in
            let newName = ac.textFields![0]
            person.name = newName.text!
            
            self.collectionView?.reloadData()
            self.save()
        })
        self.present(ac, animated: true, completion: nil)
    }))
        
        questionController.addAction(UIAlertAction(title: "Delete person", style: .default, handler:
            { (action:UIAlertAction!) -> Void in
                self.people.remove(at: indexPath.item)
                self.collectionView.deleteItems(at: [indexPath as IndexPath])
                self.collectionView.reloadData()
                self.save()
        }))
        
        present(questionController, animated: true)
    }
    
}
    
    










