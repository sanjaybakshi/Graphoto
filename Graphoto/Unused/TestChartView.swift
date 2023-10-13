//
//  TestChartView.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/29/23.
//
#if false

import SwiftUI
import Charts


struct SleepDataPoint : Identifiable
{
    var id = UUID()
    var day: String
    var hours: Int
}
struct TestChartView: View {
    
    var data = [
        SleepDataPoint(day: "Monday", hours: 6),
        SleepDataPoint(day: "Tuesday", hours: 6),
        SleepDataPoint(day: "Wednesday", hours: 10),
        SleepDataPoint(day: "Thursday", hours: 7),
        SleepDataPoint(day: "Friday", hours: 8)
    ]
    
    @State var SelectedDay = ""

    var body: some View {
        
        Chart {
            
            ForEach(data) {d in
                
                /*
                BarMark(
                    xStart: .value("HStart", 0),
                    xEnd: .value("HEnd", d.hours),
                    y: .value("Day", d.day),
                    width: 1
                )
*/
                
                BarMark(
                    x: .value("Hours", d.hours),
                    y: .value("Day", d.day),
                    width: 20

                )
                 
                .cornerRadius(20, style: .continuous)
                .annotation(position: .overlay, alignment: .trailing) {
                    Text("\(d.hours)")
                        .font(.system(size:12))
                        .fontWeight(.light)  // Makes the text bold
                        .foregroundColor(.gray)  // Changes the text color to blue
                        //.background(.black)
                }
                .foregroundStyle(SelectedDay == d.day ? .green : .blue)


                
                PointMark(x: .value("na", -0.1),
                          y: .value("na", d.day))
                .symbolSize(0)
                
                .annotation (position: .leading) {
                    Text(d.day)
                        .font(.system(size:12))
                        .fontWeight(.light)  // Makes the text bold
                        .foregroundColor(.gray)  // Changes the text color to blue
                        //.background(Color.black)
                    /*
                        .multilineTextAlignment(.trailing) // Right justification
                        .frame(width: 300, height: 100, alignment: .leading) // Add a frame for demonstration purposes
                        .border(Color.gray) // Visualize the frame
                     */

                }


            }
        }
        .chartXAxis(.hidden)

        .chartXScale(domain: -2...12)
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
         
        .frame(height: 200) // << HERE


        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                
                
                    .onTapGesture { location in
                        
                        SelectedDay = ""
                        if let (h,day) = proxy.value(at: location, as: (Int,String).self) {
                            
                        
                            if let dayData = data.first(where: { $0.day == day}) {
                                
                                if (h > -1 && h < dayData.hours) {
                                    SelectedDay = day
                                    
                                }
                            }
                        }
                    }
                        
                    .gesture(
                        

                        DragGesture()
                            .onChanged { value in
                                // Convert the gesture location to the coordinate space of the plot area.
                                let origin = geometry[proxy.plotAreaFrame].origin
                                let location = CGPoint(
                                    x: value.location.x - origin.x,
                                    y: value.location.y - origin.y
                                )
                                // Get the x (date) and y (price) value from the location.
                                if let (x,y) = proxy.value(at: location, as: (Int,String).self) {
                                    
                                    print(location,x,y)
                                } else {
                                    print("nope")
                                }
                                /*
                                let (date, price) = proxy.value(at: location, as: (Date, Double).self)
                                print("Location: \(date), \(price)")
                                 */
                            }
                    )
            }
        }
        
    }
}

#Preview {
    TestChartView()
}


#endif

