# encoding: utf-8
class Visitas::ControlVisitasPesca::EmbarcacionController < FormAjaxTabsController

  skip_before_filter :set_charset, :only=>[ :tabs, :estado_search, :municipio_search, :tipo_pasto_change, :replicar, :view, :cancel_view]
  
	def index
		fill_embarcacion
		@visitas = SeguimientoVisita.find(params[:id])
    list
	end
	
  def list
    @visita = params[:id]
    @embarcacion = Embarcacion.find_by_seguimiento_visita_id(params[:id])
    params['sort'] = "nombre_embarcacion" unless params['sort']
    
    conditions = "seguimiento_visita_id = #{params[:id]}"
    @list = Embarcacion.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    fill_embarcacion
    @embarcacion = Embarcacion.new
    @embarcacion.seguimiento_visita_id=params[:id]
    @visita = params[:id]
    form_new @embarcacion
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    puts "Lista en el save_new =========> " << params.inspect
    puts "Parametro id  "<< params[:id].to_s
    @visita = params[:id]
    @embarcacion = Embarcacion.new(params[:embarcacion])
    @embarcacion.seguimiento_visita_id = @visita
    form_save_ajaxnew @embarcacion    
  end
  
  def delete
    @embarcacion = Embarcacion.find(params[:id_embarcacion])
		form_ajaxdelete @embarcacion    
  end
  
  def edit
    @estamos_editando=1
    fill_embarcacion
      
    @visita=params[:id]
    puts "Lista =========> " << params.inspect

    puts "Parametro id_embarcacion  "<< params[:id_embarcacion].to_s

    @embarcacion = Embarcacion.find(params[:id_embarcacion])
    logger.info"XXXXXXXXXXXXXXXX==============>>>>>"
    @estado_list= Estado.find(:all,:conditions=>"id = #{@embarcacion.estado_id}", :order=>'nombre')
    @municipio_list= Municipio.find(:all, :conditions=>"id = #{@embarcacion.municipio_id}", :order=>"nombre")
    @parroquia_list= Parroquia.find(:all,:conditions=>"id=#{@embarcacion.parroquia_id}", :order=>'nombre') 
    logger.info"XXXXXXXXXXXXXXXX==============>>>>>"<<@estado_list.inspect << " municipio "<< @municipio_list.inspect
    form_edit @embarcacion
  end

  def save_edit
    @id_embarcacion=params[:id_embarcacion]
    @visita=params[:id]

    if ( (@encontramos1.nil?) || (@encontramos2.nil?) || (@encontramos3.nil?) || (@encontramos4.nil?) )
      #si existe alguna solicitud de motores, artes de pesca, equipos de seguridad y faenas de pesca por esa embarcacion ent mostramos el link
      @link=1
    else
      #existe un link para crear nuevas solicitudes
      @link=0
    end

    @embarcacion = Embarcacion.find(params[:id_embarcacion])
    form_save_edit @embarcacion
  end
  
  def cancel_edit
    @visita=params[:id]
    @embarcacion = Embarcacion.find(params[:id_embarcacion])
		form_cancel_edit @embarcacion
  end

  def estado_search
    puts "Estado =========> " << params.inspect
    puts "Parametro id estado "<< params[:id].to_s
    @municipio_list = Municipio.find_by_sql("SELECT id, nombre FROM municipio where estado_id = #{params[:id].to_s} order by nombre")
    render :update do |page|
      page.replace_html 'municipio-search', :partial => 'municipio_search'
    end
  end
  
  
  def municipio_search
    puts "Municipio =========> " << params.inspect
    puts "Parametro id municipio "<< params[:id].to_s
    @parroquia_list = Parroquia.find_by_sql("SELECT id, nombre FROM parroquia where municipio_id = #{params[:id].to_s} order by nombre")
    render :update do |page|
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end
  
  def view
    @embarcacion = Embarcacion.find(params[:id_embarcacion])
    @visita=params[:id]
    form_view @embarcacion
  end

  def cancel_view
    @embarcacion = Embarcacion.find(params[:id_embarcacion])
    @visita=params[:id]
		form_cancel_view @embarcacion
  end

  def tipo_pasto_change
    tipo_pasto = params[:tipo_pasto_forraje_id]
    especie_variedad_pasto_fill(tipo_pasto)
    render :update do |page|
      page.replace_html 'especie_pasto-select', :partial => 'especie_pasto_select'
    end
  end

  def replicar
    @visitas= SeguimientoVisita.find(params[:id])
    @embarcacion = Embarcacion.find_by_seguimiento_visita_id(@visitas.id)
    if @embarcacion
      redirect_to :action=>index, :id=>@visitas.id
    else
      embarcacion_solicitud = Embarcacion.find(:all, :conditions=>"solicitud_id=#{@visitas.solicitud.id}",:order=>"id desc")
      embarcacion_solicitud = embarcacion_solicitud[0]
      if embarcacion_solicitud
        sql = "INSERT INTO embarcacion SELECT "
        sql +="nextval('embarcacion_id_seq'::regclass) as id, nombre_embarcacion, matricula, tipo_embarcacion_id, tipo_material_id, es_propia, eslora, manga, puntal, cantidad_tripulantes, uab, autonomia_pesca, proveedor_marino_id,solicitud_id, #{@visitas.id} as seguimiento_visita_id, puerto_base, condicion, coordenadas_utm_puerto_base, capacidad_combustible, lugares_pesca, estado_id, municipio_id, parroquia_id "
        sql +="from embarcacion where solicitud_id=#{@visitas.solicitud.id} and seguimiento_visita_id =#{embarcacion_solicitud.seguimiento_visita_id}"
        logger.debug "===>" << sql
        ActiveRecord::Base.connection.execute(sql)

        motores = Motores.find_by_seguimiento_visita_id(embarcacion_solicitud.seguimiento_visita_id)
        if motores
          sql1 = "INSERT INTO motores SELECT"
          sql1 +=" nextval('motores_id_seq'::regclass) as id, modelo_motor, numero_serial, cantidad_motores, ano, proveedor_marino_id, tipo_motor_id, #{@visitas.id} as seguimiento_visita_id, embarcacion_id, potencia, condicion, observacion, es_propio"
          sql1 +=" from motores where seguimiento_visita_id =#{embarcacion_solicitud.seguimiento_visita_id}"
          logger.debug "===>" << sql1
          ActiveRecord::Base.connection.execute(sql1)
        end
        arte_pesca = ArtePesca.find_by_seguimiento_visita_id(embarcacion_solicitud.seguimiento_visita_id)
        if arte_pesca
          sql2 = "INSERT INTO arte_pesca SELECT"
          sql2 +=" nextval('arte_pesca_id_seq'::regclass) as id, es_propia, nombre_arte_pesca, cantidad, largo, ancho, alto, luz_maya, nro_anzuelo, cantidad_anzuelos, material_linea_madre, material, tipo_cordel, nro_cordel, tipo_nylon_id, #{@visitas.id} as seguimiento_visita_id, embarcacion_id, condicion, tipo_arte_pesca_id"
          sql2 +=" from arte_pesca where seguimiento_visita_id =#{embarcacion_solicitud.seguimiento_visita_id}"
          logger.debug "===>" << sql2
          ActiveRecord::Base.connection.execute(sql2)
        end
        equipo_seguridad = EquipoSeguridad.find_by_seguimiento_visita_id(embarcacion_solicitud.seguimiento_visita_id)
        if equipo_seguridad
          sql3 = "INSERT INTO equipo_seguridad SELECT"
          sql3 +=" nextval('equipo_seguridad_id_seq'::regclass) as id, modelo, numero_serial, cantidad, ano, #{@visitas.id} as seguimiento_visita_id, embarcacion_id, tipo_equipo_id, condicion, descripcion, es_propio, con_gps"
          sql3 +=" from equipo_seguridad where seguimiento_visita_id =#{embarcacion_solicitud.seguimiento_visita_id}"
          logger.debug "===>" << sql3
          ActiveRecord::Base.connection.execute(sql3)
        end
        faenas_pesca = FaenasPesca.find_by_seguimiento_visita_id(embarcacion_solicitud.seguimiento_visita_id)
        if faenas_pesca
          sql4 = "INSERT INTO faenas_pesca SELECT"
          sql4 +=" nextval('faenas_pesca_id_seq'::regclass) as id, ganancia_por_unidad, gasto_por_unidad, destino_captura, tiempo_expiracion, tipo_especie_id, #{@visitas.id} as seguimiento_visita_id, embarcacion_id, faenas_mensual, captura_campana, captura_estimada,precio_x_kg"
          sql4 +=" from faenas_pesca where seguimiento_visita_id =#{embarcacion_solicitud.seguimiento_visita_id}"
          logger.debug "===>" << sql4
          ActiveRecord::Base.connection.execute(sql4)
        end

        @embarcacion_visita = Embarcacion.find(:all, :conditions=>"seguimiento_visita_id=#{@visitas.id}")
        @embarcacion_visita.each { |i|
          logger.debug "*********"
          logger.debug i.nombre_embarcacion
          logger.debug i.id
          em_anterior = Embarcacion.find_by_sql("select id from embarcacion where nombre_embarcacion='#{i.nombre_embarcacion}' and id < #{i.id} order by id desc limit 1")
          em_anterior = em_anterior[0]
          ActiveRecord::Base.connection.execute("UPDATE motores set embarcacion_id = #{i.id} where embarcacion_id = #{em_anterior.id} and seguimiento_visita_id=#{@visitas.id}")
          ActiveRecord::Base.connection.execute("UPDATE arte_pesca set embarcacion_id = #{i.id} where embarcacion_id = #{em_anterior.id} and seguimiento_visita_id=#{@visitas.id}")
          ActiveRecord::Base.connection.execute("UPDATE equipo_seguridad set embarcacion_id = #{i.id} where embarcacion_id = #{em_anterior.id} and seguimiento_visita_id=#{@visitas.id}")
          ActiveRecord::Base.connection.execute("UPDATE faenas_pesca set embarcacion_id = #{i.id} where embarcacion_id = #{em_anterior.id} and seguimiento_visita_id=#{@visitas.id}")
        }
      end
      redirect_to :action=>index, :id=>@visitas.id
    end
  end

  protected
  def common
    super
    @visitas = SeguimientoVisita.find(params[:id])
    @form_title = I18n.t('Sistema.Body.Controladores.VisitaSanidadAnimal.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Embarcacion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Embarcacion.FormTitles.form_title_records')
    @form_entity = 'embarcacion'
    @form_identity_field = 'nombre_embarcacion'
    @width_layout = '1080'
    @full_info = "#{@visitas.codigo_visita} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.solicitud')} #{@visitas.solicitud.numero} (#{@visitas.solicitud.nombre})"
  end

  def fill
    @tipo_pasto_forraje_list = TipoPastoForraje.find(:all, :order=>'id')
  end


  def fill_embarcacion
    @solicitud_id = SeguimientoVisita.find(params[:id].to_s)
    @identificador_rubro = Solicitud.find(@solicitud_id.solicitud_id.to_s)

    @estado_list = Estado.find(:all, :order=>'nombre')
    @municipio_list  = []
    @parroquia_list  = []

    
    if (params[:muestro].nil?)
      @muestro=-1
    end

    tipo_pasto=true
    @tipo_embarcacion  = TipoEmbarcacion.find(:all,:order=>'tipo',:conditions=>['activo=?',tipo_pasto])

    @tipo_material  = TipoMaterial.find(:all, :order=>'tipo')
    @proveedor_marino = ProveedorMarino.find(:all, :order=>'nombre')  
  end

  def especie_variedad_pasto_fill(tipo_pasto)
    @especie_variedad_pasto_list = EspecieVariedadPasto.find(:all, :order=>'id',:conditions=>['tipo_pasto_forraje_id=?',tipo_pasto])
    
  end

end

