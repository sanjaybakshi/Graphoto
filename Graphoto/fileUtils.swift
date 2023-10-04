//
//  fileUtils.swift
//  sUtils
//
//  Created by Sanjay Bakshi on 11/11/17.
//  Copyright © 2017 Same Eyes Software. All rights reserved.
//

import Foundation

public class fileUtils
{
    
    public init()
    {
        
    }

    public func bundleForFramework(bundleIdentifier: String) -> Bundle?
    {
        return Bundle(identifier: bundleIdentifier)
    }
    
    public func mainBundle() -> Bundle?
    {
        return Bundle.main
    }

    public func fileInBundle(bundle: Bundle, fileName: String, fileExtension: String) -> String?
    {
        return bundle.path(forResource: fileName, ofType: fileExtension)
    }
    
    public func file2String(pathToFile: String) -> String?
        //
        // Description:
        //      Get a path to your file and then call this function.
        //
        // Example:
        //      var mBundle = fUtils.mainBundle()
        //      var File = fUtils.fileInBundle(bundle: mBundle, filenName: "crap", fileExtension: ".txt)
        //      var fileContentsAsString = fUtils.file2String(pathToFile: pFile)
        //
    {
        do {
            var content = try String(contentsOfFile:pathToFile, encoding: String.Encoding.utf8)
            content = cleanRows(file: content)
            return content
        } catch {
            return nil
        }
    }
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }

    
    public func file2StringArray(pathToFile: String) -> [String]?
    {
        let content = file2String(pathToFile: pathToFile)
            
        if (content != nil) {
            return content!.components(separatedBy: "\n")
        } else {
            return nil
        }
    }

    public func file2StringArray(pathToFile: String, seperator: CharacterSet) -> [String]?
    {
        let content = file2String(pathToFile: pathToFile)
        
        if (content != nil) {
            return content!.components(separatedBy: seperator)
        } else {
            return nil
        }
    }

    
    func arrayFromContentsOfFileWithName(fileName: String, fileExt: String = "txt") -> [String]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: fileExt) else {
            return nil
        }
    
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n")
        } catch {
            return nil
        }
    }
    
    public func getMainBundle() -> Bundle
    {
        return Bundle.main
    }
    
    public func getMainBundleLocation() -> String
    {
        return getMainBundle().bundlePath
    }

    
    
    public func writeFile(fileName: String, outStr: String) -> Bool
    {
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            try outStr.write(to: fileURL, atomically: false, encoding: .utf8)
            
            print("Just wrote file: \(fileURL)")
            return true        
        } catch {
            print(error)
        }
        return false

    }
}
