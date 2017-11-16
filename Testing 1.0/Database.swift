//
//  Database.swift
//  Testing 1.1
//
//  Created by Savan Patel on 2016-02-27.
//  Copyright © 2016 Savan Patel. All rights reserved.
//

import Foundation

class Database
{
    var database:COpaquePointer = nil;
    var strQuery:String = "";
    
    func createDatabase()
    {
        if ( DBOpen() )
        {
            print("OK");
            createTables();
        }
        else
        {
            DBClose();
            print("Failed");
        }
    }
    
    func createTables()
    {
        //cat_details
        strQuery = "CREATE TABLE IF NOT EXISTS cat_details " + "(cid INTEGER PRIMARY KEY AUTOINCREMENT, cname TEXT )";
        var errMsg:UnsafeMutablePointer<Int8> = nil
        let cresult = sqlite3_exec(database, strQuery, nil, nil, &errMsg);
        
        //note_details
        strQuery = "CREATE TABLE IF NOT EXISTS note_details " + "(nid INTEGER PRIMARY KEY AUTOINCREMENT,cid INTEGER, ntitle TEXT,ncontent TEXT,ndate TEXT,nlatitude TEXT,nlongitude TEXT ,FOREIGN KEY(cid) REFERENCES cat_details(cid))";
        let nresult = sqlite3_exec(database, strQuery, nil, nil, &errMsg);
        
        //image_details
        strQuery = "CREATE TABLE IF NOT EXISTS image_details " + "(iid INTEGER PRIMARY KEY AUTOINCREMENT,nid INTEGER, npath TEXT,FOREIGN KEY(nid) REFERENCES note_details(nid))";
        let iresult = sqlite3_exec(database, strQuery, nil, nil, &errMsg);
        
        //audio_details
        strQuery = "CREATE TABLE IF NOT EXISTS audio_details " + "(aid INTEGER PRIMARY KEY AUTOINCREMENT,nid INTEGER, npath TEXT,FOREIGN KEY(nid) REFERENCES note_details(nid))";
        let aresult = sqlite3_exec(database, strQuery, nil, nil, &errMsg);

        if (nresult == SQLITE_OK && nresult == SQLITE_OK && iresult == SQLITE_OK && aresult == SQLITE_OK)
        {
            strQuery = "";
            insertCategoriesOnFirstRun();
            print("OK creating table!")
        }
        else
        {
            sqlite3_close(database)
            print("Failed to create table")
            return ;
        }
        strQuery = "";
    }
    
    func insertOrUpdateDatabase()
    {
        var statement:COpaquePointer = nil;
        DBOpen();
        if sqlite3_prepare_v2(database, strQuery, -1, &statement, nil) == SQLITE_OK {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                print("Row Inserted")
            }
            else
            {
                print(SQLITE_ERROR);
                DBClose();
                return;
            }
            sqlite3_finalize(statement)
        } else {
            NSLog("Error while prepare DB query : '%s'", sqlite3_errmsg(database));
        }
        DBClose();

    }
    
    func deleteFromDatabase()
    {
        
    }
    
    func DBOpen() -> Bool {
        let result = sqlite3_open(dataFilePath(), &database);
        if result == SQLITE_OK {
            print(dataFilePath());
            //print("DB open sucessfully.");
            return true;
        } else {
            print("error in opening DB : %s", sqlite3_errmsg(database));
            return false;
        }
    }
    
    //To fetch data from Category Table
    func fetchFromCategotyTable() -> [String]
    {
        var Array : [String] = [String]();
        DBOpen();
        var statement:COpaquePointer = nil
        if sqlite3_prepare_v2(database, strQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let cname = sqlite3_column_text(statement, 0)
                
                let cnameString = String.fromCString(UnsafePointer<CChar>(cname))
                
                Array.append(cnameString!);
                //print("Fname : \(cnameString!)");

            }
            sqlite3_finalize(statement)
        }
        DBClose();
        
        return Array;
    }
    
    //To fetch data from Note Table
    func fetchFromNoteTable() -> (id:[Int] ,ntitle : [String],content : [String],category : [String])
    {
        var id : [Int] = [Int]();
        var title : [String] = [String]();
        var content : [String] = [String]();
        var catname : [String] = [String]();
//        var cnameString : String = "kj";
        DBOpen();
        var statement:COpaquePointer = nil
//        var innerstatement:COpaquePointer = nil
        if sqlite3_prepare_v2(database, strQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let nid = Int(sqlite3_column_int(statement, 0))
                let ntitle = sqlite3_column_text(statement,  1)
                let ncontent = sqlite3_column_text(statement, 2)
                let ncname = sqlite3_column_text(statement, 3)
               
                
                let ntitleString = String.fromCString(UnsafePointer<CChar>(ntitle))!
                let ncontentString = String.fromCString(UnsafePointer<CChar>(ncontent))!
                 let ncnameString = String.fromCString(UnsafePointer<CChar>(ncname))!

                
                id.append(nid);
                title.append(ntitleString);
                catname.append(ncnameString);
                content.append(ncontentString);
                
                //print("\nTitle : \(ntitleString)\n");
                //print("Content : \(ncontentString)\n");
               // print("Category : \(cnameString)\n");
                

                //                let innerStrQuery = "SELECT cname FROM cat_details WHERE cid = \(cid)";
                //print("Inner Statement : \(innerStrQuery)");
                //                if(sqlite3_prepare_v2(database,innerStrQuery, -1, &innerstatement, nil) == SQLITE_OK)
                //                {
                //                    //to retrieve category from cat_details table
                //                    while( sqlite3_step(innerstatement) == SQLITE_ROW )
                //                    {
                //                        //print("In while loop...");
                //                        let cname = sqlite3_column_text(innerstatement, 0)
                //                        //print("\n\n\n Name : \(cname) \n\n\n");
                //                        let cnameString = String.fromCString(UnsafePointer<CChar>(cname))!
                //                        //print("\nCategory : \(cnameString)\n");
                //                        catname.append(cnameString);
                //                    }
                //                }
                

                
            }
            sqlite3_finalize(statement)
        }
        DBClose();
        
        return (id,title,content,catname);
    }
    
    func DBClose() {
        sqlite3_close(database);
    }
    
    func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask, true);
        let documentsDirectory = paths[0] as NSString;
        print(documentsDirectory);
        return documentsDirectory.stringByAppendingPathComponent("notes.sqlite") as String;
    }
    
    func fetchDataForEditVCFromNoteTable(id : Int) -> (nid : Int,ntitle : String,ncontent : String,ncname : String,ndate : String,nlatitude : Double,nlongitude : Double)
    {
        var nid : Int = 0;
        var ntitle : String = "";
        var ncontent : String = "";
        var cname : String = "";
        var ndate : String = "";
        var nlatitude : Double = 0.0;
        var nlongitude : Double = 0.0;
        
        DBOpen();
        var statement:COpaquePointer = nil
        var innerstatement:COpaquePointer = nil
        if sqlite3_prepare_v2(database, strQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                nid = Int(sqlite3_column_int(statement, 0))
                
                let title = sqlite3_column_text(statement,  1);
                ntitle = String.fromCString(UnsafePointer<CChar>(title))!
                
                let content = sqlite3_column_text(statement, 2);
                ncontent = String.fromCString(UnsafePointer<CChar>(content))!
                
                let ncid = sqlite3_column_text(statement, 3);
                let cid = String.fromCString(UnsafePointer<CChar>(ncid))!
                print("kbk vkjbkdjfbkgkdb\(cid)");
                let innerStrQuery = "SELECT cname FROM cat_details WHERE cid = \(cid)";
                if(sqlite3_prepare_v2(database,innerStrQuery, -1, &innerstatement, nil) == SQLITE_OK)
                {
                    while( sqlite3_step(innerstatement) == SQLITE_ROW )
                    {
                       let catname = sqlite3_column_text(innerstatement, 0)
                        cname = String.fromCString(UnsafePointer<CChar>(catname))!
                    }
                }
                let date = sqlite3_column_text(statement, 4);
                ndate = String.fromCString(UnsafePointer<CChar>(date))!
                
                let latitude = sqlite3_column_text(statement, 5);
                nlatitude = Double(String.fromCString(UnsafePointer<CChar>(latitude))!)!
                
                let longitude = sqlite3_column_text(statement, 6);
                nlongitude = Double(String.fromCString(UnsafePointer<CChar>(longitude))!)!
            }
//            print("Id : \(nid)");
//            print("Title : \(ntitle)");
//            print("Content : \(ncontent)");
//            print("Category : \(cname)");
//            print("Date : \(ndate)");
//            print("Lat : \(nlatitude)");
//            print("Lon : \(nlongitude)");
            
            sqlite3_finalize(statement)
        }
        DBClose();
        
        return (nid,ntitle,ncontent,cname,ndate,nlatitude,nlongitude);
    }
    
    func insertCategoriesOnFirstRun()
    {
        // see carefully..
        if !NSUserDefaults.standardUserDefaults().boolForKey("insert") {
            
        strQuery = "INSERT OR REPLACE INTO cat_details (cname) VALUES ('Default')";
        insertOrUpdateDatabase();
        strQuery = "INSERT OR REPLACE INTO cat_details (cname) VALUES ('Personal')";
        insertOrUpdateDatabase();
        strQuery = "INSERT OR REPLACE INTO cat_details (cname) VALUES ('Work')";
        insertOrUpdateDatabase();
        strQuery = "INSERT OR REPLACE INTO cat_details (cname) VALUES ('Education')";
        insertOrUpdateDatabase();
        strQuery = "INSERT OR REPLACE INTO cat_details (cname) VALUES ('Travelling')";
        insertOrUpdateDatabase();
            
        NSUserDefaults.standardUserDefaults().setBool(true, forKey:"insert");
        }
    }
    
    func getCatId() -> Int
    {
        var cid = -1;
        DBOpen();
        var statement:COpaquePointer = nil
        if sqlite3_prepare_v2(database, strQuery, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                cid = Int(sqlite3_column_int(statement, 0))
                print(cid);
            }
            sqlite3_finalize(statement)
        }
        DBClose();
        return cid;
    }
    
    func getCountOfAudioAndVideo() -> Int
    {
        var count = 0;
        DBOpen();
        var statement:COpaquePointer = nil
        if sqlite3_prepare_v2(database, strQuery, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                count++;
            }
            sqlite3_finalize(statement)
        }
        DBClose();
        return count;
    }
    
    func saveImagePathToDatabase()
    {
        self.insertOrUpdateDatabase();
    }

    
    func getImageOrAudioPath() -> [String]
    {
        var Array : [String] = [String]();
        DBOpen();
        var statement:COpaquePointer = nil
        if sqlite3_prepare_v2(database, strQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let path = sqlite3_column_text(statement, 0)
                
                let pathString = String.fromCString(UnsafePointer<CChar>(path))
                
                Array.append(pathString!);
                //print("Fname : \(cnameString!)");
                
            }
            sqlite3_finalize(statement)
        }
        DBClose();
        
        return Array;
    }
    
    func saveAudioPathToDatabase()
    {
        self.insertOrUpdateDatabase();
    }
}