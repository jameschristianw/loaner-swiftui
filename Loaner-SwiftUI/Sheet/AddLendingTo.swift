//
//  SwiftUIView.swift
//  Loaner-SwiftUI
//
//  Created by James Christian Wira on 29/04/22.
//

import SwiftUI

struct AddLendingTo: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var purpose = ""
    @State private var amount: Int32 = 0
    
    private let numberFormatter: NumberFormatter
    let coloredNavAppearance = UINavigationBarAppearance()
    
    init() {
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.currencyCode = "Rp."
        
//        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = .white
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
               
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $amount, formatter: numberFormatter).keyboardType(.numberPad)
                    TextField("Name", text: $name)
                    TextField("Purpose", text: $purpose)
                }


                Section {
                    Button("Save") {
                        let loaner = LoanItem(context: moc)
                        loaner.id = UUID()
                        loaner.name = name.count == 0 ? "No name" : name
                        loaner.purpose = purpose.count == 0 ? "Just tell me your secret" : purpose
                        loaner.amount = amount
                        loaner.isLending = true
                        loaner.lendDate = Date.now
                        loaner.lendPayed = nil

                        do {
                            try moc.save()
                            dismiss()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                    Button("Cancel"){
                        dismiss()
                    }
                }
            }
            .navigationTitle("Lending money to")
            .navigationBarTitleDisplayMode(.inline)
        }
    
    }
}
