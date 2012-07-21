PeekAView::Engine.routes.draw do
  scope module: 'peek_a_view' do
    get '/' => 'views#index', as: 'views'
    get '/*view' => 'views#show', as: 'view'
  end
end
