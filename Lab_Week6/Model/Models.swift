import Foundation
import SwiftUI

struct LogbookEntry: Identifiable {
    let id = UUID()
    var foodName: String
    var calories: Int
    var date: Date
    var image: Data?
}

enum Gender: String, CaseIterable {
    case male = "Laki-laki"
    case female = "Perempuan"
}

enum WeightUnit: String, CaseIterable {
    case kg = "kg"
    case lbs = "lbs"
}

enum HeightUnit: String, CaseIterable {
    case cm = "cm"
    case m = "m"
    case inch = "in"
}

struct UserProfile {
    var name: String
    var age: Int
    var gender: Gender
    var weight: Double
    var height: Double
    var dailyStreak: Int = 0
}
