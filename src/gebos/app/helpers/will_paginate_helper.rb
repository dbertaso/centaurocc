module WillPaginateHelper
  class WillPaginateAjaxLinkRenderer < WillPaginate::ActionView::LinkRenderer
    def prepare(collection, options, template)      
      options[:params] ||= {}
      options[:params]["_"] = nil      
      super(collection, options, template)
    end
 
    protected
    def link(text, target, attributes = {})      
      
      if target.is_a? Integer
        attributes[:rel] = rel_value(target)      
        target = url(target)        
      end            
      ajax_call="new Ajax.Request('#{target}', {asynchronous:true, evalScripts:true, method:'get', onLoaded:function(request){image_unload()}, onLoading:function(request){image_load()}})"
      @template.link_to_function(text.to_s.html_safe, ajax_call, attributes)
    end
  end
 
  def ajax_will_paginate(collection, options = {})  
    will_paginate(collection, options.merge(:renderer => WillPaginateHelper::WillPaginateAjaxLinkRenderer))
  end
end
