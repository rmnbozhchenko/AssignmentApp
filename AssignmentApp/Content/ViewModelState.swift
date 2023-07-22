enum ViewModelState<Data> {
    case loading
    case error(String)
    case success(content: Data)
}
