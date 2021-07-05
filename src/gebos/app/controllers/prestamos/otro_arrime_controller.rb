# encoding: utf-8
class Prestamos::OtroArrimeController < FormTabTabsController

  skip_before_filter :set_charset, :only=>[:tabs, :silo_change, :sector_change, :sub_sector_change, :sub_sector_change, :rubro_change, :sub_rubro_change, :imprimir]
  
  def index
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(params[:solicitud_id])
    list
  end

  def list
    params['sort'] = "otro_arrime.solicitud_id" unless params['sort']
    conditions = "solicitud_id = #{@view_boleta_arrime.solicitud_id}"
    conditions  << " and solicitud_id > 0"
    
    @list = OtroArrime.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end


  def new
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(params[:solicitud_id])
    @cliente= Cliente.find(@view_boleta_arrime.cliente_id)
    @actividad= Actividad.find(@view_boleta_arrime.actividad_id)
    @otro_arrime = OtroArrime.new
    hora = Time.now.strftime("%X,%p")
    @otro_arrime.hora_registro_f = hora
    @municipio = Municipio.find(Oficina.find(session[:oficina]).municipio_id.to_s)
    @silo_list = Silo.find(:all, :conditions=>["estado_id = #{@municipio.estado_id}"])
    fill
  end

  def silo_change
    @acta_silo_list = Silo.find(:first, :conditions=>"id = #{params[:id]}")
    render :update do |page|
      page.replace_html 'rif-silo', :partial => 'rif_silo'
    end
  end

def sector_change
  @actividad_id = params[:actividad_id]
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-search', :partial => 'sub_sector_search'
    end
  end
  def sub_sector_change
    @actividad_id = params[:actividad_id]
    @rubro_list = Rubro.find(:all, :conditions=>"sub_sector_id = #{params[:sub_sector_id]}")
    render :update do |page|
      page.replace_html 'rubro-search', :partial => 'rubro_search'
    end
  end
  def rubro_change
    @actividad_id = params[:actividad_id]
    @sub_rubro_list = SubRubro.find(:all, :conditions=>"rubro_id = #{params[:rubro_id]}")
    render :update do |page|
      page.replace_html 'sub-rubro-search', :partial => 'sub_rubro_search'
    end
  end
  def sub_rubro_change
    @actividad_list = Actividad.find(:all, :conditions=>"sub_rubro_id = #{params[:sub_rubro_id]} and id <> #{params[:actividad_id]}")
    render :update do |page|
      page.replace_html 'actividad-search', :partial => 'actividad_search'
    end
  end

  def save_new
    nombre_conductor = eliminar_acentos(params[:otro_arrime][:nombre_conductor])
    params[:otro_arrime][:nombre_conductor] = nombre_conductor.upcase
    placa_vehiculo = eliminar_acentos(params[:otro_arrime][:placa_vehiculo])
    params[:otro_arrime][:placa_vehiculo] = placa_vehiculo.upcase
    guia_movilizacion = eliminar_acentos(params[:otro_arrime][:guia_movilizacion])
    params[:otro_arrime][:guia_movilizacion] = guia_movilizacion.upcase
    @otro_arrime = OtroArrime.new(params[:otro_arrime])
    @otro_arrime.solicitud_id = params[:solicitud_id]
    @otro_arrime.cliente_id = params[:cliente_id]
 		form_save_new @otro_arrime
  end

  def edit
    @otro_arrime = OtroArrime.find(params[:id])
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(@otro_arrime.solicitud_id)
    @silo_list = Silo.find(:all, :conditions=>["estado_id = #{@otro_arrime.silo.estado_id}"])
    @acta_silo_list = Silo.find(:first, :conditions=>"id = #{@otro_arrime.silo_id}")
    fill
  end

def save_edit
    @otro_arrime = OtroArrime.find(params[:id])
    form_save_edit @otro_arrime
  end

  def view
    @otro_arrime = OtroArrime.find(params[:id])
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(params[:solicitud_id])
  end

  def delete
    @otro_arrime = OtroArrime.find(params[:id])
    form_delete @otro_arrime
  end

  def cancel_new
		form_cancel_new
  end

  def imprimir
    @form_title = ''
    @otro_arrime = OtroArrime.find(params[:id])
    @vista = 'view_imprimir'
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(params[:solicitud_id])
    @cuenta_bancaria = CuentaBancaria.find_by_cliente_id(@otro_arrime.cliente_id)
    if @cuenta_bancaria.nil?
      @entidad_financiera = nil
    else
      @entidad_financiera = EntidadFinanciera.find_by_id(@cuenta_bancaria.entidad_financiera_id)
    end
  end

 
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.Arrime.HeaderOtroArrime.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.Arrime.HeaderOtroArrime.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Vistas.Arrime.HeaderOtroArrime.form_title_records')
    @form_entity = 'otro_arrime'
    @form_identity_field = 'numero_ticket'
    @width_layout = '1000'
  end

  def fill
    @sector_list = Sector.find(:all, :order=>'nombre')
    unless @otro_arrime.id.nil?
      @solicitud = Solicitud.new
      @solicitud.sector_id = @otro_arrime.actividad.sub_rubro.rubro.sub_sector.sector_id
      sector_id = @otro_arrime.actividad.sub_rubro.rubro.sector_id
      sub_sector_fill(sector_id)
    else
      sub_sector_fill(0)
    end
  end
  def sub_sector_fill(sector_id)
    if (sector_id.to_i > 0)
      @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', sector_id], :order=>'nombre')
      unless @otro_arrime.nil?
        @solicitud.sub_sector_id = @otro_arrime.actividad.sub_rubro.rubro.sub_sector_id
        sub_sector_id = @otro_arrime.actividad.sub_rubro.rubro.sub_sector_id
        rubro_fill(sub_sector_id)
      end
    else
      @sub_sector_list = []
      rubro_fill(0)
    end 
  end
  def rubro_fill(sub_sector_id)
    if sub_sector_id.to_i > 0
      @rubro_list = Rubro.find(:all, :conditions=>['sub_sector_id = ?', sub_sector_id], :order=>'nombre')
      unless @otro_arrime.nil?
        @solicitud.rubro_id = @otro_arrime.actividad.sub_rubro.rubro_id
        rubro_id = @otro_arrime.actividad.sub_rubro.rubro_id
        sub_rubro_fill(rubro_id)
      end
    else
      @rubro_list = []
      sub_rubro_fill(0)
    end
  end
  def sub_rubro_fill(rubro_id)
    if rubro_id > 0
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['rubro_id = ?', rubro_id], :order=>'nombre')
      unless @otro_arrime.nil?
        @solicitud.sub_rubro_id = @otro_arrime.actividad.sub_rubro_id
        sub_rubro_id = @otro_arrime.actividad.sub_rubro_id
        actividad_fill(sub_rubro_id)
      end
    else
      @sub_rubro_list = []
      actividad_fill(0)
    end
  end
  def actividad_fill(sub_rubro_id)
    if sub_rubro_id > 0
      @actividad_list = Actividad.find(:all, :conditions=>['sub_rubro_id = ?', sub_rubro_id], :order=>'nombre')
    else
      @actividad_list = []
    end
  end

  
  
end

