//
//  SearchViewController.swift
//
//
//  Created by i-Verve on 20/04/21.
//

import UIKit
import GooglePlaces

protocol SearchViewControllerDelegate {
    func searched(viewController: UIViewController, text: String, latitude: Double?, longitude: Double?, venueId: Int?) -> Void
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GMSAutocompleteFetcherDelegate{

    //MARK: - Outlet variable
    @IBOutlet weak var textSearch: UITextField!{
        didSet{
            textSearch.tintColor = .black
            textSearch.backgroundColor = .white
            textSearch.autocorrectionType = .no
            textSearch.font =  UIFont.Font_WorkSans_Regular(fontsize: 17)
            textSearch.becomeFirstResponder()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonCancel: UIButton!{
        didSet{
            buttonCancel.setTitleColor(.black, for: .normal)
            buttonCancel.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
        }
    }
    
    //MARK: - Local variables
    var delegate: SearchViewControllerDelegate?
    var searchVM = SearchVM()
    var needSuburb = false
    
    //MARK: - btn Click
    @IBAction func buttonCancel(_ sender: UIButton) {
        textSearch.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonCancel.setTitle(searchVM.cancel, for: .normal)

        textSearch.text = searchVM.searchedText
        textSearch.placeholder = needSuburb ? "Search Suburb" : "Search Address"

        tableView.tableFooterView = UIView()

        let filter = GMSAutocompleteFilter()
        if needSuburb{
            filter.type = .city
        }
        else{
            filter.type = .address
        }
        filter.country = "AU"

        searchVM.fetcher = GMSAutocompleteFetcher(filter: filter)
        searchVM.fetcher.provide(GMSAutocompleteSessionToken())
        searchVM.fetcher.delegate = self

        searchVM.placesClient = GMSPlacesClient.shared()

        textSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        textFieldDidChange(textField: textSearch)
    }
    
    //MARK: - tbl delegate/datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchVM.places.count > 0 ? searchVM.places.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.configure(searchTableVM: searchVM.getData(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if !searchVM.searchedText.isEmpty {
            guard searchVM.places.count > 0 else { return }
            let item = searchVM.places[indexPath.row]
            searchVM.placesClient.fetchPlace(fromPlaceID: item.placeID, placeFields: GMSPlaceField.init(rawValue: GMSPlaceField.name.rawValue | GMSPlaceField.coordinate.rawValue) , sessionToken: nil) { (place, error) in
                if let error = error {
                    showAlertWith(message: error.localizedDescription, inView: self)
                }
                else if let place = place {
                    if self.needSuburb{
                        self.searchVM.searchedText = self.searchVM.places[indexPath.row].attributedPrimaryText.string
                    }
                    else{
                        self.searchVM.searchedText = self.searchVM.places[indexPath.row].attributedFullText.string
                    }
                    self.delegate?.searched(viewController: self, text: self.searchVM.searchedText, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, venueId: nil)
                }
                else {
                    print("Error...")
                }
            }
        }
    }
    
    //MARK: - txt delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textSearch.resignFirstResponder()
        return true
    }
    
    //MARK: - GMSAutocompleteFetcherDelegate
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]){
        searchVM.places = predictions
        tableView.reloadData()
    }

    func didFailAutocompleteWithError(_ error: Error){
        print(error.localizedDescription)
    }

    // MARK: - CustomMethods
    @objc private func textFieldDidChange(textField: UITextField) -> Void{
        searchVM.searchedText = textField.text ?? searchVM.empty
        searchVM.fetcher.sourceTextHasChanged(searchVM.searchedText)
    }
}
