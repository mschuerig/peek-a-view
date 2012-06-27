PeekAView::Engine.routes.draw do
  scope module: 'peek_a_view' do
    get '/*view' => 'views#show'
  end
end
