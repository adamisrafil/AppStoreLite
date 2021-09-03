//
//  FilterView.swift
//  IBM
//
//  Created by Adam Israfil on 9/1/21.
//

import Foundation
import UIKit

protocol FilterViewDelegate: AnyObject {
    func didPressBackButton(_ filterView: FilterView)
    func didPressFilterButton(genreFilter: GenresFilters, priceFilter: AppPriceFilter)
    // func didPressResetFilterButton()
}

class FilterView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Public
    
    override init(frame: CGRect) {
        filterViewFrame = frame
        super.init(frame: filterViewFrame)
        
        setupViews()
        backButton.layer.cornerRadius = backButton.frame.height / 2
        filterButton.layer.cornerRadius = filterButton.frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: FilterViewDelegate?
    private var filterViewFrame: CGRect!
    
    // MARK: UIPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var components = 0
        if pickerView == genrePickerView {
            components = GenresFilters.count
        } else if pickerView == pricePickerView {
            components = AppPriceFilter.count
        }
        
        return components
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title: String?
        if pickerView == genrePickerView {
            title = GenresFilters(rawValue: row)?.description;
        } else if pickerView == pricePickerView {
            title = AppPriceFilter(rawValue: row)?.description;
        }
        
        return title
    }
    
    // MARK: Private
    
    // MARK: Actions
    
    @objc private func didPressBackButton() {
        delegate?.didPressBackButton(self)
    }
    
    @objc private func didPressFilterButton() {
        guard let genre = GenresFilters(rawValue: genrePickerView.selectedRow(inComponent: 0)),
              let price = AppPriceFilter(rawValue: pricePickerView.selectedRow(inComponent: 0)) else { return }
        
        delegate?.didPressFilterButton(genreFilter: genre, priceFilter: price)
    }
    
    // MARK: Views
    
    private var backButton: UIButton!
    private var genrePickerView: UIPickerView!
    private var pricePickerView: UIPickerView!
    private var filterButton: UIButton!
    
    private func setupViews() {
        
        self.backgroundColor = #colorLiteral(red: 0.09562460333, green: 0, blue: 0.3830236197, alpha: 1)
        self.layer.cornerRadius = 5
        let backButtonTextSize: CGFloat = 15.0
        
        backButton = UIButton()
        backButton.addTarget(self, action: #selector(didPressBackButton), for: .touchUpInside)
        backButton.setTitle("X", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: backButtonTextSize, weight: .bold)
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.borderWidth = 1
        self.addSubview(backButton)
        
        let backButtonTitleSize = (backButton.currentTitle! as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: backButtonTextSize)])
        backButton.frame = CGRect(x: 5, y: 5, width: backButtonTitleSize.height * 1.5, height: backButtonTitleSize.height * 1.5)
        
        filterButton = UIButton()
        filterButton.addTarget(self, action: #selector(didPressFilterButton), for: .touchUpInside)
        filterButton.setTitle("Filter", for: .normal)
        filterButton.setTitleColor(.white, for: .normal)
        filterButton.titleLabel?.font = UIFont.systemFont(ofSize: backButtonTextSize, weight: .bold)
        filterButton.layer.borderColor = UIColor.white.cgColor
        filterButton.layer.borderWidth = 1
        self.addSubview(filterButton)
        
        let filterButtonTitleSize = (filterButton.currentTitle! as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: backButtonTextSize)])
        let yPos = (self.frame.height - filterButtonTitleSize.height * 1.5) - 5
        filterButton.frame = CGRect(x: 5, y: yPos, width: filterButtonTitleSize.width * 1.5, height: filterButtonTitleSize.height * 1.5)
        
        let genreLabel = UILabel(frame: CGRect(x: 5, y: backButton.frame.maxY + 10, width: filterViewFrame.width, height: 18))
        genreLabel.text = "Genre:"
        self.addSubview(genreLabel)
        
        genrePickerView = UIPickerView(frame: CGRect(x: 5, y: genreLabel.frame.maxY + 5, width: filterViewFrame.width, height: filterViewFrame.height * 0.4))
        genrePickerView.dataSource = self
        genrePickerView.delegate = self
        self.addSubview(genrePickerView)
        
        let priceLabel = UILabel(frame: CGRect(x: 5, y: genrePickerView.frame.maxY + 10, width: filterViewFrame.width, height: 18))
        priceLabel.text = "Price:"
        self.addSubview(priceLabel)
        
        pricePickerView = UIPickerView(frame: CGRect(x: 5, y: priceLabel.frame.maxY + 5, width: filterViewFrame.width, height: filterViewFrame.height * 0.2))
        pricePickerView.dataSource = self
        pricePickerView.delegate = self
        self.addSubview(pricePickerView)
    }
}
