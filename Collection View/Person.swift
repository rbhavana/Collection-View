//
//  Person.swift
//  Collection View
//
//  Created by Student on 11/9/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
//NSCoding is a protocall that allow you to save data to disk, writ and read data.

class Person: NSObject, NSCoding
{
    var name : String
    var image : String
    
    init(name: String, image: String)
    {
        self.name = name
        self.image = image
    }
    
    //init used for loading object of the class 
    required init?(coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject(forKey: "name") as! String
        image = aDecoder.decodeObject(forKey: "image") as! String
    }

    //used for saving 
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}
