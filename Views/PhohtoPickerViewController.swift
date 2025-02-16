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
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("Выбрать фото", for: .normal)
        btn.titleLabel?.textColor = .appBlack
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let clearSelectedButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("Очистить выбор", for: .normal)
        btn.titleLabel?.textColor = .red
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let convertButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("Конвертировать в PDF", for: .normal)
        btn.titleLabel?.textColor = .appBlack
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isEnabled = false
        btn.alpha = 0.3
        
        return btn
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [selectButton, clearSelectedButton, convertButton])
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
        view.backgroundColor = .appBlack
        
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func selectPhoto() {
        pickerViewModel.pickImages(from: self)
    }
    
    @objc private func clearImages() {
        pickerViewModel.photoModel.images = []
        convertButton.isEnabled = false
        convertButton.alpha = 0.3
    }
    
    @objc private func convertToPDF() {
        guard let pdfURL = converterViewModel.generatePDF(from: pickerViewModel.photoModel.images) else {return}
        let previewVC = PDFPreviewViewController(pdfURL: pdfURL)
        navigationController?.pushViewController(previewVC, animated: true)
    }
    
    @objc private func enableConvertButton() {
        if !pickerViewModel.photoModel.images.isEmpty {
            self.convertButton.isEnabled = true
            self.convertButton.alpha = 1
        }
    }
}
