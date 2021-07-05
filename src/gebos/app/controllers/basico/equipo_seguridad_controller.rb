# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Basico::EquipoSeguridadController
# descripción: Migración a Rails 3
#
class Basico::EquipoSeguridadController < FormAjaxTabsController

  def index
    @visita = params[:id]

    fill_equipo_seguridad
    #@id_embarcacion=params[:id_embarcacion]
    
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

    puts "Parametro id  "<< params[:id].to_s


    @visita = params[:id]
    @id_embarcacion=params[:id_embarcacion]
    @equipo_seguridad = EquipoSeguridad.find_by_seguimiento_visita_id(params[:id])
    params['sort'] = "modelo" unless params['sort']
    
    @condition = "seguimiento_visita_id = #{params[:id]} and embarcacion_id = #{id_de_embarcacion}"    
    @list = EquipoSeguridad.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end

  def new

    fill_equipo_seguridad
    @eq1=0
    @eq2=0    
    @equipo_seguridad = EquipoSeguridad.new
    form_new @equipo_seguridad


    #end
  end

  def cancel_new
    form_cancel_new
  end

  def save_new
    @visita=params[:id]
    #@id_embarcacion=params[:id_embarcacion]
    @equipo_seguridad = EquipoSeguridad.new(params[:equipo_seguridad])
    @equipo_seguridad.seguimiento_visita_id =@visita
    #@equipo_seguridad.embarcacion_id =@id_embarcacion
    @id_mo=@equipo_seguridad.embarcacion_id
    
    form_save_new @equipo_seguridad

  end

  def delete
    @equipo_seguridad = EquipoSeguridad.find(params[:id])
    form_delete @equipo_seguridad
  end

  def edit
    fill_equipo_seguridad
    @es_algo=1
    @equipo_seguridad = EquipoSeguridad.find(params[:id_equipo])
    
	  @estoy_editando="1"
    if @equipo_seguridad.es_propio
      @es_propia="1"
    else
      @es_propia="0"
    end


    if @equipo_seguridad.condicion != "***No-aplica***" && @equipo_seguridad.condicion != nil
      @eq1=1
    else
      @eq1=0
    end
    
    if @equipo_seguridad.descripcion != "***No-aplica***" && @equipo_seguridad.descripcion != nil
      @eq2=1
    else
      @eq2=0
    end
    
    
    
    @identificador_embarcacion=@equipo_seguridad.embarcacion_id
    #fill_sector_tipo(@actividad_economica.sector_economico_id)
    form_edit @equipo_seguridad
  end

  def save_edit
    @equipo_seguridad = EquipoSeguridad.find(params[:id_equipo])
    @id_mo=@equipo_seguridad.embarcacion_id
    @id_seg=@equipo_seguridad.seguimiento_visita_id
    
    #@motores.embarcacion_id=@id_embarcacion
    form_save_edit @equipo_seguridad
    
  end

  def sector_economico_change
    fill_sector_tipo(params[:sector_economico_id])
    render :update do |page|
      page.replace_html 'sector-tipo-select', :partial => 'sector_tipo_select'
    end
  end

  def cancel_edit
    @equipo_seguridad = EquipoSeguridad.find(params[:id])
    form_cancel_edit @equipo_seguridad
  end

  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')}"
    @form_title_record = I18n.t('Sistema.Body.Controladores.EquipoSeguridad.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.EquipoSeguridad.FormTitles.form_title_records')
    @form_entity = 'equipo_seguridad'
    @form_identity_field = 'modelo'
    @width_layout = '955'
  end

  private
  def fill_sector_economico
    @sector_economico_list = SectorEconomico.find(:all, :conditions=>'activo = true and id <> 1000', :order=>'descripcion')
    fill_sector_tipo(@sector_economico_list.first.id)
  end

  def fill_sector_tipo(sector_economico_id)
    @sector_tipo_list = SectorTipo.find(:all, :conditions=>['id = 1 or sector_economico_id = ?',sector_economico_id], :order=>'nombre')
  end

  def fill_equipo_seguridad

    if params[:id].nil?
      @mot = EquipoSeguridad.find(params[:id_equipo])
      @iii=@mot.seguimiento_visita_id
    else
      @iii=params[:id]
    end
    
    @solicitud_id = SeguimientoVisita.find(@iii.to_s)
    @identificador_rubro = Solicitud.find(@solicitud_id.solicitud_id.to_s)
    #@partida= Partida.find(:partida_id ,conditions=>'rubro_id=' + @identificador_rubro)
    #@item= Item.find(:partida_id ,conditions=>'rubro_id=' + @identificador_rubro)

    #@muestro=-1
    #@equipo_seguridad1 = Item.find_by_sql("select nombre, id, activo from item where partida_id in (select id from partida where rubro_id = #{@identificador_rubro.rubro_id.to_s} and lower(nombre) like 'equipos de seguridad' order by nombre) order by nombre")
    @embarcaciones=Embarcacion.find(:all,:conditions=>"solicitud_id = #{@solicitud_id.solicitud_id}", :order=>'nombre_embarcacion')
    tipo_pasto=true
    @tipo_equipo_seguridad = TipoEquipoSeguridad.find(:all, :order=>'tipo',:conditions=>['activo=?',tipo_pasto])

  end



end

