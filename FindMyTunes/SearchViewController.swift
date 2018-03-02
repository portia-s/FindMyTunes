//
//  SearchViewController.swift
//  FindMyTunes
//
//  Created by Portia Sharma on 2/13/18.
//  Copyright © 2018 Portia Sharma. All rights reserved.
//

import UIKit



class SearchViewController: UIViewController, UISearchBarDelegate, MusicSearchDelegate {
    
    
    @IBOutlet weak var musicDetailTableView: UITableView!
    var searchController: UISearchController!
    
    //passed onto LyricsVC for lyrics of the song
    var selectedIndex = Int()
    
    //instance to access model for URLSessin & JSON Parsing
    var vcModel = MusicSearchModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // searchController to use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Music Search"
        //create searchBar in NavBar
        self.navigationItem.titleView = searchController.searchBar       
        searchController.hidesNavigationBarDuringPresentation = false
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        
        //Recustomize* cursor in searchBar textField from white to gray
        let view: UIView = self.searchController.searchBar.subviews[0]
        let subViewsArray = view.subviews
        
        for subView in subViewsArray {
            if subView.isKind(of: UITextField.self) {
                subView.tintColor = UIColor.lightGray
            }
        }
        
        //setting self tableView datasource and delegate
        musicDetailTableView.dataSource = self
        musicDetailTableView.delegate = self
        //setting self to be model's delegate
        vcModel.musicDelegate = self 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helper functions
    
    //initialize url arrays & initiate photo search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text {
            if !searchText.isEmpty {
                vcModel.kind = [String]()
                vcModel.artistName = [String]()
                vcModel.collectionName = [String]()
                vcModel.trackName = [String]()
                vcModel.artworkUrl100 = [String]()
                vcModel.iTunesSearchAPI(searchString: searchText, offset: vcModel.artistName.count)
            }
        }
    }
    
    func updateTableView() {
        DispatchQueue.main.async(execute: {
            self.musicDetailTableView.reloadData()
        })
    }
    
    //pass selected track url to detailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLyrics" {
            let nextVC = segue.destination as! LyricsViewController
            nextVC.selectedTrack = vcModel.trackName[selectedIndex]
            nextVC.selectedArtist = vcModel.artistName[selectedIndex]
        }
    }

}

// MARK: Tableview datasource and delegate functions

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vcModel.artistName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let myCell = tableView.dequeueReusableCell(withIdentifier: "tvCell", for: indexPath) as! MusicDetailTableViewCell
        myCell.musicArtworkImageView.bringArtworkFromUrl(url: NSURL(string: vcModel.artworkUrl100[indexPath.row]))
        myCell.musicTrackNameLabel.text = vcModel.trackName[indexPath.row]      //"TRACK name goes here"
        myCell.musicArtistNameLabel.text = vcModel.artistName[indexPath.row]     //"ARTIST name goes here"
        myCell.musicAlbumNameLabel.text = vcModel.collectionName[indexPath.row]      //"ALBUM name goes here"
        //reFetch next set of urls as collectionView usesup* current set of images
        if vcModel.artistName.count - 1 <= indexPath.row {
            vcModel.iTunesSearchAPI(searchString: searchController.searchBar.text!, offset: vcModel.artistName.count)
        }
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        vcModel.lyricsAPI(artist: vcModel.artistName[selectedIndex], song: vcModel.trackName[selectedIndex])
        performSegue(withIdentifier: "toLyrics", sender: self)
    }
    
}



