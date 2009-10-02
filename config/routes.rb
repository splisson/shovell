ActionController::Routing::Routes.draw do |map|
  map.connect '', :controller => "story"
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  map.story 'story/show/:permalink',
    :controller => 'story',
    :action => 'show'  
  map.connect ':controller/:action/:id'
end
