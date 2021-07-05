# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Basico::MotoresController
# descripción: Migración a Rails 3

class Basico::MotoresController < FormAjaxTabsController
  
  skip_before_filter :set_charset, :only=>[:proveedor_click]

  def index

    @visita = params[:id]
    fill_motores
    @visitas = SeguimientoVisita.find(params[:id])
    @solicitud = Solicitud.find(@visitas.solicitud_id)
    list

  end

  def list

    if params[:id_de_embarcacion].to_s==''
      id_de_embarcacion=0
    else
      id_de_embarcacion=params[:id_de_embarcacion]
    end

    @visita = params[:id]
    @id_embarcacion=params[:id_embarcacion]
    @motores = Motores.find_by_seguimiento_visita_id(params[:id])
    params['sort'] = "modelo_motor" unless params['sort']
    @total = Motores.count(:all, :conditions => ['seguimiento_visita_id = ? and embarcacion_id = ?', params[:id],id_de_embarcacion])
    conditions = "seguimiento_visita_id = #{params[:id]} and embarcacion_id = #{id_de_embarcacion}"

    
    @list = Motores.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list
  
  end

  def new
    
    fill_motores
    @mo1=0
    @mo2=0
    @motores = Motores.new
    form_new @motores

  end

  def cancel_new
    form_cancel_new
  end

  def save_new
    @visita=params[:id]
    @motores = Motores.new(params[:motores])
    @motores.seguimiento_visita_id =@visita
    @id_mo=@motores.embarcacion_id

    form_save_new @motores

  end

  def delete
    @motores = Motores.find(params[:id])
    form_delete @motores
  end

  def edit
    fill_motores
    @es_algo=1
    @motores = Motores.find(params[:id_equipo])
	  @estoy_editando="1"
    @es_asociado_fondas=@motores.proveedor_marino.asociado_fondas

    if @motores.es_propio
      @es_propio="1"
    else
      @es_propio="0"
    end
    @identificador_embarcacion=@motores.embarcacion_id
    
    if @motores.condicion != '***No-aplica***' && @motores.condicion != nil 
      @mo1=1
    else
      @mo1=0
    end
    
    if @motores.observacion != '***No-aplica***' && @motores.observacion != nil
      @mo2=1
    else
      @mo2=0
    end
    
    form_edit @motores
  end

  def save_edit
    @motores = Motores.find(params[:id_equipo])
    @id_mo=@motores.embarcacion_id
    @id_seg=@motores.seguimiento_visita_id

    form_save_edit @motores

  end

  def sector_economico_change
    fill_sector_tipo(params[:sector_economico_id])
    render :update do |page|
      page.replace_html 'sector-tipo-select', :partial => 'sector_tipo_select'
    end
  end

  def cancel_edit
    @motores = Motores.find(params[:id])
    form_cancel_edit @motores
  end

  def proveedor_click
    if params[:valor]=="true"
      @proveedor_marino=ProveedorMarino.find(:all,:conditions=>"asociado_fondas = 't'",:order=>"nombre")
    else
      @proveedor_marino=ProveedorMarino.find(:all,:conditions=>"asociado_fondas = 'f'",:order=>"nombre")
    end
    render :update do |page|
      page.replace_html 'proveedor-marino-select', :partial => 'proveedor_marino_select'.html_safe
      page.show 'proveedor-marino-select'
    end  
  end

  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.motor')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.motores')
    @form_entity = 'motores'
    @form_identity_field = 'modelo_motor'
    @width_layout = '955'
  end

   def fill_motores
    
    if params[:id].nil?
      @mot = Motores.find(params[:id_equipo])
      @iii=@mot.seguimiento_visita_id
    else
      @iii=params[:id]
    end

    @solicitud_id = SeguimientoVisita.find(@iii.to_s)
    @identificador_rubro = Solicitud.find(@solicitud_id.solicitud_id.to_s)
    @tipo_motor=TipoMotor.find(:all,:order=>'tipo',:conditions=>['activo=?', true])
    @embarcaciones=Embarcacion.find(:all, :conditions=>"solicitud_id = #{@solicitud_id.solicitud_id}",:order=>'nombre_embarcacion')
    @proveedor_marino=ProveedorMarino.find(:all, :order=>'nombre')

  end

end
