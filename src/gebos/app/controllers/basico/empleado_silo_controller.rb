# encoding: utf-8
class Basico::EmpleadoSiloController < FormTabTabsController
  
  skip_before_filter :set_charset, :only=>[:estado_change, :municipio_change, :tabs ]
	
	def index
	  @silo = Silo.find(params[:silo_id])
	  list
  end
  
  def list
    @silo = Silo.find(params[:silo_id])
    params['sort'] = "silo.nombre, empleado_silo.primer_nombre" unless params['sort']
    conditions = "silo.id =#{@silo.id}"
    
    @list = EmpleadoSilo.search(conditions, params[:page], params[:sort])
    @total=@list.count
   form_list
  end
	
  def new
    @silo = Silo.find(params[:silo_id])
    @empleado_silo = EmpleadoSilo.new
    fill_empleado_silo
  end
    
  def cancel_new
		form_cancel_new
  end

  def save_new
    @empleado_silo = EmpleadoSilo.new(params[:empleado_silo])
    @empleado_silo.silo_id = params[:silo_id]
		form_save_new @empleado_silo
  end

  def delete
    @empleado_silo = EmpleadoSilo.find(params[:id])
    form_delete @empleado_silo
  end
  
  def edit
    @empleado_silo = EmpleadoSilo.find(params[:id])
    @silo = @empleado_silo.silo
    fill_empleado_silo
  end
  
  def view
    @empleado_silo = EmpleadoSilo.find(params[:id])
  end
  
  def save_edit
    @empleado_silo = EmpleadoSilo.find(params[:id])
    form_save_edit @empleado_silo
  end

  def cancel_edit
    @empleado_silo = EmpleadoSilo.find(params[:id])
		form_cancel_edit @empleado_silo
  end

  def estado_change
    municipio_fill(params[:estado_id])
    render :update do |page|
      page.replace_html 'municipio-search', :partial => 'municipio_search'
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end

  def municipio_change
    parroquia_fill(params[:municipio_id])
    render :update do |page|
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end

  def fill_empleado_silo
    @estado = Estado.find(:all, :order=>'nombre')
    @profesion = Profesion.find(:all, :order=>'nombre')
    unless @empleado_silo.nil?
      if @empleado_silo.estado_id
        estado_id = @empleado_silo.estado_id
      else
        estado_id = @estado[0].id
      end
    else
      estado_id = @estado[0].id
    end
    municipio_fill(estado_id)
  end

  def municipio_fill(estado_id)
    @municipio_list = Municipio.find(:all, :conditions=>['estado_id = ?', estado_id], :order=>'nombre')
    if @empleado_silo && @empleado_silo.municipio_id
      municipio_id = @empleado_silo.municipio_id
    else
      municipio_id = @municipio_list.first.id
    end
    parroquia_fill(municipio_id)
  end

  def parroquia_fill(municipio_id)
    @parroquia_list = Parroquia.find(:all, :conditions=>['municipio_id = ?', municipio_id], :order=>'nombre')
  end
   
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.EmpleadoSilo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.EmpleadoSilo.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.EmpleadoSilo.FormTitles.form_title_records')
    @form_entity = 'empleado_silo'
    @form_identity_field = 'nombre'
    @width_layout = '850'
  end
  
end
