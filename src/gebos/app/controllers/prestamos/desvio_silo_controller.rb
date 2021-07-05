# encoding: utf-8 
class Prestamos::DesvioSiloController < FormTabTabsController

  skip_before_filter :set_charset, :only=>[:tabs, :silo_origen_change, :silo_destino_change]
  
	def index
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(params[:solicitud_id])
		list()
	end
	
  def list
    params['sort'] = "desvio_silo.solicitud_id" unless params['sort']
    conditions = "solicitud_id = #{@view_boleta_arrime.solicitud_id}"
    conditions  << " and solicitud_id > 0"
    
    @list = DesvioSilo.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(params[:solicitud_id])
    @desvio_silo = DesvioSilo.new
    @desvio_silo.actividad_id = params[:actividad_id]
    fill_origen
  end

  def fill_origen
    @municipio = Municipio.find(Oficina.find(session[:oficina]).municipio_id.to_s)
    @silo_list = Silo.find(:all, :conditions=>["estado_id = #{@municipio.estado_id}"])
    if @desvio_silo.nil?
      id = nil
    else
      id = @desvio_silo.silo_origen_id
    end
    fill_destino(id, params[:actividad_id])
  end

  def silo_origen_change
    fill_destino(params[:id], params[:actividad_id])
    @view_silo_list = Silo.find(params[:id])
    render :update do |page|
      page.replace_html 'rif-silo-origen', :partial => 'rif_silo_origen'
      page.replace_html 'silo-destino', :partial => 'silo_destino'
    end
  end

  def fill_destino(id, actividad_id)
    if id.nil?
      @view_acta_silo = []
    else
      @view_acta_silo = ViewActaSilo.find(:all, :conditions=>["actividad_id = #{actividad_id} and id <> #{id} and status = true and fecha_fin is null"])
    end
  end

  def silo_destino_change
    if params[:id].blank?
      @view_silo_destino_list = nil
    else
      @view_silo_destino_list = ViewActaSilo.find_by_id(params[:id])
    end
    render :update do |page|
      page.replace_html 'rif-silo-destino', :partial => 'rif_silo_destino'
    end
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    nombre_conductor = eliminar_acentos(params[:desvio_silo][:nombre_conductor])
    params[:desvio_silo][:nombre_conductor] = nombre_conductor.upcase
    placa_vehiculo = eliminar_acentos(params[:desvio_silo][:placa_vehiculo])
    params[:desvio_silo][:placa_vehiculo] = placa_vehiculo.upcase
    @desvio_silo = DesvioSilo.new(params[:desvio_silo])
    @desvio_silo.solicitud_id = params[:solicitud_id]
    @desvio_silo.cliente_id = params[:cliente_id]
    @desvio_silo.usuario_id = session[:id]
    hora = Time.now.strftime("%X,%p")
    @desvio_silo.hora_desvio_f = hora
    logger.info"XXXXXXXX=========save======>>>>"<<@desvio_silo.inspect
 		form_save_new @desvio_silo
  end
  
  def delete
    @desvio_silo = DesvioSilo.find(params[:id])
    form_delete @desvio_silo
  end
  
  def edit
    @desvio_silo = DesvioSilo.find(params[:id])
    @view_boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(@desvio_silo.solicitud_id)
    @silo_list = Silo.find(:all, :conditions=>["estado_id = #{@desvio_silo.silo_origen.estado_id}"])
    @view_acta_silo = ViewActaSilo.find(:all, :conditions=>["actividad_id = #{@desvio_silo.actividad_id}"])
    fill_silo(@desvio_silo.silo_origen_id, @desvio_silo.silo_destino_id)
  end

  def fill_silo(silo_origen_id, silo_destino_id)
    @view_silo_list = Silo.find(silo_origen_id)
    @view_silo_destino_list = ViewActaSilo.find_by_silo_destino_id(silo_destino_id)
  end

  def save_edit
    nombre_conductor = eliminar_acentos(params[:desvio_silo][:nombre_conductor])
    params[:desvio_silo][:nombre_conductor] = nombre_conductor.upcase
    placa_vehiculo = eliminar_acentos(params[:desvio_silo][:placa_vehiculo])
    params[:desvio_silo][:placa_vehiculo] = placa_vehiculo.upcase
    @desvio_silo = DesvioSilo.find(params[:id])
		form_save_edit @desvio_silo
  end

  def cancel_edit
    @desvio_silo = DesvioSilo.find(params[:id])
		form_cancel_edit @desvio_silo
  end

  protected
  def fill
    @ciclo_productivo_select = CicloProductivo.find(:all, :order=>"nombre")
    if @ciclo_productivo_select.length == 0
      @ciclo_productivo_select = []
    end  
  end
  
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.Arrime.HeaderDesvioSilo.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.Arrime.HeaderDesvioSilo.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Vistas.Arrime.HeaderDesvioSilo.form_title_records')
    @form_entity = 'desvio_silo'
    @form_identity_field = 'nombre'
    @width_layout = '850'
  end
  
end
