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
        btn.setTitle("Выбрать фото", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let convertButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Конвертировать в PDF", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [selectButton, convertButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        selectButton.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        convertButton.addTarget(self, action: #selector(convertToPDF), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .gray
        
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func selectPhoto() {
        pickerViewModel.pickImages(from: self)
    }
    
    @objc private func convertToPDF() {
        guard let pdfURL = converterViewModel.generatePDF(from: pickerViewModel.photoModel.images) else {return}
        let previewVC = PDFPreviewViewController(pdfURL: pdfURL)
        navigationController?.pushViewController(previewVC, animated: true)
    }
}
