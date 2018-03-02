//
//  LyricsViewController.swift
//  FindMyTunes
//
//  Created by Portia Sharma on 2/13/18.
//  Copyright © 2018 Portia Sharma. All rights reserved.
//

import UIKit

class LyricsViewController: UIViewController, LyricsViewDelegate {
    
        @IBOutlet weak var songLyricsTextView: UITextView!
        @IBOutlet weak var shareButton: UIBarButtonItem!
        @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
        var selectedTrack = String()
        var selectedArtist = String()
        var lyricsModel = MusicSearchModel()
        
        //setup activity indicator and delegate
        override func viewDidLoad() {
            super.viewDidLoad()
            self.activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            // Do any additional setup after loading the view.
            songLyricsTextView.isScrollEnabled = true
            songLyricsTextView.isEditable = false
            lyricsModel.lyricsDelegate = self
        }
        
        //bring Image from URL
        override func viewDidAppear(_ animated: Bool) {
            //print("\nLyrics are here")
            lyricsModel.lyricsAPI(artist: selectedArtist, song: selectedTrack)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    
    func updateTextView() {
        DispatchQueue.main.async(execute: {
            self.songLyricsTextView.text = self.lyricsModel.lyricsForTrack
            self.activityIndicator.stopAnimating()
        })
    }

    
    
    }

