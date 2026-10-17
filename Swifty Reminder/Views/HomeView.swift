//
//  ContentView.swift
//  RemindersApp
//
//  Created by Mohammad Azam on 1/19/23.
//

import SwiftUI

struct HomeView: View {
    @FetchRequest(sortDescriptors: [])
    private var myListResults: FetchedResults<MyList>
    
    @FetchRequest(sortDescriptors: [])
    private var searchResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .today))
    private var todayResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .scheduled))
    private var scheduledResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .all))
    private var allResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .completed))
    private var completedResults: FetchedResults<Reminder>
    
    @State private var search: String = ""
    @State private var isPresented: Bool = false
    @State private var searching: Bool = false
    
    private var reminderStats = ReminderStatsBuilder()
    @State private var reminderStatsValues = ReminderStatsValues()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    HStack {
                        NavigationLink {
                            ReminderListView(reminders: todayResults)
                        } label: {
                            ReminderStatsView(icon: "moon.stars.fill", title: "Tonight", count: reminderStatsValues.todayCount, iconColor: .pumpkin)
                        }
                        
                        NavigationLink {
                            ReminderListView(reminders: scheduledResults)
                        } label: {
                            ReminderStatsView(icon: "eye.fill", title: "Lurking", count: reminderStatsValues.scheduledCount, iconColor: .candleGlow)
                        }
                    }
                    
                    HStack {
                        NavigationLink {
                            ReminderListView(reminders: allResults)
                            
                        } label: {
                            ReminderStatsView(icon: "flame.fill", title: "All Haunts", count: reminderStatsValues.allCount, iconColor: .ember)
                        }
                        
                        NavigationLink {
                            ReminderListView(reminders: completedResults)
                        } label: {
                            ReminderStatsView(icon: "moon.zzz.fill", title: "Buried", count: reminderStatsValues.completedCount, iconColor: .boneWhite)
                        }
                    }
                    
                    Text("My Cauldrons")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.pumpkin)
                        .padding()
                    
                    MyListView(myLists: myListResults)
                    
                    Button {
                        isPresented = true
                    } label: {
                        Text("Brew a Cauldron")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.headline)
                    }.padding()
                }
            }
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    AddNewListView { name, color in
                        do {
                            try ReminderService.saveMyList(name, color)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .onChange(of: search, perform: { searchTerm in
                searching = !searchTerm.isEmpty ? true : false
                searchResults.nsPredicate = ReminderService.getRemindersBySearchTerm(search).predicate
            })
            .overlay(alignment: .center, content: {
                ReminderListView(reminders: searchResults)
                    .opacity(searching ? 1.0 : 0.0)
            })
            .onAppear {
                reminderStatsValues = reminderStats.build(myListResults: myListResults)
            }
            .padding()
            .background(Color.midnight.ignoresSafeArea())
            .navigationTitle("Haunted Reminders")
        }.searchable(text: $search, prompt: "Search the crypt")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
    }
}
