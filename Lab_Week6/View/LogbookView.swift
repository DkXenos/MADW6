import SwiftUI

struct LogbookView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Greeting
                    HStack {
                        Text("Logbook Makanan")
                            .font(.largeTitle)
                            .bold()
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Text("Hi, \(appViewModel.userProfile.name.isEmpty ? "..." : appViewModel.userProfile.name)!")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(Capsule())
                        .padding(.horizontal)
                    
                    // Summary Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ringkasan Kalori Harian")
                            .font(.headline)
                        
                        if appViewModel.entries.isEmpty {
                            Text("Belum ada data logbook.")
                                .foregroundColor(.secondary)
                        } else {
                            HStack {
                                Text("Tanggal")
                                Spacer()
                                Text("Total")
                                    .frame(width: 60, alignment: .trailing)
                                Text("Entri")
                                    .frame(width: 40, alignment: .trailing)
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            
                            // Group entries by date
                            let grouped = Dictionary(grouping: appViewModel.entries) { item -> Date in
                                Calendar.current.startOfDay(for: item.date)
                            }
                            let sortedDates = grouped.keys.sorted(by: >)
                            
                            ForEach(sortedDates, id: \.self) { date in
                                let dailyEntries = grouped[date] ?? []
                                let totalDailyCal = dailyEntries.reduce(0) { $0 + $1.calories }
                                
                                HStack {
                                    Text(dateFormatter.string(from: date))
                                    Spacer()
                                    Text("\(totalDailyCal) kcal")
                                        .frame(width: 60, alignment: .trailing)
                                    Text("\(dailyEntries.count)")
                                        .frame(width: 40, alignment: .trailing)
                                }
                                .font(.subheadline)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Rata-rata / hari")
                                Spacer()
                                Text("\(appViewModel.meanCalories) kcal")
                            }
                            .font(.headline)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // List of entries
                    if appViewModel.entries.isEmpty {
                        Text("Belum ada makanan tercatat. Tekan + untuk mulai.")
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                            .padding(.horizontal)
                    } else {
                        // Grouping for the main list
                        let grouped = Dictionary(grouping: appViewModel.entries) { item -> Date in
                            Calendar.current.startOfDay(for: item.date)
                        }
                        let sortedDates = grouped.keys.sorted(by: >)
                        
                        ForEach(sortedDates, id: \.self) { date in
                            VStack(alignment: .leading) {
                                Text(dateFormatter.string(from: date))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 5)
                                    
                                ForEach(grouped[date] ?? []) { entry in
                                    EntryCard(entry: entry) {
                                        appViewModel.deleteEntry(entry)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 80) // for nav bar space
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddLogbookView()) {
                        Image(systemName: "plus")
                            .padding(10)
                            .background(Circle().fill(Color(.systemGray5)))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    // Helper to format dates
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }
}
