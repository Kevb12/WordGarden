//
//  ContentView.swift
//  WordGarden
//
//  Created by BELLO, KEVIN on 1/13/26.
//

import SwiftUI

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var wordsToGuessed = ["SIFT", "DOG", "CAT"] // All Caps
    @State private var gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"
    @State private var currentWord = 0 // index in wordsToGuess
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    
    
    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .leading) {
                    Text("Word Guessed: \(wordsGuessed)")
                    Text("Word Missed: \(wordsMissed)")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Words to Guess: \(wordsToGuessed.count - (wordsGuessed + wordsMissed))")
                    Text("Word in Game: \(wordsToGuessed.count)")
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            //TODO: Switch to wordsTo Guessed
            Text("_ _ _ _ _")
                .font(.title)
            
            if playAgainHidden {
                
                HStack {
                    TextField("", text: $guessedLetter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                    
                    Button("Guess a Letter:"){
                        //TODO: Huess a Letter button action here
                        playAgainHidden = false
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                }
            } else {
                Button("Another Word?"){
                //TODO: Another Word Button Action Here
                    playAgainHidden = true
                    
            }
            .buttonStyle(.borderedProminent)
            .tint(.mint)
                
            }
            
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
