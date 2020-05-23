//
//  SearchViewController.swift
//  TalentedApp
//
//  Created by jess on 5/4/20.
//  Copyright © 2020 giotech. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import AVFoundation
import CoreData

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    var dataTask: URLSessionDataTask? // optional because I won't have a datatask until user performs a search
    var soundID: SystemSoundID = 0
    var audioPlayer = AVAudioPlayer()
    var managedObjectContext: NSManagedObjectContext!
    let player = AudioManager.sharedInstance
    var jobSearchLocation: String = ""


    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cellNib = UINib(nibName: TableView.CellIdentifier.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifier.searchResultCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifier.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifier.nothingFoundCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifier.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifier.loadingCell)
        
        searchBar.becomeFirstResponder()
        
        UITabBar.appearance().tintColor = UIColor(named: "accentColor")
        
        
                
       }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("First tab")
        if (UserDefaults.standard.string(forKey: "Location") == nil ){
            jobSearchLocation = "CA"
        } else {
        jobSearchLocation = UserDefaults.standard.string(forKey: "Location")!
        }
        print(UserDefaults.standard.string(forKey: "Location") as Any)
    }
    struct TableView {
        struct CellIdentifier {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    
    //MARK :- Helper Methods
    func jobSearchURL(searchText: String) -> URL
    {
        // allows special characters to be escaped
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://jobs.github.com/positions.json?description=%@&location=\(jobSearchLocation)", encodedText)
        let url = URL(string: urlString)!
        return url
    }


    // JSON parser
    func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode([SearchResult].self, from: data) //include [] for array
            return result
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the jobs. " + "Please Try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    // invoked when user taps search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //disable keyboard
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            dataTask?.cancel()
            isLoading = true
            tableView.reloadData() // to show activity indicator
            hasSearched = true

            // new search results each time -> previous search results are thrown away and deallocated
            searchResults = []
            
            let url = jobSearchURL(searchText: searchBar.text!)
            
            let session = URLSession.shared //MARK:- use of Singleton Pattern
            // data taska re for fetching contents of given url
            dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
                if let error = error as NSError?, error.code == -999 || error.code == 503 {
                    return
                }else if  let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        self.searchResults = self.parse(data: data)
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.tableView.reloadData()
                            self.player.playAudio(fileName: "done", fileType: "wav")
                            
                        }
                        
                        return
                    }
                }
                else {
                    print("Failure! \(response!)")
                }
                
                DispatchQueue.main.async {
                    self.hasSearched = false
                    self.isLoading = false
                    self.tableView.reloadData()
                    self.showNetworkError()
                }
            })
            // sends request to server
            dataTask?.resume()
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    //MARK:- SOUND EFFECT
    // this function loads sound file and puts it in a new sound object
    // MARK:- Sound effects
    func loadSoundEffect(_ name: String) {
      if let path = Bundle.main.path(forResource: name, ofType: nil) {
        let fileURL = URL(fileURLWithPath: path, isDirectory: false)
        let error = AudioServicesCreateSystemSoundID(fileURL as CFURL, &soundID)
        if error != kAudioServicesNoError {
          print("Error code \(error) loading sound: \(path)")
        }
      }
    }
    
    func unloadSoundEffect() {
      AudioServicesDisposeSystemSoundID(soundID)
      soundID = 0
    }
    
    func playSoundEffect() {
      AudioServicesPlaySystemSound(soundID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! SecondViewController
        controller.managedObjectContext = managedObjectContext
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
        return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifier.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        }
        
        if searchResults.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifier.nothingFoundCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifier.searchResultCell, for: indexPath) as! SearchResultCell
            let searchResult = searchResults[indexPath.row]
            cell.configure(for: searchResult)
            
            cell.selectionStyle = .none
                       
            // Check if job already exists in saved list
//            if checkRecordExists(companyAttribute: searchResult.company!, positionAttribute: searchResult.title!) {
//                // if so -> change the color of the bookmark and disable touch button
//                cell.saveButton.isSelected = true
//            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
    
//    func checkRecordExists(companyAttribute:String, positionAttribute:String) -> Bool {
//        let context = managedObjectContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "JobInfo")
//        fetchRequest.predicate = NSPredicate(format: "company == %@ AND position== %@", companyAttribute, positionAttribute)
//
//        var results: [NSManagedObject] = []
//
//        do {
//            results = try (context?.fetch(fetchRequest))!
//        }
//        catch {
//            print("error executing fetch request: \(error)")
//        }
//
//        print(results.count)
//        return results.count > 0
//
//    }
    
    
}

