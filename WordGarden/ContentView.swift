//  Created by BELLO, KEVIN on 1/13/26.
import SwiftUI
import AVFAudio

struct ContentView: View {
    
    private static let maximumGuesses = 8 // need to refer this as self.maximumGuesses
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"
    @State private var currentWordIndex = 0 // index in wordsToGuess
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var letterGuessed = ""
    @State private var guessesRemaining = maximumGuesses
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @State private var playAgainButtonLabel = "another word?"
    @State private var audioPlayer: AVAudioPlayer!
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
                .frame(height: 80)
                .minimumScaleFactor(0.5)
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
                            updateGamePlay()
                        }
                    
                    Button("Guess a Letter:"){
                        guessedALetter()
                        updateGamePlay()
                    }
                    
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)
                }
            } else {
                Button(playAgainButtonLabel) {
                    // if all of the words have been guessed...
                    if currentWordIndex == wordsToGuess.count {
                        currentWordIndex = 0
                        wordsGuessed = 0
                        wordsMissed = 0
                        playAgainButtonLabel = "Another Word?"
                    }
                    
                // reset after a word was guessed or missed
                    
                    wordToGuess = wordsToGuess[currentWordIndex]
                    revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
                    letterGuessed = ""
                    guessesRemaining = Self.maximumGuesses // because maximumGuesses is static
                    imageName = "flower\(guessesRemaining)"
                    gameStatusMessage = "how many guesses to uncover the hidden word?"
                    playAgainHidden = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.mint)
                
            }
            
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .animation(.easeIn(duration: 0.75), value: imageName)
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear{
            wordToGuess = wordsToGuess[currentWordIndex]
            // CREATE A STRING FROM A REPEATING VALUE
            revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
        }
    }
    func guessedALetter() {
        textFieldIsFocused = false
        letterGuessed = letterGuessed + guessedLetter
        revealedWord = wordToGuess.map { letter in letterGuessed.contains(letter) ? "\(letter)" : "_"
        }.joined(separator: "  ")
    }
    
    func updateGamePlay() {
        if !wordToGuess.contains(guessedLetter) {
            guessesRemaining -= 1
            // animate crumbilng leaf and play the incorrect sound
            imageName = "wilt\(guessesRemaining)"
            playSound(soundName: "incorrect")
            // delay change to flower image until after wilt animation is done
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                imageName = "flower\(guessesRemaining)"
            }
        } else {
            playSound(soundName: "correct")
        }
        
        // when do we play another word?
        if !revealedWord.contains("_") { // guessed when no "_" in revealedWord
            gameStatusMessage = "You Guessed it! it took you \(letterGuessed.count) Guesses to guess the word."
            wordsGuessed += 1
            currentWordIndex += 1
            playAgainHidden = false
            playSound(soundName: "word-guessed")
        } else if guessesRemaining == 0 { // words missed
            gameStatusMessage = "so sorry, you're all out of guesses"
            wordsMissed += 1
            currentWordIndex += 1
            playAgainHidden = false
            playSound(soundName: "word-not-guessed")
        } else { // keep guessing
            //TODO: Redo this with LocaizedStringKey & Inflect
            gameStatusMessage = "You've Made \(letterGuessed.count) Guess\(letterGuessed.count == 1 ? "" : "es")"
        }
        
        if currentWordIndex == wordsToGuess.count {
            playAgainButtonLabel = "Restart Game?"
            gameStatusMessage = gameStatusMessage + "\nYou've tried all of the words. restart from the beginning?"
        }
        
        guessedLetter = ""
    }
    func playSound(soundName: String) {
        if audioPlayer != nil && audioPlayer.isPlaying {
    audioPlayer.stop()
}
guard let soundFile = NSDataAsset(name: soundName) else {
    print("😡 could not read file named \(soundName)")
    return
    
}
do {
    audioPlayer = try AVAudioPlayer(data: soundFile.data)
    audioPlayer.play()
} catch {
    print("😡 Error: \(error.localizedDescription)creating audioPlayer")
    }
}

}

#Preview {
    ContentView()
}
