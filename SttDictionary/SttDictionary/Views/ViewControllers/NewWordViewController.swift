//
//  NewWordViewController.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit
import AlignedCollectionViewFlowLayout
import RxSwift

class NewWordViewController: SttViewController<NewWordPresenter>, NewWordDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
  
    enum CollectionType {
        case translation
        case linkedWords
        case tags
    }
    
    // property
    
    var mainTranslateSource: WordCollectionCellSource!
    var linkedWordsSource: WordCollectionCellSource!
    var tagsSource: WordCollectionCellSource!
    
    let handlerMain = SttHandlerTextField()
    let handlerOriginalWord = SttHandlerTextField()
    let handlerLinkedWord = SttHandlerTextField()
    let handlerTags = SttHandlerTextField()
    let handlerExampleOriginal = SttHandlerTextField()
    let handlerExampleTranslate = SttHandlerTextField()
    let handlerExplanation = SttHandlerTextField()
    
    // outlet
    
    @IBOutlet weak var btnAddTranslation: UIButton!
    @IBOutlet weak var tfWord: SttTextField!
    @IBOutlet weak var tfMainTranslation: SttTextField!
    @IBOutlet weak var tfLinkedWords: SttTextField!
    @IBOutlet weak var tfTags: SttTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var linkedWordsCollection: UICollectionView!
    @IBOutlet weak var tagsCollection: UICollectionView!
    @IBOutlet weak var cnstrMainTranslationHeight: NSLayoutConstraint!
    @IBOutlet weak var cnstrLinkedWordsHeight: NSLayoutConstraint!
    @IBOutlet weak var cnstrTags: NSLayoutConstraint!
    @IBOutlet weak var wordExistsLabel: UILabel!
    @IBOutlet weak var cnstrHeightExists: NSLayoutConstraint!
    @IBOutlet weak var swtchReverse: UISwitch!
    @IBOutlet weak var swtchPronounciation: UISwitch!
    @IBOutlet weak var tfExampleOriginal: SttTextField!
    @IBOutlet weak var tfExampleTranslate: SttTextField!
    @IBOutlet weak var tfExplanation: SttTextField!
    
    let linkedWordSearchPublisher = PublishSubject<String>()
    let tagsSearchPublisher = PublishSubject<String>()
    
    // outlet action
    
    @IBAction func saveClick(_ sender: Any) {
        if !(tfWord.text ?? "").isEmpty {
            presenter.word = tfWord.text
            addMainTranslateClick(sender)
            presenter.save.execute()
        }
    }
    @IBAction func addMainTranslateClick(_ sender: Any) {
        if !(tfMainTranslation.text ?? "").isEmpty {
            presenter.addNewMainTranslation(value: tfMainTranslation.text!)
            tfMainTranslation.text = ""
        }
        else {
            tfExampleOriginal.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurateTextField()
        configurationHandlerTextField()
        configurateCollectionView()
        
        btnAddTranslation.layer.cornerRadius = UIConstants.cornerRadius
        btnAddTranslation.clipsToBounds = true
        btnAddTranslation.tintColor = UIColor.white
        
        swtchReverse.addTarget(self, action: #selector(onSwitcherChange(_:)), for: .valueChanged)
        swtchPronounciation.addTarget(self, action: #selector(onSwitcherPronunciationChange(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tfWord.becomeFirstResponder()
    }
    
    @objc private func onSwitcherChange(_ sender: UISwitch) {
        presenter.useReverse = sender.isOn
    }
    @objc private func onSwitcherPronunciationChange(_ sender: UISwitch) {
        presenter.usePronunciation = sender.isOn
    }
    
    private func configurateCollectionView() {
        cnstrLinkedWordsHeight.constant = 0
        cnstrMainTranslationHeight.constant = 0
        cnstrTags.constant = 0
        
        mainTranslateSource = WordCollectionCellSource(collectionView: collectionView, _collection: presenter.mainTranslation.data)
        linkedWordsSource = WordCollectionCellSource(collectionView: linkedWordsCollection, _collection: presenter.linkedWords.data)
        tagsSource = WordCollectionCellSource(collectionView: tagsCollection, _collection: presenter.tags.data)
        
        collectionView.dataSource = mainTranslateSource
        collectionView.delegate = mainTranslateSource
        linkedWordsCollection.dataSource = linkedWordsSource
        linkedWordsCollection.delegate = linkedWordsSource
        tagsCollection.dataSource = tagsSource
        tagsCollection.delegate = tagsSource
        
        _ = presenter.mainTranslation.data.observableObject.subscribe(onNext: { _ in self.reloadCollectionCell(type: .translation) })
        _ = presenter.linkedWords.data.observableObject.subscribe(onNext: { [weak self] _ in self?.reloadCollectionCell(type: .linkedWords) })
        _ = presenter.tags.data.observableObject.subscribe(onNext: { [weak self] _ in self?.reloadCollectionCell(type: .tags) })
        
        let alignedFlowLayout = collectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.minimumLineSpacing = 4
        alignedFlowLayout?.minimumInteritemSpacing = 4
        
        presenter.save.addHandler(start: {
            let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            indicator.startAnimating()
            let indicatorButton = UIBarButtonItem(customView: indicator)
            indicatorButton.isEnabled = false
            self.navigationItem.setRightBarButton(indicatorButton, animated: true)
        }, end: {
            self.close()
        })
    }
    
    private func configurateTextField() {
        let tfArray = [tfWord, tfMainTranslation, tfLinkedWords, tfTags, tfExampleOriginal, tfExampleTranslate, tfExplanation]
        for item in tfArray {
            item!.setBorder(color: UIColor(named: "border")!, size: 1)
            item!.setPlaceholderColor(color: UIColor.gray)
            item!.insets = UIConstants.insetsForTextField
            item!.layer.cornerRadius = UIConstants.cornerRadius
        }
        
        tfWord.delegate = handlerOriginalWord
        tfMainTranslation.delegate = handlerMain
        tfLinkedWords.delegate = handlerLinkedWord
        tfTags.delegate = handlerTags
        tfExampleOriginal.delegate = handlerExampleOriginal
        tfExampleTranslate.delegate = handlerExampleTranslate
        tfExplanation.delegate = handlerExplanation
    }
    private func configurationHandlerTextField() {
        
        handlerMain.addTarget(type: .shouldReturn, delegate: self, handler: { $0.addMainTranslateClick($1) }, textField: tfMainTranslation)
        handlerOriginalWord.addTarget(type: .shouldReturn, delegate: self, handler: { (view, _) in view.tfMainTranslation.becomeFirstResponder() }, textField: tfWord)
        handlerExampleOriginal.addTarget(type: .shouldReturn, delegate: self, handler: {  (view, _) in view.tfExampleTranslate.becomeFirstResponder() }, textField: tfLinkedWords)
        
        handlerOriginalWord.addTarget(type: .editing, delegate: self, handler: { $0.presenter.word = $1.text }, textField: tfWord)
        handlerLinkedWord.addTarget(type: .editing, delegate: self, handler: { $0.linkedWordSearchPublisher.onNext($1.text ?? "") }, textField: tfLinkedWords)
        handlerTags.addTarget(type: .editing, delegate: self, handler: { $0.tagsSearchPublisher.onNext($1.text ?? "") }, textField: tfTags)
        handlerExampleOriginal.addTarget(type: .editing, delegate: self, handler: { $0.presenter.exampleOriginal = $1.text }, textField: tfExampleOriginal)
        handlerExampleTranslate.addTarget(type: .editing, delegate: self, handler: { $0.presenter.exampleTranslate = $1.text }, textField: tfExampleTranslate)
        handlerExplanation.addTarget(type: .editing, delegate: self, handler: { $0.presenter.explanation = $1.text }, textField: tfExplanation)
        
        handlerLinkedWord.addTarget(type: .didStartEditing, delegate: self, handler: { (self, _) in
            
            let wordController = self.getViewCotroller(isLinkedWords: true)
            self.present(wordController, animated: true, completion: nil)
            
        }, textField: tfLinkedWords)
        handlerTags.addTarget(type: .didStartEditing, delegate: self, handler: { (self, _) in
            
            let wordController = self.getViewCotroller(isLinkedWords: false)
            self.present(wordController, animated: true, completion: nil)
            
        }, textField: tfLinkedWords)
    }
    
    private func getViewCotroller(isLinkedWords: Bool) -> UIViewController {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "listWords") as! SearchLinkedWordsViewController
        viewController.changeTextObservable = isLinkedWords ? self.linkedWordSearchPublisher : self.tagsSearchPublisher
        viewController.insertParametr(parametr: isLinkedWords)
        viewController.modalPresentationStyle = .popover
        viewController.closeDelegate = { [weak self] data in
            if isLinkedWords {
                self?.presenter.addNewLinkedWords(words: data)
            }
            else {
                self?.presenter.addNewTags(words: data)
            }
        }
        
        viewController.popoverPresentationController?.permittedArrowDirections = .down
        viewController.popoverPresentationController?.delegate = self
        viewController.popoverPresentationController?.sourceView = isLinkedWords ? self.tfLinkedWords : self.tfTags
        viewController.popoverPresentationController?.sourceRect = isLinkedWords ? self.tfLinkedWords.bounds : self.tfTags.bounds
        
        return viewController
    }
    
    private func reloadCollectionCell(type: CollectionType) {
        var targetCollection: UICollectionView!
        var targetCnstraint: NSLayoutConstraint!
        switch type {
        case .translation:
            targetCollection = collectionView
            targetCnstraint = cnstrMainTranslationHeight
        case .linkedWords:
            targetCollection = linkedWordsCollection
            targetCnstraint = cnstrLinkedWordsHeight
        case .tags:
            targetCollection = tagsCollection
            targetCnstraint = cnstrTags
        default: break;
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            targetCnstraint.constant = targetCollection.contentSize.height
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: -- Popover protocol
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: -- Flow layout protocol
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((presenter.mainTranslation.data[indexPath.row].word ?? "") as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 18)!]).width + 13, height: 35)
    }

    // MARK: -- protocols presenter implement
    
    func error(isHidden: Bool) {
        wordExistsLabel.isHidden = isHidden
        cnstrHeightExists.constant = isHidden ? 0 : 14
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}
