//
//  ChartView.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/25/23.
//

import SwiftUI
import Charts


struct ChartView: View {
    //@ObservedObject var photoModel : PhotoModel
    @ObservedObject var photoModel23 : PhotoModel23
    
    @State var SelectedMonth = ""
    
    var body: some View {
        
        let photoList = photoModel23.fPhotosModel.GetPhotolist().fPhotoList
        let filterList = photoModel23.fPhotoFilterList
        
        let chartData = filterList.getChartData_month(inputList: photoList)
        
        let monthWithMax = chartData.max(by: { $0.numPhotos < $1.numPhotos })
        
        VStack()
        {
            
            
            Chart {
                
                ForEach(chartData) { datum in
                    
                    BarMark(x: .value("num photos", datum.numPhotos),
                            y: .value("month", datum.month),
                            width: 20
                    )
                    
                    
                    
                    .cornerRadius(20, style: .continuous)
                    .annotation(position: .overlay, alignment: .trailing) {
                        Text("\(datum.numPhotos)")
                            .font(.system(size:12))
                            .fontWeight(.light)  // Makes the text bold
                            .foregroundColor(.gray)  // Changes the text color to blue
                        //.background(.black)
                    }
                    .foregroundStyle(SelectedMonth == datum.month ? .green : .blue)
                    
                    
                    
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
            
            
            /*
             var hasMax = (monthWithMax != nil)
             //let grade = score >= 90 ? "A" : score >= 80 ? "B" : "C"
             
             var correctDomain = monthWithMax != nil ? ScaleDomain(-2...monthWithMax?.numPhotos) : ScaleDomain(-2...100)
             */
            .chartXScale(domain: -100...monthWithMax!.numPhotos+100)
            .chartXAxis(.hidden)
            
            
            /*
             .chartYAxisLabel(position: .top, alignment: .center) {
             Text("Position (meters)")
             
             }
             */
            
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
        }
    }
}

/*
#Preview {
    var test_photoModel = PhotoModel23()

    test_photoModel.fPhotosModel.loadCityDatabase()
    test_photoModel.fPhotosModel.loadTestingData()
    
    ChartView(photoModel23: test_photoModel)
}
*/
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


       
       ChartView(photoModel23: test_photoModel)
   }
}

