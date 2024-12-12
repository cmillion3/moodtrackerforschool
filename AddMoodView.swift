//
//  AddMoodView.swift
//  MoodTracka
//
//  Created by Cameron Banks on 9/8/24.
//

import SwiftUI

struct AddMoodView: View {
    @Binding var moods: [MoodEntry]
    @State private var selectedMood = "😊" // Default emoji
    @State private var notes = ""
    @State private var selectedHobbies: Set<String> = []
    @Environment(\.dismiss) var dismiss

    // Mood choices represented by emojis
    let moodOptions = ["😁", "😊", "😐", "☹️", "😭"]
    
    // Hobby choices represented by emojis
    let hobbyOptions = [
        "💪": "Exercise",
        "📺": "TV",
        "🎮": "Gaming",
        "📚": "Reading",
        "🚶‍♂️": "Walking",
        "🎵": "Music",
        "🎨": "Art"
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("How are you feeling?")) {
                        Picker("Mood", selection: $selectedMood) {
                            ForEach(moodOptions, id: \.self) { mood in
                                Text(mood).font(.largeTitle)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Notes about your day")) {
                        TextField("Enter notes", text: $notes)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Section(header: Text("Select Hobbies")) {
                        ForEach(hobbyOptions.keys.sorted(), id: \.self) { emoji in
                            MultipleSelectionRow(emoji: emoji, description: hobbyOptions[emoji]!, isSelected: selectedHobbies.contains(emoji)) {
                                if selectedHobbies.contains(emoji) {
                                    selectedHobbies.remove(emoji)
                                } else {
                                    selectedHobbies.insert(emoji)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("New Mood")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            let newMood = MoodEntry(
                                mood: selectedMood,
                                notes: notes,
                                date: Date(),
                                hobbies: Array(selectedHobbies) // Convert Set to Array
                            )
                            moods.append(newMood)
                            saveMoods()
                            dismiss()
                        }
                        .disabled(notes.isEmpty) // Disable save if no notes are added
                    }
                }
            }
        }
    }
    
    func saveMoods() {
        if let encoded = try? JSONEncoder().encode(moods) {
            UserDefaults.standard.set(encoded, forKey: "Moods")
        }
    }
}

struct MultipleSelectionRow: View {
    let emoji: String
    let description: String
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        HStack {
            Text(emoji)
                .font(.largeTitle) // Adjust font size as needed
                .frame(width: 40, height: 40) // Set a fixed size for better alignment
            VStack(alignment: .leading) {
                Text(description)
                    .font(.title2)
                    .padding(.leading, 8)
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}



#Preview {
    MoodTrackerView()
}
