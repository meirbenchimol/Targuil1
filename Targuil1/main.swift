//
//  main.swift
//  Targuil1
//
//  Created by meir Benchimol on 24/03/2019.
//  Copyright © 2019 meir Benchimol & Nethanel Cohen-Solal. All rights reserved.
//

import Foundation
let fileManager = FileManager.default
var home = FileManager.default.homeDirectoryForCurrentUser //User home directory
var filePath:String!; //Path input by user

//Check if is a valid path and file.
func isValidFile(file:String!) -> Bool {
    if(file==nil){
        return false;
    }
    home.appendPathComponent(file);
    return home.isFileURL
}
func push_base ()->String{
    var res = ""
    res.append("@SP\n")
    res.append("A=M\n")
    res.append("M=D\n")
    res.append("@SP\n")
    res.append("M=M+1\n")

    return res
}
func push_translate (line:String)-> String{
    var res = ""
    let words = line.split(separator: " ")
    
    switch words[1]
    {
    case "constant":
        res.append("@\(words[2])\n")
        res.append("D=A\n")
        res.append(push_base())
    case "local":
        res.append("@\(words[2])\n")
        res.append("D=A\n")
        res.append("@LCL\n")
        res.append("A=M+D\n")
        res.append("D=M\n")
        res.append(push_base())



        
        
    default:
        print ("eror")
    }
    
    
    return res
    
    
}


//Ask the user to enter a directoty path
print("Hi ! 🤓","Please enter a name of your file.vm :");
repeat{
    //repeat until invalid path.
    print(home.absoluteString)
    filePath = readLine();
    if(!isValidFile(file:filePath)){
        print("Please enter a correct path")
    }
}while(filePath==nil)

do{
    let stack : [Int]
    
    
    let content = try String(contentsOfFile: home.path, encoding: .utf8)
    let arrayLine = content.split(separator: "\r\n")
    for line in arrayLine{
        let words = line.split(separator: " ")
        switch words[0]
        {
        case "//":
            print("ceci est un commentaire")
        case "pop":
            print("pop")
        case "push":
            print("// "+line )
            print(push_translate(line: String(line)))
            print(Int(Commamde.add))
            
        case "add":
            print("add")
        case "sub":
            print("sub")
        case "neg":
            print("neg")
        case "eq","gt","lt","and","or","not":
            print("flem")
        default:
            print("eror the progame is not good")
           
            
        
 }
    
    }
}
catch{
    print("Error attemting to read asm files.")
}

