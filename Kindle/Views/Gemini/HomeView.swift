//
//  HomeView.swift
//  Kindle
//
//  Created by Freddy Morales on 27/02/25.
//

import SwiftUI

struct HomeView: View {
    // state tetxtfield
    @State private var promptText: String = ""
    @State private var navigationDetail: Bool = false
    
    var body: some View {
        
        NavigationStack {
            ZStack (alignment: .bottom){
                // content
                VStack {
                    Text("Welcome ") +
                    Text("bro")
                }
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(
                    LinearGradient(gradient: Gradient(colors: [Color.primaryColor1, Color.primaryColor2, Color.primaryColor3]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                )
                .frame(maxHeight: .infinity)
                //floating button
                FloatingButtonTwoView(prompText: $promptText)
                    .onSubmit {
                        if !promptText.isEmpty {
                            navigationDetail = true
                        }
                    }
            }
            .navigationDestination(isPresented: $navigationDetail) {
                DetailView(text: promptText)
            }
            //title
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                //leading
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    }label: {
                        Image(systemName: "bubble")
                            .foregroundStyle(.black)
                    }
                }
                //trailing
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    }label: {
                        ZStack {
                            Circle()
                                .fill(.blue)
                                .frame(width: 34, height: 34)
                            Text("A")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

