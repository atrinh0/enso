//
//  ContentView.swift
//  enso
//
//  Created by An Trinh on 24/06/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var isPaused = true
    @State private var isEnded = true
    @State private var progress: Double = 1
    @State private var isFocused = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color(white: isFocused ? 0 : 0.95)
            VStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        progress = 1
                        isFocused = false
                        isPaused = false
                        isEnded = true
                    }
                }, label: {
                    Image(systemName: "stop.circle.fill")
                        .font(Font.system(size: 44))
                        .opacity(isPaused && !isEnded ? 1 : 0)
                        .scaleEffect(!isPaused ? 0.01 : 1)
                        .animation(!isPaused ? .default : Animation.spring(response: 0.35, dampingFraction: 0.35, blendDuration: 1).delay(0.175))
                })
                Spacer()
                ZStack {
                    Image(isFocused ? "ensow" : "ensob")
                        .resizable()
                        .opacity(0.1)
                    Image("bonsai")
                        .resizable()
                        .opacity(isFocused ? 0 : 1)
                    Image(isFocused ? "ensow" : "ensob")
                        .resizable()
                        .mask(Circle()
                                .trim(from: 0, to: CGFloat(progress))
                                .stroke(Color.black, lineWidth: 300)
                                .rotationEffect(Angle(degrees: 270.0)))
                }
                .frame(width: 300, height: 300, alignment: .center)
                Spacer()
                Button(action: {
                    withAnimation {
                        if isEnded {
                            progress = 0
                            isFocused = true
                            isPaused = false
                            isEnded = false
                        } else {
                            isPaused = false
                        }
                    }
                }, label: {
                    Image(systemName: "play.circle.fill")
                        .font(Font.system(size: 44))
                        .opacity((isPaused || isEnded) ? 1 : 0)
                        .scaleEffect(!(isPaused || isEnded) ? 0.01 : 1)
                        .animation(!(isPaused || isEnded) ? .default : Animation.spring(response: 0.35, dampingFraction: 0.35, blendDuration: 1))
                })
                Spacer()
            }
        }
        .onTapGesture {
            withAnimation {
                isPaused = true
            }
        }
        .onReceive(timer) { _ in
            withAnimation {
                if !isPaused {
                    progress += 0.1
                    if progress > 1 {
                        if isFocused {
                            isFocused = false
                            progress = 0
                        } else {
                            isEnded = true
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
