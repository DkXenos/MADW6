import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var gender: Gender = .male
    @State private var weight: String = ""
    @State private var weightUnit: WeightUnit = .kg
    @State private var height: String = ""
    @State private var heightUnit: HeightUnit = .cm
    
    var body: some View {
        Form {
            Section(header: Text("Data Pribadi")) {
                TextField("Nama", text: $name)
                HStack {
                    TextField("Umur", text: $age)
                        .keyboardType(.numberPad)
                    Text("tahun")
                        .foregroundColor(.secondary)
                }
                
                Picker("Gender", selection: $gender) {
                    ForEach(Gender.allCases, id: \.self) { g in
                        Text(g.rawValue).tag(g)
                    }
                }
            }
            
            Section(header: Text("Berat Badan")) {
                HStack {
                    TextField("Berat badan", text: $weight)
                        .keyboardType(.decimalPad)
                    
                    Picker("", selection: $weightUnit) {
                        ForEach(WeightUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 80)
                }
                if weightUnit == .lbs {
                    let w = (Double(weight.replacingOccurrences(of: ",", with: ".")) ?? 0) * 0.453592
                    Text("≈ \(String(format: "%.2f", w)) kg (standar)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Tinggi Badan")) {
                HStack {
                    TextField("Tinggi badan", text: $height)
                        .keyboardType(.decimalPad)
                    
                    Picker("", selection: $heightUnit) {
                        ForEach(HeightUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 120)
                }
                if heightUnit == .m {
                    let h = (Double(height.replacingOccurrences(of: ",", with: ".")) ?? 0) * 100
                    Text("≈ \(String(format: "%.2f", h)) cm (standar)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if heightUnit == .inch {
                    let h = (Double(height.replacingOccurrences(of: ",", with: ".")) ?? 0) * 2.54
                    Text("≈ \(String(format: "%.2f", h)) cm (standar)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Edit Profil")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Save action logic
                    saveProfile()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Simpan & Kembali")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.name = appViewModel.userProfile.name
            self.age = "\(appViewModel.userProfile.age)"
            self.gender = appViewModel.userProfile.gender
            self.weight = String(format: "%.2f", appViewModel.userProfile.weight)
            self.height = String(format: "%.2f", appViewModel.userProfile.height)
        }
    }
    
    private func saveProfile() {
        appViewModel.userProfile.name = name
        if let ageInt = Int(age) {
            appViewModel.userProfile.age = ageInt
        }
        appViewModel.userProfile.gender = gender
        
        let cleanedWeight = weight.replacingOccurrences(of: ",", with: ".")
        if let weightVal = Double(cleanedWeight) {
            if weightUnit == .lbs {
                appViewModel.userProfile.weight = weightVal * 0.453592
            } else {
                appViewModel.userProfile.weight = weightVal
            }
        }
        
        let cleanedHeight = height.replacingOccurrences(of: ",", with: ".")
        if let heightVal = Double(cleanedHeight) {
            if heightUnit == .m {
                appViewModel.userProfile.height = heightVal * 100
            } else if heightUnit == .inch {
                appViewModel.userProfile.height = heightVal * 2.54
            } else {
                appViewModel.userProfile.height = heightVal
            }
        }
    }
}
