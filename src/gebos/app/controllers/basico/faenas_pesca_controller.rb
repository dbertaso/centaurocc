# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Basico::EquipoSeguridadController
# descripción: Migración a Rails 3
#
class Basico::FaenasPescaController < FormAjaxTabsController

  def index
    fill_faenas_pesca
    @visita = params[:id]
    @visitas = SeguimientoVisita.find(params[:id])
    @solicitud = Solicitud.find(@visitas.solicitud_id)
    #@id_embarcacion = params[:id_embarcacion]
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
    @faenas_pesca = FaenasPesca.find_by_seguimiento_visita_id(params[:id])
    params['sort'] = "destino_captura" unless params['sort']
    
    @condition = "seguimiento_visita_id = #{params[:id]} and embarcacion_id = #{id_de_embarcacion}"
    @list = FaenasPesca.search(@condition, params[:page], params[:sort])
    @total=@list.count
    form_list

  end

  def new

    #fill_sector_economico
    fill_faenas_pesca
    @fa1=0
    @fa2=0
    @fa3=0
    @faenas_pesca = FaenasPesca.new

    form_new @faenas_pesca
    #end

  end


  def cancel_new
    form_cancel_new
  end

  def save_new
    @visita = params[:id]
    #@id_embarcacion=params[:id_embarcacion]
    @faenas_pesca = FaenasPesca.new(params[:faenas_pesca])
    @faenas_pesca.seguimiento_visita_id=@visita
    @id_mo=@faenas_pesca.embarcacion_id
    @id_seg=@faenas_pesca.seguimiento_visita_id

    form_save_new @faenas_pesca
    #logger.debug @faenas_pesca.inspect
  end

  def delete
    @faenas_pesca = FaenasPesca.find(params[:id])
    form_delete @faenas_pesca
  end

  def edit
    #fill_sector_economico
    #fill_sitio_colocacion
    fill_faenas_pesca
    @es_algo=1
    @faenas_pesca = FaenasPesca.find(params[:id_faena])
    #fill_sector_tipo(@actividad_economica.sector_economico_id)
    
    if @faenas_pesca.faenas_mensual > 1 && @faenas_pesca.faenas_mensual != nil
      @fa1=1
    else
      @fa1=0
    end
    
    if @faenas_pesca.captura_campana > 0 && @faenas_pesca.captura_campana != nil
      @fa2=1
    else
      @fa2=0
    end
    
    if @faenas_pesca.captura_estimada > 0 && @faenas_pesca.captura_estimada != nil
      @fa3=1
    else
      @fa3=0
    end
        
    
    @identificador_embarcacion=@faenas_pesca.embarcacion_id
    
    form_edit @faenas_pesca
  end

  def save_edit
    @faenas_pesca = FaenasPesca.find(params[:id_faena])
    
    @id_mo=@faenas_pesca.embarcacion_id
    #@motores.embarcacion_id=@id_embarcacion
    form_save_edit @faenas_pesca
    
    #form_save_edit @faenas_pesca
  end


  def cancel_edit
    @faenas_pesca = FaenasPesca.find(params[:id])
    form_cancel_edit @faenas_pesca
  end

  protected
  def common
    super
    @form_title = 'Faena de Pesca'
    @form_title_record = 'Faena de Pesca'
    @form_title_records = 'Faenas de Pesca'
    @form_entity = 'faenas_pesca'
    @form_identity_field = 'destino_captura'
    @width_layout = '955'
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
    @embarcaciones=Embarcacion.find(:all,:conditions=>"solicitud_id = #{@solicitud_id.solicitud_id}", :order=>'nombre_embarcacion')    

  end
end
