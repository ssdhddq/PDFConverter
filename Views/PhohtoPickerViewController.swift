//
//  PhohtoPickerViewController.swift
//  PDFConverter
//
//  Created by SSDHDDQ on 15.02.2025.
//

import UIKit
import PhotosUI

class PhotoPickerViewController: UIViewController {
    private let pickerViewModel = PhotoPickerViewModel()
    private let converterViewModel = PDFConverterViewModel()
    
    private let selectButton: UIButton = {
        let btn = UIButton(configuration: .filled())
        btn.configuration?.baseBackgroundColor = .systemBlue
        btn.configuration?.cornerStyle = .large
        btn.configuration?.title = "Выбрать фото"
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let clearSelectedButton: UIButton = {
        let btn = UIButton(configuration: .plain())
        btn.configuration?.baseForegroundColor = .systemRed
        btn.configuration?.title = "Очистить выбор"
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let convertButton: UIButton = {
        let btn = UIButton(configuration: .filled())
        btn.configuration?.baseBackgroundColor = .systemGreen
        btn.configuration?.cornerStyle = .large
        btn.configuration?.title = "Конвертировать в PDF"
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isEnabled = false
        return btn
    }()
    
    private let selectedImagesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Выбрано фото: 0"
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [selectedImagesLabel, selectButton, clearSelectedButton, convertButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        selectButton.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        clearSelectedButton.addTarget(self, action: #selector(clearImages), for: .touchUpInside)
        convertButton.addTarget(self, action: #selector(convertToPDF), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enableConvertButton), name: NSNotification.Name("ImagesUpdated"), object: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        [selectButton, convertButton].forEach { button in
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    
    @objc private func selectPhoto() {
        pickerViewModel.pickImages(from: self)
    }
    
    @objc private func clearImages() {
        pickerViewModel.photoModel.images = []
        convertButton.isEnabled = false
        selectedImagesLabel.text = "Выбрано фото: 0"
    }
    
    @objc private func convertToPDF() {
        guard let pdfURL = converterViewModel.generatePDF(from: pickerViewModel.photoModel.images) else {return}
        let previewVC = PDFPreviewViewController(pdfURL: pdfURL)
        navigationController?.pushViewController(previewVC, animated: true)
    }
    
    @objc private func enableConvertButton() {
        if !pickerViewModel.photoModel.images.isEmpty {
            self.convertButton.isEnabled = true
            selectedImagesLabel.text = "Выбрано фото: \(pickerViewModel.photoModel.images.count)"
        }
    }
}
