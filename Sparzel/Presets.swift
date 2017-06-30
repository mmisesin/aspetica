//
//  Presets.swift
//  Aspetica
//
//  Created by Artem Misesin on 4/24/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit
import CoreData

public struct Presets {
    
    var customName = false
    
    var addCounter = 0
    
    fileprivate var storage: [(name: String, value: String)] = []
    
    mutating func push(name: String, value: String) -> Bool{
        if !existing(value: value){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newEntry = NSEntityDescription.insertNewObject(forEntityName: "RatioPreset", into: context)
            
            newEntry.setValue(name, forKey: "name")
            newEntry.setValue(value, forKey: "value")
            
            do {
                try context.save()
            } catch {
                print("Error while inserting into database")
            }
            storage.insert((value, name), at: 0)
            if !customName{
                addCounter += 1
            }
            return true
        }
        return false
    }
    
    subscript(index: Int) -> (name: String, value: String) {
        return storage[index]
    }
    
    var count: Int{
        get {
            return storage.count
        }
    }
    
    mutating func swap(_ toIndex: Int, with fromIndex: Int){
        let itemToMove = storage[fromIndex]
        remove(at: fromIndex)
        storage.insert(itemToMove, at: toIndex)
    }
    
    mutating func remove(at index: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RatioPreset")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                context.delete(results[index] as! NSManagedObject)
                storage.remove(at: index)
                if !customName{
                    addCounter -= 1
                }
            }
        } catch {
            print("Error while deleting")
        }
        do {
            try context.save()
        } catch {
            print("Error while saving the context")
        }
    }
    
    func existing(value: String) -> Bool{
        print(value)
        for preset in storage {
            print(preset.name)
            if preset.name == value {
                return true
            }
        }
        return false
    }
    
    mutating func fetchPresets(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RatioPreset")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request) as! [NSManagedObject]
            if results.count > 0 {
                for result in results {
                    let value = result.value(forKey: "value") as! String
                    let name = result.value(forKey: "name") as! String
                    storage.insert((value, name), at: 0)
                }
            }
        } catch {
            print("Error while fetching in getEntries")
        }
    }
}
