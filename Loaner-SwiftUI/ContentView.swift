//
//  ContentView.swift
//  Loaner-SwiftUI
//
//  Created by James Christian Wira on 29/04/22.
//
import CoreData
import SwiftUI

struct ContentView: View {
    let coloredNavAppearance = UINavigationBarAppearance()
    
    init() {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = .systemBlue
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }
    
    var body: some View {
        NavigationView{
            Home()
                .navigationTitle("Home")
             
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

