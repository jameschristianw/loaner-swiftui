//
//  LoanViewModel.swift
//  Loaner-SwiftUI
//
//  Created by James Christian Wira on 09/05/22.
//

import SwiftUI
import CoreData

class LoanViewModel: ObservableObject {
    
    @Published var showAddLendTo: Bool = false
    @Published var showAddLendFrom: Bool = false
    
    @Published var name: String = ""
    @Published var purpose: String = ""
    @Published var amount: Int32 = 0
    @Published var isLending: Bool = true
    @Published var lendDate: Date = Date()
    @Published var lendPayed: Date = Date()
    
    @Published var editLoan: LoanItem?
    
    func addItem(context: NSManagedObjectContext, isLend: Bool) -> Bool {
        var item: LoanItem!
        
        if let editLoan = editLoan {
            item = editLoan
        } else {
            item = LoanItem(context: context)
        }
        
        item.name = name
        item.purpose = purpose
        item.isLending = isLend
        item.amount = amount
        item.lendDate = lendDate
        item.isPayed = false
        item.lendPayed = nil
        
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    func resetLoanData() {
        name = ""
        purpose = ""
        amount = 0
        isLending = true
        lendDate = Date()
        lendPayed = Date()
        editLoan = nil
    }
    
    func setupLoanItem() {
        if let editLoan = editLoan {
            name = editLoan.name ?? ""
            purpose = editLoan.purpose ?? ""
            amount = editLoan.amount
        }
    }
}
