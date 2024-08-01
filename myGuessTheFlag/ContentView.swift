//
//  ContentView.swift
//  myGuessTheFlag
//
//  Created by Víctor Ávila on 04/12/23.
//

import SwiftUI

struct ContentView: View {
    // Array of flag names and Integer storing which country has the correct flag for this round of the game
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var selectedCountry = ""
    @State private var questionsAsked = 0
    @State private var showingGameOver = false
    
    // VoiceOver/Accessibility notes
    // SwiftUI VoiceOver's default behaviour is to read out the name of each image as its labels, destroying the gameplay
    // To fix this, we will add descriptions to each flag with just enough detail they can be guessed correctly by someone (without the name of the country)
    // Making a dictionary with all the countries as keys and all labels as the values
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe is gold with crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    var body: some View {
        // Two labels telling the user what to do,
        // And three images telling the user the world flags
        // Their names are in a pattern Xcode is able to handle
        // Since iPhone 4, all images have been 2x or greater
        // 1x is the original iPhone
        
        ZStack {
            // Adding a background
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) { // This is the spacing between views
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary) // Using iOS Vibrancy to let the blue color shining
                            .font(.subheadline.weight(.heavy)) // The size is adjusted based on the environment variable Dynamic Type (depending on User Preferences)
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    // Adding a second VStack to have more control over spacing
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                            // There are 4 shapes in SwiftUI
                            // Capsule keeps the longest edge and rounds the shortest edge
                                .clipShape(.capsule)
                            // We will use a shadow the stand up the flag against the background
                                .shadow(radius: 5)
                        }
                        // Accessibility Label for the Button
                        // Looking up the name of the country and use that name as the key in our labels array
                        // If the key is missing, provide a default string (this is mandatory)
                        .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if scoreTitle == "Wrong" {
                Text("Wrong! That's the flag of \(selectedCountry). \nYour score is \(score).")
            }
            Text("Your score is \(score).")
        }
        
        .alert("Game Over", isPresented: $showingGameOver) {
            Button("Restart game", action: reset)
        } message: {
            if score >= 4 {
                Text("You did \(score) points! Nice job 😎")
            } else {
                Text("You only did \(score) points. Bummer 😭")
            }
        }
    }
    
    // Checking if the flag selected is the correct
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
            score -= 1
        }
        selectedCountry = countries[number]
        showingScore = true
    }
    
    // This reshuffles the array and picks a new correctAnswer property
    func askQuestion() {
        questionsAsked += 1
        
        if questionsAsked == 8 {
            showingGameOver = true
            return
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    // This restarts the game
    func reset() {
        score = 0
        questionsAsked = 0
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        showingGameOver = false
    }
}

#Preview {
    ContentView()
}
