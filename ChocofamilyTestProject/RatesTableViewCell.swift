//
//  RatesTableViewCell.swift
//  ChocofamilyTestProject
//
//  Created by Khaled on 21.06.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import UIKit

class RatesTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var countryCurrency: UILabel!
    @IBOutlet weak var moneyTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //rounding corner of image
        countryImage.layer.cornerRadius = countryImage.frame.size.width/2.0
        //setting up numerical keyboard, instead of regular one
        moneyTextField.keyboardType = .decimalPad
        
        //underline of textfield
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: moneyTextField.frame.size.height - width, width:  moneyTextField.frame.size.width, height: moneyTextField.frame.size.height)
        border.borderWidth = width
        moneyTextField.layer.addSublayer(border)
        moneyTextField.layer.masksToBounds = true
    }

    //setting up content of a cell
    func update(image: UIImage, code: String, currency: String, money: String){
        countryImage.image = image
        countryCode.text = code
        countryCurrency.text = currency
        moneyTextField.text = money
    }

}
