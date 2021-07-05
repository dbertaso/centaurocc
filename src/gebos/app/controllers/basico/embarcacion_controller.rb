# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Basico::EmbarcacionController
# descripción: Migración a Rails 3
#
class Basico::EmbarcacionController < FormAjaxTabsController
  
  skip_before_filter :set_charset, :only=>[:proveedor_click]
  
	def index
		fill_embarcacion
		@visitas = SeguimientoVisita.find(params[:id])
    @solicitud = Solicitud.find(@visitas.solicitud_id)
    list
	end
	
  def list
    @visita = params[:id]
    @embarcacion = Embarcacion.find_by_seguimiento_visita_id(params[:id])
    conditions = "seguimiento_visita_id = #{params[:id]}"
    params['sort'] = "nombre_embarcacion" unless params['sort']
    
    @list = Embarcacion.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    fill_embarcacion
    @embarcacion = Embarcacion.new
    @embarcacion.seguimiento_visita_id=params[:id]
    @visita = params[:id]
    @em1=0
    @em2=0
    @em3=0
    @em4=0
    @em5=0
    @em6=0
    @em7=0
    @em8=0
    form_new @embarcacion
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @visita = params[:id]
    @visitas = SeguimientoVisita.find(@visita)
    @embarcacion = Embarcacion.new(params[:embarcacion])

    @embarcacion.seguimiento_visita_id = @visita
    @embarcacion.solicitud_id = @visitas.solicitud.id
    form_save_new @embarcacion  
  end
  
  def delete
    @embarcacion = Embarcacion.find(params[:id_embarcacion])
		form_delete @embarcacion    
  end
  
  def edit
    fill_embarcacion

    @visita=params[:id]

    @embarcacion = Embarcacion.find(params[:id_embarcacion])
	  @estoy_editando="1"
      
    @es_asociado_fondas=@embarcacion.proveedor_marino.asociado_fondas


    if @embarcacion.es_propia
      @es_propia="1"
    else
      @es_propia="0"
    end

	  if @embarcacion.puerto_base != I18n.t('Sistema.Body.Controladores.Embarcacion.Etiquetas.no_aplica') && @embarcacion.puerto_base != nil
      @em1=1
    else
      @em1=0
    end
    
    if @embarcacion.condicion != I18n.t('Sistema.Body.Controladores.Embarcacion.Etiquetas.no_aplica') && @embarcacion.condicion != nil
      @em2=1
    else
      @em2=0
    end
	
	  if @embarcacion.coordenadas_utm_puerto_base != I18n.t('Sistema.Body.Controladores.Embarcacion.Etiquetas.no_aplica') && @embarcacion.coordenadas_utm_puerto_base != nil
      @em3=1
    else
      @em3=0
    end
	
	  if @embarcacion.capacidad_combustible > 1 && @embarcacion.capacidad_combustible != nil
      @em4=1
    else
      @em4=0
    end
	
	  if @embarcacion.lugares_pesca != I18n.t('Sistema.Body.Controladores.Embarcacion.Etiquetas.no_aplica') && @embarcacion.lugares_pesca != nil
      @em5=1
    else
      @em5=0
    end
	
	  if @embarcacion.estado_id != 25 && @embarcacion.estado_id != nil
      @em6=1
    else
      @em6=0
    end
				
	  if @embarcacion.municipio_id != 359 && @embarcacion.municipio_id != nil
      @em7=1
    else
      @em7=0
    end

	  if @embarcacion.parroquia_id != 2697 && @embarcacion.parroquia_id != nil
      @em8=1
    else
      @em8=0
    end

		form_edit @embarcacion
  end

  def save_edit
    @id_embarcacion=params[:id_embarcacion]
    @visita=params[:id]

    if ( (@encontramos1.nil?) || (@encontramos2.nil?) || (@encontramos3.nil?) || (@encontramos4.nil?) )
      #si existe alguna solicitud de motores, artes de pesca, equipos de seguridad y faenas de pesca por esa embarcacion ent mostramos el link
      @link=1
    else
      @link=0
    end
    @embarcacion = Embarcacion.find(params[:id_embarcacion])
    form_save_edit @embarcacion
  end
  
  def cancel_edit
    @embarcacion = Embarcacion.find(params[:id])
		form_cancel_edit @embarcacion
  end

  def potreros_onchange
    cerca_electrica = (params[:nro_potrero_cerca_electrica])
    cerca_tradicional = (params[:nro_potrero_cerca_tradicional])

    cantidad_potreros = cerca_electrica.to_i + cerca_tradicional.to_i
    render :update do |page|
      page.replace_html 'cantidad_potreros_label', "<label><b>#{cantidad_potreros}</b></label>"
    end
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

  def view
    @embarcacion = Embarcacion.find(params[:id_embarcacion])
    form_view @embarcacion

  end

  def cancel_view
    @embarcacion = Embarcacion.find(params[:id])
		form_cancel_view @embarcacion
  end

  def tipo_pasto_change
    tipo_pasto = params[:tipo_pasto_forraje_id]
    especie_variedad_pasto_fill(tipo_pasto)

    render :update do |page|
      page.replace_html 'especie_pasto-select', :partial => 'especie_pasto_select'
    end
  end

  ################### Codigo unicamente usado para la impresion del informe de control de visita NO BORRAR!!!!!!!! ###################################3
  def imprimir
    
    #aqui guardo todos los datos que necesito para imprimirlos en las variable
    
    @siniestros = Siniestro.find(:all,:conditions => ['id = ?', params[:id]])  
   
    @solicitudes = Solicitud.find(@siniestros[0].solicitud_id)
    
    if !@solicitudes.cliente.persona_id.nil?
      @es_no=1    
      @datos_cliente=Persona.find(@solicitudes.cliente.persona_id)    
    else
      @es_no=2    
      @datos_cliente=Empresa.find(@solicitudes.cliente.empresa_id)    
    end

    @tecnico_visita=SeguimientoVisita.find_by_solicitud_id(@siniestros[0].solicitud_id)   
    
    unless @solicitudes.usuario_pre_evaluacion.nil?  
      @tecnico_campo=TecnicoCampo.find(:all,:conditions => ['cedula = ?', Usuario.find_by_nombre_usuario(@solicitudes.usuario_pre_evaluacion).cedula])    
    else      
      @tecnico_campo=[]
    end
    @tecnico_supervisor=Oficina.find(@solicitudes.oficina_id)

    @prestamos=Prestamo.find(:all,:conditions => ['solicitud_id = ? ', @solicitudes.id])
    @vista = 'view_planilla_siniestro'
    #@vista = 'view_planilla_vegetal_forestal'
  end
  
  #fin del codigo
  #codigo para generar pdf 

  
  def generate_html
    File.open('/home/malfonzo/sandboxes/fondas/public/documentos/desembolso/envio/ver.html', 'w+') do |f1|
      f1.puts open('/home/malfonzo/sandboxes/fondas/app/views/solicitudes/orden_despacho_detalle/index.rhtml').read
    end
  end

  #fin de codigo para generar pdf

  def imprimir_sector
    
    #aqui guardo todos los datos que necesito para imprimirlos en las variable
    @form_title=''
    @seguimientos = SeguimientoVisita.find(:all,:conditions => ['id = ?', params[:id]])  
   
    @solicitudes = Solicitud.find(@seguimientos[0].solicitud_id)
    
    @unidad_produccion=UnidadProduccion.find(@solicitudes.unidad_produccion_id)        
    
    if !@solicitudes.cliente.persona_id.nil?
      @es_no=1    
      @datos_cliente=Persona.find(@solicitudes.cliente.persona_id)    
    else
      @es_no=2    
      @datos_cliente=Empresa.find(@solicitudes.cliente.empresa_id)    
      @empresa_integrante = EmpresaIntegrante.find(:all, :conditions=> "empresa_id = #{@datos_cliente.id}")
      @empresa_unidad_produccion = Empresa.find(@unidad_produccion.Cliente.empresa_id)    
      unless @empresa_integrante.empty?
        condi="("
        @empresa_integrante.each{ |empresa|

          condi+=empresa.id.to_s << "," 
        }
        condi=condi[0,condi.length-1]      
        condi+=")"    
        @empresa_integrante_tipo = EmpresaIntegranteTipo.find(:first, :conditions=> "empresa_integrante_id in #{condi} and tipo = 'R'")
        @datos_empresa=EmpresaIntegrante.find(@empresa_integrante_tipo.empresa_integrante_id).persona   
        @conppa=UnidadProduccion.find(:first,:conditions=>"cliente_id = #{@empresa_unidad_produccion.cliente_empresa.id}")
      else
        @empresa_integrante=[]
        @datos_empresa=[]
      end    
    end

    @tecnico_visita=SeguimientoVisita.find_by_solicitud_id(@seguimientos[0].solicitud_id)   
    
    unless @solicitudes.usuario_pre_evaluacion.nil?  
      @tecnico_campo=TecnicoCampo.find(:all,:conditions => ['cedula = ?', Usuario.find_by_nombre_usuario(@solicitudes.usuario_pre_evaluacion).cedula])    
    else      
      @tecnico_campo=[]
    end

    @tecnico_supervisor=Oficina.find(@solicitudes.oficina_id)

    @prestamos=Prestamo.find(:all,:conditions => ['solicitud_id = ? ', @solicitudes.id])

    @siniestro_informacion=Siniestro.find(:all,:conditions => ['solicitud_id = ?', @solicitudes.id])

    @seguimiento_cultivo=SeguimientoCultivo.find_by_seguimiento_visita_id(@seguimientos[0].id)
    @decision_informacion=DecisionVisita.find_by_seguimiento_visita_id(@seguimientos[0].id)

    @pastizales_potreros=PastizalesPotreros.find(:all,:conditions=>"seguimiento_visita_id = #{params[:id]}")
  
    @manejo_instalacion=ManejoInstalaciones.find_by_seguimiento_visita_id(params[:id])
    @sanidad_animal=SanidadAnimal.find(:all,:conditions=>"seguimiento_visita_id = #{params[:id]}")

    unless @sanidad_animal.empty?
      cont=0
      condi='('      
      while (cont < @sanidad_animal.length)
        condi+=@sanidad_animal[cont].id.to_s+','      
        cont+=1
      end
      condi=condi[0,condi.length-1] if @sanidad_animal.length!=0
      condi+=')'
      @vacunacion=Vacunacion.find_by_sql("select distinct on (vacuna_id) * from vacunacion where sanidad_animal_id in #{condi}")

    else
      @vacunacion=[]
    end
    @arreglo_desembolso=[]
    @arreglo_orden=[]
    @plan_inversion_desembolso=[]
    @plan_inversion_orden=[]
    @cantidad_plan_inversion_orden=0
    @cantidad_plan_inversion_desembolso=0

    @semovientes=Semovientes.find_by_seguimiento_visita_id(params[:id])


    @sumado_montos_desembolso=Desembolso.sum(:monto,:conditions=>"solicitud_id = #{@solicitudes.id} and seguimiento_visita_id < #{@seguimientos[0].id} ")

    @sumado_montos_orden=OrdenDespacho.sum(:monto,:conditions=>"solicitud_id = #{@solicitudes.id} and seguimiento_visita_id < #{@seguimientos[0].id} ")


    #fin

    if !Desembolso.find_by_seguimiento_visita_id(@seguimientos[0].id).nil?    
      @es_desembolso=1      
      @desembolso=Desembolso.find(:all,:conditions=>['seguimiento_visita_id = ? and solicitud_id = ?',@seguimientos[0].id,@solicitudes.id])      
      desembolso_contador=DesembolsoDetalle.count(:all,:conditions=>['desembolso_id = ?',@desembolso[0].id])
      cont=0
      @arreglo_desembolso=[]
      condi='('      
      @desembolso_detalle=DesembolsoDetalle.find(:all,:conditions=>['desembolso_id = ?',@desembolso[0].id],:order=>"plan_inversion_id")
      while (cont < desembolso_contador)
            
        condi+=@desembolso_detalle[cont].plan_inversion_id.to_s+','
        @arreglo_desembolso[cont]=@desembolso_detalle[cont].monto      

        cont+=1
      end
      condi=condi[0,condi.length-1] if desembolso_contador!=0  
      condi+=')'
      
      if desembolso_contador!=0
        logger.info "condicion para el plan de inversion " << condi

        @plan_inversion_desembolso=PlanInversion.find_by_sql("select * from plan_inversion where id in #{condi} and solicitud_id = #{@solicitudes.id} order by id")
        @cantidad_plan_inversion_desembolso=(PlanInversion.find_by_sql("select * from plan_inversion where id in #{condi} and solicitud_id = #{@solicitudes.id}")).length
        logger.info "plan de inversion desembolso " << @plan_inversion_desembolso.inspect

      else
        
        @plan_inversion_desembolso=[]
        @cantidad_plan_inversion_desembolso=0
      end
    
    elsif !OrdenDespacho.find_by_seguimiento_visita_id(@seguimientos[0].id).nil? 
      @es_desembolso=0
      @orden=OrdenDespacho.find(:all,:conditions=>['seguimiento_visita_id = ? and solicitud_id = ?',@seguimientos[0].id,@solicitudes.id])
      orden_contador=OrdenDespachoDetalle.count(:all,:conditions=>['orden_despacho_id = ?',@orden[0].id])
      logger.debug "orden contador ssssssssssssssssssssssssss " << orden_contador.to_s

      cont=0
      @arreglo_orden=[]
      condi='('      
      @orden_detalle=OrdenDespachoDetalle.find(:all,:conditions=>"orden_despacho_id= #{@orden[0].id.to_s}",:order=>"plan_inversion_id")

      logger.debug "orden detalee ssssssssssssssssssssssssss " << @orden_detalle.inspect      
      while (cont < orden_contador)


        condi+=@orden_detalle[cont].plan_inversion_id.to_s+','
        @arreglo_orden[cont]=@orden_detalle[cont].monto_recomendado      

        cont+=1
      end
      condi=condi[0,condi.length-1] if orden_contador!=0       
      condi+=')'
      logger.debug "Condeicones ssssssssssssssssssssssssss " << condi.to_s      
      if orden_contador !=0
        @plan_inversion_orden=PlanInversion.find_by_sql("select * from plan_inversion where id in #{condi} and solicitud_id = #{@solicitudes.id} order by id")
        @cantidad_plan_inversion_orden=(PlanInversion.find_by_sql("select * from plan_inversion where id in #{condi} and solicitud_id = #{@solicitudes.id}")).length

        logger.debug "plan de inversion orden despacho " << @plan_inversion_orden.inspect
      else        
        @plan_inversion_orden=[]
        @cantidad_plan_inversion_orden=0
      end
    else
      @arreglo=[]
      @arreglo_desembolso=[]
      @arreglo_desembolso=[]
      @plan_inversion_orden=[]
      @cantidad_plan_inversion_orden=0
      @plan_inversion_desembolso=[]
      @cantidad_plan_inversion_desembolso=0

    end
    @arreglo=@arreglo_desembolso+@arreglo_orden
    @plan_inversion=@plan_inversion_desembolso+@plan_inversion_orden
    @cantidad_plan_inversion=@cantidad_plan_inversion_desembolso + @cantidad_plan_inversion_orden
    
    @acumulador1=0
    @acumulador2=0
    @acumulador3=0
    indice=0


    unless @arreglo.empty?
      @arreglo.each{ |monto|
        @acumulador3+=monto
        @acumulador1+=(@plan_inversion[indice].monto_financiamiento)
        indice+=1

      }
    end


    @produccion_leche_carne=ProduccionLecheCarne.find_by_seguimiento_visita_id(params[:id])

    @condiciones_acuicultura=CondicionesAcuicultura.find(:all,:conditions => "solicitud_id = #{@solicitudes.id}")      
    @calidad_agua_alimento=CalidadAguaAlimento.find(:all,:conditions => "solicitud_id = #{@solicitudes.id}")
    @cultivo_laguna=CultivoLaguna.find(:all,:conditions => "solicitud_id = #{@solicitudes.id}")

    
    @embarcacion=Embarcacion.find(:all,:conditions => ['seguimiento_visita_id = ? ', params[:id]],:order=>'id')
    @embarcacion_cantidad=Embarcacion.count(:all,:conditions => ['seguimiento_visita_id = ? ', params[:id]])


    @motor=Motores.find(:all,:conditions => ['seguimiento_visita_id = ? ', params[:id]],:order=>'id')
    @motor_cantidad=Motores.count(:all,:conditions => ['seguimiento_visita_id = ? ', params[:id]])

    @arte_pesca=ArtePesca.find(:all,:conditions => ['seguimiento_visita_id = ? ', params[:id]],:order=>'id')
    @arte_pesca_cantidad=ArtePesca.count(:all,:conditions => ['seguimiento_visita_id = ? ', params[:id]])



    @equipo_seguridad=EquipoSeguridad.find(:all,:conditions => ['seguimiento_visita_id = ? ', params[:id]],:order=>'id')
    @equipo_seguridad_cantidad=EquipoSeguridad.count(:all,:conditions => ['seguimiento_visita_id = ? ', params[:id]])


    @faenas_pesca=FaenasPesca.find(:all,:conditions => ['seguimiento_visita_id = ? ', params[:id]],:order=>'id')
    @faenas_pesca_cantidad=FaenasPesca.count(:all,:conditions => ['seguimiento_visita_id = ? ', params[:id]])

    @sect=Sector.find(@solicitudes.sector_id)

    case params[:tipo]
    when "VE"
      @vista = 'view_planilla_vegetal_forestal'    
    when "AN"
      @vista = 'view_planilla_animal'    
    when "AC"
      @vista = 'view_planilla_acuicola'    
    when "PE"
      @vista = 'view_planilla_pesca'    
    else 

      joins= " INNER JOIN solicitud ON solicitud.id=#{SeguimientoVisita.find(@seguimientos[0].id).solicitud_id} and solicitud.estatus_id=10110 and solicitud.por_inventario=true "
      @maquinarias = Catalogo.find(:all,:joins=>joins, :conditions=>["catalogo.estatus='R' and catalogo.solicitud_id=solicitud.id"])
      
      @solicitud = Solicitud.find(@solicitudes.id)
      @visita = SeguimientoVisita.find(:first, :conditions=>['solicitud_id = ?', @solicitud.id], :order=>'id')
      @tipo_maquinaria = TipoMaquinaria.find(:all, :order=>'nombre')

      @vista = 'view_planilla_maquinaria'
    end    

  end

  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')}"
    @form_title_record = I18n.t('Sistema.Body.Controladores.Embarcacion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Embarcacion.FormTitles.form_title_records')
    @form_entity = 'embarcacion'
    @form_identity_field = 'nombre_embarcacion'
    @width_layout = '955'

  end

  def fill
    @tipo_pasto_forraje_list = TipoPastoForraje.find(:all, :order=>'id')
  end


  def fill_embarcacion

    if params[:id].nil?
      @emba = Embarcacion.find(params[:id_embarcacion])
      @iii=@emba.seguimiento_visita_id
    else
      @iii=params[:id]
    end

    @solicitud_id = SeguimientoVisita.find(@iii.to_s)
    @identificador_rubro = Solicitud.find(@solicitud_id.solicitud_id.to_s)

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

