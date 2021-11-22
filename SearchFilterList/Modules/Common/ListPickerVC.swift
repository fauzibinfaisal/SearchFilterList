//
//  ListPickerVC.swift
//  SearchFilterList
//
//  Created by Infotech Solutions on 22/11/21.
//

import UIKit

enum PickerType {
    case hospital
    case specialization
}

class ListPickerVC: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Required
    var pickerType: PickerType?
    var callbackButton : ((Any?) -> Void)?
    
    var titlePicker = ""
    var hospitalList: [Hospital] = []
    var specializationList: [Specialization] = []
    
    var SelectedItem: Any?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGesture()
    }

    //MARK: Setup and register view
    func setupView(){
        tableView.register(UINib.init(nibName: "ListPickerCell", bundle: Bundle(for: ListPickerCell.self)), forCellReuseIdentifier: "ListPickerCell")

        pickerView.setDefaultCornerRadius()
        selectButton.setDefaultBorderButton()
        titleLabel.text = titlePicker
    }
    
    //MARK: Setup Gestures
    func setupGesture(){
        let bgTap = UITapGestureRecognizer(target: self, action: #selector(self.bgTappad))
        bgView.isUserInteractionEnabled = true
        bgView.addGestureRecognizer(bgTap)
    }
    
    @objc func bgTappad(){
        dismiss(animated: true, completion: nil)
    }

    @IBAction func selectButtonTapped(_ sender: Any) {
        
    }
}


//MARK: Table View
extension ListPickerVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch pickerType {
        case .hospital:
            return hospitalList.count
        case .specialization:
            return specializationList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListPickerCell", for: indexPath) as! ListPickerCell
        
        var itemName = ""
        switch pickerType {
        case .hospital:
            itemName = hospitalList[indexPath.row].name
        case .specialization:
            itemName = specializationList[indexPath.row].name
        default:
            break
        }
        
        cell.itemLabel.text = itemName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch pickerType {
        case .hospital:
            let item = hospitalList[indexPath.row]
            SelectedItem = item
        case .specialization:
            let item = specializationList[indexPath.row]
            SelectedItem = item
        default:
            break
        }
        
        dismiss(animated: true, completion: nil)
        callbackButton?(SelectedItem)
    }
}

