# encoding: utf-8
class Prestamos::BandejaArrimeController < FormClassicController

  skip_before_filter :set_charset, :only=>[:sector_change, :sector_form_change, :sub_sector_change, :sub_sector_form_change, :rubro_form_change, :sub_rubro_change, :confirmar ]
  
  def index
    @silo = Silo.find(:all,:order=>"nombre")
    @sector_list = Sector.find(:all, :order=>'nombre')
    sector_fill(0)
  end

  def list
    conditions = "confirmacion = FALSE"
    params['sort'] = "numero_tramite" unless params['sort']
    unless params[:sector_id][0].to_s.nil? || params[:sector_id][0].to_s.empty?
      sector_id = params[:sector_id][0].to_s
      sector = Sector.find(sector_id)
      conditions = "#{conditions} AND sector_id = " + sector_id
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sector')} '#{sector.nombre}'"
    end
    unless params[:sub_sector_id][0].to_s.nil? || params[:sub_sector_id][0].to_s.empty?
      subsector_id = params[:sub_sector_id][0].to_s
      subsector = SubSector.find(subsector_id)
      conditions = "#{conditions} AND sub_sector_id = " + subsector_id
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sub_sector')} '#{subsector.nombre}'"
    end
    unless params[:rubro_id][0].to_s.nil? || params[:rubro_id][0].to_s.empty?
      rubro_id = params[:rubro_id][0].to_s
      rubro = Rubro.find(rubro_id)
      conditions = "#{conditions} AND rubro_id = " + rubro_id
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.rubro')} '#{rubro.nombre}'"
    end
    unless params[:sub_rubro_id][0].to_s.nil? || params[:sub_rubro_id][0].to_s.empty?
      sub_rubro_id = params[:sub_rubro_id][0].to_s
      sub_rubro = SubRubro.find(sub_rubro_id)
      conditions = "#{conditions} AND sub_rubro_id = " + sub_rubro_id
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} '#{sub_rubro.nombre}'"
    end
    unless params[:actividad_id][0].to_s.nil? || params[:actividad_id][0].to_s.empty?
      actividad_id = params[:actividad_id][0].to_s
      actividad = Actividad.find(actividad_id)
      conditions = "#{conditions} AND actividad_id = " + actividad_id
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.actividad')} '#{actividad.nombre}'"
    end
    unless params[:numero].nil? || params[:numero].empty?
      conditions = "#{conditions} AND numero_tramite =  #{params[:numero].to_i}"
      conditions_totales = "#{conditions_totales} AND numero_tramite =  #{params[:numero].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Form.nro_tramite')} '#{params[:numero]}'"
    end
    unless params[:ticket].nil? || params[:ticket].empty?
      conditions = "#{conditions} AND numero_ticket =  '#{params[:ticket]}'"
      conditions_totales = "#{conditions_totales} AND numero_ticket =  '#{params[:ticket]}'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Arrime.Etiquetas.numero_boleta')} #{params[:ticket].to_s}"
    end
    unless params[:nombre].nil? || params[:nombre].empty?
      conditions = "#{conditions} AND LOWER(nombre_beneficiario) LIKE  '%#{params[:nombre].strip.downcase}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.beneficiario')} '#{params[:nombre]}'"
    end
    unless params[:silo_id][0].to_s.nil? || params[:silo_id][0].to_s.empty?
      conditions = "#{conditions} AND silo_id = #{params[:silo_id][0].to_s}"
      silo = Silo.find(params[:silo_id][0])
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Form.silo')} '#{silo.nombre}'"
    end

    
    @list = ViewBandejaArrime.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

 
  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.show 'sub-sector-select'
      page.show 'rubro-select'
    end
  end

  def sector_form_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
      page.replace_html 'rubro-select', :partial => 'rubro_form_select'
      page.show 'sub-sector-select'
      page.show 'rubro-select'
    end
  end

  def sub_sector_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.show 'rubro-select'
    end
  end

  def sub_sector_form_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_form_select'
      page.show 'rubro-select'
    end
  end
  
  def rubro_form_change
    sub_rubro_fill(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.show 'sub-rubro-select'
    end
  end
  
  def sub_rubro_change
    actividad_fill(params[:sub_rubro_id])
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'actividad-select'
    end
  end


  def confirmar
#    fecha_confirmacion = Time.now.strftime('%Y/%m/%d')
#    parametros = {"confirmacion"=>"true","fecha_confirmacion"=>fecha_confirmacion,"usuario_id"=>session[:id]}
#    errores_update = BoletaArrime.confirmacion(params[:id], parametros)
#    if errores_update == true
#      render :update do |page|
#        page.remove "row_#{params[:id]}"
#        page.hide 'error'
#        page.replace_html 'message', "La boleta se Confirmo con éxito."
#        page.show 'message'
#      end
#    else
#      render :update do |page|
#        page.hide 'message'
#        page.replace_html 'errorExplanation',"<h2> #{I18n.t('Sistema.Body.General.ocurrio_error')} </h2><p><UL>" << errores << '</UL></p>'
#        page.show 'errorExplanation'
#        page.<< "window.scrollTo(0,0);"
#      end
#    end

    @boleta_arrime = BoletaArrime.find(params[:id])
    @view_boleta_arrime = ViewBoletaArrime.find_by_cliente_id(@boleta_arrime.cliente_id)
    parametros = @boleta_arrime
    cliente_ci = @view_boleta_arrime.cedula_rif
     errores = BoletaArrime.check_confirmar(parametros, cliente_ci)
     logger.info"XXXXXXXXX==============EU1==========>>>>>>>"<<errores.inspect
     if errores
     ###
        fecha_confirmacion = Time.now.strftime('%Y/%m/%d')
        parametros = {"confirmacion"=>"true","fecha_confirmacion"=>fecha_confirmacion,"usuario_id"=>session[:id]}
        logger.info "usuario confirmar========================> #{parametros["usuario_id"]}"
        errores_update = BoletaArrime.confirmacion(params[:id], parametros)
        if errores_update
          render :update do |page|
       	     page.remove "row_#{params[:id]}"
             page.hide 'error'
             page.replace_html 'message', "La boleta se Confirmo con éxito."
             page.show 'message'
         end
        else
          render :update do |page|
            page.hide 'message'
            page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << errores.to_s << '</UL></p>'
            page.show 'error'
            page.<< "window.scrollTo(0,0);"
          end
        end
#####
     else
     render :update do |page|
            page.hide 'message'
            page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << errores.to_s << '</UL></p>'
            page.show 'errorExplanation'
            page.<< "window.scrollTo(0,0);"
          end
     end
  end

  protected
  def common
    super
    @form_title = 'Confirmación de Arrime'
    @form_title_record = 'Confirmación de Arrime'
    @form_title_records = 'Confirmación de Arrime'
    @form_entity = 'boleta_arrime'
    @form_identity_field = 'id'
    @width_layout = '1120'
  end

  def sector_fill(sector_id)
    @sector_list = Sector.find(:all, :order=>'nombre')
    sub_sector_fill(0)
  end

  def sub_sector_fill(sector_id)
    if sector_id.to_s.length > 0
      @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', sector_id], :order=>'nombre')
    else
      @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', 0], :order=>'nombre')
    end
    rubro_fill(0)
  end

  def rubro_fill(sub_sector_id)
    if sub_sector_id.to_s.length > 0
      @rubro_list = Rubro.find(:all, :conditions=>["sub_sector_id = ? and activo = true and id in (select rubro_id from rubro_oficina where activo = true and oficina_id = #{session[:oficina]})", sub_sector_id], :order=>'nombre')
    else
      @rubro_list = Rubro.find(:all, :conditions=>["sub_sector_id = ?", 0], :order=>'nombre')
    end
    sub_rubro_fill(0)
  end
  
  def sub_rubro_fill(rubro_id)
    if rubro_id.to_s.length > 0
      @sub_rubro_list = SubRubro.find(:all, :conditions=>["rubro_id = ? and activo = true and rubro_id in (select rubro_id from rubro_oficina where activo = true and oficina_id = #{session[:oficina]})", rubro_id], :order=>'nombre')
    else
      @sub_rubro_list = SubRubro.find(:all, :conditions=>["rubro_id = ?", 0], :order=>'nombre')
    end
    actividad_fill(0)
  end
  
  def actividad_fill(sub_rubro_id)
    if sub_rubro_id.to_s.length > 0
      @actividad_list = Actividad.find(:all, :conditions=>["sub_rubro_id = ? and activo = true ", sub_rubro_id], :order=>'nombre')
    else
      @actividad_list = Actividad.find(:all, :conditions=>["sub_rubro_id = ?", 0], :order=>'nombre')
    end
  end


end

