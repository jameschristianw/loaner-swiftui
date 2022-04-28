//
//  ContentView.swift
//  Loaner-SwiftUI
//
//  Created by James Christian Wira on 29/04/22.
//
import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.lendDate)], predicate: NSPredicate(format: "isLending = 1")) var loaners: FetchedResults<LoanItem>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.lendDate)], predicate: NSPredicate(format: "isLending = 0")) var lendingFrom: FetchedResults<LoanItem>
    @State private var refreshingId = UUID()
    
    let coloredNavAppearance = UINavigationBarAppearance()
    
    @State private var isLoading = true
    @State private var isLoading2 = true
    
    @State private var amount: Int32 = 0
    
    @State private var showResetAlert = false
    @State private var showingAddScreenTo = false
    @State private var showingAddScreenFrom = false
    
    init() {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = .systemBlue
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
               
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance

    }
    
    @ViewBuilder
    var renderData: some View {
        if (loaners.isEmpty) {
            Text("No Data").multilineTextAlignment(.trailing)
        } else {
            ForEach(loaners) { loaner in
//                amount += loaner.amount
                HStack{
                    Image(systemName: loaner.isLending == 1 ? "arrow.up" : "arrow.down").foregroundColor(loaner.isLending == 1 ? Color(uiColor: UIColor(red: 0.31, green: 0.70, blue: 0.89, alpha: 1.00)) : Color.red).imageScale(.large)
                    VStack(alignment: .leading){
                        Text(loaner.name ?? "Unknown")
                            .multilineTextAlignment(.leading)
                        
                        Text(loaner.purpose ?? "Unknown")
                            .multilineTextAlignment(.leading).foregroundColor(Color.gray)
                    }
                    Spacer()
                    Text("Rp. \(String(loaner.amount))")
                        .multilineTextAlignment(.trailing)
                }.padding().background(Rectangle().fill(Color.white)).listRowSeparator(.hidden)
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
                    Image(systemName: loaner.isLending == 1 ? "arrow.up" : "arrow.down").foregroundColor(loaner.isLending == 1 ? Color(uiColor: UIColor(red: 0.31, green: 0.70, blue: 0.89, alpha: 1.00)) : Color.red).imageScale(.large)
                    VStack(alignment: .leading){
                        Text(loaner.name ?? "Unknown")
                            .multilineTextAlignment(.leading)
                        
                        Text(loaner.purpose ?? "Unknown")
                            .multilineTextAlignment(.leading).foregroundColor(Color.gray)
                    }
                    Spacer()
                    Text( String(loaner.amount) )
                        .multilineTextAlignment(.trailing)
                }.padding().background(Rectangle().fill(Color.white))
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
    
    func deleteAllData() {
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
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00))
                
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
                                Button (action: {
                                    showingAddScreenTo.toggle()
                                }){
                                    HStack {
                                        Text("Add new")
                                        Image(systemName: "plus").foregroundColor(Color(UIColor(red: 0.31, green: 0.70, blue: 0.89, alpha: 1.00)))
                                    }
                                }
                            }
                            .padding()
                                
                            renderData
                        }.sheet(isPresented: $showingAddScreenTo) {
                            AddLendingTo()
                        }
                                                
                        VStack() {
                            HStack{
                                Text("Lend from")
                                Spacer()
                                Button (action: {
                                    showingAddScreenFrom.toggle()
                                }){
                                    HStack {
                                        Text("Add new")
                                        Image(systemName: "plus").foregroundColor(Color(UIColor(red: 0.31, green: 0.70, blue: 0.89, alpha: 1.00)))
                                    }
                                }
                            }.padding()
                            
                            renderDataLending
                            
                        }.sheet(isPresented: $showingAddScreenFrom) {
                            AddLendingFrom()
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .toolbar{
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

