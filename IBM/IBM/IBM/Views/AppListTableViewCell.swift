//
//  AppListTableViewCell.swift
//  IBM
//
//  Created by Adam Israfil on 9/1/21.
//

import Foundation
import UIKit

class AppListTableViewCell: UITableViewCell {
    
    // MARK: UITableViewCell
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupCells()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        iconImage.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: Public
    
    func populate(_ model: iTunesSearchResultModel) {
        nameLabel.text = model.trackName
        
        guard let IconURL = URL(string: model.artworkUrl60) else { return }
        downloadImage(from: IconURL)
    }
    
    // MARK: Private
    
    private func downloadImage(from url: URL) {
        iTunesAPIManager().getImageData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() { [weak self] in
                self?.iconImage.image = UIImage(data: data)
                
            }
        }
    }
    
    // MARK: Views
    
    private var nameLabel: UILabel!
    private var iconImage: UIImageView!
    
    private func setupCells() {
        contentView.clipsToBounds = true
        
        iconImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 60, height: 60))
        iconImage.contentMode = .scaleAspectFill
        iconImage.clipsToBounds = true
        contentView.addSubview(iconImage)
        
        nameLabel = UILabel(frame: CGRect(x: iconImage.frame.maxX + 10, y: 0, width: contentView.frame.width * 0.75, height: 60))
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)
    }
}
