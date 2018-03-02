//
//  Model.swift
//  FindMyTunes
//
//  Created by Portia Sharma on 2/13/18.
//  Copyright © 2018 Portia Sharma. All rights reserved.
//

import Foundation

//Delegate SearchViewController to update the tableView when images have finished downloading
protocol MusicSearchDelegate: class {
    func updateTableView()
}

//Delegate LyricsViewController to update the textView when lyrics have finished downloading
protocol LyricsViewDelegate: class {
    func updateTextView()
}

class MusicSearchModel {
    
    // arrays to store music details
    var kind = [String]()
    var artistName = [String]()
    var collectionName = [String]()
    var trackName = [String]()
    var artworkUrl100 = [String]()
    var lyricsForTrack = String()
    
    weak var musicDelegate : MusicSearchDelegate?
    weak var lyricsDelegate : LyricsViewDelegate?
    
    //iTunes searched then JSONSerialized to get music details arrayed
    func iTunesSearchAPI(searchString: String, offset: Int) {
        //NSURLSession
        if !searchString.isEmpty {
            //create requestUrl with query parameters: user's search string and offset to take care of which set of 35 songs
            let urlTemp = "https://itunes.apple.com/search?term=\(searchString)&offset=\(offset)"
            //replace spaces in search string with %
            let url = urlTemp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let request = URLRequest(url: URL(string: url!)!)
            
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate:nil,
                delegateQueue:OperationQueue.main
            )
            
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let requestError = error {
                    print(requestError.localizedDescription)
                }
                else {
                    if data != nil {
                        self.extractDataFromResponse(data: data!)
                    }
                }
            })
            task.resume()
        }
    }
    
    //Parsing JSON to extract the details and delegate ViewController to update tableView
    func extractDataFromResponse(data: Data) {
        if let itemDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary  {
            if let results = itemDictionary["results"] as? [NSDictionary] {
                for result in results {
                    if let artist = result["artistName"] as? String {
                        artistName.append(artist)
                    } else {
                        artistName.append("")
                    }
                    if let collection = result["collectionName"] as? String {
                        collectionName.append(collection)
                    } else {
                        collectionName.append("")
                    }
                    if let track = result["trackName"] as? String {
                        trackName.append(track)
                    } else {
                        trackName.append("")
                    }
                    if let artworkUrl = result["artworkUrl100"] as? String {
                        artworkUrl100.append(artworkUrl)
                    } else {
                        artworkUrl100.append("")
                    }
                }
            }
        }
        musicDelegate?.updateTableView()
    }

    func lyricsAPI(artist: String, song: String) {
        //NSURLSession
        if !artist.isEmpty {
            let urlTemp = "http://lyrics.wikia.com/api.php?func=getSong&artist=\(artist)&song=\(song)&fmt=json"
            //replace spaces in search string with %
            let url = urlTemp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let request = URLRequest(url: URL(string: url!)!)
            
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate:nil,
                delegateQueue:OperationQueue.main
            )
            
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let requestError = error {
                    print(requestError.localizedDescription)
                }
                else {
                    if data != nil {
                        self.extractLyricsUrlFromResponse(data: data!)
                    }
                }
            })
            task.resume()
        }
    }

    //Parsing JSON to extract the lyrics Url
    func extractLyricsUrlFromResponse(data: Data) {
        var dataSplit1 = data
        dataSplit1.removeFirst()    //remove space
        dataSplit1.removeFirst()    //remove space
        dataSplit1.removeFirst()    //remove space
        dataSplit1.removeFirst()    //remove space
        dataSplit1.removeFirst()    //remove space
        dataSplit1.removeFirst()    //remove space
        dataSplit1.removeFirst()    //remove space
        let jsonData = dataSplit1 as Data
        //print(jsonData)
        
        let jsonResult = String(data: jsonData, encoding: .utf8)    //stringing as text
        let jsonDecodedString1 = jsonResult
        let jsonDecodedString2 = jsonDecodedString1?.replacingOccurrences(of: "'", with:"\"")   //
        //print(jsonDecodedString2!)
        let data1 = jsonDecodedString2?.data(using: .utf8)
        do {
            if let json = try JSONSerialization.jsonObject(with: data1!, options: []) as? [String: String] {
                if let lyrics = json["lyrics"] as? String {
                    lyricsForTrack = lyrics
                    print("\n\n lets see what lyrics are : \n\n" + lyrics)
                }
                else {
                    lyricsForTrack = "No lyrics found for this track."
                }
            }
        } catch let error {
            lyricsForTrack = "json error: \(error.localizedDescription)"
            print("json error: \(error.localizedDescription)")
        }
        
        lyricsDelegate?.updateTextView()
    }

    
}
