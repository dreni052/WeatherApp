//
//  ContentView.swift
//  WeatherApp
//
//  Created by Dren Uruqi on 9.8.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModal = WeatherViewModel()
    @State private var cityTxtLabel: String = ""
    
    var body: some View {
        VStack {
            TextField("City Name", text: $cityTxtLabel)
                .background(Color.gray)
                .frame(width: 300, height: 135, alignment: .center)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear() {
            viewModal.fetchWeatherData(place: "tirana")
            print(viewModal.weatherData?.current.cloud ?? "!!!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
