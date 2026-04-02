import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Daily Streak")) {
                    HStack {
                        Text("Daily Streak")
                        Spacer()
                        Text("\(appViewModel.userProfile.dailyStreak) hari")
                            .foregroundColor(.secondary)
                        
                        Button("+1") {
                            appViewModel.incrementStreak()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                    }
                    
                    Button("Reset Streak", role: .destructive) {
                        appViewModel.resetStreak()
                    }
                }
                
                Section(header: Text("Rangkuman Profil")) {
                    ProfileRow(title: "Nama", value: appViewModel.userProfile.name)
                    ProfileRow(title: "Umur", value: "\(appViewModel.userProfile.age) tahun")
                    ProfileRow(title: "Gender", value: appViewModel.userProfile.gender.rawValue)
                    ProfileRow(title: "Berat", value: String(format: "%.1f kg", appViewModel.userProfile.weight))
                    ProfileRow(title: "Tinggi", value: String(format: "%.1f cm", appViewModel.userProfile.height))
                    ProfileRow(title: "Kebutuhan Kalori", value: String(format: "%.0f kcal/hari", appViewModel.bmr))
                }
                
                Section(header: Text("BMI")) {
                    ProfileRow(title: "Indeks Massa Tubuh", value: String(format: "%.1f", appViewModel.bmi))
                    ProfileRow(title: "Kategori", value: "Berat Badan \(appViewModel.bmiCategory)")
                }
                
                Section(header: Text("Pengaturan")) {
                    NavigationLink(destination: EditProfileView()) {
                        Text("Edit Profil")
                    }
                    Toggle("Tema Gelap", isOn: $appViewModel.isDarkMode)
                }
            }
            .navigationTitle("Profil Saya")
        }
    }
}

struct ProfileRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
