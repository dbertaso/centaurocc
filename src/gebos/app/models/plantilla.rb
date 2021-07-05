# encoding: utf-8

#
# 
# clase: Plantilla
# descripción: Migración a Rails 3
#
class Plantilla < ActiveRecord::Base

require 'rubygems'
require 'number_to_words'

  self.table_name = 'plantilla'
  
  attr_accessible :id,
                  :tipo_beneficiario,
                  :sector_id,
                  :nombre,
                  :encabezado,
                  :logotipo,
                  :documento,
                  :definido,
                  :activo,
                  :nemonico
 
before_save :actualizar_definido

  def actualizar_definido
    if self.definido == true
       self.class.update_all("definido = false", "definido = true")
    end
  end

  def setFechaActa(fecha)
 	@fecha_ae = fecha
  end  
  
  def complementar(solicitud_id,oficina_id,ruta)
    $KCODE = 'UTF8'

	    @documento_resultante = self.documento.to_s
	    arreglo_final = []
	    
	    arreglo_final = cargar_arreglo(solicitud_id,oficina_id)
	    if arreglo_final[0][0] == I18n.t('Sistema.Body.Modelos.Plantilla.Errores.error')
            documento_resultante = "#{I18n.t('Sistema.Body.Modelos.Plantilla.Errores.error_campo')} [" + arreglo_final[1][1] + "] " + arreglo_final[0][1]
      else
            logger.info "ARREGLO_FINAL" << arreglo_final.inspect

	          documento_resultante = @documento_resultante
	    
	          for variable in arreglo_final
	             documento_resultante.gsub!(variable[0], variable[1].to_s)
	          end
      end
      logger.debug "DOCUMENTO RESULTANTE:::::::." 
      logger.debug documento_resultante.to_s 
      logger.debug ruta
    documento_resultante.gsub!('http://localhost', ruta)

    return documento_resultante
  end

 
  def complementar_NA(solicitud_id,testigos,oficina_id,ruta)
    $KCODE = 'UTF8'

    @documento_resultante = self.documento.to_s
    arreglo_final = []

    arreglo_final = cargar_arreglo(solicitud_id,oficina_id)

    if testigos.length == 3
      nombres_testigos = "[/nt1/], [/nt2/] y [/nt3/]"
      cedulas_testigos = "[/ct1/], [/ct2/] y [/ct3/]"
    elsif testigos.length == 2
      nombres_testigos = "[/nt1/] y [/nt2/]"
      cedulas_testigos = "[/ct1/] y [/ct2/]"
    end
    testigos_firma = ""
     x = 1
     for testigo in testigos
       nombres_testigos.gsub!("[/nt#{x.to_s}/]", testigo.nombre_testigo)
       cedulas_testigos.gsub!("[/ct#{x.to_s}/]", testigo.cedula_testigo)
       testigos_firma += "<br></br><br></br><br></br><br></br>" << "_____________________________<br>" << testigo.nombre_testigo
       x+=1
     end

    arreglo_final << ["[/nombres_testigos/]", nombres_testigos]
    arreglo_final << ["[/nombres_testigos_seccion_firma/]", testigos_firma]
    arreglo_final << ["[/cedulas_testigos/]", cedulas_testigos]


    logger.info "ARREGLO_FINAL" << arreglo_final.inspect

    documento_resultante = @documento_resultante

    for variable in arreglo_final
      documento_resultante.gsub!(variable[0], variable[1].to_s)
    end

    documento_resultante.gsub!('http://localhost', ruta)


    return documento_resultante
  end
  
  def fix_numero_comite(numero)

    return numero.split("-")[0].to_s + "/" + (numero.split("-")[1].to_i - 2000).to_s
 
  end
  
  
  
  def cargar_arreglo(solicitud_id,oficina_id)
  
  
    arreglo_final = []
    field_error = ""
    msg_error = ""	
 begin
	
    parametro_general = ParametroGeneral.find(:all)
    
    #DATOS PERSONA
    datos_persona = ViewPersona.find_by_solicitud_id(solicitud_id)
    if !datos_persona.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Persona.cedula')
      var_cedula_persona = datos_persona.cedula_persona
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Persona.nombre')
      var_nombre_persona = datos_persona.nombre_persona
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Persona.estado_civil')
      var_estado_civil = datos_persona.estado_civil_texto
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Persona.fecha_nacimiento')
      var_fecha_nacimiento = datos_persona.fecha_nacimiento
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Persona.rif')
      var_rif_personal = datos_persona.rif_personal
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Persona.pasaporte')
      var_pasaporte = datos_persona.pasaporte
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Persona.estado')
      var_estado_persona = datos_persona.estado_persona
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Persona.municipio')
      var_municipio_persona = datos_persona.municipio_persona
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Persona.parroquia')
      var_parroquia_persona = datos_persona.parroquia_persona
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Persona.ciudad')
      var_ciudad_persona = datos_persona.ciudad_persona
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Persona.estado_civil')
      if datos_persona.estado_civil == 'C'
        if @documento_resultante.index('[/{conyuge?_ini}/]') != nil
          @documento_resultante.gsub!('[/{conyuge?_ini}/]', '')
        end
        if @documento_resultante.index('[/{conyuge?_fin}/]') != nil
         @documento_resultante.gsub!('[/{conyuge?_fin}/]', '')
        end
      else
        while @documento_resultante.index('[/{conyuge?_ini}/]') != nil
          if @documento_resultante.index('[/{conyuge?_fin}/]') != nil
            @documento_resultante = @documento_resultante.slice(0, @documento_resultante.index('[/{conyuge?_ini}/]')) << @documento_resultante.slice(@documento_resultante.index('[/{conyuge?_fin}/]')+18, @documento_resultante.length - (@documento_resultante.index('[/{conyuge?_fin}/]')+18))
          end
        end
      end

    else
      var_cedula_persona = "[/cedula_persona/]"
      var_nombre_persona = "[/nombre_persona/]"
      var_estado_civil = "[/estado_civil/]"
      var_fecha_nacimiento = "[/fecha_nacimiento/]"
      var_rif_personal = "[/rif_personal/]"
      var_pasaporte = "[/pasaporte/]"
      var_estado_persona = "[/estado_persona/]"
      var_municipio_persona = "[/municipio_persona/]"
      var_parroquia_persona = "[/parroquia_persona/]"
      var_ciudad_persona = "[/ciudad_persona/]"
    end

    arreglo_final << ["[/cedula_persona/]", var_cedula_persona]
    arreglo_final << ["[/nombre_persona/]", var_nombre_persona]
    arreglo_final << ["[/estado_civil/]", var_estado_civil]
    arreglo_final << ["[/rif_personal/]", var_fecha_nacimiento]
    arreglo_final << ["[/fecha_nacimiento/]", var_rif_personal]
    arreglo_final << ["[/pasaporte/]", var_pasaporte]
    arreglo_final << ["[/estado_persona/]", var_estado_persona]
    arreglo_final << ["[/municipio_persona/]", var_municipio_persona]
    arreglo_final << ["[/parroquia_persona/]", var_parroquia_persona]
    arreglo_final << ["[/ciudad_persona/]", var_ciudad_persona]

    #DATOS CONYUGE
    datos_conyuge = ViewConyuge.find_by_solicitud_id(solicitud_id)
    if !datos_conyuge.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Conyugue.cedula')
      var_conyuge_cedula = datos_conyuge.conyuge_cedula
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Conyugue.nombres')
      var_conyuge_nombre_apellido = datos_conyuge.conyuge_nombre_apellido
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Conyugue.lugar_nacimiento')
      var_conyuge_lugar_nacimiento = datos_conyuge.conyuge_lugar_nacimiento
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Conyugue.nacionalidad')
      var_conyuge_nacionalidad = datos_conyuge.conyuge_nacionalidad
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Conyugue.profesion')
      var_conyuge_profesion = datos_conyuge.conyuge_profesion
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Conyugue.oficio')
      var_conyuge_oficio = datos_conyuge.conyuge_oficio      
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Conyugue.direccion_trabajo')
      var_conyuge_direccion_trabajo = datos_conyuge.conyuge_direccion_trabajo
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Conyugue.telefono')
      var_conyuge_telefono = datos_conyuge.conyuge_telefono
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Conyugue.celular')
      var_conyuge_celular = datos_conyuge.conyuge_celular
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Conyugue.empresa')
      var_conyuge_empresa = datos_conyuge.conyuge_empresa
    else
      var_conyuge_cedula = "[/conyuge_cedula/]"
      var_conyuge_nombre_apellido = "[/conyuge_nombre_apellido/]"
      var_conyuge_lugar_nacimiento = "[/conyuge_lugar_nacimiento/]"
      var_conyuge_nacionalidad = "[/conyuge_nacionalidad/]"
      var_conyuge_profesion = "[/conyuge_profesion/]"
      var_conyuge_oficio = "[/conyuge_oficio/]"
      var_conyuge_direccion_trabajo = "[/conyuge_direccion_trabajo/]"
      var_conyuge_telefono = "[/conyuge_telefono/]"
      var_conyuge_celular = "[/conyuge_celular/]"
      var_conyuge_empresa = "[/conyuge_empresa/]"
    end

    arreglo_final << ["[/conyuge_cedula/]", var_conyuge_cedula]
    arreglo_final << ["[/conyuge_nombre_apellido/]", var_conyuge_nombre_apellido]
    arreglo_final << ["[/conyuge_lugar_nacimiento/]", var_conyuge_lugar_nacimiento]
    arreglo_final << ["[/conyuge_nacionalidad/]", var_conyuge_nacionalidad]
    arreglo_final << ["[/conyuge_profesion/]", var_conyuge_profesion]
    arreglo_final << ["[/conyuge_oficio/]", var_conyuge_oficio]
    arreglo_final << ["[/conyuge_direccion_trabajo/]", var_conyuge_direccion_trabajo]
    arreglo_final << ["[/conyuge_telefono/]", var_conyuge_telefono]
    arreglo_final << ["[/conyuge_celular/]", var_conyuge_celular]
    arreglo_final << ["[/conyuge_empresa/]", var_conyuge_empresa]


    #DATOS EMPRESA
    datos_empresa = ViewEmpresa.find_by_solicitud_id(solicitud_id)
    if !datos_empresa.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.rif')
      var_den_rif = datos_empresa.rif
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.nombre')
      var_den_nombre_empresa = datos_empresa.nombre_empresa
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.fecha_constitucion')
      var_den_fecha_constitucion = datos_empresa.fecha_constitucion
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.fecha_inicio_operaciones')
      var_den_fecha_inicio_operaciones = datos_empresa.fecha_inicio_operaciones
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.capital')
      var_den_capital_suscrito = datos_empresa.capital_suscrito
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.capital_pagado')
      var_den_capital_pagado = datos_empresa.capital_pagado
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.numero_patente')
      var_den_numero_patente = datos_empresa.numero_patente
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.cicom')
      var_den_numero_sunacop = datos_empresa.numero_sunacop
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.producto')
      var_den_producto = datos_empresa.producto
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.nro_registro_mercantil')
      var_den_nro_registro_mercantil = datos_empresa.nro_registro_mercantil
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.folio_inicial')
      var_den_nro_folio_inicial = datos_empresa.nro_folio_inicial
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.folio_final')
      var_den_nro_folio_final = datos_empresa.nro_folio_final
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.nro_protocolo')
      var_den_nro_protocolo = datos_empresa.nro_protocolo
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.nro_tomo')
      var_den_nro_tomo = datos_empresa.nro_tomo
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.nro_trimestre')
      var_den_nro_trimestre = datos_empresa.nro_trimestre
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.nit')
      var_den_nit = datos_empresa.nit
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.estado_registro')
      var_den_estado = datos_empresa.estado_registro
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.municipio_registro')
      var_den_municipio = datos_empresa.municipio_registro
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Empresa.parroquia_registro')
      var_den_parroquia = datos_empresa.parroquia_registro
     
    else
      var_den_rif = "[/rif/]"
      var_den_nombre_empresa = "[/nombre_empresa/]"
      var_den_fecha_constitucion = "[/fecha_constitucion/]"
      var_den_fecha_inicio_operaciones = "[/fecha_inicio_operaciones/]"
      var_den_capital_suscrito = "[/capital_suscrito/]"
      var_den_capital_pagado = "[/capital_pagado/]"
      var_den_numero_patente = "[/numero_patente/]"
      var_den_numero_sunacop = "[/numero_sunacop/]"
      var_den_producto = "[/producto/]"
      var_den_nro_registro_mercantil = "[/nro_registro_mercantil/]"
      var_den_nro_folio_inicial = "[/nro_folio_inicial/]"
      var_den_nro_folio_final = "[/nro_folio_final/]"
      var_den_nro_protocolo = "[/nro_protocolo/]"
      var_den_nro_tomo = "[/nro_tomo/]"
      var_den_nro_trimestre = "[/nro_trimestre/]"
      var_den_nit = "[/nit/]"
      var_den_estado = "[/estado/]"
      var_den_municipio = "[/municipio/]"
      var_den_parroquia = "[/parroquia/]"
    end
    
    arreglo_final << ["[/rif/]", var_den_rif]
    arreglo_final << ["[/nombre_empresa/]", var_den_nombre_empresa]
    arreglo_final << ["[/fecha_constitucion/]", var_den_fecha_constitucion]
    arreglo_final << ["[/fecha_inicio_operaciones/]", var_den_fecha_inicio_operaciones]
    arreglo_final << ["[/capital_suscrito/]", var_den_capital_suscrito]
    arreglo_final << ["[/capital_pagado/]", var_den_capital_pagado]
    arreglo_final << ["[/numero_patente/]", var_den_numero_patente]
    arreglo_final << ["[/numero_sunacop/]", var_den_numero_sunacop]
    arreglo_final << ["[/producto/]", var_den_producto]
    arreglo_final << ["[/nro_registro_mercantil/]", var_den_nro_registro_mercantil]
    arreglo_final << ["[/nro_folio_inicial/]", var_den_nro_folio_inicial]
    arreglo_final << ["[/nro_folio_final/]", var_den_nro_folio_final]
    arreglo_final << ["[/nro_protocolo/]", var_den_nro_protocolo]
    arreglo_final << ["[/var_den_nro_tomo/]", var_den_nro_tomo]
    arreglo_final << ["[/nro_trimestre/]", var_den_nro_trimestre]
    arreglo_final << ["[/nit/]", var_den_nit]
    arreglo_final << ["[/estado/]", var_den_estado]
    arreglo_final << ["[/municipio/]", var_den_municipio]
    arreglo_final << ["[/parroquia/]", var_den_parroquia]

        
    
     #DATOS DE LA SOLICITUD
    datos_solicitud = ViewSolicitud.find_by_solicitud_id(solicitud_id)
    if !datos_solicitud.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.numero')
      var_numero_solicitud = datos_solicitud.numero_solicitud
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.nro_prestamo')
      var_numero_prestamo = datos_solicitud.numero_prestamo
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.nro_grupo')
      var_numero_grupo = datos_solicitud.numero_grupo
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.nro_empresa')
      var_numero_empresa = datos_solicitud.numero_empresa
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.estado')
      var_estado = datos_solicitud.estado
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.municipio')
      var_municipio = datos_solicitud.municipio
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.parroquia')
      var_parroquia = datos_solicitud.parroquia
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.ciudad')
      var_ciudad = datos_solicitud.ciudad
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.monto_solicitado')
      var_monto_solicitado_s = datos_solicitud.monto_solicitado
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.monto_solicitado_letras')
      var_monto_solicitado_letras = datos_solicitud.monto_solicitado_letras.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.con')).upcase} " << datos_solicitud.monto_solicitado.to_s.split('.')[1] << "/100"
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.monto_garantia')
      var_monto_garantia_s = datos_solicitud.monto_garantia
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.monto_garantia_letras')
      var_monto_garantia_letras = datos_solicitud.monto_garantia_letras.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.con')).upcase} " << datos_solicitud.monto_garantia.to_s.split('.')[1] << "/100"
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.identificador_cliente')
      var_identificador_cliente = datos_solicitud.identificador_cliente
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.nombre_cliente')
      var_nombre_cliente = datos_solicitud.nombre_cliente
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.plan')
      var_plan = datos_solicitud.plan
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.plazo')
      var_plazo= datos_solicitud.plazo
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.meses_muertos')
      var_meses_muertos = datos_solicitud.meses_muertos
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.rubro')
      var_rubro = datos_solicitud.rubro
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Solicitud.tipo_gasto')
      if datos_solicitud.tipo_gasto == 1
          var_tipo_gasto = "#{I18n.t('Sistema.Body.Vistas.General.y')} #{I18n.t('Sistema.Body.Vistas.General.un')} " << porcentaje_letras(datos_solicitud.porcentaje) << " (" << format_fm(datos_solicitud.porcentaje) << "%) #{I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.gastos_admi')}"
      elsif datos_solicitud.tipo_gasto == 2
          var_tipo_gasto = "#{I18n.t('Sistema.Body.Vistas.General.y')} " << datos_solicitud.monto_fijo.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.bolivares')).upcase} (" << format_fm(datos_solicitud.monto_fijo) << ") #{I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.gastos_admi')}"
      end
    else
      var_numero_solicitud = "[/numero_solicitud/]"
      var_numero_prestamo = "[/numero_prestamo/]"
      var_numero_grupo = "[/numero_grupo/]"
      var_numero_empresa = "[/numero_empresa/]"
      var_estado = "[/estado/]"
      var_municipio = "[/municipio/]"
      var_parroquia = "[/parroquia/]"
      var_ciudad = "[/ciudad/]"
      var_monto_solicitado_s = "[/monto_solicitado/]"
      var_monto_solicitado_letras = "[/monto_solicitado_letras/]"
      var_monto_garantia_s = "[/monto_garantia/]"
      var_monto_garantia_letras = "[/monto_garantia_letras/]"
      var_identificador_cliente = "[/identificador_cliente/]"
      var_nombre_cliente = "[/nombre_cliente/]"
      var_plan = "[/plan/]"
      var_plazo= "[/plazo/]"
      var_meses_muertos = "[/meses_muertos/]"
      var_rubro = "[/rubro/]"
      var_tipo_gasto = "[/tipo_gasto/]"
    end

   arreglo_final << ["[/numero_solicitud/]", var_numero_solicitud]
   arreglo_final << ["[/numero_prestamo/]", var_numero_prestamo]
   arreglo_final << ["[/numero_grupo/]", var_numero_grupo]
   arreglo_final << ["[/numero_empresa/]", var_numero_empresa]
   arreglo_final << ["[/estado/]", var_estado]
   arreglo_final << ["[/municipio/]", var_municipio]
   arreglo_final << ["[/parroquia/]", var_parroquia]
   arreglo_final << ["[/ciudad/]", var_ciudad]
   arreglo_final << ["[/monto_solicitud/]", var_monto_solicitado_s]
   arreglo_final << ["[/identificador_cliente/]", var_identificador_cliente]
   arreglo_final << ["[/nombre_cliente/]", var_nombre_cliente]
   arreglo_final << ["[/plan/]", var_plan]
   arreglo_final << ["[/plazo/]", var_plazo]
   arreglo_final << ["[/meses_muertos/]", var_meses_muertos]
   arreglo_final << ["[/rubro/]", var_rubro]
   arreglo_final << ["[/monto_solicitado/]", var_monto_solicitado_s]
   arreglo_final << ["[/monto_solicitado_letras/]", var_monto_solicitado_letras]
   arreglo_final << ["[/monto_garantia/]", var_monto_garantia_s]
   arreglo_final << ["[/monto_garantia_letras/]", var_monto_garantia_letras]
   arreglo_final << ["[/tipo_gasto/]", var_tipo_gasto]

   nemo = Solicitud.find(solicitud_id).sub_sector.nemonico 
   unless nemo.nil?
	if nemo == 'VE'     
		if @documento_resultante.index('[/{vegetal?_ini}/]') != nil
		  @documento_resultante.gsub!('[/{vegetal?_ini}/]', '')
		end
		if @documento_resultante.index('[/{vegetal?_fin}/]') != nil
		 @documento_resultante.gsub!('[/{vegetal?_fin}/]', '')
		end
	else
		while @documento_resultante.index('[/{vegetal?_ini}/]') != nil
			if @documento_resultante.index('[/{vegetal?_fin}/]') != nil
			@documento_resultante = @documento_resultante.slice(0, @documento_resultante.index('[/{vegetal?_ini}/]')) << @documento_resultante.slice(@documento_resultante.index('[/{vegetal?_fin}/]')+18, @documento_resultante.length - (@documento_resultante.index('[/{vegetal?_fin}/]')+18))
			end
		end
	end
    end
   
   field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Maquinarias.plan')
   if Solicitud.find(solicitud_id).por_inventario
      var_plan_maquinarias = ""
     plan_maquinaria_plantilla = ViewPlanMaquinariaPlantilla.find(:all,:conditions=>['solicitud_id = ?',solicitud_id])
       unless plan_maquinaria_plantilla.nil?
        plan_maquinaria_plantilla.each do |registro|
          var_plan_maquinarias += registro.clase_maquinaria << " #{(I18n.t('Sistema.Body.Vistas.General.marca')).upcase}:"  << registro.marca_maquinaria << " #{(I18n.t('Sistema.Body.Vistas.General.modelo')).upcase}:"  << registro.modelo_maquinaria << " #{(I18n.t('Sistema.Body.Vistas.General.serial')).upcase} #{(I18n.t('Sistema.Body.Vistas.General.motor')).upcase}:"  << registro.serial << " #{(I18n.t('Sistema.Body.Vistas.General.serial')).upcase} #{(I18n.t('Sistema.Body.Vistas.General.chasis')).upcase}:"  << registro.chasis << ", "
        end
      end
       arreglo_final << ["[/plan_maquinaria/]", var_plan_maquinarias]
   end

     #DATOS DEL PRESTAMO
    datos_prestamo = ViewPrestamoPlantilla.find_by_solicitud_id(solicitud_id)
    if !datos_prestamo.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.numero')
      var_numero_prestamo = datos_prestamo.numero_prestamo
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.monto_aprobado')
      var_monto_aprobado = datos_prestamo.monto_aprobado
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.monto_aprobado_letras')
      var_monto_aprobado_letras = datos_prestamo.monto_aprobado_letras.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.con')).upcase} " << datos_prestamo.monto_aprobado.to_s.split('.')[1] << "/100"
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.fecha_aprobacion')
      var_fecha_aprobacion = datos_prestamo.fecha_aprobacion
      #var_tasa_id = datos_prestamo.tasa_id
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.tasa_fija')
      var_tasa_fija = datos_prestamo.tasa_fija
      if !datos_prestamo.diferencial_tasa.nil?
        var_diferencial_tasa = (datos_prestamo.diferencial_tasa = nil ? 0 : datos_prestamo.diferencial_tasa)
        var_diferencial_tasa_letras = porcentaje_letras(datos_prestamo.diferencial_tasa_letras)
      else
        var_diferencial_tasa = "0#{I18n.t('Sistema.Body.ExpresionesRegulares.separador_decimal')}00"  #I18n.t('Sistema.Body.ExpresionesRegulares.separador_decimal')
        var_diferencial_tasa_letras = I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.cero')
      end
      var_tasa_referencial_inicial = (datos_prestamo.tasa_referencia_inicial = nil ? 0 : datos_prestamo.tasa_referencia_inicial)
      var_tasa_referencial_inicial_letras = porcentaje_letras(datos_prestamo.tasa_referencia_inicial_letras)
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.plazo')
      var_plazo = datos_prestamo.plazo
      var_plazo_letras = datos_prestamo.plazo_letras.to_words.upcase
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.cuotas')
      if datos_prestamo.cuotas.to_i != 1
        if @documento_resultante.index('[/{no_pago_unico?_ini}/]') != nil
           @documento_resultante.gsub!('[/{no_pago_unico?_ini}/]', '')
        end
        if @documento_resultante.index('[/{no_pago_unico?_fin}/]') != nil
           @documento_resultante.gsub!('[/{no_pago_unico?_fin}/]', '')
        end
      else
        while @documento_resultante.index('[/{no_pago_unico?_ini}/]') != nil
          if @documento_resultante.index('[/{no_pago_unico?_fin}/]') != nil
            @documento_resultante = @documento_resultante.slice(0, @documento_resultante.index('[/{no_pago_unico?_ini}/]')) << @documento_resultante.slice(@documento_resultante.index('[/{no_pago_unico?_fin}/]')+24, @documento_resultante.length - (@documento_resultante.index('[/{no_pago_unico?_fin}/]')+24))
          end
        end
      end

      var_cuotas = datos_prestamo.cuotas
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.cuotas_letras')
      var_cuotas_letras = datos_prestamo.cuotas_letras.to_words.upcase
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.meses_fijos_tasa')
      var_meses_fijos_sin_cambio_tasa = datos_prestamo.meses_fijos_sin_cambio_tasa
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.meses_fijos_tasa_letras')
      var_meses_fijos_sin_cambio_tasa_letras = datos_prestamo.meses_fijos_sin_cambio_tasa_letras.to_words.upcase
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.meses_gracia')
      var_meses_gracia = datos_prestamo.meses_gracia
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.meses_gracia_letras')
      var_meses_gracia_letras = datos_prestamo.meses_gracia_letras.to_words.upcase
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.meses_muertos')
      var_meses_muertos = datos_prestamo.meses_muertos
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.meses_muertos_letras')
      var_meses_muertos_letras = datos_prestamo.meses_muertos_letras.to_words.upcase
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.frecuencia_pago')
      var_frecuencia_pago = datos_prestamo.frecuencia_pago
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.frecuencia_pago_2')
      var_frecuencia_pago2 = datos_prestamo.frecuencia_pago2
      var_tasa_mora = (parametro_general[0].tasa_maxima_mora = nil ? 0 : parametro_general[0].tasa_maxima_mora)
      var_tasa_mora_letras = porcentaje_letras(var_tasa_mora)
      var_tasa_valor = (datos_prestamo.tasa_valor = nil ? 0 : datos_prestamo.tasa_valor)
      var_tasa_valor_letras = porcentaje_letras(datos_prestamo.tasa_valor_letras)
      var_tasa_inicial = (datos_prestamo.tasa_inicial = nil ? 0 : datos_prestamo.tasa_inicial)
      var_tasa_inicial_letras = porcentaje_letras(datos_prestamo.tasa_inicial_letras)
      var_tasa_vigente = (datos_prestamo.tasa_vigente = nil ? 0 : datos_prestamo.tasa_vigente)
      var_tasa_vigente_letras = porcentaje_letras(datos_prestamo.tasa_vigente_letras)
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.saldo_insoluto')
      var_saldo_insoluto = datos_prestamo.saldo_insoluto
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.saldo_insoluto_letras')
      var_saldo_insoluto_letras = datos_prestamo.saldo_insoluto_letras.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.con')).upcase} " << datos_prestamo.saldo_insoluto_letras.to_s.split('.')[1] << "/100"
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.monto_liquidado')
      var_monto_liquidado = datos_prestamo.monto_liquidado
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.monto_liquidado_letras')
      var_monto_liquidado_letras = datos_prestamo.monto_liquidado_letras.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.con')).upcase} " << datos_prestamo.monto_liquidado_letras.to_s.split('.')[1] << "/100"
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.fecha_liquidacion')
      var_fecha_liquidacion = datos_prestamo.fecha_liquidacion
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.saldo_capital')
      var_saldo_capital = datos_prestamo.saldo_capital
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.saldo_capital_letras')
      var_saldo_capital_letras = datos_prestamo.saldo_capital_letras.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.con')).upcase} " << datos_prestamo.saldo_capital_letras.to_s.split('.')[1] << "/100"
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.meses_diferidos')
      var_meses_diferidos = datos_prestamo.meses_diferidos
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.meses_diferidos_letras')
      var_meses_diferidos_letras = datos_prestamo.meses_diferidos_letras.to_words.upcase
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.dia_facturacion')
      var_dia_facturacion = datos_prestamo.dia_facturacion
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.plan_inversion')
      var_plan_inversion = datos_prestamo.plan_inversion
      plan_inversion_plantilla = ViewPlanInversionPlantilla.find(:all,:conditions=>['solicitud_id = ?',solicitud_id])
      var_plan_inversion = ""
      if plan_inversion_plantilla != nil
        for registro in plan_inversion_plantilla
          var_plan_inversion += registro.nombre << format_fm(registro.monto_financiamiento) << ", "
        end
        #var_plan_inversion = var_plan_inversion.slice(var_plan_inversion.length() -1)
      end
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Prestamo.plan_inversion_pesca')
      plan_inversion_pesca = ViewPlanInversionPesca.find(:all,:conditions=>['solicitud_id = ?',solicitud_id])
      var_plan_inversion_pesca = ""
      for registro in plan_inversion_pesca
          var_plan_inversion_pesca = var_plan_inversion_pesca << "- #{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.embarcacion')} #{I18n.t('Sistema.Body.Vistas.General.de')} " << registro.tipo_material << ", #{I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.penero_faena')}: #{(I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.eslora')).upcase}: "  << registro.eslora.to_words.upcase << " (#{registro.eslora.to_s} #{I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.penero_faena')}), #{(I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.manga')).upcase}: "  << registro.manga.to_words.upcase << " (#{registro.manga.to_s} #{I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.penero_faena')}), #{(I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.puntal')).upcase}: " << registro.puntal.to_words.upcase << " (#{registro.puntal.to_s} #{I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.penero_faena')}), #{I18n.t('Sistema.Body.Vistas.General.denominada')} #{registro.nombre_embarcacion} #{I18n.t('Sistema.Body.Vistas.General.con')} " << registro.cantidad_motores.to_words.upcase << " (#{registro.cantidad_motores.to_s}) #{I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.motores')} #{registro.tipo_motor}[/{consolidacion?_ini}/], #{I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.cuyas_caracteristicas')}: #{(I18n.t('Sistema.Body.Vistas.General.marca')).upcase}: #{registro.modelo_motor}, #{(I18n.t('Sistema.Body.Vistas.General.serial')).upcase}: #{registro.numero_serial.to_s}[/{consolidacion?_fin}/]. "
      end
      var_plan_inversion_pesca = var_plan_inversion_pesca << " - #{I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.artes_pesca')}"
    else
      var_numero_prestamo = "[/numero_prestamo/]"
      var_monto_aprobado = "[/monto_aprobado/]"
      var_monto_aprobado_letras = "[/monto_aprobado_letras/]"
      var_fecha_aprobacion = "[/fecha_aprobacion/]"
      #var_tasa_id = "[/tasa_id/]"
      var_tasa_fija = "[/tasa_fija/]"
      var_diferencial_tasa = "[/diferencial_tasa/]"
      var_diferencial_tasa_letras = "[/diferencial_tasa_letras/]"
      var_tasa_referencial_inicial = "[/tasa_referencia_inicial/]"
      var_tasa_referencial_inicial_letras = "[/tasa_referencia_inicial_letras/]"
      var_plazo = "[/plazo/]"
      var_plazo_letras = "[/plazo_letras/]"
      var_cuotas = "[/cuotas/]"
      var_cuotas_letras = "[/cuotas_letras/]"
      var_meses_fijos_sin_cambio_tasa = "[/meses_fijos_sin_cambio_tasa/]"
      var_meses_fijos_sin_cambio_tasa_letras = "[/meses_fijos_sin_cambio_tasa_letras/]"
      var_meses_gracia = "[/meses_gracia/]"
      var_meses_gracia_letras = "[/meses_gracia_letras/]"
      var_meses_muertos = "[/meses_muertos/]"
      var_meses_muertos_letras = "[/meses_muertos_letras/]"
      var_frecuencia_pago = "[/frecuencia_pago/]"
      var_frecuencia_pago2 = "[/frecuencia_pago2/]"
      var_tasa_mora = "[/tasa_mora/]"
      var_tasa_mora_letras = "[/tasa_mora_letras/]"
      var_tasa_valor = "[/tasa_valor/]"
      var_tasa_valor_letras = "[/tasa_valor_letras/]"
      var_tasa_inicial = "[/tasa_inicial/]"
      var_tasa_inicial_letras = "[/tasa_inicial_letras/]"
      var_tasa_vigente = "[/tasa_vigente/]"
      var_tasa_vigente_letras = "[/tasa_vigente_letras/]"
      var_saldo_insoluto = "[/saldo_insoluto/]"
      var_saldo_insoluto_letras = "[/saldo_insoluto_letras/]"
      var_monto_liquidado = "[/monto_liquidado/]"
      var_monto_liquidado_letras = "[/monto_liquidado_letras/]"
      var_fecha_liquidacion = "[/fecha_liquidacion/]"
      var_saldo_capital = "[/saldo_capital/]"
      var_saldo_capital_letras = "[/saldo_capital_letras/]"
      var_meses_diferidos = "[/meses_diferidos/]"
      var_meses_diferidos_letras = "[/meses_diferidos_letras/]"
      var_dia_facturacion = "[/dia_facturacion/]"
      var_plan_inversion = "[/plan_inversion/]"
      var_plan_inversion_pesca = "[/plan_inversion_pesca/]"
   end

   arreglo_final << ["[/numero_prestamo/]", var_numero_prestamo]
   arreglo_final << ["[/monto_aprobado/]", var_monto_aprobado]
   arreglo_final << ["[/monto_aprobado_letras/]", var_monto_aprobado_letras]
   arreglo_final << ["[/fecha_aprobacion/]", var_fecha_aprobacion]
   #arreglo_final << ["[/tasa_id/]", var_tasa_id]
   arreglo_final << ["[/tasa_fija/]", var_tasa_fija]
   arreglo_final << ["[/diferencial_tasa/]", var_diferencial_tasa]
   arreglo_final << ["[/diferencial_tasa_letras/]", var_diferencial_tasa_letras]
   arreglo_final << ["[/tasa_referencia_inicial/]", var_tasa_referencial_inicial]
   arreglo_final << ["[/tasa_referencia_inicial_letras/]", var_tasa_referencial_inicial_letras]
   arreglo_final << ["[/plazo/]", var_plazo]
   arreglo_final << ["[/plazo_letras/]", var_plazo_letras]
   arreglo_final << ["[/cuotas/]", var_cuotas]
   arreglo_final << ["[/cuotas_letras/]", var_cuotas_letras]
   arreglo_final << ["[/meses_fijos_sin_cambio_tasa/]", var_meses_fijos_sin_cambio_tasa]
   arreglo_final << ["[/meses_fijos_sin_cambio_tasa_letras/]", var_meses_fijos_sin_cambio_tasa_letras]
   arreglo_final << ["[/meses_gracia/]", var_meses_gracia]
   arreglo_final << ["[/meses_gracia_letras/]", var_meses_gracia_letras]
   arreglo_final << ["[/meses_muertos/]", var_meses_muertos]
   arreglo_final << ["[/meses_muertos_letras/]", var_meses_muertos_letras]
   arreglo_final << ["[/frecuencia_pago/]", var_frecuencia_pago]
   arreglo_final << ["[/frecuencia_pago2/]", var_frecuencia_pago2]
   arreglo_final << ["[/tasa_mora/]", var_tasa_mora]
   arreglo_final << ["[/tasa_mora_letras/]", var_tasa_mora_letras]
   arreglo_final << ["[/tasa_valor/]", var_tasa_valor]
   arreglo_final << ["[/tasa_valor_letras/]", var_tasa_valor_letras]
   arreglo_final << ["[/tasa_inicial/]", var_tasa_inicial]
   arreglo_final << ["[/tasa_inicial_letras/]", var_tasa_inicial_letras]
   arreglo_final << ["[/tasa_vigente/]", var_tasa_vigente]
   arreglo_final << ["[/tasa_vigente_letras/]", var_tasa_vigente_letras]
   arreglo_final << ["[/saldo_insoluto/]", var_saldo_insoluto]
   arreglo_final << ["[/saldo_insoluto_letras/]", var_saldo_insoluto_letras]
   arreglo_final << ["[/monto_liquidado/]", var_monto_liquidado]
   arreglo_final << ["[/monto_liquidado_letras/]", var_monto_liquidado_letras]
   arreglo_final << ["[/fecha_liquidacion/]", var_fecha_liquidacion]
   arreglo_final << ["[/saldo_capital/]", var_saldo_capital]
   arreglo_final << ["[/saldo_capital_letras/]", var_saldo_capital_letras]
   arreglo_final << ["[/meses_diferidos/]", var_meses_diferidos]
   arreglo_final << ["[/meses_diferidos_letras/]", var_meses_diferidos_letras]
   arreglo_final << ["[/dia_facturacion/]", var_dia_facturacion]
   arreglo_final << ["[/plan_inversion/]", var_plan_inversion]
   unless plan_inversion_pesca.empty?
      if !plan_inversion_pesca[0].es_propia
        if @documento_resultante.index('[/{consolidacion?_ini}/]') != nil
          @documento_resultante.gsub!('[/{consolidacion?_ini}/]', '')
        end
        if @documento_resultante.index('[/{consolidacion?_fin}/]') != nil
         @documento_resultante.gsub!('[/{consolidacion?_fin}/]', '')
        end
        if var_plan_inversion_pesca.index('[/{consolidacion?_ini}/]') != nil
          var_plan_inversion_pesca.gsub!('[/{consolidacion?_ini}/]', '')
        end
        if var_plan_inversion_pesca.index('[/{consolidacion?_fin}/]') != nil
         var_plan_inversion_pesca.gsub!('[/{consolidacion?_fin}/]', '')
        end
      else
        while @documento_resultante.index('[/{consolidacion?_ini}/]') != nil
          if @documento_resultante.index('[/{consolidacion?_fin}/]') != nil
            @documento_resultante = @documento_resultante.slice(0, @documento_resultante.index('[/{consolidacion?_ini}/]')) << @documento_resultante.slice(@documento_resultante.index('[/{consolidacion?_fin}/]')+24, @documento_resultante.length - (@documento_resultante.index('[/{consolidacion?_fin}/]')+24))
          end
        end
        while var_plan_inversion_pesca.index('[/{consolidacion?_ini}/]') != nil
          if var_plan_inversion_pesca.index('[/{consolidacion?_fin}/]') != nil
            var_plan_inversion_pesca = var_plan_inversion_pesca.slice(0, var_plan_inversion_pesca.index('[/{consolidacion?_ini}/]')) << var_plan_inversion_pesca.slice(var_plan_inversion_pesca.index('[/{consolidacion?_fin}/]')+24, var_plan_inversion_pesca.length - (var_plan_inversion_pesca.index('[/{consolidacion?_fin}/]')+24))
          end
        end
      end
      while @documento_resultante.index('[/{no_pesca?_ini}/]') != nil
          if @documento_resultante.index('[/{no_pesca?_fin}/]') != nil
            @documento_resultante = @documento_resultante.slice(0, @documento_resultante.index('[/{no_pesca?_ini}/]')) << @documento_resultante.slice(@documento_resultante.index('[/{no_pesca?_fin}/]')+19, @documento_resultante.length - (@documento_resultante.index('[/{no_pesca?_fin}/]')+19))
          end
      end

     else
	if @documento_resultante.index('[/{no_pesca?_ini}/]') != nil
	  @documento_resultante.gsub!('[/{no_pesca?_ini}/]', '')
	end
	if @documento_resultante.index('[/{no_pesca?_fin}/]') != nil
	 @documento_resultante.gsub!('[/{no_pesca?_fin}/]', '')
	end
	if var_plan_inversion_pesca.index('[/{no_pesca?_ini}/]') != nil
	  var_plan_inversion_pesca.gsub!('[/{no_pesca?_ini}/]', '')
	end
	if var_plan_inversion_pesca.index('[/{no_pesca?_fin}/]') != nil
	 var_plan_inversion_pesca.gsub!('[/{no_pesca?_fin}/]', '')
	end

     end
	

   arreglo_final << ["[/plan_inversion_pesca/]", var_plan_inversion_pesca]

   if datos_empresa != nil
    empresa = Empresa.find_by_rif(datos_empresa.rif)
    unless empresa.nil?
         #DATOS DEL INTEGRANTES DEL CONSEJO COMUNAL
        datos_empresa_int = EmpresaIntegrante.find(:all,:conditions=>['empresa_id = ?',empresa.id], :limit => '3')
        field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.EmpresaIntegrantes.miembro_consejo_comunal')
        if datos_empresa_int.length > 0
            x = 1
            if datos_empresa_int.length >= 3
              nombres_integrantes = "[/ni1/], [/ni2/] y [/ni3/]"
              cedulas_integrantes = "[/ci1/], [/ci2/] y [/ci3/]"
              cargos_integrantes = "[/cgi1/], [/cgi2/] y [/cgi3/]"
            elsif datos_empresa_int.length == 2
              nombres_integrantes = "[/ni1/] y [/ni2/]"
              cedulas_integrantes = "[/ci1/] y [/ci2/]"
              cargos_integrantes = "[/cgi1/] y [/cgi2/]"
            end

             x = 1
             for integrante in datos_empresa_int
                var_nombre_int = integrante.persona.primer_nombre.strip << (integrante.persona.segundo_nombre.nil? ? '' : ' ' << integrante.persona.segundo_nombre.strip)  << ' ' <<  integrante.persona.primer_apellido.strip << ' ' << (integrante.persona.segundo_apellido.nil? ? '' : ' ' << integrante.persona.segundo_apellido.strip)
                var_cedula_int = integrante.persona.cedula_nacionalidad.upcase << "-" << integrante.persona.cedula.to_s
                var_cargo_int = integrante.cargo.strip
                nombres_integrantes.gsub!("[/ni#{x.to_s}/]", var_nombre_int)
                cedulas_integrantes.gsub!("[/ci#{x.to_s}/]", var_cedula_int)
                cargos_integrantes.gsub!("[/cgi#{x.to_s}/]", var_cargo_int)
               x+=1
             end

            arreglo_final << ["[/nombres_miembros_consejo_comunal/]", nombres_integrantes]
            arreglo_final << ["[/cedulas_miembros_consejo_comunal/]", cedulas_integrantes]
            arreglo_final << ["[/cargos_miembros_consejo_comunal/]", cargos_integrantes]

#            while (x <= 3)
#              unless datos_empresa_int[x-1].nil?
#                  var_nombre_int = datos_empresa_int[x-1].persona.primer_nombre.strip << (datos_empresa_int[x-1].persona.segundo_nombre.nil? ? '' : ' ' << datos_empresa_int[x-1].persona.segundo_nombre.strip)  << ' ' <<  datos_empresa_int[x-1].persona.primer_apellido.strip << ' ' << (datos_empresa_int[x-1].persona.segundo_apellido.nil? ? '' : ' ' << datos_empresa_int[x-1].persona.segundo_apellido.strip)
#                  var_cedula_int = datos_empresa_int[x-1].persona.cedula_nacionalidad.upcase << "-" << datos_empresa_int[x-1].persona.cedula.to_s
#                  var_cargo_int = datos_empresa_int[x-1].cargo.strip
#              else
#                var_nombre_int = "[/nombre_miembro_#{x}_consejo_comunal/]"
#                var_cedula_int =  "[/cedula_miembro_#{x}_consejo_comunal/]"
#                var_cargo_int =  "[/cargo_miembro_#{x}_consejo_comunal/]"
#              end
#              arreglo_final << ["[/nombre_miembro_#{x}_consejo_comunal/]", var_nombre_int]
#              arreglo_final << ["[/cedula_miembro_#{x}_consejo_comunal/]", var_cedula_int]
#              arreglo_final << ["[/cargo_miembro_#{x}_consejo_comunal/]", var_cargo_int]
#              x=x+1
#            end
        end
    end
   end
    #DATOS DE LA OFICINA
    datos_oficina = ViewOficina.find_by_solicitud_id(solicitud_id)
    if !datos_oficina.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.id')
      var_oficina_id = datos_oficina.oficina_id
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.nombre')
      var_oficina = datos_oficina.oficina.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.municipio')
      var_municipio = datos_oficina.municipio_oficina.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.ciudad')
      var_ciudad = datos_oficina.ciudad_oficina.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.estado')
      var_estado = datos_oficina.estado_oficina.upcase
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.representante')
      var_nombre_supervisor = datos_oficina.representante_oficina
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.cedula_representante')
      var_cedula_supervisor = datos_oficina.cedula_representante.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.abogado')
      var_nombre_abogado = datos_oficina.nombre_abogado unless datos_oficina.nombre_abogado.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.cedula_abogado')
      var_cedula_abogado = datos_oficina.cedula_abogado.capitalize unless datos_oficina.cedula_abogado.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.inpreabogado')
      var_inpreabogado = datos_oficina.inpreabogado.upcase unless datos_oficina.inpreabogado.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.año_bicentenario')
      arreglo_final << ["[/bicentenario/]", datos_oficina.bicentenario]
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.año_federacion')
      arreglo_final << ["[/federacion/]", datos_oficina.federacion]
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.documento_autenticacion')
      arreglo_final << ["[/documento_autenticacion/]", datos_oficina.documento_autenticacion]
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Oficina.tomo_autentificacion')
      arreglo_final << ["[/tomo_autenticacion/]", datos_oficina.tomo_autenticacion]

    else
      var_oficina_id = "[/oficina_id/]"
      var_oficina = "[/oficina/]"
      var_municipio = "[/municipio_oficina/]"
      var_ciudad = "[/ciudad_oficina/]"
      var_estado = "[/estado_oficina/]"
      var_nombre_supervisor = "[/representante_oficina/]"
      var_cedula_supervisor = "[/cedula_representante/]"
      var_nombre_abogado = "[/nombre_abogado/]"
      var_cedula_abogado = "[/cedula_abogado/]"
      var_inpreabogado = "[/inpreabogado/]"
    end
      if @fecha_ae.nil?
	      arreglo_final << ["[/fecha_corta/]", format_fecha(Date.today)]
	      arreglo_final << ["[/fecha_larga/]", datos_oficina.estado_oficina.upcase << ", #{I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.a_los')} " << 		Date.today.strftime('%d').to_i.to_words << ' (' << Date.today.strftime('%d') << ") #{I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.dias_del_mes')} " << es_month(Date.today) << " #{I18n.t('Sistema.Body.Vistas.General.de')} " << Date.today.strftime('%Y').to_i.to_words << ' (' << Date.today.strftime('%Y') << ')']
      else
	  
      fecha_ae =Date.strptime(@fecha_ae, I18n.t('time.formats.gebos_short')) 	      
          arreglo_final << ["[/fecha_corta/]", format_fecha(fecha_ae)]
	      arreglo_final << ["[/fecha_larga/]", datos_oficina.estado_oficina.upcase << ", #{I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.a_los')} " << fecha_ae.strftime('%d').to_i.to_words << ' (' << fecha_ae.strftime('%d') << ") #{I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.dias_del_mes')} " << es_month(fecha_ae) << " #{I18n.t('Sistema.Body.Vistas.General.de')} " << fecha_ae.strftime('%Y').to_i.to_words << ' (' << fecha_ae.strftime('%Y') << ')']
      end

   arreglo_final << ["[/oficina_id/]", var_oficina_id]
   arreglo_final << ["[/oficina/]", var_oficina]
   arreglo_final << ["[/municipio_oficina/]", var_municipio]
   arreglo_final << ["[/ciudad_oficina/]", var_ciudad]
   arreglo_final << ["[/estado_oficina/]", var_estado]
   arreglo_final << ["[/representante_oficina/]", var_nombre_supervisor]
   arreglo_final << ["[/cedula_representante/]", var_cedula_supervisor]
   arreglo_final << ["[/nombre_abogado/]", var_nombre_abogado]
   arreglo_final << ["[/cedula_abogado/]", var_cedula_abogado]
   arreglo_final << ["[/inpreabogado/]", var_inpreabogado]

   #DATOS DEl HIERRO FONDAS
    datos_hierrof = ViewHierroFondas.find_by_oficina_id(oficina_id)
    if !datos_hierrof.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroFondas.nombre_registro')
      var_nombre_registro_hierro = datos_hierrof.nombre_registro_hierro
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroFondas.nombre_oficina')
      var_nombre_oficina_hierro = datos_hierrof.nombre_oficina_hierro.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroFondas.municipio')
      var_municipio_hierro = datos_hierrof.municipio_hierro.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroFondas.nombre_registro')
      var_ciudad_hierro = datos_hierrof.ciudad_hierro.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroFondas.nombre_registro')
      var_estado_hierro = datos_hierrof.estado_hierro.upcase
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroFondas.nombre_registro')
      var_fecha_registro_hierro = datos_hierrof.fecha_registro_hierro
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroFondas.nombre_registro')
      var_numero_registro_hierro = datos_hierrof.numero_registro_hierro
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroFondas.nombre_registro')
      var_nro_tomo_hierro = datos_hierrof.tomo_hierro
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroFondas.nombre_registro')
      var_nro_protocolo_hierro = datos_hierrof.protocolo_hierro
    else
      var_nombre_registro_hierro = "[/nombre_registro_hierro/]"
      var_nombre_oficina_hierro = "[/nombre_oficina_hierro/]"
      var_municipio_hierro = "[/municipio_hierro/]"
      var_ciudad_hierro = "[/ciudad_hierro/]"
      var_estado_hierro = "[/estado_hierro/]"
      var_fecha_registro_hierro = "[/fecha_registro_hierro/]"
      var_numero_registro_hierro = "[/numero_registro_hierro/]"
      var_nro_tomo_hierro = "[/tomo_hierro/]"
      var_nro_protocolo_hierro = "[/protocolo_hierro/]"
    end

   arreglo_final << ["[/nombre_registro_hierro/]", var_nombre_registro_hierro]
   arreglo_final << ["[/nombre_oficina_hierro/]", var_nombre_oficina_hierro]
   arreglo_final << ["[/municipio_hierro/]", var_municipio_hierro]
   arreglo_final << ["[/ciudad_hierro/]", var_ciudad_hierro]
   arreglo_final << ["[/estado_hierro/]", var_estado_hierro]
   arreglo_final << ["[/fecha_registro_hierro/]", var_fecha_registro_hierro]
   arreglo_final << ["[/numero_registro_hierro/]", var_numero_registro_hierro]
   arreglo_final << ["[/tomo_hierro/]", var_nro_tomo_hierro]
   arreglo_final << ["[/protocolo_hierro/]", var_nro_protocolo_hierro]


    #DATOS DEl HIERRO BENEFICIARIO
    datos_hierrob = ViewHierroBeneficiario.find_by_solicitud_id(solicitud_id)
    if !datos_hierrob.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroBeneficiario.nombre_registro')
      var_nombre_registro_hierro_beneficiario = datos_hierrob.nombre_registro_hierro_beneficiario
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroBeneficiario.municipio_registro')
      var_municipio_hierro_beneficiario = datos_hierrob.municipio_registro_hierro_beneficiario.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroBeneficiario.estado_registro')
      var_estado_hierro_beneficiario = datos_hierrob.estado_registro_hierro_beneficiario.upcase
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroBeneficiario.fecha_registro')
      var_fecha_registro_hierro_beneficiario = datos_hierrob.fecha_registro_hierro_beneficiario
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroBeneficiario.numero_registro')
      var_numero_registro_hierro_beneficiario = datos_hierrob.numero_registro_hierro_beneficiario
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroBeneficiario.nro_tomo_registro')
      var_nro_tomo_hierro_beneficiario = datos_hierrob.nro_tomo_hierro_beneficiario
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.HierroBeneficiario.nro_protocolo_registro')
      var_nro_protocolo_hierro_beneficiario = datos_hierrob.nro_protocolo_hierro_beneficiario
    else
      var_nombre_registro_hierro_beneficiario = "[/nombre_registro_hierro_beneficiario/]"
      var_municipio_hierro_beneficiario = "[/municipio_registro_hierro_beneficiario/]"
      var_estado_hierro_beneficiario = "[/estado_registro_hierro_beneficiario/]"
      var_fecha_registro_hierro_beneficiario = "[/fecha_registro_hierro_beneficiario/]"
      var_numero_registro_hierro_beneficiario = "[/numero_registro_hierro_beneficiario/]"
      var_nro_tomo_hierro_beneficiario = "[/nro_tomo_hierro_beneficiario/]"
      var_nro_protocolo_hierro_beneficiario = "[/nro_protocolo_hierro_beneficiario/]"
    end

   arreglo_final << ["[/nombre_registro_hierro_beneficiario/]", var_nombre_registro_hierro_beneficiario]
   arreglo_final << ["[/municipio_registro_hierro_beneficiario/]", var_municipio_hierro_beneficiario]
   arreglo_final << ["[/estado_registro_hierro_beneficiario/]", var_estado_hierro_beneficiario]
   arreglo_final << ["[/fecha_registro_hierro_beneficiario/]", var_fecha_registro_hierro_beneficiario]
   arreglo_final << ["[/numero_registro_hierro_beneficiario/]", var_numero_registro_hierro_beneficiario]
   arreglo_final << ["[/nro_tomo_hierro_beneficiario/]", var_nro_tomo_hierro_beneficiario]
   arreglo_final << ["[/nro_protocolo_hierro_beneficiario/]", var_nro_protocolo_hierro_beneficiario]

    
    #DATOS DE LA UNIDAD DE PRODUCCION
    datos_unidad_produccion = ViewUnidadProduccion.find_by_solicitud_id(solicitud_id)
    if !datos_unidad_produccion.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.nombre_lote')
      var_nombre_lote = datos_unidad_produccion.nombre_lote
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.total_hectareas_letras')
      var_total_hectareas_letras = datos_unidad_produccion.total_hectareas.to_words.upcase
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.total_hectareas')
      var_total_hectareas = format_fm(datos_unidad_produccion.total_hectareas)
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.ciudad_lote')
      var_ciudad_lote = datos_unidad_produccion.ciudad_lote.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.estado_lote')
      var_estado_lote = datos_unidad_produccion.estado_lote.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.municipio_lote')
      var_municipio_lote = datos_unidad_produccion.municipio_lote.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.estado_registro_lote')
      var_estado_lote_reg = datos_unidad_produccion.estado_registro_lote.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.municipio_registro_lote')
      var_municipio_lote_reg = datos_unidad_produccion.municipio_registro_lote.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.parroquia_registro_lote')
      var_parroquia_lote = datos_unidad_produccion.parroquia_lote.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.direccion_lote')
      var_direccion_lote = datos_unidad_produccion.direccion_lote
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.referencia_lote')
      var_referencia_lote = datos_unidad_produccion.referencia_lote
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.lindero_norte_lote')
      var_lindero_norte = datos_unidad_produccion.lindero_norte
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.lindero_sur_lote')
      var_lindero_sur = datos_unidad_produccion.lindero_sur
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.lindero_este_lote')
      var_lindero_este = datos_unidad_produccion.lindero_este
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.lindero_oeste_lote')
      var_lindero_oeste = datos_unidad_produccion.lindero_oeste
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.fecha_registro_lote')
      var_fecha_registro_lote = datos_unidad_produccion.fecha_registro_lote
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.numero_registro_lote')
      var_numero_registro_lote = datos_unidad_produccion.numero_registro_lote
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.nro_tomo_registro')
      var_nro_tomo_lote = datos_unidad_produccion.nro_tomo_lote
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.nro_protocolo_registro_lote')
      var_nro_protocolo_lote = datos_unidad_produccion.nro_protocolo_lote
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.nombre_registro_lote')
      var_nombre_registro_lote = datos_unidad_produccion.nombre_registro_lote
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.tipo_lote')
      var_tipo_lote = datos_unidad_produccion.tipo_lote.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.tierra_propia')
      var_tierra_propia =  (datos_unidad_produccion.id_tipo_lote == 1? I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.hipoteca') : '')
#      var_prenda =  (datos_unidad_produccion.id_tipo_lote != 1? 'PRENDA SIN DESPLAZAMIENTO DE POSESIÓN' : '')
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadProduccion.nombre_lote')
      var_prenda = I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.prenda')
    else
      var_nombre_lote = "[/nombre_lote/]"
      var_total_hectareas_letras = "[/total_hectareas_letras/]"
      var_total_hectareas = "[/total_hectareas/]"
      var_estado_lote = "[/estado_lote/]"
      var_ciudad_lote = "[/ciudad_lote/]"
      var_municipio_lote = "[/municipio_lote/]"
      var_estado_lote_reg = "[/estado_registro_lote/]"
      var_municipio_lote_reg = "[/municipio_registro_lote/]"
      var_parroquia_lote = "[/parroquia_lote/]"
      var_direccion_lote = "[/direccion_lote/]"
      var_referencia_lote = "[/referencia_lote/]"
      var_lindero_norte = "[/lindero_norte/]"
      var_lindero_sur = "[/lindero_sur/]"
      var_lindero_este = "[/lindero_este/]"
      var_lindero_oeste = "[/lindero_oeste/]"
      var_fecha_registro_lote = "[/fecha_registro_lote/]"
      var_numero_registro_lote = "[/numero_registro_lote/]"
      var_nro_tomo_lote = "[/nro_tomo_lote/]"
      var_nro_protocolo_lote = "[/nro_protocolo_lote/]"
      var_tipo_lote = "[/tipo_lote/]"
      var_nombre_registro_lote = "[/nombre_registro_lote/]"
      var_tierra_propia = "[/{hipoteca_tierra_propia?}/]"
      var_prenda = "[/{prenda_sin_desplazamiento?}/]"
    end

   arreglo_final << ["[/nombre_lote/]", var_nombre_lote]
   arreglo_final << ["[/total_hectareas_letras/]", var_total_hectareas_letras]
   arreglo_final << ["[/total_hectareas/]", var_total_hectareas]
   arreglo_final << ["[/estado_lote/]", var_estado_lote]
   arreglo_final << ["[/ciudad_lote/]", var_ciudad_lote]
   arreglo_final << ["[/municipio_lote/]", var_municipio_lote]
   arreglo_final << ["[/parroquia_lote/]", var_parroquia_lote]
   arreglo_final << ["[/direccion_lote/]", var_direccion_lote]
   arreglo_final << ["[/referencia_lote/]", var_referencia_lote]
   arreglo_final << ["[/lindero_norte/]", var_lindero_norte]
   arreglo_final << ["[/lindero_sur/]", var_lindero_sur]
   arreglo_final << ["[/lindero_este/]", var_lindero_este]
   arreglo_final << ["[/lindero_oeste/]", var_lindero_oeste]
   arreglo_final << ["[/fecha_registro_lote/]", var_fecha_registro_lote]
   arreglo_final << ["[/numero_registro_lote/]", var_numero_registro_lote]
   arreglo_final << ["[/nro_tomo_lote/]", var_nro_tomo_lote]
   arreglo_final << ["[/nro_protocolo_lote/]", var_nro_protocolo_lote]
   arreglo_final << ["[/nombre_registro_lote/]", var_nombre_registro_lote]
   arreglo_final << ["[/municipio_registro_lote/]", var_municipio_lote_reg]
   arreglo_final << ["[/estado_registro_lote/]", var_estado_lote_reg]
   arreglo_final << ["[/tipo_lote/]", var_tipo_lote]

   arreglo_final << ["[/{hipoteca_tierra_propia?}/]",var_tierra_propia]
   arreglo_final << ["[/{prenda_sin_desplazamiento?}/]",var_prenda]

    #DATOS DEl REGISTRO NAVAL
    datos_registro_naval = ViewRegistroNaval.find_by_solicitud_id(solicitud_id)
    if !datos_registro_naval.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.RegistroNaval.nombre_registro')
      var_nombre_registro_naval = datos_registro_naval.nombre_registro_naval
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.RegistroNaval.municipio_registro')
      var_municipio_naval = datos_registro_naval.municipio_registro_naval.capitalize
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.RegistroNaval.estado_registro')
      var_estado_naval = datos_registro_naval.estado_registro_naval.upcase
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.RegistroNaval.fecha_registro')
      var_fecha_registro_naval = datos_registro_naval.fecha_registro_naval
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.RegistroNaval.numero_registro')
      var_numero_registro_naval = datos_registro_naval.numero_registro_naval
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.RegistroNaval.nro_tomo_registro')
      var_nro_tomo_registro_naval = datos_registro_naval.nro_tomo_registro_naval
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.RegistroNaval.nro_protocolo_registro')
      var_nro_protocolo_registro_naval = datos_registro_naval.nro_protocolo_registro_naval
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.RegistroNaval.nombre_embarcacion')
      var_nombre_embarcacion = datos_registro_naval.nombre_embarcacion
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.RegistroNaval.matricula_embarcacion')
      var_matricula = datos_registro_naval.matricula
    else
      var_nombre_registro_naval = "[/nombre_registro_naval/]"
      var_municipio_naval = "[/municipio_registro_naval/]"
      var_estado_naval = "[/estado_registro_naval/]"
      var_fecha_registro_naval = "[/fecha_registro_naval/]"
      var_numero_registro_naval = "[/numero_registro_naval/]"
      var_nro_tomo_registro_naval = "[/nro_tomo_registro_naval/]"
      var_nro_protocolo_registro_naval = "[/nro_protocolo_registro_naval/]"
      var_nombre_embarcacion = "[/nombre_nombre_embarcacion/]"
      var_matricula = "[/matricula/]"
    end

   arreglo_final << ["[/nombre_registro_naval/]", var_nombre_registro_naval]
   arreglo_final << ["[/municipio_registro_naval/]", var_municipio_naval]
   arreglo_final << ["[/estado_registro_naval/]", var_estado_naval]
   arreglo_final << ["[/fecha_registro_naval/]", var_fecha_registro_naval]
   arreglo_final << ["[/numero_registro_naval/]", var_numero_registro_naval]
   arreglo_final << ["[/nro_tomo_registro_naval/]", var_nro_tomo_registro_naval]
   arreglo_final << ["[/nro_protocolo_registro_naval/]", var_nro_protocolo_registro_naval]
   arreglo_final << ["[/nombre_embarcacion/]", var_nombre_embarcacion]
   arreglo_final << ["[/matricula/]", var_matricula]

	field_error = "#{I18n.t('Sistema.Body.Vistas.General.reestructuracion')} #{I18n.t('Sistema.Body.Vistas.General.detalle')}"
	model_reestructura = ViewReestructuracionDetalle.find(:all,:conditions=>['solicitud_nueva_id = ?',solicitud_id])
	var_reestructura = ""
	if model_reestructura != nil
		for registro in model_reestructura
		  var_reestructura += " #{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.año')} "  << registro.fecha_solicitud.strftime('%Y') << ", #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.rubro')} " << registro.rubro << ", #{I18n.t('Sistema.Body.Vistas.General.con')} #{I18n.t('Sistema.Body.Vistas.General.el')} #{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.credito')} " << registro.numero.to_s << ","
		end

	end
   arreglo_final << ["[/reestructuracion_detalle/]", var_reestructura]

    datos_reestructura = ViewReestructuracion.find_by_solicitud_id(solicitud_id)
    if !datos_reestructura.nil?
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.monto_abono')
      var_reest_monto_abono = datos_reestructura.monto_abono
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.monto_abono_letras')
      var_reest_monto_abono_letras = datos_reestructura.monto_abono_letras.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.con')).upcase} " << datos_reestructura.monto_abono_letras.to_s.split('.')[1] << "/100"
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.referencia_abono')
      var_reest_referencia_abono = datos_reestructura.referencia_abono
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.banco_abono')
      var_reest_banco_abono = datos_reestructura.banco_abono
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.numero_cta_abono')
      var_reest_numero_cuenta = datos_reestructura.numero_cuenta
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.fecha_abono')
      var_reest_fecha_abono = datos_reestructura.fecha_abono
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.porcentaje_arrime')
      var_reest_porcentaje_arrime = datos_reestructura.porcentaje_arrime
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.porcentaje_arrime_letras')
      var_reest_porcentaje_arrime_letras = porcentaje_letras(datos_reestructura.porcentaje_arrime_letras)
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.interes_diferido')
      var_reest_interes_moratorio = datos_reestructura.interes_moratorio
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.interes_diferido_letras')
      var_reest_interes_moratorio_letras = datos_reestructura.interes_moratorio_letras.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.con')).upcase} " << datos_reestructura.interes_moratorio_letras.to_s.split('.')[1] << "/100"
     var_reest_interes_diferido = datos_reestructura.interes_diferido
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.interes_diferido_letras')
      var_reest_interes_diferido_letras = datos_reestructura.interes_diferido_letras.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.con')).upcase} " << datos_reestructura.interes_diferido_letras.to_s.split('.')[1] << "/100"
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.interes_ordinario')
      var_reest_interes_ordinarios = datos_reestructura.interes_ordinarios
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.interes_diferido_letras')
      var_reest_interes_ordinarios_letras = datos_reestructura.interes_ordinarios_letras.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.con')).upcase} " << datos_reestructura.interes_ordinarios_letras.to_s.split('.')[1] << "/100"
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.interes_causado_no_devengado')
      var_reest_interes_causado_no_devengado = datos_reestructura.interes_causado_no_devengado
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.interes_causado_no_devengado_letras')
      var_reest_interes_causado_no_devengado_letras = datos_reestructura.interes_causado_no_devengado_letras.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.con')).upcase} " << datos_reestructura.interes_causado_no_devengado_letras.to_s.split('.')[1] << "/100"
     field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.monto_reestructurado')
      var_reest_monto_reestructurado = datos_reestructura.monto_reestructurado
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.monto_reestructurado_letras')
      var_reest_monto_reestructurado_letras = datos_reestructura.monto_reestructurado_letras.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.con')).upcase} " << datos_reestructura.monto_reestructurado_letras.to_s.split('.')[1] << "/100"
       field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.frecuencia')
      var_reest_frecuencia = datos_reestructura.frecuencia
       field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.cuotas')
      var_reest_cuotas = datos_reestructura.cuotas
       field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.saldo_insoluto')
      var_reest_saldo_insoluto = datos_reestructura.saldo_insoluto_reestructuracion
      field_error = I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.Reestructuracion.saldo_insoluto_letras')
      var_reest_saldo_insoluto_letras = datos_reestructura.saldo_insoluto_reestructuracion_letras.to_words.upcase << " #{(I18n.t('Sistema.Body.Vistas.General.con')).upcase} " << datos_reestructura.saldo_insoluto_reestructuracion_letras.to_s.split('.')[1] << "/100"
else
      var_reest_monto_abono = '[/monto_abono/]'
      var_reest_monto_abono_letras =  '[/monto_abono_letras/]'
      var_reest_referencia_abono =  '[/referencia_abono/]'
      var_reest_banco_abono =  '[/banco_abono/]'
      var_reest_numero_cuenta =  '[/numero_cuenta/]'
      var_reest_fecha_abono =  '[/fecha_abono/]'
      var_reest_interes_diferido =  '[/porcentaje_arrime/]'
      var_reest_interes_diferido_letras =  '[/porcentaje_arrime_letras/]'
      var_reest_interes_diferido =  '[/interes_diferido/]'
      var_reest_interes_diferido_letras =  '[/interes_diferido_letras/]'
      var_reest_interes_moratorio =  '[/interes_moratorio/]'
      var_reest_interes_moratorio_letras =  '[/interes_moratorio_letras/]'
      var_reest_interes_ordinarios =  '[/interes_ordinarios/]'
      var_reest_interes_ordinarios_letras =  '[/interes_ordinarios_letras/]'
      var_reest_interes_causado_no_devengado =  '[/interes_causado_no_devengado/]'
      var_reest_interes_causado_no_devengado_letras = '[/interes_causado_no_devengado_letras/]'
      var_reest_monto_reestructurado =  '[/monto_reestructurado/]'
      var_reest_monto_reestructurado_letras =  '[/monto_reestructurado_letras/]'
      var_reest_frecuencia = '[/frecuencia/]'
      var_reest_cuotas =  '[/cuotas/]'
      var_reest_saldo_insoluto =  '[/saldo_insoluto_reestructuracion/]'
      var_reest_saldo_insoluto_letras =  '[/saldo_insoluto_reestructuracion_letras/]'
    end
logger.debug "SALDO INSOLUTO..............." << var_reest_saldo_insoluto.inspect	
      arreglo_final << ['[/monto_abono/]',var_reest_monto_abono]
      arreglo_final << ['[/monto_abono_letras/]',var_reest_monto_abono_letras]
      arreglo_final << ['[/banco_abono/]',var_reest_banco_abono]
      arreglo_final << ['[/numero_cuenta/]',var_reest_numero_cuenta]
      arreglo_final << ['[/referencia_abono/]',var_reest_referencia_abono]
      arreglo_final << ['[/fecha_abono/]',var_reest_fecha_abono]
      arreglo_final << ['[/porcentaje_arrime/]',var_reest_porcentaje_arrime]
      arreglo_final << ['[/porcentaje_arrime_letras/]',var_reest_porcentaje_arrime_letras]
      arreglo_final << ['[/interes_diferido/]',var_reest_interes_diferido]
      arreglo_final << ['[/interes_diferido_letras/]',var_reest_interes_diferido_letras]
      arreglo_final << ['[/interes_ordinarios/]',var_reest_interes_ordinarios]
      arreglo_final << ['[/interes_ordinarios_letras/]',var_reest_interes_ordinarios_letras]
      arreglo_final << ['[/interes_moratorio/]',var_reest_interes_moratorio]
      arreglo_final << ['[/interes_moratorio_letras/]',var_reest_interes_moratorio_letras]
      arreglo_final << ['[/interes_causado_no_devengado/]',var_reest_interes_causado_no_devengado]
      arreglo_final << ['[/interes_causado_no_devengado_letras/]',var_reest_interes_causado_no_devengado_letras]
      arreglo_final << ['[/monto_reestructurado/]',var_reest_monto_reestructurado]
      arreglo_final << ['[/monto_reestructurado_letras/]',var_reest_monto_reestructurado_letras]
      arreglo_final << ['[/frecuencia/]',var_reest_frecuencia]
      arreglo_final << ['[/cuotas/]',var_reest_cuotas]
      arreglo_final << ['[/saldo_insoluto_reestructuracion/]',var_reest_saldo_insoluto]
      arreglo_final << ['[/saldo_insoluto_reestructuracion_letras/]',var_reest_saldo_insoluto_letras]



rescue Exception => e
  logger.info "Error en PLANTILLA : " << e.message.to_s << " full " << e.message.inspect.to_s 
  logger.info "StackTrace : " << e.backtrace.to_s << " trace " << e.backtrace.inspect.to_s
	arreglo_final[0][0] = I18n.t('Sistema.Body.Modelos.Plantilla.Errores.error')
  unless e.message["nil."].nil?
    arreglo_final[0][1] = I18n.t('Sistema.Body.Modelos.Plantilla.Errores.no_contiene_valor_alguno')
  else
    arreglo_final[0][1] = I18n.t('Sistema.Body.Modelos.Plantilla.Errores.no_contiene_datos_validos')
  end
	arreglo_final[1][0] = I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.campo')
	arreglo_final[1][1] = field_error
end

    return arreglo_final
    
end


def es_month(date)
   _months = [ I18n.t('date.month_names')[1],  I18n.t('date.month_names')[2],  I18n.t('date.month_names')[3],  I18n.t('date.month_names')[4],  I18n.t('date.month_names')[5],  I18n.t('date.month_names')[6] ,
 I18n.t('date.month_names')[7],  I18n.t('date.month_names')[8], I18n.t('date.month_names')[9],  I18n.t('date.month_names')[10],  I18n.t('date.month_names')[11],  I18n.t('date.month_names')[12]]
   month = date.strftime('%m')
   return _months[(month.to_i)-1]
  end

  def porcentaje_letras(valor)
      valor = 0 if valor == nil
      if valor.to_s.split('.')[1].to_i == 0
          valor.to_words.upcase << " #{(I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.por_ciento')).upcase}"
      else
          dec = valor.to_s.split('.')[1]
          valor.to_words.upcase << " #{I18n.t('Sistema.Body.ExpresionesRegulares.separador_decimal')} " << dec.to_i.to_words.upcase << " #{(I18n.t('Sistema.Body.Modelos.Plantilla.Mensajes.por_ciento')).upcase}"
      end
  end


  def convertidor(inicial)
    valor = ""
    
    if inicial == 'D'
    valor = I18n.t('Sistema.Body.Vistas.General.divorciado')
    end
     if inicial == 'S'
    valor = I18n.t('Sistema.Body.Vistas.General.soltero')
    end
     if inicial == 'C'
    valor = I18n.t('Sistema.Body.Vistas.General.casado')
    end
    if inicial == 'V'
    valor = I18n.t('Sistema.Body.Vistas.General.viudo')
    end
    
    return valor
  end

  validate :validate
  
  def validate
    if self.new_record?
      pl = Plantilla.count(:conditions=>['sector_id = ? and nemonico = ? and tipo_beneficiario = ? and activo and not id in (10,11,1,9)',self.sector_id,self.nemonico, self.tipo_beneficiario])
    else
      pl = Plantilla.count(:conditions=>['sector_id = ? and nemonico = ? and tipo_beneficiario = ? and id <> ? and activo and not id in (10,11,1,9)',self.sector_id,self.nemonico, self.tipo_beneficiario,self.id])
    end
    if pl > 0
      errors.add(:plantilla,I18n.t('Sistema.Body.Modelos.Plantilla.Errores.ya_existe_planilla_activa'))
    end

  end

end

# == Schema Information
#
# Table name: plantilla
#
#  id                :integer         not null, primary key
#  tipo_beneficiario :string(1)
#  sector_id         :integer
#  nombre            :string(255)     not null
#  encabezado        :string(255)     not null
#  logotipo          :string(255)     not null
#  documento         :text            not null
#  definido          :boolean         default(FALSE)
#  activo            :boolean         default(FALSE)
#  nemonico          :string(2)
#

