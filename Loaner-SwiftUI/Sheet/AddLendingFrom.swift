//
//  AddLendingFrom.swift
//  Loaner-SwiftUI
//
//  Created by James Christian Wira on 29/04/22.
//

import SwiftUI

struct AddLendingFrom: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var purpose = ""
    @State private var amount: Int32 = 0
    
    private let numberFormatter: NumberFormatter
    
    init() {
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.currencyCode = "Rp."
        
    }
    
    var body: some View {NavigationView {
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
                    loaner.name = name
                    loaner.purpose = purpose
                    loaner.amount = amount
                    loaner.isLending = false
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
            }
        }
        .navigationTitle("Lending money from")
    }
    
    }
}

