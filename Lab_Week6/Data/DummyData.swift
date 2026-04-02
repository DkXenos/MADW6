import Foundation

struct DummyData {
    static let userProfile = UserProfile(
        name: "Kevin",
        age: 22,
        gender: .male,
        weight: 60,
        height: 165
    )
    
    static let entries: [LogbookEntry] = [
        LogbookEntry(foodName: "Soto Ayam", calories: 400, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
        LogbookEntry(foodName: "Salad", calories: 200, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
        LogbookEntry(foodName: "Steak", calories: 900, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)
    ]
}
