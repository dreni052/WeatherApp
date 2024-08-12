//
//  ContentView.swift
//  WeatherApp
//
//  Created by Dren Uruqi on 9.8.24.
//

import SwiftUI
import SDWebImageSwiftUI

struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    @StateObject var userLocationVm = UserLocalisationVm()
    @State private var searchButton: Bool = false
    @State private var cityTxtLabel: String = ""
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                TextField("City Name", text: $cityTxtLabel)
                    .frame(width: 250, height: 30, alignment: .center)
                    .border(Color.black, width: 2)
                Button("Get Weather") {
                    searchButton.toggle()
                }
                .frame(width: 110, height: 30)
                .foregroundColor(Color.black)
                .background(Color.blue.opacity(0.7))
            } .padding(.vertical)
            HStack(spacing: 35) {
                Text(viewModel.weatherData?.location.name ?? "City")
                    .frame(width: 150)
                    .foregroundColor(.black)
                    .font(.bold(.headline)())
                Text(viewModel.weatherData?.location.country ?? "Country")
                    .frame(width: 150)
                    .foregroundColor(.black)
                    .font(.bold(.headline)())
            } .padding(.vertical, 20)
            HStack(alignment: .center, spacing: 20) {
                Text("""
                    Local Time:
                    \(viewModel.weatherData?.location.localtime ?? "No data")
                    """)
                    .frame(width: 150)
                    .foregroundColor(.black)
                    .font(.bold(.headline)())
                Text("""
                    Last time updated:
                    \(viewModel.weatherData?.current.lastUpdated ?? "No data")
                    """)
                    .frame(width: 150)
                    .foregroundColor(.black)
                    .font(.bold(.headline)())
            } .padding(.vertical, 20)
            HStack(spacing: 30) {
                Text("""
                Temperature
                \(String(format: "%.2f", viewModel.weatherData?.current.tempC ?? 0.0))
                """)
                    .frame(width: 150)
                    .foregroundColor(.black)
                    .font(.bold(.headline)())
                Text("""
                Wind speed
                \(String(format: "%.2f", viewModel.weatherData?.current.windKph ?? 0.0))
                """)
                    .frame(width: 150)
                    .foregroundColor(.black)
                    .font(.bold(.headline)())
            } .padding(.vertical, 20)
            Text(viewModel.weatherData?.current.condition.text ?? "NoCondition")
                .frame(width: 100)
                .foregroundColor(.black)
                .font(.bold(.headline)())
                .padding(.vertical, 20)
            WebImage(url: URL(string: "https:" + (viewModel.weatherData?.current.condition.icon ?? "")))
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundColor(.black)
            Spacer()
        }
        .padding()
        .onAppear() {
            viewModel.fetchWeatherData(place: userLocationVm.currentCity)
            print(userLocationVm.currentCity)
        }
        .onChange(of: searchButton) { newValue in
            viewModel.fetchWeatherData(place: cityTxtLabel)
        }
        .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
            Button {
                viewModel.fetchWeatherData(place: userLocationVm.currentCity)
            } label: {
                Text("retry")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
