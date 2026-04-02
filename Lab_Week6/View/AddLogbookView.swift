import SwiftUI
import PhotosUI

struct AddLogbookView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var foodName = ""
    @State private var calories = ""
    @State private var date = Date()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        Form {
            Section(header: Text("Foto Makanan")) {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Pilih Foto")
                        }
                    }
                    .onChange(of: selectedItem) { oldItem, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        }
                    }
                
                if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(12)
                    
                    Button("Hapus Foto", role: .destructive) {
                        self.selectedImageData = nil
                        self.selectedItem = nil
                    }
                }
            }
            
            Section(header: Text("Info Makanan")) {
                TextField("Nama Makanan", text: $foodName)
                HStack {
                    TextField("Kalori", text: $calories)
                        .keyboardType(.numberPad)
                    Text("kcal")
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Tanggal")) {
                DatePicker("Pilih Tanggal", selection: $date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
        }
        .navigationTitle("Tambah Makanan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Batal") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Simpan") {
                    if let cal = Int(calories), !foodName.isEmpty {
                        let newEntry = LogbookEntry(
                            foodName: foodName,
                            calories: cal,
                            date: date,
                            image: selectedImageData
                        )
                        appViewModel.addEntry(newEntry)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(foodName.isEmpty || calories.isEmpty || Int(calories) == nil)
            }
        }
    }
}
