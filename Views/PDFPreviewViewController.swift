//
//  PDFPreviewViewController.swift
//  PDFConverter
//
//  Created by SSDHDDQ on 15.02.2025.
//

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
    private let pdfURL: URL
    
    private lazy var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: pdfURL)
        
        return pdfView
    }()

    init(pdfURL: URL) {
        self.pdfURL = pdfURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Поделиться", style: .plain, target: self, action: #selector(sharePDF))
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(pdfView)
        
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func sharePDF() {
        let activityVC = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
        present(activityVC, animated: true)
    }
}
