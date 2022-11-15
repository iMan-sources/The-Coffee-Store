//
//  NotificationNames.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 04/11/2022.
//

import Foundation


extension Notification.Name {
    static let popToOrderViewController = Notification.Name("popToOrderViewController")
    static let popToOrderViewControllerAfterBooking = Notification.Name("popToOrderViewControllerAfterBooking")
    static let popToHomeViewControllerFromAfterBooking = Notification.Name("popToHomeViewControllerFromAfterBooking")
    static let switchToHomeViewController = Notification.Name("switchToHomeViewController")
    static let hideBottomTabBar = Notification.Name("hideBottomTabBar")
    static let unHideBottomTabBar = Notification.Name("unhideBottomTabBar")
}
