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
    
    var body: some View {
        
        let photoList = photoModel23.fPhotosModel.GetPhotolist().fPhotoList
        let filterList = photoModel23.fPhotoFilterList
        
        let chartData = filterList.getChartData_month(inputList: photoList)
         

        Chart {
            
            ForEach(chartData) { datum in
 
                BarMark(x: .value("year", datum.month),
                        y: .value("num photos", datum.numPhotos))

            }
        }
        .chartXAxis(content: {
            AxisMarks { value in
                AxisValueLabel {
                    if let month = value.as(String.self) {
                        Text(month)
                            .rotationEffect(Angle(degrees: 60))
                    }
                }
            }
        })
        Chart {
            
            ForEach(chartData) { datum in
 
                BarMark(x: .value("num photos", datum.numPhotos),
                        y: .value("year", datum.month))

            }
            .cornerRadius(10)

        }
        .chartYAxis(content: {
            AxisMarks { value in
                AxisValueLabel {
                    if let month = value.as(String.self) {
                        Text(month)
                            .rotationEffect(Angle(degrees: 60))
                    }
                }
            }
        })






        

        /*
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks(position: .leading, values: chartData.map{$0.month}) { data in
                AxisValueLabel(format: .dateTime.month(), centered: true)
            }
        }
        .chartXScale(domain: 0...9000)
*/

        
        /*
         Chart {
         
         
         ForEach(photoModel.fDevicesList.keys.sorted(), id: \.self) { key in
         
         BarMark(x: PlottableValue.value("wtfo", key),
         y: PlottableValue.value("crewSize", photoModel.fDevicesList[key]!))
         }
         
         
         }
         
         Chart {
         
         ForEach(photoModel.fDevicesListHC) { datum in
         
         BarMark(x: PlottableValue.value("device", datum.deviceName),
         y: PlottableValue.value("crewSize", datum.deviceCount))
         }
         }
         
         
         Chart {
         
         
         ForEach(photoModel.fDevicesListHC_dict.keys.sorted(), id: \.self) { key in
         BarMark(x: PlottableValue.value("device", key),
         y: PlottableValue.value("crewSize", photoModel.fDevicesListHC_dict[key]!))
         }
         
         
         }
         Text("Number of items: \(photoModel.fDevicesListHC_dict["iphone10"]!)")
         */
    }
}
