# encoding: utf-8
class Visitas::ControlVisitasPesca::EquipoSeguridadController < FormAjaxTabsController

   skip_before_filter :set_charset, :only=>[ :tabs, :sector_economico_change]

  def index
    @visita = params[:id]
  fill_equipo_seguridad 
    @visitas = SeguimientoVisita.find(params[:id])
    list
  end

  def list
    puts "Parametro id embarcacion "<< params[:id_de_embarcacion].to_s
    if params[:id_de_embarcacion].nil?
      id_de_embarcacion=0
    else
      id_de_embarcacion=params[:id_de_embarcacion]
    end

    puts "Parametro id  "<< params[:id].to_s
    @visita = params[:id]
    @id_embarcacion=params[:id_embarcacion]
    @equipo_seguridad = EquipoSeguridad.find_by_seguimiento_visita_id(params[:id])
    params['sort'] = "modelo" unless params['sort']
    
    conditions = "seguimiento_visita_id = #{params[:id]} and embarcacion_id = #{id_de_embarcacion}"
    @list = EquipoSeguridad.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    fill_equipo_seguridad
    @equipo_seguridad = EquipoSeguridad.new
    form_new @equipo_seguridad
  end

  def cancel_new
    form_cancel_new
  end

  def save_new
    @visita=params[:id]
    puts "Lista del save new =========> " << params.inspect
    puts "Parametro id= #{@visita} id_embarcacion= "<< params[:id_embarcacion].to_s

    @equipo_seguridad = EquipoSeguridad.new(params[:equipo_seguridad])
    @equipo_seguridad.seguimiento_visita_id =@visita
    @id_mo=@equipo_seguridad.embarcacion_id
    form_save_new @equipo_seguridad
  end

  def delete
    @visita = params[:id]
    @equipo_seguridad = EquipoSeguridad.find(params[:id_equipo])
    form_ajaxdelete @equipo_seguridad
  end

  def edit
    fill_equipo_seguridad
    @es_algo=1
    @visita = params[:id]
    @equipo_seguridad = EquipoSeguridad.find(params[:id_equipo])
    @identificador_embarcacion=@equipo_seguridad.embarcacion_id
    form_edit @equipo_seguridad
  end

  def save_edit
    @visita = params[:id]
    @equipo_seguridad = EquipoSeguridad.find(params[:id_equipo])
    @id_mo=@equipo_seguridad.embarcacion_id
    @id_seg=@equipo_seguridad.seguimiento_visita_id
    form_save_edit @equipo_seguridad  
  end

  def sector_economico_change
    fill_sector_tipo(params[:sector_economico_id])
    render :update do |page|
      page.replace_html 'sector-tipo-select', :partial => 'sector_tipo_select'
    end
  end

  def cancel_edit
    @visita = params[:id]
    @equipo_seguridad = EquipoSeguridad.find(params[:id_equipo])
    form_cancel_edit @equipo_seguridad
  end

  protected
  def common
    super
    @visitas = SeguimientoVisita.find(params[:id])
    @form_title = I18n.t('Sistema.Body.Controladores.VisitaSanidadAnimal.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Motores.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Motores.FormTitles.form_title_records')
    @form_entity = 'equipo_seguridad'
    @form_identity_field = 'modelo'
    @width_layout = '1080'
    @full_info = "#{@visitas.codigo_visita} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.solicitud')} #{@visitas.solicitud.numero} (#{@visitas.solicitud.nombre})"
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
    tipo_pasto=true
    @embarcaciones=Embarcacion.find(:all,:conditions=>"seguimiento_visita_id=#{@iii}", :order=>"nombre_embarcacion")
    @tipo_equipo_seguridad = TipoEquipoSeguridad.find(:all, :order=>'tipo',:conditions=>['activo=?',tipo_pasto])
  end



end

