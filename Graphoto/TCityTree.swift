//
//  TCityTree.swift
//
//  Created by Sanjay Bakshi on 7/13/17.
//
//

import Foundation
//import UIKit

class TCityNode
//
// Description:
//      Basically a kd-tree of city nodes.
//      Accelerates seaches of closest city based on latitude/longitude.
//
{
    public var longMin : Double = 0.0
    public var longMax : Double = 0.0
    public var latMin  : Double = 0.0
    public var latMax  : Double = 0.0
    
    public var cities : [TCity]?
    public var kids   : [TCityNode]?
    
    init(cityList: [TCity])
    {
        cities = cityList
        
        longMin =  999999.0
        longMax = -999999.0
        latMin  =  999999.0
        latMax  = -999999.0
        
        for i in (0 ..< cityList.count) {
            
            if cityList[i].fLatitude < latMin {
                latMin = cityList[i].fLatitude
            }
            if cityList[i].fLatitude > latMax {
                latMax = cityList[i].fLatitude
            }
            if cityList[i].fLongitude < longMin {
                longMin = cityList[i].fLongitude
            }
            if cityList[i].fLongitude > longMax {
                longMax = cityList[i].fLongitude
            }
        }
        
    }
    
    init()
    {
        cities = nil
        kids   = nil
    }
    
    
    
    func printNode()
    {
        //print("box: \(self.box.origin.x) \(self.box.origin.y) \(self.box.origin.x+self.box.size.width) \(self.box.origin.y+self.box.size.height)")
        
        print("box: \(latMin) \(latMax) \(longMin) \(longMax)")
        
        if (self.cities == nil) {
            print("no cityList but \(kids!.count) kids.")
        } else {
            print("cityList: \(self.cities!.count) so no kids")
            
        }
    }
    
    
    func printMe()
    {
        var queue = [TCityNode]()
        queue.append(self)
        
        while (queue.count > 0) {
            
            let n = queue.removeLast()
            print("queue: \(queue.count)")
            
            n.printNode()
            
            if (n.kids != nil) {
                for j in (0 ..< n.kids!.count) {
                    queue.insert(n.kids![j], at: 0)
                }
            }
        }
    }
    
    func save(fileName: String)
    {
        var queue = [TCityNode]()
        queue.append(self)
        
        var outStr = ""
        
        while (queue.count > 0) {
            
            let n = queue.removeLast()
            
            let bboxInfo = "\(n.latMin) \(n.latMax) \(n.longMin) \(n.longMax)\n"
            outStr += bboxInfo
            if (n.kids != nil) {
                let numKidInfo = "kids: \(n.kids!.count)\n"
                outStr += numKidInfo
            } else if (n.cities != nil) {
                let numCityInfo = "cities: \(n.cities!.count)\n"
                outStr += numCityInfo
                
                for c in n.cities! {
                    let cityInfo = "\(c.fCity),\(c.fCountry),\(c.fLatitude),\(c.fLongitude),\(c.fState)\n"
                    outStr += cityInfo
                }
            }
            
            if (n.kids != nil) {
                for j in (0 ..< n.kids!.count) {
                    queue.insert(n.kids![j], at: 0)
                }
            }
        }
        
        
        let fUtils = fileUtils()
        let cName = (fileName + ".txt")
        if (fUtils.writeFile(fileName: cName, outStr: outStr) == false) {
            fatalError("Couldn't write the file \(cName)")
            
        }
    }
    
    class func string2NodeType(nodeTypeString: String) -> (numKids: Int?, numCities: Int?)
    {
        let nodeType = nodeTypeString.components(separatedBy: .whitespaces)
        
        var numKids   : Int? = nil
        var numCities : Int? = nil
        
        if (nodeType.count == 2) {
            if (nodeType[0] == "kids:") {
                numKids = Int(nodeType[1])
            } else if (nodeType[0] == "cities:") {
                numCities = Int(nodeType[1])
            }
        }
        
        return (numKids, numCities)
    }
    
    class func string2Coords(coordString: String) -> (latMin: Double, latMax:Double, longMin:Double, longMax:Double)?
    {
        let coordInfo = coordString.components(separatedBy: .whitespaces)
        
        var latMin  = 0.0
        var latMax  = 0.0
        var longMin = 0.0
        var longMax = 0.0
        if (coordInfo.count == 4) {
            latMin  = Double(coordInfo[0])!
            latMax  = Double(coordInfo[1])!
            longMin = Double(coordInfo[2])!
            longMax = Double(coordInfo[3])!
        } else {
            return nil
        }
        
        return (latMin, latMax, longMin, longMax)
    }
    
    class func string2City(cityString: String) -> (city: String, state: String, country: String,
        latitude: Double, longitude: Double)
    {
        var city      = ""
        var state     = ""
        var country   = ""
        var latitude  = 0.0
        var longitude = 0.0
        
        let cityInfo = cityString.components(separatedBy: ",")
        
        if (cityInfo.count == 5) {
            city      =        cityInfo[0]
            country   =        cityInfo[1]
            latitude  = Double(cityInfo[2])!
            longitude = Double(cityInfo[3])!
            state     =        cityInfo[4]
        }
        
        return (city, state, country, latitude, longitude)
    }
    
    class func string2Nodes(fileContents: String) -> [TCityNode]
    {
        var NodeList = [TCityNode]()
        
        let myStrings = fileContents.components(separatedBy: .newlines)
        
        var i = 0
        while (i < myStrings.count) {
            
            
            if let coords = string2Coords(coordString: myStrings[i]) {
                let n = TCityNode()
                
                n.latMin  = coords.latMin
                n.latMax  = coords.latMax
                n.longMin = coords.longMin
                n.longMax = coords.longMax
                
                i = i + 1
                let nodeType = string2NodeType(nodeTypeString: myStrings[i])
                
                if (nodeType.numCities != nil) {
                    let numCities = nodeType.numCities!
                    
                    var cList = [TCity]()
                    
                    for _ in (0 ..< numCities) {
                        i = i + 1
                        let cityInfo = string2City(cityString: myStrings[i])
                        
                        let c = TCity()
                        c.fCity      = cityInfo.city
                        c.fCountry   = cityInfo.country
                        c.fLatitude  = cityInfo.latitude
                        c.fLongitude = cityInfo.longitude
                        c.fState     = cityInfo.state
                        
                        cList.append(c)
                    }
                    n.cities = cList
                    
                    i = i + 1
                    
                } else if (nodeType.numKids != nil) {
                    let numKids = nodeType.numKids!
                    
                    var kList = [TCityNode]()
                    for _ in (0 ..< numKids) {
                        let tempCityNode = TCityNode()
                        kList.append(tempCityNode)
                    }
                    n.kids = kList
                    
                    i = i + 1
                }
                
                NodeList.append(n)
            } else {
                i = i + 1
            }
        }
        return NodeList
    }
    
    class func read(fileName: String, progressUpdateFunc: ((Float) -> ())? = nil) -> TCityNode?
    {
        var retNode : TCityNode? = nil
        
        let fUtils = fileUtils()
        //let sUtilsBundle = fUtils.bundleForFramework(bundleIdentifier: "Same-Eyes-Software.jUtils18")

        let sUtilsBundle = fUtils.getMainBundle()
        guard let PathToFile = fUtils.fileInBundle(bundle: sUtilsBundle, fileName: fileName, fileExtension: "txt") else {
        
//        guard let PathToFile = sUtilsBundle?.path(forResource: fileName, ofType: "txt") else {
//        guard let PathToFile = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            fatalError("Couldn't get path to bundle.")
        }
        
        do {
            let timer_loadTime = ParkBenchTimer()

            let data = try String(contentsOfFile: PathToFile, encoding: .utf8)
            var NodeList = string2Nodes(fileContents: data)
            
            print("Just parsing the filer \(PathToFile) took \(timer_loadTime.stop()) seconds.")

            
            
            let timer_nodeTime = ParkBenchTimer()

            // Now go through the node list and update the children.
            //
            
            var childStartIndex = 1
            
            for i in (0 ..< NodeList.count) {
                let n = NodeList[i]
                
                if (n.kids != nil) {
                    let numKids = n.kids?.count
                    
                    let startIndex = childStartIndex
                    let endIndex   = childStartIndex + numKids!
                    
                    n.kids?.removeAll()
                    
                    n.kids = [TCityNode]()
                    n.kids?.reserveCapacity(numKids!)
                    
                    for childIndex in (startIndex ..< endIndex) {
                        n.kids?.append(NodeList[childIndex])
                    }
                    
                    childStartIndex = endIndex
                    
                    let progress = Float(i) / Float(NodeList.count-1)
                    DispatchQueue.main.async {
                        if (progressUpdateFunc != nil) {
                            //print(progress)
                            progressUpdateFunc!(progress)
                        }
                    }
                }
                
            }
            print("processing the nodes took \(timer_nodeTime.stop()) seconds.")

            retNode = NodeList[0]
        } catch {
            print(error)
        }
        
        return retNode
    }
    
    func contains(lt: Double, lg: Double) -> Bool
    {
        // Fudge the range by 5%
        let fudgeAmt = 0.2
        let latFudgeAmt  = (latMax  - latMin ) * fudgeAmt
        let longFudgeAmt = (longMax - longMin) * fudgeAmt
        
        let fudgeLatMin  = latMin  - latFudgeAmt
        let fudgeLatMax  = latMax  + latFudgeAmt
        let fudgeLongMin = longMin - longFudgeAmt
        let fudgeLongMax = longMax + longFudgeAmt
        
        if (lt >= fudgeLatMin && lt <= fudgeLatMax && lg >= fudgeLongMin && lg <= fudgeLongMax) {
            return true
        } else {
            return false
        }
    }
    /*
    func contains(lt: Double, lg: Double) -> Bool
    {
        if (lt >= latMin && lt <= latMax && lg >= longMin && lg <= longMax) {
            return true
        } else {
            return false
        }
    }
     */
    func findClosestCityTo(thisCity: TCity) -> TCity?
    {
        var retCity: TCity? = nil
        var stack = [TCityNode]()
        
        stack.append(self)
        
        let found = false
        var minDistance = 999999999.0
        
        //var numBoxes = 0
        //var numLinearCities = 0
        
        while (stack.count > 0 && found == false) {
            
            let n = stack[0]
            stack.remove(at: 0)
            //numBoxes = numBoxes + 1
            
            if (n.cities == nil) {
                
                // Has children.  Iterate and add child that
                // containts pt.
                //
                for kidIt in (0 ..< n.kids!.count) {
                    if n.kids![kidIt].contains(lt: thisCity.fLatitude, lg: thisCity.fLongitude) {
                        stack.append(n.kids![kidIt])
                    } else {
                        //stack.append(n.kids![kidIt])
                        
                        
                    }
                }
            } else {
                
                if (n.cities!.count == 1) {
                    return n.cities![0]
                } else {
                    // Iterate through the list of cities and find the
                    // one we are looking for.
                    //
                
                    for i in (0 ..< n.cities!.count) {
                    
                        let d  = thisCity.squaredDistance(to: n.cities![i])
                        if (d < minDistance) {
                            minDistance = d
                            retCity = n.cities![i]
                            //numLinearCities = numLinearCities + 1
                        }
                    }
                }
                //found = true
                
            }
        }
        
        if (retCity == nil) {
            print("whoops: \(thisCity.fLatitude) \(thisCity.fLongitude)")
        }
        //print("visited numBoxes: \(numBoxes) and linear searched \(numLinearCities).")
        return retCity
    }
    
    
    
    
    
    
    
    private func splitCityListIntoKids(axis: String, numKids: Int)
        //
        // Description:
        //      Convert the list of cities into numKids number of
        //      children CityNodes.
        //
        // cities: [city1, city2, city3, city4, city5 ... city100]
        //
        // kids:   [kid1,              kid2,                    kid3]
        //           |                  |                        |
        //          box1               box2                     box3
        //    [city7, city4, city9]   [city1, city5, city8]    [city2, city10, city3]
        //
        //
    {
        assert(  self.kids == nil  )
        assert(self.cities != nil  )
        
        if (self.cities!.count == 0) {
            return
        }
        
        var sortedCityList : [TCity]
        
        if (axis == "latitude") {
            sortedCityList = self.cities!.sorted { (a, b) -> Bool in
                return a.fLatitude < b.fLatitude
            }
        } else {
            sortedCityList = self.cities!.sorted { (a, b) -> Bool in
                return a.fLongitude < b.fLongitude
            }
        }
        
        var nKids = numKids
        
        if (sortedCityList.count < numKids) {
            nKids = sortedCityList.count
        }
        
        let numCitiesPerBox: Int = sortedCityList.count / nKids
        
        let numOverflowCities: Int = sortedCityList.count % nKids
        
        self.kids = [TCityNode]()
        
        //var tempCityNode = CityNode()
        
        
        for i in (0 ..< nKids) {
            
            let tempCityNode = TCityNode()
            tempCityNode.cities = [TCity]()
            
            var numCitiesInThisBin = numCitiesPerBox
            
            if (i == nKids-1) {
                numCitiesInThisBin += numOverflowCities
            }
            
            
            let startIndex = i*numCitiesPerBox
            var endIndex   = (i+1) * numCitiesPerBox
            
            if (i == nKids-1) {
                endIndex = endIndex + numOverflowCities
            }
            
            for cIt in (startIndex ..< endIndex) {
                tempCityNode.cities!.append(sortedCityList[cIt])
            }
            
            
            //if (tempCityNode.cities!.count > 0) {
            if (axis == "latitude") {
                
                tempCityNode.latMin = tempCityNode.cities![0].fLatitude
                tempCityNode.latMax = tempCityNode.cities![numCitiesInThisBin-1].fLatitude
                
                
                // latitude has been determined by sorting- use the latitude from the parent bbox.
                //
                tempCityNode.longMin = self.longMin
                tempCityNode.longMax = self.longMax
                
            } else {
                // longitude has been determined by sorting- use the latitude from the parent bbox.
                //
                tempCityNode.longMin = tempCityNode.cities![0].fLongitude
                tempCityNode.longMax = tempCityNode.cities![numCitiesInThisBin-1].fLongitude
                
                tempCityNode.latMin  = self.latMin
                tempCityNode.latMax  = self.latMax
            }
            
            
            self.kids!.append(tempCityNode)
            //}
        }
        
        // Now walk through all of the kids and update the bounding boxes.
        //
        
        if (axis == "latitude") {
            var previousLatMax = 0.0
            
            let nKids = self.kids!.count
            
            for i in (0 ..< nKids) {
                let CityNodei        = self.kids![i]
                let NumCitiesi       = CityNodei.cities!.count
                let CityNodeiMaxLat  = CityNodei.cities![NumCitiesi-1].fLatitude
                
                if (i == 0) {
                    //CityNodei.latMin = CityNodei.cities![0].latitude
                    CityNodei.latMin = self.latMin
                } else {
                    CityNodei.latMin = previousLatMax
                }
                
                if (i == nKids-1) {
                    //CityNodei.latMax = CityNodeiMaxLat
                    CityNodei.latMax = self.latMax
                } else {
                    let CityNodeip1     = self.kids![i+1]
                    let CityNodeiMinLat = CityNodeip1.cities![0].fLatitude
                    
                    CityNodei.latMax = CityNodeiMaxLat + (CityNodeiMinLat-CityNodeiMaxLat)/2.0
                    previousLatMax   = CityNodei.latMax
                }
            }
        } else {
            var previousLongMax = 0.0
            
            let nKids = self.kids!.count
            
            for i in (0 ..< nKids) {
                let CityNodei        = self.kids![i]
                let NumCitiesi       = CityNodei.cities!.count
                let CityNodeiMaxLong = CityNodei.cities![NumCitiesi-1].fLongitude
                
                if (i == 0) {
                    //CityNodei.longMin = CityNodei.cities![0].longitude
                    CityNodei.longMin = self.longMin
                } else {
                    CityNodei.longMin = previousLongMax
                }
                
                if (i == nKids-1) {
                    //CityNodei.longMax = CityNodeiMaxLong
                    CityNodei.longMax = self.longMax
                } else {
                    let CityNodeip1     = self.kids![i+1]
                    let CityNodeiMinLong = CityNodeip1.cities![0].fLongitude
                    
                    CityNodei.longMax = CityNodeiMaxLong + (CityNodeiMinLong-CityNodeiMaxLong)/2.0
                    previousLongMax   = CityNodei.longMax
                }
            }
        }
        
        self.cities = nil
        
    }
    
    
    func splitIntoKids(axis: String, numKids: Int)
    {
        var nodesToSplit = [TCityNode]()
        
        var queue = [TCityNode]()
        queue.append(self)
        
        while (queue.count > 0) {
            
            let n = queue.removeLast()
            
            if (n.kids != nil) {
                for j in (0 ..< n.kids!.count) {
                    queue.insert(n.kids![j], at: 0)
                }
            } else {
                // This doesn't have kids so it's a leaf.
                //
                nodesToSplit.append(n)
            }
        }
        
        for nodeIt in (0 ..< nodesToSplit.count) {
            nodesToSplit[nodeIt].splitCityListIntoKids(axis: axis, numKids: numKids)
        }
    }
    
    
    func bakeCacheFile(fileName: String) -> TCityNode
    //
    // Description:
    //      This function takes the citiesProcessed.csv file (which is just a list of cities)
    //      and creates a TCityNode tree.  It then writes out this tree to a file that can be
    //      loaded efficiently and searched efficiently.
    //      You shouldn't have to do this very often.
    //
    //      The resulting file is called SplitCities.txt and is stored in the documented directory
    //      ~/Library/Developer/CoreSimulator/Devices/1FC28870-4C0B-46F0-89FA-E838AA5751EC/data/Containers/Data/Application/609D3F64-4A41-4A8B-981E-DD0E1FC6FE09/Documents

    {
        let fUtils = fileUtils()
        
        let sUtilsBundle = fUtils.bundleForFramework(bundleIdentifier: "Same-Eyes-Software.jUtils")
        
        guard let PathToFile = fUtils.fileInBundle(bundle: sUtilsBundle!, fileName: "citiesProcessed", fileExtension: "csv") else {
            fatalError("Couldn't get path to bundle.")
        }
        
        if let cityListStrings = fUtils.file2StringArray(pathToFile: PathToFile) {
            
            var cityList = [TCity]()
            
            for c in cityListStrings {
                
                var record = c.components(separatedBy: ",")
                
                if (record.count == 6) {
                    
                    let city = TCity()
                    
                    city.fCity        = record[0]
                    city.fLatitude    = Double(record[1])!
                    city.fLongitude   = Double(record[2])!
                    city.fCountry     = record[4]
                    city.fState       = record[5]
                    
                    cityList.append(city)
                }
            }
            
            /*
            // This is how 4x2 was built.
            //
            let cityTree = TCityNode(cityList: cityList)
            cityTree.splitIntoKids(axis: "latitude",  numKids: 4)
            cityTree.splitIntoKids(axis: "longitude", numKids: 4)
             
            cityTree.splitIntoKids(axis: "latitude",  numKids: 4)
            cityTree.splitIntoKids(axis: "longitude", numKids: 4)
             */
            
            /*
            // This is how 4x2 was built.
            //
            let cityTree = TCityNode(cityList: cityList)
            cityTree.splitIntoKids(axis: "latitude",  numKids: 4)
            cityTree.splitIntoKids(axis: "longitude", numKids: 4)
            
            cityTree.splitIntoKids(axis: "latitude",  numKids: 4)
            cityTree.splitIntoKids(axis: "longitude", numKids: 4)

            cityTree.splitIntoKids(axis: "latitude",  numKids: 4)
            cityTree.splitIntoKids(axis: "longitude", numKids: 4)
            
            cityTree.splitIntoKids(axis: "latitude",  numKids: 4)
            cityTree.splitIntoKids(axis: "longitude", numKids: 4)
*/
            
            // This is how 16x2 was built.
            //
            /*
            let cityTree = TCityNode(cityList: cityList)
            cityTree.splitIntoKids(axis: "latitude",  numKids: 16)
            cityTree.splitIntoKids(axis: "longitude", numKids: 16)
            
            cityTree.splitIntoKids(axis: "latitude",  numKids: 16)
            cityTree.splitIntoKids(axis: "longitude", numKids: 16)
            */
            
            /*
            
            // This is how 2x2 was built.
            //
            let cityTree = TCityNode(cityList: cityList)
            cityTree.splitIntoKids(axis: "latitude",  numKids: 2)
            cityTree.splitIntoKids(axis: "longitude",  numKids: 2)
             */
            
            /*
            // This is how 16x2x2 was built.
            //
            
             let cityTree = TCityNode(cityList: cityList)
             cityTree.splitIntoKids(axis: "latitude",  numKids: 16)
             cityTree.splitIntoKids(axis: "longitude", numKids: 16)
             
             cityTree.splitIntoKids(axis: "latitude",  numKids: 16)
             cityTree.splitIntoKids(axis: "longitude", numKids: 16)
            
             cityTree.splitIntoKids(axis: "latitude", numKids: 2)
            */

            
            // This is how 4x2 was built.
            //
            /*
            let cityTree = TCityNode(cityList: cityList)
            cityTree.splitIntoKids(axis: "latitude",  numKids: 4)
            cityTree.splitIntoKids(axis: "longitude", numKids: 4)
            
            cityTree.splitIntoKids(axis: "latitude",  numKids: 4)
            cityTree.splitIntoKids(axis: "longitude", numKids: 4)
             */
            
            
            // This is how 4x3 was built.
            //
            
             let cityTree = TCityNode(cityList: cityList)
             cityTree.splitIntoKids(axis: "latitude",  numKids: 4)
             cityTree.splitIntoKids(axis: "longitude", numKids: 4)
             
             cityTree.splitIntoKids(axis: "latitude",  numKids: 4)
             cityTree.splitIntoKids(axis: "longitude", numKids: 4)
             
             cityTree.splitIntoKids(axis: "latitude",  numKids: 4)
             cityTree.splitIntoKids(axis: "longitude", numKids: 4)

 

            
            
            // This is how 2x8 was built.
            //
            /*
             let cityTree = TCityNode(cityList: cityList)
             cityTree.splitIntoKids(axis: "latitude",  numKids: 2)
             cityTree.splitIntoKids(axis: "longitude", numKids: 2)
             
             cityTree.splitIntoKids(axis: "latitude",  numKids: 2)
             cityTree.splitIntoKids(axis: "longitude", numKids: 2)
             
             cityTree.splitIntoKids(axis: "latitude",  numKids: 2)
             cityTree.splitIntoKids(axis: "longitude", numKids: 2)
             
             cityTree.splitIntoKids(axis: "latitude",  numKids: 2)
             cityTree.splitIntoKids(axis: "longitude", numKids: 2)

             cityTree.splitIntoKids(axis: "latitude",  numKids: 2)
             cityTree.splitIntoKids(axis: "longitude", numKids: 2)
             
             cityTree.splitIntoKids(axis: "latitude",  numKids: 2)
             cityTree.splitIntoKids(axis: "longitude", numKids: 2)

             cityTree.splitIntoKids(axis: "latitude",  numKids: 2)
             cityTree.splitIntoKids(axis: "longitude", numKids: 2)
             
             cityTree.splitIntoKids(axis: "latitude",  numKids: 2)
             cityTree.splitIntoKids(axis: "longitude", numKids: 2)
             */
             
            // This is how 0x0 was built.
            //
            //let cityTree = TCityNode(cityList: cityList)

            
            
            cityTree.save(fileName: fileName)

            return cityTree
        
        }
        return self
    }
}


