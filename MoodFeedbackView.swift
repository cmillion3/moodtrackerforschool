//
//  MoodFeedbackView.swift
//  MoodTracka
//
//  Created by Cameron Banks on 9/12/24.
//


import SwiftUI
import Combine

let exampleMoodEntry = MoodEntry( //example mood that will be sent
    mood: "😂",
    notes: "Had a great day, went for a walk and read a new book.",
    date: Date(),
    hobbies: ["🚶‍♂️", "📚"]
)


struct MoodFeedbackView: View {
    @Binding var moodEntry: MoodEntry
    @State private var feedbackMessage = "Fetching feedback..."
    
    var body: some View {
        VStack {
            Text("Your Mood: \(moodEntry.mood)")
                .font(.largeTitle)
            Text("Notes: \(moodEntry.notes)")
                .padding()
            Text(feedbackMessage)
                .font(.title3)
                .padding()
            
            Button("Get Feedback") {
                fetchMoodFeedback(mood: moodEntry.mood, notes: moodEntry.notes)
            }
        }
        .onAppear {
            fetchMoodFeedback(mood: moodEntry.mood, notes: moodEntry.notes)
        }
    }
    
    func fetchMoodFeedback(mood: String, notes: String) {
        let openaiAPIKey = "enter openai key here!"
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        // Setup request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openaiAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create prompt
        let prompt = "Given the mood \(mood) and the notes: \(notes), give personalized feedback."
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": prompt]
            ]
        ]
        
        // Encode request body as JSON
        let requestData = try! JSONSerialization.data(withJSONObject: requestBody, options: [])
        request.httpBody = requestData
        
        // Send API request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    feedbackMessage = "Failed to fetch feedback."
                }
                return
            }
            
            if let responseData = try? JSONDecoder().decode(OpenAIResponse.self, from: data) {
                DispatchQueue.main.async {
                    feedbackMessage = responseData.choices.first?.message.content ?? "No feedback available."
                }
            } else {
                DispatchQueue.main.async {
                    feedbackMessage = "Failed to parse feedback."
                }
            }
        }.resume()
    }
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let content: String
}

#Preview {
    MoodFeedbackView(moodEntry: .constant(exampleMoodEntry))
}
