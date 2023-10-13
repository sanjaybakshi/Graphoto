//
//  PhotoGraph_ChartView.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/25/23.
//

import SwiftUI
import Charts


struct PhotoGraph_ChartView: View {
    
    @EnvironmentObject var myStateData : MyStateData
    @State var SelectedLabel = ""
    
    //@Binding var chartData : [TchartDatas]
    
    var body: some View {
        
        let barWidth : Int = 20
        
        
        VStack {
            Text(myStateData.fSelectedFilter)
            Text("\(myStateData.fChartData.count)")
            
            Chart {
                ForEach(myStateData.fChartData) {datum in
                    //PointMark(x: .value("shit", datum.fLabel), y: .value("sandwich", datum.fValue))
                    
                    BarMark(x: .value("numValues", datum.fValue),
                            y: .value("month",     datum.fLabel),
                            width: MarkDimension(integerLiteral: barWidth))
                    
                    .cornerRadius(20, style: .continuous)
                    
                    .annotation(position: .overlay, alignment: .trailing) {
                        Text("\(datum.fValue)")
                            .font(.system(size:12))
                            .fontWeight(.light)  // Makes the text bold
                            .foregroundColor(.gray)  // Changes the text color to blue
                    }
                    
                    .foregroundStyle(SelectedLabel == datum.fLabel ? .green : .blue)
                    
                    
                    PointMark(x: .value("na", -0.1),
                              y: .value("na", datum.fLabel))
                    .symbolSize(0)

                    
                    .annotation(position: .leading) {
                        Text(datum.fLabel)
                            .font(.system(size:12))
                            .fontWeight(.light)  // Makes the text bold
                            .foregroundColor(.gray)  // Changes the text color to blue
                        
                    }
                    
                }
            }

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
            
            .frame(height: CGFloat(barWidth+10) * CGFloat(myStateData.fChartData.count)) // << HERE
            
            
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .onTapGesture { location in
                            
                            SelectedLabel = ""
                            if let (numPhotos, v) = proxy.value(at: location, as: (Int,String).self) {
                                
                                if let selData = myStateData.fChartData.first(where: { $0.fLabel == v}) {
                                    
                                    //if (numPhotos > -1 && numPhotos < monthData.numPhotos ) {
                                    SelectedLabel = v
                                    
                                    //}
                                }
                            }
                        }
                }
            }
        }
    }
}
                    
                    //.foregroundStyle(SelectedLabel == datum.fLabel ? .green : .blue)
                    
                    
                    /*
                    PointMark(x: .value("na", -0.1),
                              y: .value("na", datum.label))
                    .symbolSize(0)
                    
                    
                    .annotation(position: .leading) {
                        Text(datum.label)
                            .font(.system(size:12))
                            .fontWeight(.light)  // Makes the text bold
                            .foregroundColor(.gray)  // Changes the text color to blue
                        
                    }
                }
            }
                     */
            /*
             Chart {
             ForEach(chartData) { datum in
             
             let x = datum.fValue
             let y = datum.fLabel
             
             
             
             BarMark(x: .value("numValues", x),
             y: .value("month", y),
             width: MarkDimension(integerLiteral: barWidth))
             
             .cornerRadius(20, style: .continuous)
             
             .annotation(position: .overlay, alignment: .trailing) {
             Text("\(datum.value)")
             .font(.system(size:12))
             .fontWeight(.light)  // Makes the text bold
             .foregroundColor(.gray)  // Changes the text color to blue
             }
             
             
             .foregroundStyle(SelectedLabel == datum.fLabel ? .green : .blue)
             
             
             
             PointMark(x: .value("na", -0.1),
             y: .value("na", datum.label))
             .symbolSize(0)
             
             
             .annotation(position: .leading) {
             Text(datum.label)
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
             
             .frame(height: CGFloat(barWidth+10) * CGFloat(myStateData.fChartData.count)) // << HERE
             
             
             .chartOverlay { proxy in
             GeometryReader { geometry in
             Rectangle().fill(.clear).contentShape(Rectangle())
             .onTapGesture { location in
             
             SelectedLabel = ""
             if let (numPhotos, v) = proxy.value(at: location, as: (Int,String).self) {
             
             if let selData = myStateData.fChartData.first(where: { $0.label == v}) {
             
             //if (numPhotos > -1 && numPhotos < monthData.numPhotos ) {
             SelectedLabel = v
             
             //}
             }
             }
             }
             }
             }
             */
        
