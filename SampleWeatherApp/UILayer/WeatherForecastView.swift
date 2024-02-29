//
//  ContentView.swift
//  SampleWeatherApp
//
//  Created by Anđela Šćepović on 20.3.23..
//

import SwiftUI

struct WeatherForecastView: View {
    @ObservedObject var viewModel: ViewModel
    
    init(dependencies: WeatherForecastViewModelDependencies){
        viewModel = ViewModel(dependencies: dependencies)
    }
    
    var body: some View {
        Group{
            switch viewModel.viewState{
            case .initial:
                ProgressView()
                    .onAppear{viewModel.loadWeatherdata()}
            case .loading:
                ProgressView()
            case .error:
                Text("Error")
            case .finished:
                prestentationView
            }
            
        }
    }
    
    var prestentationView: some View{
        VStack {
            currentForecastView
                .padding(16)
            Spacer()
            
            hourlyForecastView
            Spacer()
            
            weeklyForecastView
        }
        .padding()
    }
    
    var currentForecastView: some View{
        HStack{
            Image(systemName: "plus")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(.white)
            Spacer()
            
            Text("Malang")
                .font(.system(size: 30, weight: .bold))
            Spacer()
            
            Image(systemName: "ellipsis")
                .resizable()
                .frame(width: 30, height: 6)
                .rotationEffect(.degrees(90))
            
        }
    }
    
    var hourlyForecastView: some View{
        Text("Hourly forecast")
    }
    
    var weeklyForecastView: some View{
        Text("Forecast for 7 days")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView(dependencies: <#WeatherForecastViewModelDependencies#>)
    }
}


protocol WeatherForecastViewModelDependencies{
    var currentWeatherUseCase: CurrentWeatherUseCase { get }
}


extension WeatherForecastView{
    final class ViewModel:  ObservableObject{
        let dependencies: WeatherForecastViewModelDependencies
        @Published var viewState: ViewState = .initial
        
        init(dependencies: WeatherForecastViewModelDependencies){
            self.dependencies = dependencies
        }
        
        enum ViewState{
            case initial
            case loading
            case error
            case finished
        }
        
        func loadWeatherdata(){
            viewState = .loading
            
            dependencies.currentWeatherUseCase.fetchCurrentWeather()
        }
    }
}

