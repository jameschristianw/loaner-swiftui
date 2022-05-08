//
//  Loaner_SwiftUIApp.swift
//  Loaner-SwiftUI
//
//  Created by James Christian Wira on 29/04/22.
//

// App Icon is using free vector from
// https://www.vectorstock.com/royalty-free-vector/book-money-growth-chart-investment-currency-vector-32434118

import SwiftUI

@main
struct Loaner_SwiftUIApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
//            TestView()
            ContentView().environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
