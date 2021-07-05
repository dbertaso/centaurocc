# encoding: utf-8
class Prestamos::BandejaOtroArrimeController < FormClassicController

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
      @form_search_expression << "Sector es igual '#{sector.nombre}'"
    end
    unless params[:sub_sector_id][0].to_s.nil? || params[:sub_sector_id][0].to_s.empty?
      subsector_id = params[:sub_sector_id][0].to_s
      subsector = SubSector.find(subsector_id)
      conditions = "#{conditions} AND sub_sector_id = " + subsector_id
      @form_search_expression << "Sub sector es igual '#{subsector.nombre}'"
    end
    unless params[:rubro_id][0].to_s.nil? || params[:rubro_id][0].to_s.empty?
      rubro_id = params[:rubro_id][0].to_s
      rubro = Rubro.find(rubro_id)
      conditions = "#{conditions} AND rubro_id = " + rubro_id
      @form_search_expression << "Rubro es igual '#{rubro.nombre}'"
    end
    unless params[:sub_rubro_id][0].to_s.nil? || params[:sub_rubro_id][0].to_s.empty?
      sub_rubro_id = params[:sub_rubro_id][0].to_s
      sub_rubro = SubRubro.find(sub_rubro_id)
      conditions = "#{conditions} AND sub_rubro_id = " + sub_rubro_id
      @form_search_expression << "SubRubro es igual '#{sub_rubro.nombre}'"
    end
    unless params[:actividad_id][0].to_s.nil? || params[:actividad_id][0].to_s.empty?
      actividad_id = params[:actividad_id][0].to_s
      actividad = Actividad.find(actividad_id)
      conditions = "#{conditions} AND actividad_id = " + actividad_id
      @form_search_expression << "Actividad es igual '#{actividad.nombre}'"
    end
    unless params[:numero].nil? || params[:numero].empty?
      conditions = "#{conditions} AND numero_tramite =  #{params[:numero].to_i}"
      conditions_totales = "#{conditions_totales} AND numero_tramite =  #{params[:numero].to_i}"
      @form_search_expression << "Número Trámite igual '#{params[:numero]}'"
    end
    unless params[:ticket].nil? || params[:ticket].empty?
      conditions = "#{conditions} AND numero_ticket =  '#{params[:ticket]}'"
      conditions_totales = "#{conditions_totales} AND numero_ticket =  '#{params[:ticket]}'"
      @form_search_expression << "Número Ticket igual #{params[:ticket].to_s}"
    end
    unless params[:nombre].nil? || params[:nombre].empty?
      conditions = "#{conditions} AND LOWER(nombre_beneficiario) LIKE  '%#{params[:nombre].strip.downcase}%'"
      @form_search_expression << "Nombre o Apellido contenga '#{params[:nombre]}'"
    end
    unless params[:silo_id][0].to_s.nil? || params[:silo_id][0].to_s.empty?
      conditions = "#{conditions} AND silo_id = #{params[:silo_id][0].to_s}"
      silo = Silo.find(params[:silo_id][0])
      @form_search_expression << "Silo es igual '#{silo.nombre}'"
    end

    
    @list = ViewBandejaOtroArrime.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
  
  def fill
    @sector_list = Sector.find(:all, :order=>'nombre')
    unless @otro_arrime.id.nil?
      if @otro_arrime.rubro.sector_id
        sector_id = @otro_arrime.rubro.sector_id
      else
        sector_id = @sector_list[0].id
      end
    else
      sector_id = @sector_list[0].id
    end
    sub_sector_fill(sector_id)
  end

  def sub_sector_fill(sector_id)
    @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', sector_id], :order=>'nombre')
    unless @otro_arrime.rubro_id.nil?
      sub_sector_id = @otro_arrime.rubro.sub_sector_id
    else
      sub_sector_id = @sub_sector_list.first.id
    end
    rubro_fill(sub_sector_id)
  end

  def rubro_fill(sub_sector_id)
    unless @otro_arrime.id.nil?
      @rubro_list = Rubro.find(:all, :conditions=>['sub_sector_id = ?', sub_sector_id], :order=>'nombre')
    else
      @rubro_list = []
    end
  end

  def sector_change
    @rubro_id = params[:rubro_id]
    @sub_sector_list = SubSector.find(:all, :conditions=>"sector_id = #{params[:sector_id]}", :order=>'nombre')
    render :update do |page|
      page.replace_html 'sub_sector-search', :partial => 'sub_sector_search'
    end
  end
  def sub_sector_change
    @rubro_list = Rubro.find(:all, :conditions=>"sub_sector_id = #{params[:sub_sector_id]} and id <> #{params[:rubro_id]}", :order=>'nombre')
    render :update do |page|
      page.replace_html 'rubro-search', :partial => 'rubro_search'
    end
  end
 
  def silo_change
    @acta_silo_list = Silo.find(:first, :conditions=>"id = #{params[:id]}")
    render :update do |page|
      page.replace_html 'rif-silo', :partial => 'rif_silo'
    end
  end

  def confirmar
    fecha_confirmacion = Time.now.strftime('%Y/%m/%d')
    parametros = {"confirmacion"=>"true","fecha_confirmacion"=>fecha_confirmacion,"usuario_id"=>session[:id]}
    errores_update = OtroArrime.confirmacion(params[:id], parametros)
    if errores_update == true
      render :update do |page|
        page.remove "row_#{params[:id]}"
        page.hide 'error'
        page.replace_html 'message', "La boleta se Confirmo con éxito."
        page.show 'message'
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2> #{I18n.t('Sistema.Body.General.ocurrio_error')} </h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
    end

  end

  protected
  def common
    super
    @form_title = 'Confirmación Otras Boletas de Arrime'
    @form_title_record = 'Boleta de Arrime'
    @form_title_records = 'Boleta de Arrime'
    @form_entity = 'otro_arrime'
    @form_identity_field = 'numero_ticket'
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

