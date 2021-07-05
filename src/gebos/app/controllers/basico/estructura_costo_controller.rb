# encoding: utf-8
class Basico::EstructuraCostoController < FormTabTabsController
  
  skip_before_filter :set_charset, :only=>[:estado_change, :estado_select, :estado_up_select,
    :sector_list, :sub_sector_list, :rubro_list, :sub_rubro_list, :sector_change, :sub_sector_change,
    :rubro_change, :sub_rubro_change, :actividad_change
  ]

  def index
    @estado_list = Estado.find(:all, :order=>'nombre')
    estado(nil)
    @sector_list = Sector.find(:all, :order=>'nombre')
    @moneda = Moneda.find(:all, :conditions => "activo = true", :order => "nombre")
    parametros = ParametroGeneral.first
    @meneda_activa = parametros.moneda_id
    @configurador = Configurador.new
    sub_sector(nil)
  end

  def list
    msj = ""
    if params[:configurador][:oficina_id].blank?
      msj << "<li>#{I18n.t('Sistema.Body.Controladores.EstructuraCosto.oficina_consultar')}</li>"
    end
    if params[:configurador][:actividad_id].blank?
      msj << "<li>#{I18n.t('Sistema.Body.Controladores.EstructuraCosto.actividad_consultar')}</li>"
    end
    if params[:configurador][:moneda_id].blank?
      msj << "<li>#{I18n.t('Sistema.Body.Controladores.EstructuraCosto.no_encontraron')}</li>"
    end
    if msj.length > 0
       render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << msj << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
       end
       return false
    else
      @partida_list = Partida.find(:all, :conditions=>['actividad_id = ? and id in (select partida_id from configurador where oficina_id = ? and moneda_id = ?)', params[:configurador][:actividad_id], params[:configurador][:oficina_id], params[:configurador][:moneda_id]], :order=>'nombre')
      @oficina_id = params[:configurador][:oficina_id]
      @moneda_id = params[:configurador][:moneda_id]
      render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'list', :partial => 'partida_item_view'
        page.show 'list'
        page.hide 'message'
      end
    end
  end

  def estado_change
    estado(params[:estado_id])
    render :update do |page|
      page.replace_html 'select-oficina', :partial => 'estado_select'
      page.show 'select-oficina'
    end
  end

  def estado_select
    render :update do |page|
      page.hide "estado-select"
      page.show 'oficina-select'
    end
  end

  def estado_up_select
    render :update do |page|
      page.show "estado-select"
      page.hide 'oficina-select'
      page.<< "window.scrollTo(0,0);"
    end
  end

  def sector_list
    sub_sector(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_list'
      page.replace_html 'rubro-select', :partial => 'rubro_list'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_list'
      page.replace_html 'actividad-select', :partial => 'actividad_list'
      page.show 'sub-sector-select'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
    end
  end

  def sub_sector_list
    rubro(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_list'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_list'
      page.replace_html 'actividad-select', :partial => 'actividad_list'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
    end
  end
  
  def rubro_list
    sub_rubro(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_list'
      page.replace_html 'actividad-select', :partial => 'actividad_list'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
    end
  end
  
  def sub_rubro_list
    actividad(params[:sub_rubro_id])
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_list'
      page.show 'actividad-select'
    end
  end
	
  def new
    @estado_list = Estado.find(:all, :order=>'nombre')
    @configurador = Configurador.new
    @configurador.moneda_id = 2
    @sector_list = Sector.find(:all, :order=>"nombre")
    @moneda = Moneda.find(:all, :conditions => "activo = true", :order => "nombre")
    parametros = ParametroGeneral.first
    @meneda_activa = parametros.moneda_id
    sub_sector(nil)
  end
  
  def save_new
    oficinas = params[:oficinas_id]
    if oficinas.blank?
      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL><li>#{I18n.t('Sistema.Body.Controladores.EstructuraCosto.oficina_seleccion')}</li></UL></p>"
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
      return
    end
    ids = params[:items_id]
    if ids.blank?
      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL><li>#{I18n.t('Sistema.Body.Controladores.EstructuraCosto.item_seleccion')}</li></UL></p>"
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
      return
    end
    errores = ""
    unless params[:configurador][:justificacion].nil?
      unless params[:configurador][:justificacion].length > 0
        errores << "<li>#{I18n.t('Sistema.Body.Vistas.General.justificacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}</li>"
      end
    else
      errores << "<li>#{I18n.t('Sistema.Body.Vistas.General.justificacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}</li>"
    end
    if params[:configurador][:moneda_id].blank?
      errores << "<li>#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.moneda')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}</li>"
    end
    configurador = Configurador.new
    items = Item.find(:all, :conditions=>["id in (#{ids[0,ids.to_s.length - 1]})"])
    items.each { |i|
      errores << configurador.validar(i,params["tipo_#{i.id}"], params[:fijo]["valor_#{i.id}"], params[:minimo]["valor_#{i.id}"], params[:maximo]["valor_#{i.id}"])
    }

    if errores.length > 0
       render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
       end
       return false
    end

    items = Item.find(:all, :conditions=>["id in (#{ids[0,ids.to_s.length - 1]})"])
    items.each { |i|
      oficinas_list = oficinas.split(',')
      #logger.debug "Cantidad de registro en oficinas " + oficinas.length.to_s
      oficinas_list.each{|o|
        #logger.info "entro con el item " + i.nombre
        configurador.save_new(i, params["tipo_#{i.id}"], params[:fijo]["valor_#{i.id}"], params[:minimo]["valor_#{i.id}"], params[:maximo]["valor_#{i.id}"], params[:configurador], o)
      }
    }

    flash[:notice] = "#{I18n.t('Sistema.Body.General.guardar')}"
    render :update do |page|
      page.redirect_to :action=>'new'
	  end
  end
  
  def delete
    @configurador = Configurador.find(params[:id])
    form_delete @configurador
  end
  
  def sector_change
    sub_sector(params[:sector_id])
    @partida_list = []
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'partida-item-select', :partial => 'partida_item_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'partida-item-select'
      page.show 'sub-sector-select'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
      page << "document.getElementById('items_id').value = '';"
    end
  end

  def sub_sector_change
    rubro(params[:sub_sector_id])
    @partida_list = []
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'partida-item-select', :partial => 'partida_item_select'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'partida-item-select'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
      page << "document.getElementById('items_id').value = '';"
    end
  end
  
  def rubro_change
    sub_rubro(params[:rubro_id])
    @partida_list = []
    render :update do |page|
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.replace_html 'partida-item-select', :partial => 'partida_item_select'
      page.show 'partida-item-select'
      page.show 'sub_rubro-select'
      page.show 'actividad-select'
      page << "document.getElementById('items_id').value = '';"
    end
  end
  
  def sub_rubro_change
    actividad(params[:sub_rubro_id])
    @partida_list = []
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.replace_html 'partida-item-select', :partial => 'partida_item_select'
      page.show 'partida-item-select'
      page.show 'actividad-select'
      page << "document.getElementById('items_id').value = '';"
    end
  end

  def actividad_change
    @partida_list = Partida.find(:all, :conditions=>['actividad_id = ?', params[:actividad_id]], :order=>'nombre')
    render :update do |page|
      page.replace_html 'partida-item-select', :partial => 'partida_item_select'
      page.show 'partida-item-select'
      page << "document.getElementById('items_id').value = '';"
    end
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.EstructuraCosto.title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.EstructuraCosto.title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.EstructuraCosto.title')
    @form_entity = 'configurador'
    @form_identity_field = 'id'
    @width_layout = '1200'
  end 
  
  private
  def estado(id)
    unless id.nil?
      @oficina_list = Oficina.find(:all, :conditions=>['ciudad_id in (select id from ciudad where estado_id = ?)', id], :order=>'nombre')
    else
      @oficina_list = []
    end
  end
    
  def sub_sector(id)
      unless id.nil?
        @sub_sector_list = SubSector.find(:all, :conditions=>['activo = true and sector_id = ?', id], :order=>'nombre')
        if (@sub_sector_list.length > 0)
          rubro(nil)
        else
          rubro(nil)
        end
      else
        @sub_sector_list = []
        rubro(nil)
      end
    end

    def rubro(id)
      unless id.nil?
        @rubro_list = Rubro.find(:all, :conditions=>['activo = true and sub_sector_id = ?', id], :order => 'nombre')
      else
        @rubro_list =[]
      end
      sub_rubro(nil)
    end
    
    def sub_rubro(id)
      unless id.nil?
        @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo = true and rubro_id = ?', id], :order => 'nombre')
      else
        @sub_rubro_list =[]
      end
      actividad(nil)
    end
    
    def actividad(id)
      unless id.nil?
        @actividad_list = Actividad.find(:all, :conditions=>['activo = true and sub_rubro_id = ?', id], :order => 'nombre')
      else
        @actividad_list =[]
      end
    end

end