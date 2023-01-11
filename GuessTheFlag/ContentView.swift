//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ruben Granet on 27/11/2022.
//

import SwiftUI

struct FlagImage : View {
    var flag : Image
    @State private var amountRotation = 0.0
    
    
    var body: some View{
        flag
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
            .rotation3DEffect(.degrees(amountRotation), axis: (x: 0, y: 1, z: 0))
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var endGame = false
    @State private var numberOfQuestion = 0
    @State private var amountRotation = 0.0
    
    var body: some View {
        ZStack {
            //            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
            RadialGradient(stops: [.init(color:Color(red: 0.1, green: 0.2, blue: 0.5), location: 0.3),
                                   .init(color:Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Fun with Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    
                    VStack{
                        
                        Text("Tap the flag of ")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                        
                    }
                    
                    ForEach(0..<3) {number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(flag: Image(countries[number]))
                                .accessibilityLabel(labels[countries[number]] ?? "Unknown Flag")
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score : \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
                
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert(scoreTitle, isPresented: $endGame) {
            Button("Reset the game", action: reset)
        } message: {
            Text("Your score is \(score) / \(numberOfQuestion + 1)")
        }
    }
    
    func flagTapped(_ number: Int) {
        let maxQuestions = 7
        switch numberOfQuestion {
        case maxQuestions: endGame = true
            scoreTitle = "This is the end of the game"
            
        default:  if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            numberOfQuestion += 1
        } else {
            scoreTitle = "Wrong! \nThis is the flag of \(countries[number])"
            numberOfQuestion += 1
        }
            showingScore = true
        }
        
    }
    
    func askQuestion() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        countries = countries.shuffled()
        endGame = false
        numberOfQuestion = 0
        score = 0
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
