//
//  main.swift
//  Targuil1
//
//  Created by meir Benchimol on 24/03/2019.
//  Copyright © 2019 meir Benchimol & Nethanel Cohen-Solal. All rights reserved.
//


//Ask the user to enter a directoty path
var filePath:String!;
print("Hi ! 🤓","Please enter a name of your directory :");
repeat{
    //repeat until invalid path.
    filePath = readLine();
    
}while(filePath==nil)

var manager = FileManagerCu(path: filePath);
manager.scanDirectoryAndTranslateVMFiles();
