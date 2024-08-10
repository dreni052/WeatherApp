//
//  ContentView.swift
//  WeatherApp
//
//  Created by Dren Uruqi on 9.8.24.
//

import SwiftUI
import SDWebImageSwiftUI

struct WeatherView: View {
    @StateObject var viewModal = WeatherViewModel()
    @State private var searchBtn: Bool = false
    @State private var cityTxtLabel: String = ""
    @State private var defaultSymbol = "https://www.google.com/search?q=weather+symbol&sca_esv=67842c87415e33f5&sca_upv=1&udm=2&biw=1440&bih=710&ei=Ldi3ZoLIBcKTxc8PuK-yiQU&ved=0ahUKEwjCktjyq-uHAxXCSfEDHbiXLFEQ4dUDCBA&uact=5&oq=weather+symbol&gs_lp=Egxnd3Mtd2l6LXNlcnAiDndlYXRoZXIgc3ltYm9sMggQABiABBixAzIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABEjpG1DPBFjXGHADeACQAQCYAW-gAb4KqgEDNy43uAEDyAEA-AEBmAIRoAL5CsICChAAGIAEGEMYigXCAgsQABiABBixAxiDAcICDhAAGIAEGLEDGIMBGIoFmAMAiAYBkgcDOS44oAeYRg&sclient=gws-wiz-serp#vhid=h0BKTsfhNu49AM&vssid=mosaic"
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                TextField("City Name", text: $cityTxtLabel)
                    .frame(width: 280, height: 30, alignment: .center)
                    .border(Color.black, width: 2)
                Button("Search") {
                    searchBtn.toggle()
                }
                .frame(width: 70, height: 30)
                .foregroundColor(Color.black)
                .background(Color.blue.opacity(0.7))
            } .padding(.vertical)
            HStack {
                Text(viewModal.weatherData?.location.name ?? "City")
                    .frame(width: 100, height: 35)
                    .foregroundColor(.black)
                Text(viewModal.weatherData?.location.country ?? "Country")
                    .frame(width: 100, height: 35)
                    .foregroundColor(.black)
                Text(viewModal.weatherData?.location.localtime ?? "TimeLine")
                    .frame(width: 100, height: 35)
                    .foregroundColor(.black)
            } .padding(.vertical, 20)
            HStack {
                Text("\(viewModal.weatherData?.current.tempC ?? 0.0)")
                    .frame(width: 100, height: 35)
                    .foregroundColor(.black)
                Text("\(viewModal.weatherData?.current.windKph ?? 0.0)")
                    .frame(width: 100, height: 35)
                    .foregroundColor(.black)
                Text(viewModal.weatherData?.current.condition.text ?? "Condition")
                    .frame(width: 100, height: 35)
                    .foregroundColor(.black)
            } .padding(.vertical, 20)
            WebImage(url: URL(string: viewModal.weatherData?.current.condition.icon ?? defaultSymbol))
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundColor(.black)
            Text("Hello, world!")
            Spacer()
        }
        .padding()
        .onAppear() {
            viewModal.fetchWeatherData(place: "tirana")
            print(viewModal.weatherData?.current.cloud ?? "!!!")
        }
        .onChange(of: searchBtn) { newValue in
            viewModal.fetchWeatherData(place: cityTxtLabel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
