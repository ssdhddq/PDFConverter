//
//  PDFConverterViewModel.swift
//  PDFConverter
//
//  Created by SSDHDDQ on 15.02.2025.
//

import UIKit
import PDFKit

class PDFConverterViewModel {
    func generatePDF(from images: [UIImage]) -> URL? {
        let pdfFileName = FileManager.default.temporaryDirectory.appendingPathComponent("ConvertedPDF.pdf")
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        
        do {
            try renderer.writePDF(to: pdfFileName, withActions: { context in
                for image in images {
                    context.beginPage()
                    image.draw(in: CGRect(x: 0, y: 0, width: 612, height: 792))
                }
            })
            return pdfFileName
        } catch {
            print("Ошибка при создании PDF: \(error)")
            return nil
        }
    }
}
