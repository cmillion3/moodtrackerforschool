//
//  ContentView.swift
//  MoodTracka
//
//  Created by YA GIRL on 9/8/24.
//

import SwiftUI

struct MoodTrackerView: View {
    @State private var moods: [MoodEntry] = []
    @State private var showingAddMood = false

    var body: some View {
        NavigationView {
            
            ZStack {
                Color.mint.opacity(0.2) // Light orange background
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if moods.isEmpty {
                        Text("Press the button to add an entry")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List {
                            ForEach(moods) { mood in // Setup for loop to grab mood entry values
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(mood.mood) // grab emoji value
                                            .font(.largeTitle)
                                        VStack(alignment: .leading) {
                                            Text(mood.notes) // grab notes if any
                                                .font(.body)
                                            HStack {
                                                Text(mood.date, style: .date) + Text(" ") + Text(mood.date, style: .time) // Display date & time at time of creation!
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            HStack {
                                                Text("Hobbies:")
                                                    .font(.subheadline)
                                                    .bold()
                                                ForEach(mood.hobbies, id: \.self) { hobby in
                                                    Text(hobby)
                                                        .font(.title2)
                                                }
                                            }
                                        }
                                    }
                                    
                                    // AI Button
                                    NavigationLink(destination: MoodFeedbackView(moodEntry: .constant(mood))) {
                                        Text("Therapist feedback✨")
                                            .foregroundColor(.blue)
                                            .padding(.top, 4)
                                    }
                                }
                            }
                            .onDelete(perform: deleteMood)
                        }
                    }
                    Button(action: {
                        showingAddMood = true
                    }) {
                        Text("Add Mood")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .navigationTitle("MOOD TRACKER")
                .toolbar {
                    EditButton()
                }
                .sheet(isPresented: $showingAddMood) {
                    AddMoodView(moods: $moods)
                }
                .onAppear(perform: loadMoods)
            }
        }
    }

    func deleteMood(at offsets: IndexSet) {
        moods.remove(atOffsets: offsets)
        saveMoods()
    }

    func loadMoods() {
        if let savedMoods = UserDefaults.standard.data(forKey: "Moods"),
           let decodedMoods = try? JSONDecoder().decode([MoodEntry].self, from: savedMoods) {
            moods = decodedMoods
        }
    }

    func saveMoods() {
        if let encoded = try? JSONEncoder().encode(moods) {
            UserDefaults.standard.set(encoded, forKey: "Moods")
        }
    }
}





#Preview {
    MoodTrackerView()
}
