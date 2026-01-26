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
    @State private var gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"
    @State private var currentWordIndex = 0 // index in wordsToGuess
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var letterGuessed = ""
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @FocusState private var textFieldIsFocused: Bool
    
    private let wordsToGuess = ["UBIQUITOUS", "DOG", "CAT"] // All Caps
    
    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .leading) {
                    Text("Word Guessed: \(wordsGuessed)")
                    Text("Word Missed: \(wordsMissed)")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Words to Guess: \(wordsToGuess.count - (wordsGuessed + wordsMissed))")
                    Text("Word in Game: \(wordsToGuess.count)")
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            //TODO: Switch to wordsTo Guessed[currentWordIndex]
            Text(revealedWord)
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
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: guessedLetter) {
                            guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted)
                            guard let lastChar = guessedLetter.last else{
                                return
                            }
                            guessedLetter = String(lastChar).uppercased()
                        }
                        .focused($textFieldIsFocused)
                        .onSubmit {
                            // as long as guessedLetter is not an empty string we can continue, otherwise dont do anything
                            guard guessedLetter != "" else {
                                return
                            }
                            guessedALetter()
                        }
                    
                    Button("Guess a Letter:"){
                        guessedALetter()
                    }
                    
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)
                }
            } else {
                Button("Another Word?"){
                //TODO: Another Word Button Action Here
            }
            .buttonStyle(.borderedProminent)
            .tint(.mint)
                
            }
            
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear{
            wordToGuess = wordsToGuess[currentWordIndex]
            revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
        }
    }
    func guessedALetter() {
        textFieldIsFocused = false
        letterGuessed = letterGuessed + guessedLetter
        revealedWord = wordToGuess.map { letter in letterGuessed.contains(letter) ? "\(letter)" : "_"
            
        }.joined(separator: "  ")
        guessedLetter = ""
    }
}

#Preview {
    ContentView()
}
