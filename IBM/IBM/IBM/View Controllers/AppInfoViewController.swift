//
//  AppInfoViewController.swift
//  IBM
//
//  Created by Adam Israfil on 8/31/21.
//

import Foundation
import UIKit

class AppInfoViewController: UIViewController {
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        updateAppDetailLabels()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateViews()
    }
    
    init(_ model: iTunesAppModel) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private var model: iTunesAppModel
    private var appScreenshots = [UIImage?]()
    private var currentImageIndex = 0
    
    private func updateAppDetailLabels() {
        
        titleLabel.text = model.trackName
        descriptionLabel.text = "\(model.description)"
        appCreatorLabel.text = "Creator: \(model.artistName)"
        genresLabel.text = "Genres: \(model.genres.joined(separator: ", "))"
        advisoriesLabel.text = "Advisories: \(model.advisories.joined(separator: ", "))"
        ageRecommendationLabel.text = "Recommended For: \(model.contentAdvisoryRating)"
        let appSizeWithUnit = ByteCountFormatter.string(fromByteCount: Int64(model.fileSizeBytes) ?? 0, countStyle: .file)
        appSizeLabel.text = "Size: \(appSizeWithUnit)"
        versionLabel.text = "Version: \(model.version)"
        priceLabel.text = "Price: \(model.formattedPrice)"
        minimumOSVersionLabel.text = "Minimum iOS Version: \(model.minimumOsVersion)"
        let supportedDevices = model.supportedDevices.filter({
            $0.contains("iPhone")
        })
        supportedDevicesLabel.text = "Supported Devices: \(supportedDevices.reversed().joined(separator: ", "))" // Show newer devices first
        ratingLabel.text = "Rating: \(String(format: "%.2f", model.averageUserRatingForCurrentVersion)) in \(model.userRatingCountForCurrentVersion) Reviews"
        
        if let iconURL = URL(string: model.artworkUrl60) {
            downloadIconImage(from: iconURL)
        } else {
            appIconImageView.isHidden = true
        }
        
        getAppScreenShots()
    }
    
    private func getAppScreenShots() {
        // Potential Improvements: 1. Batch download app screenshots 2. only load screenshots as they are needed
        
        for url in model.screenshotUrls {
            guard let url = URL(string: url) else { return }
            
            downloadAppScreenshotImages(from: url)
        }
    }
    
    private func downloadAppScreenshotImages(from url: URL) {
        iTunesAPIManager().getImageData(from: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            self?.appScreenshots.append(UIImage(data: data))
            
            DispatchQueue.main.async() { [weak self] in
                if self?.appScreenshotImageView.image == nil {
                    self?.appScreenshotImageView.image = UIImage(data: data)
                    self?.currentImageIndex = 0
                }
            }
        }
    }
    
    private func downloadIconImage(from url: URL) {
        iTunesAPIManager().getImageData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() { [weak self] in
                self?.appIconImageView.image = UIImage(data: data)
            }
        }
    }
    
    // MARK: Actions
    
    @objc private func didPressBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didPressPreviousImageButton() {
        if currentImageIndex == 0 {
            currentImageIndex = appScreenshots.count - 1
        } else {
            currentImageIndex -= 1
        }
        
        appScreenshotImageView.image = appScreenshots[currentImageIndex]
    }
    
    @objc private func didPressNextImageButton() {
        if currentImageIndex + 1 >= appScreenshots.count {
            currentImageIndex = 0
        } else {
            currentImageIndex += 1
        }
        
        appScreenshotImageView.image = appScreenshots[currentImageIndex]
    }
    
    // MARK: Views
    
    private var backButton: UIButton!
    private var titleLabel: UILabel!
    private var appIconImageView: UIImageView!
    private var appScreenshotImageView: UIImageView!
    private var bookTicketButton: UIButton!
    private var descriptionScrollView: UIScrollView!
    private var descriptionLabel: UITextView!
    private var appSizeLabel: UILabel!
    private var appCreatorLabel: UILabel!
    private var versionLabel: UILabel!
    private var genresLabel: UILabel!
    private var nextImageButton: UIButton!
    private var previousImageButton: UIButton!
    private var advisoriesLabel: UILabel!
    private var ageRecommendationLabel: UILabel!
    private var ratingLabel: UILabel!
    private var priceLabel: UILabel!
    private var minimumOSVersionLabel: UILabel!
    private var appInfoScrollView: UIScrollView!
    private var appInfoStackView: UIStackView!
    private var supportedDevicesLabel: UILabel!
    
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        
        let backButtonTextSize: CGFloat = 20.0
        
        view.backgroundColor = .clear
        view.clipsToBounds = true
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        container.backgroundColor = #colorLiteral(red: 0.04631470889, green: 0, blue: 0.1507385969, alpha: 1)
        view.addSubview(container)
        
        backButton = UIButton()
        backButton.addTarget(self, action: #selector(didPressBackButton), for: .touchUpInside)
        backButton.setTitle("X", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: backButtonTextSize, weight: .bold)
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.borderWidth = 1
        view.addSubview(backButton)
        
        let buttonTitleSize = (backButton.currentTitle! as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: backButtonTextSize)])
        backButton.frame = CGRect(x: 15, y: 40, width: buttonTitleSize.height * 1.5, height: buttonTitleSize.height * 1.5)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: backButton.frame.maxY + 5, width: container.frame.width, height: 25))
        titleLabel.text = "App Title "
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        container.addSubview(titleLabel)
        
        appIconImageView = UIImageView(frame: CGRect(x: container.frame.midX - 30, y: titleLabel.frame.maxY + 10, width: 60, height: 60))
        container.addSubview(appIconImageView)
        
        descriptionLabel = UITextView(frame: CGRect(x: 0, y: appIconImageView.frame.maxY + 10, width: container.frame.width, height: view.frame.height * 0.20))
        descriptionLabel.backgroundColor = #colorLiteral(red: 0.09562460333, green: 0, blue: 0.3830236197, alpha: 1).withAlphaComponent(0.95)
        descriptionLabel.layer.cornerRadius = 10
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .white
        descriptionLabel.isEditable = false
        container.addSubview(descriptionLabel)
        
        appInfoScrollView = UIScrollView(frame: CGRect(x: 0, y: descriptionLabel.frame.maxY + 10, width: container.frame.width, height: view.frame.height * 0.25))
        appInfoScrollView.backgroundColor = #colorLiteral(red: 0.09562460333, green: 0, blue: 0.3830236197, alpha: 1).withAlphaComponent(0.95)
        appInfoScrollView.layer.cornerRadius = 10
        container.addSubview(appInfoScrollView)
        
        appInfoStackView = UIStackView(frame: CGRect(x: 5, y: 5, width: appInfoScrollView.frame.width - 10, height: appInfoScrollView.frame.height * 2))
        appInfoStackView.alignment = .fill
        appInfoStackView.distribution = .equalSpacing
        appInfoStackView.axis = .vertical
        appInfoScrollView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        appInfoScrollView.addSubview(appInfoStackView)
        
        appInfoStackView.topAnchor.constraint(equalTo: appInfoScrollView.topAnchor).isActive = true
        appInfoStackView.leadingAnchor.constraint(equalTo: appInfoScrollView.leadingAnchor).isActive = true
        appInfoStackView.trailingAnchor.constraint(equalTo: appInfoScrollView.trailingAnchor).isActive = true
        appInfoStackView.bottomAnchor.constraint(equalTo: appInfoScrollView.bottomAnchor).isActive = true
        
        let appInfoHeaderSize:CGFloat = 15
        let appInfoSize:CGFloat = 13
        
        let generalInfoLabel = UILabel()
        generalInfoLabel.text = "General Info"
        generalInfoLabel.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        generalInfoLabel.font = UIFont.systemFont(ofSize: appInfoHeaderSize, weight: .semibold)
        appInfoStackView.addArrangedSubview(generalInfoLabel)
        
        genresLabel = UILabel()
        genresLabel.text = "Genres: "
        genresLabel.numberOfLines = 0
        genresLabel.textColor = .white
        genresLabel.font = UIFont.systemFont(ofSize: appInfoSize)
        appInfoStackView.addArrangedSubview(genresLabel)
        
        advisoriesLabel = UILabel()
        advisoriesLabel.text = "Advisories: "
        advisoriesLabel.numberOfLines = 0
        advisoriesLabel.textColor = .white
        advisoriesLabel.font = UIFont.systemFont(ofSize: appInfoSize)
        appInfoStackView.addArrangedSubview(advisoriesLabel)
        
        ageRecommendationLabel = UILabel()
        ageRecommendationLabel.text = "Recommended For: "
        ageRecommendationLabel.numberOfLines = 0
        ageRecommendationLabel.textColor = .white
        ageRecommendationLabel.font = UIFont.systemFont(ofSize: appInfoSize)
        appInfoStackView.addArrangedSubview(ageRecommendationLabel)
        
        ratingLabel = UILabel()
        ratingLabel.text = "Rating: "
        ratingLabel.numberOfLines = 0
        ratingLabel.textColor = .white
        ratingLabel.font = UIFont.systemFont(ofSize: appInfoSize)
        appInfoStackView.addArrangedSubview(ratingLabel)
        
        priceLabel = UILabel()
        priceLabel.text = "Price: "
        priceLabel.numberOfLines = 0
        priceLabel.textColor = .white
        priceLabel.font = UIFont.systemFont(ofSize: appInfoSize)
        appInfoStackView.addArrangedSubview(priceLabel)
        
        let creatorInfoLabel = UILabel()
        creatorInfoLabel.text = "Creator Info"
        creatorInfoLabel.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        creatorInfoLabel.font = UIFont.systemFont(ofSize: appInfoHeaderSize, weight: .semibold)
        appInfoStackView.addArrangedSubview(creatorInfoLabel)
        
        appCreatorLabel = UILabel()
        appCreatorLabel.text = "App Creator: "
        appCreatorLabel.textColor = .white
        appCreatorLabel.font = UIFont.systemFont(ofSize: appInfoSize)
        appInfoStackView.addArrangedSubview(appCreatorLabel)
        
        let technicalDividerLabel = UILabel()
        technicalDividerLabel.text = "Technical Info"
        technicalDividerLabel.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        technicalDividerLabel.font = UIFont.systemFont(ofSize: appInfoHeaderSize, weight: .semibold)
        appInfoStackView.addArrangedSubview(technicalDividerLabel)
        
        appSizeLabel = UILabel()
        appSizeLabel.text = "Size: "
        appSizeLabel.textColor = .white
        appSizeLabel.font = UIFont.systemFont(ofSize: appInfoSize)
        appInfoStackView.addArrangedSubview(appSizeLabel)
        
        versionLabel = UILabel()
        versionLabel.text = "Version: "
        versionLabel.textColor = .white
        versionLabel.font = UIFont.systemFont(ofSize: appInfoSize)
        appInfoStackView.addArrangedSubview(versionLabel)
        
        minimumOSVersionLabel = UILabel()
        minimumOSVersionLabel.text = "Minimum iOS Version: "
        minimumOSVersionLabel.textColor = .white
        minimumOSVersionLabel.font = UIFont.systemFont(ofSize: appInfoSize)
        appInfoStackView.addArrangedSubview(minimumOSVersionLabel)
        
        supportedDevicesLabel = UILabel()
        supportedDevicesLabel.text = "Supported Devices: "
        supportedDevicesLabel.textColor = .white
        supportedDevicesLabel.numberOfLines = 5
        supportedDevicesLabel.font = UIFont.systemFont(ofSize: appInfoSize)
        appInfoStackView.addArrangedSubview(supportedDevicesLabel)
        
        let screenshotHeight = container.frame.height - appInfoScrollView.frame.maxY
        appScreenshotImageView = UIImageView(frame: CGRect(x: container.frame.midX - ((screenshotHeight * 0.75) / 2), y: appInfoScrollView.frame.maxY + 10, width: screenshotHeight * 0.75, height: screenshotHeight))
        appScreenshotImageView.contentMode = .scaleAspectFit
        container.addSubview(appScreenshotImageView)
        
        previousImageButton = UIButton()
        previousImageButton.addTarget(self, action: #selector(didPressPreviousImageButton), for: .touchUpInside)
        previousImageButton.setTitle("<", for: .normal)
        previousImageButton.setTitleColor(.white, for: .normal)
        previousImageButton.titleLabel?.font = UIFont.systemFont(ofSize: backButtonTextSize, weight: .bold)
        previousImageButton.layer.borderColor = UIColor.white.cgColor
        previousImageButton.layer.borderWidth = 1
        view.addSubview(previousImageButton)
        
        previousImageButton.frame = CGRect(x: appScreenshotImageView.frame.minX - buttonTitleSize.height, y: appScreenshotImageView.frame.midY - ((buttonTitleSize.height * 1.5) / 2), width: buttonTitleSize.height * 1.5, height: buttonTitleSize.height * 1.5)
        
        nextImageButton = UIButton()
        nextImageButton.addTarget(self, action: #selector(didPressNextImageButton), for: .touchUpInside)
        nextImageButton.setTitle(">", for: .normal)
        nextImageButton.setTitleColor(.white, for: .normal)
        nextImageButton.titleLabel?.font = UIFont.systemFont(ofSize: backButtonTextSize, weight: .bold)
        nextImageButton.layer.borderColor = UIColor.white.cgColor
        nextImageButton.layer.borderWidth = 1
        view.addSubview(nextImageButton)
        
        nextImageButton.frame = CGRect(x: appScreenshotImageView.frame.maxX, y: appScreenshotImageView.frame.midY - ((buttonTitleSize.height * 1.5) / 2), width: buttonTitleSize.height * 1.5, height: buttonTitleSize.height * 1.5)
    }
    
    private func updateViews() {
        backButton.layer.cornerRadius = backButton.frame.height / 2
        previousImageButton.layer.cornerRadius = previousImageButton.frame.height / 2
        nextImageButton.layer.cornerRadius = nextImageButton.frame.height / 2
    }
}
