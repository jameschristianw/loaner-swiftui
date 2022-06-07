//
//  Home.swift
//  Loaner-SwiftUI
//
//  Created by James Christian Wira on 09/05/22.
//

import SwiftUI
import CoreData

struct Home: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.lendDate)], predicate: NSPredicate(format: "isLending = 1 AND isPayed = false")) var loaners: FetchedResults<LoanItem>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.lendDate)], predicate: NSPredicate(format: "isLending = 0 AND isPayed = false")) var lendingFrom: FetchedResults<LoanItem>
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var loanItem: LoanViewModel = .init()
    
    @State private var isLoading = true
    @State private var isLoading2 = true
    
    @State private var amount: Int32 = 0
    
    @State private var showingAddScreenTo = false
    @State private var showingAddScreenFrom = false
    
    @State private var showHistory = false
    
    @State private var refreshingId = UUID()
    
    private let numberFormatter: NumberFormatter
    
    @Environment(\.managedObjectContext) var moc
    
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
                HStack{
                    Image(systemName: loaner.isLending ? "arrow.up" : "arrow.down")
                        .foregroundColor(loaner.isLending ? Color(uiColor: UIColor(red: 0.31, green: 0.70, blue: 0.89, alpha: 1.00)) : Color.red)
                        .imageScale(.large)
                    VStack(alignment: .leading){
                        Text(loaner.name ?? "Unknown")
                            .multilineTextAlignment(.leading)
                        
                        Text(loaner.purpose ?? "Unknown")
                            .multilineTextAlignment(.leading).foregroundColor(Color.gray)
                        
                        Text(loaner.lendDate?.formatted(date: .abbreviated, time: .shortened) ?? "Unknown")
                            .multilineTextAlignment(.leading).foregroundColor(Color.gray)
                    }
                    Spacer()
                    Text(numberFormatter.string(from: loaner.amount as NSNumber) ?? "")
                        .multilineTextAlignment(.trailing)
                }
                .padding().background(Rectangle().fill(Color.white)).listRowSeparator(.hidden)
                .onTapGesture {
                    loanItem.editLoan = loaner
                    loanItem.showAddLendTo.toggle()
                    loanItem.setupLoanItem()
                }
                
            }.id(refreshingId)
        }
    }
    
    @ViewBuilder
    var renderDataLending: some View {
        if (lendingFrom.isEmpty) {
            Text("No Data").multilineTextAlignment(.trailing)
        } else {
            ForEach(lendingFrom) { loaner in
                HStack{
                    Image(systemName: loaner.isLending ? "arrow.up" : "arrow.down").foregroundColor(loaner.isLending ? Color(uiColor: UIColor(red: 0.31, green: 0.70, blue: 0.89, alpha: 1.00)) : Color.red).imageScale(.large)
                    VStack(alignment: .leading){
                        Text(loaner.name ?? "Unknown")
                            .multilineTextAlignment(.leading)
                        
                        Text(loaner.purpose ?? "Unknown")
                            .multilineTextAlignment(.leading).foregroundColor(Color.gray)
                        
                        Text(loaner.lendDate?.formatted(date: .abbreviated, time: .shortened) ?? "Unknown")
                            .multilineTextAlignment(.leading).foregroundColor(Color.gray)
                    }
                    Spacer()
                    Text(numberFormatter.string(from: loaner.amount as NSNumber) ?? "")
                        .multilineTextAlignment(.trailing)
                }
                .padding().background(Rectangle().fill(Color.white))
                .onTapGesture {
                    loanItem.editLoan = loaner
                    loanItem.showAddLendFrom.toggle()
                    loanItem.setupLoanItem()
                }
            }.id(refreshingId)
        }
    }
    
    @ViewBuilder
    var renderDeleteButton: some View {
        if !loaners.isEmpty || !lendingFrom.isEmpty {
            Button(action: {
                
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LoanItem")
                
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do {
                    try moc.save()
                    try moc.execute(deleteRequest)
                    moc.reset()
                    self.refreshingId = UUID()
                } catch _ as NSError {
                    // TODO: handle the error
                }
            }) {
                Text("Delete all data").foregroundColor(Color.white).foregroundColor(Color.red).multilineTextAlignment(.center)
            }.padding().frame(minWidth: 0, maxWidth: .infinity, alignment: .center).id(refreshingId).background(Color.red)
        }
    }
    
    var body: some View {
        ZStack{
            Color(colorScheme == .dark ? Colors().darkPrimary : Colors().lightPrimary)
            
            ScrollView{
                VStack(alignment: .leading) {
                    
//                        VStack(alignment: .leading){
//                            Text("Money").frame(maxWidth: .infinity, alignment: .leading)
//                            Text("Amount")
//                        }.padding().padding()
//                        .background(
//                            RoundedRectangle(cornerSize: CGSize(width: 10 , height: 10))
//                            .padding()
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .foregroundColor(Color.white)
//                            .shadow(color: Color.gray, radius: 5, x: 3, y: 3)
//                        )
                    
                    
                    VStack{
                        HStack{
                            Text("Lend to")
                            Spacer()
                            Button {
                                loanItem.showAddLendTo.toggle()
                            } label: {
                                HStack {
                                    Text("Add new")
                                    Image(systemName: "plus").foregroundColor(Color(UIColor(red: 0.31, green: 0.70, blue: 0.89, alpha: 1.00)))
                                }
                            }
                        }
                        .padding()

                        renderData
                    }
                    .frame(maxWidth: .infinity)
                    .sheet(isPresented: $loanItem.showAddLendTo) {
                        loanItem.resetLoanData()
                    } content: {
                        AddLendingTo()
                            .environmentObject(loanItem)
                    }
                                            
                    VStack() {
                        HStack{
                            Text("Lend from")
                            Spacer()
                            Button {
                                loanItem.showAddLendFrom.toggle()
                            } label: {
                                HStack {
                                    Text("Add new")
                                    Image(systemName: "plus").foregroundColor(Color(UIColor(red: 0.31, green: 0.70, blue: 0.89, alpha: 1.00)))
                                }
                            }
                        }.padding()

                        renderDataLending

                    }
                    .frame(maxWidth: .infinity)
                    .sheet(isPresented: $loanItem.showAddLendFrom) {
                        loanItem.resetLoanData()
                    } content: {
                        AddLendingFrom().environmentObject(loanItem)
                    }
                    
                }.frame(maxWidth: .infinity)
            }
            
        }
        .fullScreenCover(isPresented: $showHistory) {
            self.refreshingId = UUID()
        } content: {
            History()
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {                    
                    Button {
    //                    showResetAlert = true
                        showHistory.toggle()
                    } label: {
                        Label("History", systemImage: "clock.arrow.circlepath")
                    }
                    .foregroundColor(Color.white)
                }
            }
        }
            
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
