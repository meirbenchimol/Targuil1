//
//  FileManagerCu.swift
//  Targuil1
//
//  Created by Netanel Cohen solal on 02/04/2019.
//  Copyright © 2019 meir Benchimol & Nethanel Cohen-Solal. All rights reserved.
//

import Foundation
class FileManagerCu{
    private static let fileManager = FileManager.default
    private var currentFromHome = FileManager.default.homeDirectoryForCurrentUser //User home directory
    private var filePath:String!; //Path input by user
    
    //Check if is a valid path and file.
    public func isValidFile(file:String!) -> Bool {
        if(file==nil){
            return false;
        }
        currentFromHome.appendPathComponent(file);
        return currentFromHome.isFileURL
    }
    
    //Check if is a valid path and file.
    public func isValidDirectory(file:String!) -> Bool {
        if(file==nil){
            return false;
        }
        currentFromHome.appendPathComponent(file);
        return currentFromHome.hasDirectoryPath
    }
    
    init(path:String){
        filePath = path
        if(!isValidFile(file: path) && !isValidDirectory(file: path)){
            print("ERROR Can't find the file or the directory")
        }
    }
    
    
    
    //Write to a file (Append)
    func writeAppend(txt:String!)->Bool{
        let path = currentFromHome.absoluteURL;
        do{
            let fileHandle = try FileHandle(forWritingTo:path)
            fileHandle.seekToEndOfFile()
            fileHandle.write(Data(txt.utf8))
            fileHandle.closeFile()
            return true;
        }
        catch{
            return false;
        }
    }
    
    
    func scanDirectoryAndTranslateVMFiles(){
        do{
            //Get list of all file in the directorie
            let items = try FileManagerCu.fileManager.contentsOfDirectory(atPath:currentFromHome.path);
            
            for item in items {
                currentFromHome.appendPathComponent(item)
                if(currentFromHome.pathExtension == "vm"){
                    
                    var translated = translateFileToVM(path:currentFromHome.path)
                    
                    //Prepare the new file
                    let newFileName = currentFromHome.lastPathComponent+".asm"
                    currentFromHome.deleteLastPathComponent()
                    currentFromHome.appendPathComponent(newFileName)
                    
                    
                    //Create the file
                    FileManagerCu.fileManager.createFile(atPath: currentFromHome.path, contents: Data(translated.utf8))
                    
                }
                home.deleteLastPathComponent()
                
            }
            
        }
        catch{
            print("Unknow Error !!")
        }
    }
    
    private func translateFileToVM(path:String)->String{
        var translatedAll = [String]()
        do{
            //Translate vm file
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let arrayLine = content.split(separator: "\n")
            for line in arrayLine{
                let words = line.split(separator: " ")
                var cmd:Cmd
                if(words.count>1){
                    cmd = CmdArgs(
                        aName:Command(rawValue: String(words[0]))!,
                        aArg1:ArgType(rawValue: String(words[1]))!,
                        aArg2: Int(String(words[1]))!)
                }
                else
                {
                    cmd = Cmd(
                        aName:Command(rawValue: String(words[0]))!)
                }
                
                translatedAll.append(cmd.translateToASM())
                
            }
        }
        catch{
            print("ERROR TRYING TO TRANSLATE THE FILE")
        }
        
        return translatedAll.joined(separator: "\n")
    }
    
    
    
    
}