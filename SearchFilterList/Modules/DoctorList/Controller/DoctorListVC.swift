//
//  DoctorListVC.swift
//  SearchFilterList
//
//  Created by Infotech Solutions on 22/11/21.
//

import UIKit

class DoctorListVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var hospitalPickerView: UIView!
    @IBOutlet weak var SpecializePickerView: UIView!
    @IBOutlet weak var hospitalLabel: UILabel!
    @IBOutlet weak var SpecializationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var hospitalList: [Hospital] = []
    var specializationList: [Specialization] = []
    
    //Doctors Data
    var doctorList: [Doctor] = []
    var doctorListShown: [Doctor] = []
    
    //Selected Filter
    var hospital: Hospital?
    var specialization: Specialization?
    
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestures()
        title = "Doctor List"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }
    
    //MARK: Setup View decoration and register view
    func setupView(){
        tableView.register(UINib.init(nibName: "DoctorCell", bundle: nil), forCellReuseIdentifier: "DoctorCell")
        searchBar.delegate = self
        hospitalPickerView.setDefaultCornerRadius()
        SpecializePickerView.setDefaultBorderButton()
    }
    
    
    //MARK: View Gestures Setup
    func setupGestures(){
        let hospitalGesture = UITapGestureRecognizer(target: self, action: #selector(self.showHospitals))
        hospitalPickerView.isUserInteractionEnabled = true
        hospitalPickerView.addGestureRecognizer(hospitalGesture)
        
        let spesializationGesture = UITapGestureRecognizer(target: self, action: #selector(self.showSpecializations))
        SpecializePickerView.isUserInteractionEnabled = true
        SpecializePickerView.addGestureRecognizer(spesializationGesture)    }
    
    //MARK: Setup Data - Fetch Data needed
    func setupData(){
        showProgressDialog(show: true)
        let fetchDataGroup = DispatchGroup()
        fetchDoctors(dipatchGroup: fetchDataGroup)
        fetchDataGroup.notify(queue: DispatchQueue.main, execute: {
            self.showProgressDialog(show: false)
        })
    }
    
    
    //MARK: Update Filter View and Doctor List
    func updateData(){
        if let hospital = hospital {
            hospitalLabel.text = hospital.name
            hospitalLabel.textColor = UIColor(named: "Accent")
        }
        if let specialization = specialization {
            SpecializationLabel.text = specialization.name
            SpecializationLabel.textColor = UIColor(named: "Accent")
        }
        
        updateDoctorList(searchText: searchBar.text ?? "")
        
    }

    //MARK: Fetch Doctor List
    func fetchDoctors(dipatchGroup: DispatchGroup){
        dipatchGroup.enter()
        DoctorsRequest().getDoctorLists { [weak self](response) in
            dipatchGroup.leave()
            if response.status, response.data?.data != nil {
                self?.doctorList = (response.data?.data)!
                self?.doctorListShown = (response.data?.data)!
                self?.hospitalList = self?.doctorList.map { $0.hospital.first!} ?? []
                self?.specializationList = self?.doctorList.map { $0.specialization } ?? []
                DispatchQueue.main.async {
                    print("new hospital list")
                    dump(self?.hospitalList)
                    dump(self?.specializationList)
                    self?.tableView.reloadData()
                }
            } else {
                self?.onRequestFailed(message: response.message)
            }
        }
    }
    
    //MARK: Show Hospital Picker
    @objc func showHospitals(){
        //Remove duplicate
        hospitalList = hospitalList.unique {$0.id == $1.id }

        let vc = ListPickerVC(nibName: "ListPickerVC", bundle: nil)
        vc.titlePicker = "Select a Hospital"
        vc.pickerType = .hospital
        vc.hospitalList = hospitalList
        vc.callbackButton = { [weak self] item in
            
            self?.hospital = item as? Hospital
            self?.updateData()

        }
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: Show Specialization Picker
    @objc func showSpecializations(){
        //Remove duplicate
        specializationList = specializationList.unique {$0.id == $1.id}

        let vc = ListPickerVC(nibName: "ListPickerVC", bundle: nil)
        vc.titlePicker = "Select a Spesialization"
        vc.pickerType = .specialization
        vc.specializationList = specializationList
        vc.callbackButton = { [weak self] item in
            
            self?.specialization = item as? Specialization
            self?.updateData()

        }
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: Progress Dialog Toggle
    func showProgressDialog(show: Bool){
        DispatchQueue.main.async {
            if(show) {
                ProgressDialog.shared.show(view: self.view)
            } else {
                ProgressDialog.shared.hide()
            }
        }
    }
    
    //MARK: Show Error Message
    func showErrorMessage(message: String){
        DispatchQueue.main.async {
            Utils.shared.showAlert("Failed", message: message, parent: self)
        }
    }
    
    //MARK: Show Request Failed Message
    func onRequestFailed(message: String) {
        showProgressDialog(show: false)
        showErrorMessage(message: message)
        print("error : \(message)")
        isLoading = false
    }
}

//MARK: SearchBar Delegate
extension DoctorListVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateDoctorList(searchText: searchText)
    }
    
    func updateDoctorList(searchText: String){
        doctorListShown = searchText.isEmpty ? doctorList : doctorList.filter({(dataString: Doctor) -> Bool in
            return dataString.name.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        doctorListShown = hospital != nil ? doctorListShown.filter{$0.hospital.contains(where: { element in element.id == hospital!.id})} : doctorListShown
        doctorListShown = specialization != nil ? doctorListShown.filter{$0.specialization.id == specialization!.id} : doctorListShown
        tableView.reloadData()
    }
}
    
//MARK: TableView Doctor List
extension DoctorListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorListShown.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for: indexPath) as! DoctorCell
        cell.doctor = doctorListShown[indexPath.row]
        return cell
    }
    
    
}

