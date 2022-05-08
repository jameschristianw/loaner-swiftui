//
//  DataController.swift
//  Loaner-SwiftUI
//
//  Created by James Christian Wira on 29/04/22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Loaner")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print ("Core Data failed to load: \(error.localizedDescription)")
            }
//            print("init core data description \(description)")
        }
    }
}
