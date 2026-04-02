import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var entries: [LogbookEntry]
    @Published var isDarkMode: Bool = false
    
    init() {
        self.userProfile = DummyData.userProfile
        self.entries = DummyData.entries
    }
    
    // Logbook functions
    func addEntry(_ entry: LogbookEntry) {
        entries.append(entry)
        entries.sort { $0.date > $1.date }
    }
    
    func deleteEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }
    
    func deleteEntry(_ entry: LogbookEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries.remove(at: index)
        }
    }
    
    // Profile functions
    func incrementStreak() {
        userProfile.dailyStreak += 1
    }
    
    func resetStreak() {
        userProfile.dailyStreak = 0
    }
    
    var bmi: Double {
        let heightInMeter = userProfile.height / 100
        guard heightInMeter > 0 else { return 0 }
        return userProfile.weight / (heightInMeter * heightInMeter)
    }
    
    var bmiCategory: String {
        let b = bmi
        if b < 18.5 { return "underweight" }
        else if b < 25.0 { return "normal" }
        else if b < 30.0 { return "overweight" }
        else { return "Very overweight" }
    }
    
    var bmr: Double {
        if userProfile.gender == .male {
            return (10 * userProfile.weight) + (6.25 * userProfile.height) - (5 * Double(userProfile.age)) + 5
        } else {
            return (10 * userProfile.weight) + (6.25 * userProfile.height) - (5 * Double(userProfile.age)) - 161
        }
    }
    
    // Summary data for Logbook
    var totalCalories: Int {
        entries.reduce(0) { $0 + $1.calories }
    }
    
    var entriesPerDay: Int {
        return entries.count
    }
    
    var meanCalories: Int {
        let uniqueDays = Set(entries.map { Calendar.current.startOfDay(for: $0.date) }).count
        if uniqueDays == 0 { return 0 }
        return totalCalories / uniqueDays
    }
}
