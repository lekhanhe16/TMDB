//
//  ViewController.swift
//  ScrollviewExample
//
//  Created by acupofstarbugs on 10/03/2023.
//

import PhotosUI
import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    @IBOutlet var collectionView: UICollectionView!
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] object, _ in
                if let image = object as? UIImage {
                    self?.images.append(image)
                }

            })
        }
        picker.dismiss(animated: true, completion: {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        })
    }

    var images = [UIImage]()

    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        let drawerController = DrawerMenuViewController()
        present(drawerController, animated: true)
    }

    @IBAction func btnSelectPhotoClicked(_ sender: UIButton) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 3
        config.filter = PHPickerFilter.images

        let vc = PHPickerViewController(configuration: config)

        vc.delegate = self
        present(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.size.width
        print(width)
        return CGSize(width: width/7, height: width/7)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ViewController: UICollectionViewDelegate {}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
}
