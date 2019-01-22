//
// PermitTypeDetailViewController.swift
// IOSKT
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 30/11/18
//

import Foundation
import SAPCommon
import SAPFiori
import SAPFoundation
import SAPOData

class PermitTypeDetailViewController: FUIFormTableViewController, SAPFioriLoadingIndicator {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var workpermit: Workpermit<OnlineODataProvider> {
        return self.appDelegate.workpermit
    }

    private var validity = [String: Bool]()
    private var _entity: PermitType?
    var allowsEditableCells = false
    var entity: PermitType {
        get {
            if self._entity == nil {
                self._entity = self.createEntityWithDefaultValues()
            }
            return self._entity!
        }
        set {
            self._entity = newValue
        }
    }

    private let logger = Logger.shared(named: "PermitTypeMasterViewControllerLogger")
    var loadingIndicator: FUILoadingIndicatorView?
    var entityUpdater: EntityUpdaterDelegate?
    var tableUpdater: EntitySetUpdaterDelegate?
    private let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")
    var preventNavigationLoop = false
    var entitySetName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "updateEntity" {
            // Show the Detail view with the current entity, where the properties scan be edited and updated
            self.logger.info("Showing a view to update the selected entity.")
            let dest = segue.destination as! UINavigationController
            let detailViewController = dest.viewControllers[0] as! PermitTypeDetailViewController
            detailViewController.title = NSLocalizedString("keyUpdateEntityTitle", value: "Update Entity", comment: "XTIT: Title of update selected entity screen.")
            detailViewController.entity = self.entity
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: detailViewController, action: #selector(detailViewController.updateEntity))
            detailViewController.navigationItem.rightBarButtonItem = doneButton
            let cancelButton = UIBarButtonItem(title: NSLocalizedString("keyCancelButtonToGoPreviousScreen", value: "Cancel", comment: "XBUT: Title of Cancel button."), style: .plain, target: detailViewController, action: #selector(detailViewController.cancel))
            detailViewController.navigationItem.leftBarButtonItem = cancelButton
            detailViewController.allowsEditableCells = true
            detailViewController.entityUpdater = self
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return self.cellForOrderID(tableView: tableView, indexPath: indexPath, currentEntity: self.entity, property: PermitType.orderID)
        case 1:
            return self.cellForOperationID(tableView: tableView, indexPath: indexPath, currentEntity: self.entity, property: PermitType.operationID)
        case 2:
            return self.cellForOperationText(tableView: tableView, indexPath: indexPath, currentEntity: self.entity, property: PermitType.operationText)
        case 3:
            return self.cellForAssigneeID(tableView: tableView, indexPath: indexPath, currentEntity: self.entity, property: PermitType.assigneeID)
        case 4:
            return self.cellForAssigneeName(tableView: tableView, indexPath: indexPath, currentEntity: self.entity, property: PermitType.assigneeName)
        case 5:
            return self.cellForFunctionalLocation(tableView: tableView, indexPath: indexPath, currentEntity: self.entity, property: PermitType.functionalLocation)
        case 6:
            return self.cellForEquipment(tableView: tableView, indexPath: indexPath, currentEntity: self.entity, property: PermitType.equipment)
        case 7:
            return self.cellForLatitude(tableView: tableView, indexPath: indexPath, currentEntity: self.entity, property: PermitType.latitude)
        case 8:
            return self.cellForLongtitdue(tableView: tableView, indexPath: indexPath, currentEntity: self.entity, property: PermitType.longtitdue)
        case 9:
            return self.cellForWorkPermitRequired(tableView: tableView, indexPath: indexPath, currentEntity: self.entity, property: PermitType.workPermitRequired)
        case 10:
            return self.cellForWorkPermitStatus(tableView: tableView, indexPath: indexPath, currentEntity: self.entity, property: PermitType.workPermitStatus)
        case 11:
            return self.cellForPlannedDateTime(tableView: tableView, indexPath: indexPath, currentEntity: self.entity, property: PermitType.plannedDateTime)
        case 12:
            return self.cellForSaftyProcedureRequired(tableView: tableView, indexPath: indexPath, currentEntity: self.entity, property: PermitType.saftyProcedureRequired)
        default:
            return UITableViewCell()
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 13
    }

    override func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < 13 {
            return true
        }
        return false
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.preventNavigationLoop {
            return
        }
        switch indexPath.row {
        default:
            return
        }
    }

    // MARK: - OData property specific cell creators

    private func cellForOrderID(tableView: UITableView, indexPath: IndexPath, currentEntity: PermitType, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.orderID ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if PermitType.orderID.isOptional || newValue != "" {
                currentEntity.orderID = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }

    private func cellForOperationID(tableView: UITableView, indexPath: IndexPath, currentEntity: PermitType, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.operationID ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if PermitType.operationID.isOptional || newValue != "" {
                currentEntity.operationID = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }

    private func cellForOperationText(tableView: UITableView, indexPath: IndexPath, currentEntity: PermitType, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.operationText {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.operationText = nil
                isNewValueValid = true
            } else {
                if PermitType.operationText.isOptional || newValue != "" {
                    currentEntity.operationText = newValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }

    private func cellForAssigneeID(tableView: UITableView, indexPath: IndexPath, currentEntity: PermitType, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.assigneeID {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.assigneeID = nil
                isNewValueValid = true
            } else {
                if PermitType.assigneeID.isOptional || newValue != "" {
                    currentEntity.assigneeID = newValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }

    private func cellForAssigneeName(tableView: UITableView, indexPath: IndexPath, currentEntity: PermitType, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.assigneeName {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.assigneeName = nil
                isNewValueValid = true
            } else {
                if PermitType.assigneeName.isOptional || newValue != "" {
                    currentEntity.assigneeName = newValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }

    private func cellForFunctionalLocation(tableView: UITableView, indexPath: IndexPath, currentEntity: PermitType, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.functionalLocation {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.functionalLocation = nil
                isNewValueValid = true
            } else {
                if PermitType.functionalLocation.isOptional || newValue != "" {
                    currentEntity.functionalLocation = newValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }

    private func cellForEquipment(tableView: UITableView, indexPath: IndexPath, currentEntity: PermitType, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.equipment {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.equipment = nil
                isNewValueValid = true
            } else {
                if PermitType.equipment.isOptional || newValue != "" {
                    currentEntity.equipment = newValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }

    private func cellForLatitude(tableView: UITableView, indexPath: IndexPath, currentEntity: PermitType, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.latitude {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.latitude = nil
                isNewValueValid = true
            } else {
                if PermitType.latitude.isOptional || newValue != "" {
                    currentEntity.latitude = newValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }

    private func cellForLongtitdue(tableView: UITableView, indexPath: IndexPath, currentEntity: PermitType, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.longtitdue {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.longtitdue = nil
                isNewValueValid = true
            } else {
                if PermitType.longtitdue.isOptional || newValue != "" {
                    currentEntity.longtitdue = newValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }

    private func cellForWorkPermitRequired(tableView: UITableView, indexPath: IndexPath, currentEntity: PermitType, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.workPermitRequired {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.workPermitRequired = nil
                isNewValueValid = true
            } else {
                if PermitType.workPermitRequired.isOptional || newValue != "" {
                    currentEntity.workPermitRequired = newValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }

    private func cellForWorkPermitStatus(tableView: UITableView, indexPath: IndexPath, currentEntity: PermitType, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.workPermitStatus {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.workPermitStatus = nil
                isNewValueValid = true
            } else {
                if PermitType.workPermitStatus.isOptional || newValue != "" {
                    currentEntity.workPermitStatus = newValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }

    private func cellForPlannedDateTime(tableView: UITableView, indexPath: IndexPath, currentEntity: PermitType, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.plannedDateTime {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.plannedDateTime = nil
                isNewValueValid = true
            } else {
                if let validValue = LocalDateTime.parse(newValue) { // This is just a simple solution to handle UTC only
                    currentEntity.plannedDateTime = validValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }

    private func cellForSaftyProcedureRequired(tableView: UITableView, indexPath: IndexPath, currentEntity: PermitType, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.saftyProcedureRequired {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.saftyProcedureRequired = nil
                isNewValueValid = true
            } else {
                if PermitType.saftyProcedureRequired.isOptional || newValue != "" {
                    currentEntity.saftyProcedureRequired = newValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }

    // MARK: - OData functionalities

    @objc func createEntity() {
        self.showFioriLoadingIndicator()
        self.view.endEditing(true)
        self.logger.info("Creating entity in backend.")
        self.workpermit.createEntity(self.entity) { error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Create entry failed. Error: \(error)", error: error)
                let alertController = UIAlertController(title: NSLocalizedString("keyErrorEntityCreationTitle", value: "Create entry failed", comment: "XTIT: Title of alert message about entity creation error."), message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: self.okTitle, style: .default))
                OperationQueue.main.addOperation({
                    // Present the alertController
                    self.present(alertController, animated: true)
                })
                return
            }
            self.logger.info("Create entry finished successfully.")
            OperationQueue.main.addOperation({
                self.dismiss(animated: true) {
                    FUIToastMessage.show(message: NSLocalizedString("keyEntityCreationBody", value: "Created", comment: "XMSG: Title of alert message about successful entity creation."))
                    self.tableUpdater?.entitySetHasChanged()
                }
            })
        }
    }

    func createEntityWithDefaultValues() -> PermitType {
        let newEntity = PermitType()
        // Fill the mandatory properties with default values
        newEntity.orderID = CellCreationHelper.defaultValueFor(PermitType.orderID)
        newEntity.operationID = CellCreationHelper.defaultValueFor(PermitType.operationID)

        // Key properties without default value should be invalid by default for Create scenario
        if newEntity.orderID == nil || newEntity.orderID!.isEmpty {
            self.validity["OrderID"] = false
        }
        if newEntity.operationID == nil || newEntity.operationID!.isEmpty {
            self.validity["OperationID"] = false
        }
        self.barButtonShouldBeEnabled()
        return newEntity
    }

    @objc func updateEntity(_: AnyObject) {
        self.showFioriLoadingIndicator()
        self.view.endEditing(true)
        self.logger.info("Updating entity in backend.")
        self.workpermit.updateEntity(self.entity) { error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Update entry failed. Error: \(error)", error: error)
                let alertController = UIAlertController(title: NSLocalizedString("keyErrorEntityUpdateTitle", value: "Update entry failed", comment: "XTIT: Title of alert message about entity update failure."), message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: self.okTitle, style: .default))
                OperationQueue.main.addOperation({
                    // Present the alertController
                    self.present(alertController, animated: true)
                })
                return
            }
            self.logger.info("Update entry finished successfully.")
            OperationQueue.main.addOperation({
                self.dismiss(animated: true) {
                    FUIToastMessage.show(message: NSLocalizedString("keyUpdateEntityFinishedTitle", value: "Updated", comment: "XTIT: Title of alert message about successful entity update."))
                    self.entityUpdater?.entityHasChanged(self.entity)
                }
            })
        }
    }

    // MARK: - other logic, helper

    @objc func cancel() {
        OperationQueue.main.addOperation({
            self.dismiss(animated: true)
        })
    }

    // Check if all text fields are valid
    private func barButtonShouldBeEnabled() {
        let anyFieldInvalid = self.validity.values.first { field in
            return field == false
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = anyFieldInvalid == nil
    }
}

extension PermitTypeDetailViewController: EntityUpdaterDelegate {
    func entityHasChanged(_ entityValue: EntityValue?) {
        if let entity = entityValue {
            let currentEntity = entity as! PermitType
            self.entity = currentEntity
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}
