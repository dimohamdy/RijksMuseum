//
//  ListViewModelState.swift
//  RijksMuseum
//
//  Created by Dimo Abdelaziz on 26/05/2023.
//

enum ListViewModelState<T> {
    case loading(show: Bool)
    case loaded(data: T)
    case error(alert: RijksMuseumAlert)
    case placeholder(emptyPlaceHolderType: EmptyPlaceHolderType)
}
