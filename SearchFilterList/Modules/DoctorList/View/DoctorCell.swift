//
//  DoctorCell.swift
//  SearchFilterList
//
//  Created by Infotech Solutions on 22/11/21.
//

import UIKit

class DoctorCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var HospitalSpecializationLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    //MARK: Binding Doctor to Cell View
    var doctor: Doctor? = nil {
        didSet{
            nameLabel.text = doctor?.name
            HospitalSpecializationLabel.text = " \(doctor?.hospital.first?.name ?? "") - \(doctor?.specialization.name ?? "")"
            priceLabel.text = doctor?.price.formatted
            aboutLabel.attributedText = doctor?.aboutPreview.htmlToAttributedString
            aboutLabel.lineBreakMode = .byTruncatingTail
            aboutLabel.textColor = UIColor.label
            photoImageView.downloaded(from: doctor?.photo.formats.thumbnail ?? " ")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
   func setupView(){
       photoImageView.setDefaultCornerRadius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
