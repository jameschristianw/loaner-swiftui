//
//  History.swift
//  Loaner-SwiftUI
//
//  Created by James Christian Wira on 09/05/22.
//

import SwiftUI
import CoreData

struct History: View {
    @Environment(\.self) var env
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.lendDate)], predicate: NSPredicate(format: "isLending = 1 AND isPayed = true")) var loaners: FetchedResults<LoanItem>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.lendDate)], predicate: NSPredicate(format: "isLending = 0 AND isPayed = true")) var lendingFrom: FetchedResults<LoanItem>
    
    @State private var showResetAlert = false
    
    private let numberFormatter: NumberFormatter
    
    init() {
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.currencyCode = "IDR"
    }
    
    @ViewBuilder
    var renderData: some View {
        if (loaners.isEmpty) {
            Text("No Data").multilineTextAlignment(.trailing)
        } else {
            ForEach(loaners) { loaner in
                VStack{
                    HStack{
                        Image(systemName: loaner.isLending ? "arrow.up" : "arrow.down").foregroundColor(loaner.isLending ? Color(uiColor: UIColor(red: 0.31, green: 0.70, blue: 0.89, alpha: 1.00)) : Color.red).imageScale(.large)
                        VStack(alignment: .leading){
                            Text(loaner.name ?? "Unknown")
                                .multilineTextAlignment(.leading)
                            
                            Text(loaner.purpose ?? "Unknown")
                                .multilineTextAlignment(.leading).foregroundColor(Color.gray)
                        }
                        Spacer()
                        Text(numberFormatter.string(from: loaner.amount as NSNumber) ?? "")
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Divider()
                    
                    HStack(spacing: 8){
                        VStack{
                            Text("Borrow at")
                            Text(loaner.lendDate?.formatted(date: .abbreviated, time: .shortened) ?? "Unknown")
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color.gray)
                        }
                        .frame(maxWidth: .infinity)
                        Divider()
                        VStack {
                            Text("Paid at")
                            Text(loaner.lendPayed?.formatted(date: .abbreviated, time: .shortened) ?? "Unknown")
                                .multilineTextAlignment(.center).foregroundColor(Color.gray)
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                }
                .padding().background(Rectangle().fill(Color.white)).listRowSeparator(.hidden)
            }
        }
    }
    
    @ViewBuilder
    var renderDataLending: some View {
        if (lendingFrom.isEmpty) {
            Text("No Data").multilineTextAlignment(.center)
        } else {
            ForEach(lendingFrom) { loaner in
                VStack{
                    HStack{
                        Image(systemName: loaner.isLending ? "arrow.up" : "arrow.down").foregroundColor(loaner.isLending ? Color(uiColor: UIColor(red: 0.31, green: 0.70, blue: 0.89, alpha: 1.00)) : Color.red).imageScale(.large)
                        VStack(alignment: .leading){
                            Text(loaner.name ?? "Unknown")
                                .multilineTextAlignment(.leading)
                            
                            Text(loaner.purpose ?? "Unknown")
                                .multilineTextAlignment(.leading).foregroundColor(Color.gray)
                        }
                        Spacer()
                        Text(numberFormatter.string(from: loaner.amount as NSNumber) ?? "")
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Divider()
                    
                    HStack(spacing: 8){
                        VStack{
                            Text("Borrow at")
                            Text(loaner.lendDate?.formatted(date: .abbreviated, time: .shortened) ?? "Unknown")
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color.gray)
                        }
                        .frame(maxWidth: .infinity)
                        Divider()
                        VStack {
                            Text("Paid at")
                            Text(loaner.lendPayed?.formatted(date: .abbreviated, time: .shortened) ?? "Unknown")
                                .multilineTextAlignment(.center).foregroundColor(Color.gray)
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                }
                .padding().background(Rectangle().fill(Color.white))
            }
        }
    }
    
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LoanItem")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try env.managedObjectContext.save()
            try env.managedObjectContext.execute(deleteRequest)
            env.managedObjectContext.reset()
        } catch _ as NSError {
            // TODO: handle the error
        }
    }
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00))
                
                ScrollView{
                    VStack(alignment: .leading) {
                        
                        VStack{
                            HStack{
                                Text("Lend to")
                                Spacer()
                            }
                            .padding()

                            renderData
                        }
                        .frame(maxWidth: .infinity)
                                                
                        VStack() {
                            HStack{
                                Text("Lend from")
                                Spacer()
                            }.padding()

                            renderDataLending
                        }
                        .frame(maxWidth: .infinity)
                        
                    }.frame(maxWidth: .infinity)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationTitle("History")
            .navigationViewStyle(.stack)
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack{
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                    .onTapGesture {
                        env.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showResetAlert = true

                    } label: {
                        Label("Reset data", systemImage: "trash.slash")
                    }
                    .foregroundColor(Color.white)
                    .alert("Reset All Data?", isPresented: $showResetAlert){
                        Button("Ok", role: .destructive) {
                            deleteAllData()
                        }
                    }
                }
            }
        }
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
