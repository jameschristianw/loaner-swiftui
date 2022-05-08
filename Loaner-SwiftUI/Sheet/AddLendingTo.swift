//
//  SwiftUIView.swift
//  Loaner-SwiftUI
//
//  Created by James Christian Wira on 29/04/22.
//

import CoreData
import SwiftUI

struct AddLendingTo: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @Environment(\.self) var env
    
    @EnvironmentObject var loanItem: LoanViewModel
    
    private let numberFormatter: NumberFormatter
    let coloredNavAppearance = UINavigationBarAppearance()
    
    init() {
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.currencyCode = "IDR"
        
        coloredNavAppearance.backgroundColor = .systemBlue
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
               
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                
                VStack(alignment: .leading, spacing: 12){
                    Text("Name")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("Name", text: $loanItem.name)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                }
                Divider()
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 12){
                    Text("Amount (Rp.)")
                        .font(.caption)
                        .foregroundColor(.gray)
                
                    TextField("Amount", value: $loanItem.amount, formatter: numberFormatter).keyboardType(.numberPad)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                }
                Divider()
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 12){
                    Text("Purpose")
                        .font(.caption)
                        .foregroundColor(.gray)
                
                    
                    TextField("Purpose", text: $loanItem.purpose)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                }
                Divider()
                    .padding(.vertical, 8)
                
                Button {
                    if loanItem.addItem(context: moc, isLend: true) {
                       dismiss()
                    }
                } label: {
//                    HStack{
//                        Image(systemName: "plus")
//                    }
                    if let _ = loanItem.editLoan {
                        Text("Update")
                    } else {
                        Text("Save")
                    }
                }
                .disabled(loanItem.name.isEmpty)
                .opacity(loanItem.name.isEmpty ? 0.6 : 1)
                .padding()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(.blue, in: RoundedRectangle(cornerRadius: 12))
                
                if let item = loanItem.editLoan {
                    Button {
                        item.lendPayed = Date()
                        item.isPayed = true
                        try? moc.save()
                        dismiss()
                    } label: {
//                        HStack{
//                            Image(systemName: "checkmark")
//                        }
                        Text("Mark as payed")
                    }
                    .padding()
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .background(.white, in: RoundedRectangle(cornerRadius: 12))
                    
                }
                
                Button {
                    dismiss()
                } label: {
//                    HStack{
//                        Image(systemName: "xmark")
//                    }
                    Text("Cancel")
                }
                .padding()
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .background(.white, in: RoundedRectangle(cornerRadius: 12))
                
                
                if let item = loanItem.editLoan {
                    Button {
                        moc.delete(item)
                        try? moc.save()
                        dismiss()
                    } label: {
//                        HStack{
//                            Image(systemName: "trash")
//                        }
                        Text("Delete")
                    }
                    .padding()
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .background(.white, in: RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Lending money to")
            .navigationViewStyle(.stack)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
