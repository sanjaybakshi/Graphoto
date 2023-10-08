//
//  ChartView.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/25/23.
//

import SwiftUI
import Charts


struct ChartView: View {
    
    //@EnvironmentObject var phModel23: PhotoModel23
    
    @ObservedObject var phModel23 : PhotoModel23
    
    @State var SelectedVal = ""
    
    var body: some View {
        
        //let photoList = phModel23.fPhotosModel.GetPhotolist().fPhotoList
        //let filterList = phModel23.fPhotoFilterList
        
        
        //var chartData : [phChartData]
        
        //let chartType = filterList.fSelectedFilter
        
        //if let chartData = filterList.getChartDataForSelectedFilter(inputList: photoList) {
        
        /*
         switch chartType {
         case phModel23.fPhotoFilterList.fMonthFilterStr :
         chartData = phModel23.fPhotoFilterList.getChartData_month(inputList: phModel23.fPhotosModel.GetPhotolist().fPhotoList)
         case phModel23.fPhotoFilterList.fYearFilterStr :
         chartData = phModel23.fPhotoFilterList.getChartData_year(inputList: phModel23.fPhotosModel.GetPhotolist().fPhotoList)
         default:
         chartData = nil
         }
         */
        
        //let chartData: [phChartData] = filterList.getChartData_month(inputList: photoList)
        //let monthWithMax : phChartData? = chartData.max(by: { $0.numPhotos < $1.numPhotos })
        
        let barWidth : Int = 20
        
        let chartData: [phChartData] = phModel23.fPhotoFilterList.getChartData(chartType: phModel23.fSelectedFilter,
                                                                               inputList: phModel23.fPhotosModel.GetPhotolist().fPhotoList)
        VStack {
            Text(phModel23.fSelectedFilter)
            
            
            Chart {
                ForEach(chartData) { datum in
                    
                    BarMark(x: .value("numValues", datum.numPhotos),
                            y: .value("month", datum.xVal),
                            width: MarkDimension(integerLiteral: barWidth))
                    
                    .cornerRadius(20, style: .continuous)
                    .annotation(position: .overlay, alignment: .trailing) {
                        Text("\(datum.numPhotos)")
                            .font(.system(size:12))
                            .fontWeight(.light)  // Makes the text bold
                            .foregroundColor(.gray)  // Changes the text color to blue
                    }
                    
                    
                    .foregroundStyle(SelectedVal == datum.xVal ? .green : .blue)
                    
                    
                    
                    PointMark(x: .value("na", -0.1),
                              y: .value("na", datum.xVal))
                    .symbolSize(0)
                    
                    
                    .annotation(position: .leading) {
                        Text(datum.xVal)
                            .font(.system(size:12))
                            .fontWeight(.light)  // Makes the text bold
                            .foregroundColor(.gray)  // Changes the text color to blue
                        
                    }
                }
            }
            
            
            
            //.chartXScale(domain: -100...monthWithMax!.numPhotos+100)
            .chartXAxis(.hidden)
            
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic) { value in
                    //AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
                    AxisValueLabel() {
                        if let strValue = value.as(String.self) {
                            //Text("\(strValue) cm")
                            //.font(.system(size: 14))
                        }
                    }
                }
            }
            
            .frame(height: CGFloat(barWidth+10) * CGFloat(chartData.count)) // << HERE
            
            
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .onTapGesture { location in
                            
                            SelectedVal = ""
                            if let (numPhotos, v) = proxy.value(at: location, as: (Int,String).self) {
                                
                                if let selData = chartData.first(where: { $0.xVal == v}) {
                                    
                                    //if (numPhotos > -1 && numPhotos < monthData.numPhotos ) {
                                    SelectedVal = v
                                    
                                    //}
                                }
                            }
                        }
                }
            }
        }
    }
}

             
            /*
             Chart {
             
             ForEach(chartData) { datum in
             
             BarMark(x: .value("numValues", datum.numPhotos),
             y: .value("month", datum.xVal),
             width: 20)
             */
            
            /*                BarMark(x: .value("num photos", datum.numPhotos),
             y: .value("month", datum.xVal),
             width: 20)
             
             
             
             .cornerRadius(20, style: .continuous)
             .annotation(position: .overlay, alignment: .trailing) {
             Text("\(datum.numPhotos)")
             .font(.system(size:12))
             .fontWeight(.light)  // Makes the text bold
             .foregroundColor(.gray)  // Changes the text color to blue
             //.background(.black)
             
             //.foregroundStyle(SelectedMonth == datum.xVal ? .green : .blue)
             
             
             
             PointMark(x: .value("na", -0.1),
             y: .value("na", datum.month))
             .symbolSize(0)
             
             .annotation (position: .leading) {
             Text(datum.month)
             .font(.system(size:12))
             .fontWeight(.light)  // Makes the text bold
             .foregroundColor(.gray)  // Changes the text color to blue
             
             }
             
             
             }
             }
             
             
             //.chartXScale(domain: -100...monthWithMax!.numPhotos+100)
             .chartXAxis(.hidden)
             
             .chartYAxis {
             AxisMarks(position: .leading, values: .automatic) { value in
             //AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
             AxisValueLabel() {
             if let strValue = value.as(String.self) {
             //Text("\(strValue) cm")
             //.font(.system(size: 14))
             }
             }
             }
             }
             
             .frame(height: 400) // << HERE
             
             
             .chartOverlay { proxy in
             GeometryReader { geometry in
             Rectangle().fill(.clear).contentShape(Rectangle())
             
             
             .onTapGesture { location in
             
             SelectedMonth = ""
             if let (numPhotos,month) = proxy.value(at: location, as: (Int,String).self) {
             
             if let monthData = chartData.first(where: { $0.month == month}) {
             
             //if (numPhotos > -1 && numPhotos < monthData.numPhotos ) {
             SelectedMonth = month
             
             //}
             }
             }
             }
             
             }
             }
             */


/*
#Preview {
    var test_photoModel = PhotoModel23()

    test_photoModel.fPhotosModel.loadCityDatabase()
    test_photoModel.fPhotosModel.loadTestingData()
    
    ChartView(photoModel23: test_photoModel)
}
*/


/*
struct LoginView_Previews: PreviewProvider {
   static var previews: some View {
       
       var test_photoModel: PhotoModel23 = {
           let model = PhotoModel23()
           model.fPhotosModel.loadCityDatabase()
           model.fPhotosModel.loadTestingData()
           return model
       }()

       
       //static var test_photoModel = PhotoModel23()

        //test_photoModel.fPhotosModel.loadCityDatabase()
           //test_photoModel.fPhotosModel.loadTestingData()


       
      // ChartView(photoModel23: test_photoModel, fPhotoFilterList: <#T##TphotoFilterList#>
   }
}

*/
