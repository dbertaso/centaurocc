# encoding: utf-8
class Visitas::ControlVisitasPesca::FaenasPescaController < FormAjaxTabsController

  skip_before_filter :set_charset, :only=>[ :tabs]

  def index
    fill_faenas_pesca
    @visita = params[:id]
    @visitas = SeguimientoVisita.find(params[:id])
    list
  end

  def list
    if params[:id_de_embarcacion].nil?
      id_de_embarcacion=0
    else
      id_de_embarcacion=params[:id_de_embarcacion]
    end

    puts "Parametro id  "<< params[:id].to_s

    @visita = params[:id]
    @id_embarcacion=params[:id_embarcacion]
    @faenas_pesca = FaenasPesca.find_by_seguimiento_visita_id(params[:id])
    params['sort'] = "destino_captura" unless params['sort']
    
    conditions = "seguimiento_visita_id = #{params[:id]} and embarcacion_id = #{id_de_embarcacion}"
    @list = FaenasPesca.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    fill_faenas_pesca
    @faenas_pesca = FaenasPesca.new
    form_new @faenas_pesca
  end


  def cancel_new
    form_cancel_new
  end

  def save_new
    @visita = params[:id]
    @faenas_pesca = FaenasPesca.new(params[:faenas_pesca])
    @faenas_pesca.seguimiento_visita_id=@visita
    @id_mo=@faenas_pesca.embarcacion_id
    @id_seg=@faenas_pesca.seguimiento_visita_id
    form_save_ajaxnew @faenas_pesca
  end

  def delete
    @visita = params[:id]
    @faenas_pesca = FaenasPesca.find(params[:id_faena])
    form_ajaxdelete @faenas_pesca
  end

  def edit
    @visita = params[:id]
    fill_faenas_pesca
    @es_algo=1
    @faenas_pesca = FaenasPesca.find(params[:id_faena])
    @identificador_embarcacion=@faenas_pesca.embarcacion_id
    form_edit @faenas_pesca
  end

  def save_edit
    @visita = params[:id]
    @faenas_pesca = FaenasPesca.find(params[:id_faena])
    @id_mo=@faenas_pesca.embarcacion_id
    form_save_edit @faenas_pesca
  end

  def cancel_edit
    @visita = params[:id]
    @faenas_pesca = FaenasPesca.find(params[:id_faena])
    form_cancel_edit @faenas_pesca
  end

  protected
  def common
    super
    @visitas = SeguimientoVisita.find(params[:id])
    @form_title = I18n.t('Sistema.Body.Controladores.VisitaSanidadAnimal.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.FaenasPesca.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.FaenasPesca.FormTitles.form_title_records')
    @form_entity = 'faenas_pesca'
    @form_identity_field = 'destino_captura'
    @width_layout = '1080'
    @full_info = "#{@visitas.codigo_visita} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.solicitud')} #{@visitas.solicitud.numero} (#{@visitas.solicitud.nombre})"
  end

  
  def fill_sector_economico
    @sector_economico_list = SectorEconomico.find(:all, :conditions=>'activo = true and id <> 1000', :order=>'descripcion')
    fill_sector_tipo(@sector_economico_list.first.id)
  end

  def fill_sector_tipo(sector_economico_id)
    @sector_tipo_list = SectorTipo.find(:all, :conditions=>['id = 1 or sector_economico_id = ?',sector_economico_id], :order=>'nombre')
  end

  def fill_faenas_pesca
    if params[:id].nil?
      @mot = FaenasPesca.find(params[:id_faena])
      @iii=@mot.seguimiento_visita_id
    else
      @iii=params[:id]
    end
    
    @solicitud_id = SeguimientoVisita.find(@iii.to_s)
    @identificador_rubro = Solicitud.find(@solicitud_id.solicitud_id.to_s)

    @faenas_pesca = Item.find_by_sql("select nombre, id, activo from item where partida_id in (select id from partida where rubro_id = #{@identificador_rubro.rubro_id.to_s} and lower(nombre) like 'capital de campaña o faena de pesca' order by nombre) order by nombre")
    @tipo_especie=TipoEspecieAcuicultura.find(:all,:order=>'nombre')
    @embarcaciones=Embarcacion.find(:all,:conditions=>"seguimiento_visita_id=#{@iii}", :order=>"nombre_embarcacion")
  end


end

