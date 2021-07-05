class RechazoCobranzaController < FormTabsController

    def list

      params['sort'] = "fecha desc" unless params['sort']
      conditions = "fecha <= " << Time.now.strftime("%Y-%m-%d")

      @list = RechazoCobranza.search(conditions, params[:page], params['sort'])    
      @total = @list.count


      form_list

  end

end
