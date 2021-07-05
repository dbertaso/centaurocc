# encoding: utf-8
class SigaCausado < ActiveRecord::Base


self.table_name = 'siga_causado'
  
  attr_accessible   :id,
					:fecha,
					:numero_solicitud,
					:numero_prestamo,
					:rif_ci,
					:nombre_beneficiario,
					:monto,
					:forma_desembolso,
					:tipo_transaccion,
					:registrado,
					:fecha_registro,
					:cuenta_presupuestaria




	def self.generar(solicitud,prestamo,desembolso,tipo_transaccion,forma_desembolso)
		solicitud = solicitud
		prestamo = prestamo
		desembolso = desembolso
		tipo_transaccion = tipo_transaccion
		forma_desembolso = forma_desembolso

		nro_solicitud = solicitud.numero
		numero_prestamo = prestamo.numero
		if forma_desembolso !='I'
			monto = desembolso.monto
		else
			monto = prestamo.monto_facturado
		end
        
        # ubicando el dato de cuenta presupuestaria 31/05/2013        
        plazo=solicitud.actividad.plazo_ciclo
        unless plazo.nil?
            partida_presupuestaria=PartidaPresupuestaria.find_by_programa_id_and_plazo_ciclo(solicitud.programa_id,plazo)        
            unless partida_presupuestaria.nil?
                cuenta_presupuestaria = partida_presupuestaria.proyecto.to_s + "-" +
                                    partida_presupuestaria.accion_especifica.to_s + "-" +
                                    partida_presupuestaria.partida.to_s + "." +
                                    partida_presupuestaria.generica.to_s + "." +
                                    partida_presupuestaria.especifica.to_s + "." +
                                    partida_presupuestaria.sub_especifica.to_s
            else
                cuenta_presupuestaria =I18n.t('Sistema.Body.Modelos.Solicitud.Mensajes.cuenta_inexistente')
            end
        else                                
            cuenta_presupuestaria=I18n.t('Sistema.Body.Modelos.Solicitud.Mensajes.cuenta_inexistente')
        end
        # fin ubicando el dato de cuenta presupuestaria 31/05/2013                                
        
		# Ubicando Info del Cliente
    cliente = solicitud.cliente_id
    logger.info "CLIENTE =========> " << cliente.to_s
    if Cliente.find(cliente).empresa_id.nil?
    	# Cliente es una persona natural
      info_beneficiario = Persona.find(Cliente.find(cliente).persona_id)
			rif_ci = info_beneficiario.cedula_nacionalidad.to_s + '-' + info_beneficiario.cedula.to_s
		else		
      #Cliente es una empresa
			info_empresa = Empresa.find(Cliente.find(cliente).empresa_id)
			rif_ci = info_empresa.rif
		end				
		nombre_beneficiario = solicitud.nombre
		registrado = false

   	self.create(
			:fecha => Time.now,
			:numero_solicitud=> nro_solicitud,
			:numero_prestamo=> numero_prestamo,
		    :rif_ci=> rif_ci[0,15],
		    :nombre_beneficiario=> nombre_beneficiario[0,255],
		    :monto=> monto,
			:forma_desembolso=> forma_desembolso,
		    :tipo_transaccion=> tipo_transaccion,
		    :registrado=> registrado,
            :cuenta_presupuestaria=>cuenta_presupuestaria[0,20] 
		)
		return true
	end  



    def self.generar_para_revocatoria(solicitud,prestamo,desembolso,tipo_transaccion,forma_desembolso,tipo_revocatoria,monto_revocar)
		solicitud = solicitud
		prestamo = prestamo
		desembolso = desembolso
		tipo_transaccion = tipo_transaccion
		forma_desembolso = forma_desembolso

		nro_solicitud = solicitud.numero
		numero_prestamo = prestamo.numero
		
        
        
        # ubicando el dato de cuenta presupuestaria 31/05/2013        
        plazo=solicitud.actividad.plazo_ciclo
        unless plazo.nil?
            partida_presupuestaria=PartidaPresupuestaria.find_by_programa_id_and_plazo_ciclo(solicitud.programa_id,plazo)        
            unless partida_presupuestaria.nil?
                cuenta_presupuestaria = partida_presupuestaria.proyecto.to_s + "-" +
                                    partida_presupuestaria.accion_especifica.to_s + "-" +
                                    partida_presupuestaria.partida.to_s + "." +
                                    partida_presupuestaria.generica.to_s + "." +
                                    partida_presupuestaria.especifica.to_s + "." +
                                    partida_presupuestaria.sub_especifica.to_s
            else
                cuenta_presupuestaria =I18n.t('Sistema.Body.Modelos.Solicitud.Mensajes.cuenta_inexistente')
            end
        else                                
            cuenta_presupuestaria=I18n.t('Sistema.Body.Modelos.Solicitud.Mensajes.cuenta_inexistente')
        end
        # fin ubicando el dato de cuenta presupuestaria 31/05/2013                                
        
		
        if tipo_revocatoria=='T'
        
                # Ubicando Info del Cliente
            monto=(prestamo.monto_insumos.to_f + prestamo.monto_banco.to_f + prestamo.monto_sras_total.to_f  + prestamo.monto_gasto_total.to_f)
            cliente = solicitud.cliente_id
            logger.info "CLIENTE =========> " << cliente.to_s
            if Cliente.find(cliente).empresa_id.nil?
                # Cliente es una persona natural
              info_beneficiario = Persona.find(Cliente.find(cliente).persona_id)
                    rif_ci = info_beneficiario.cedula_nacionalidad.to_s + '-' + info_beneficiario.cedula.to_s
                else		
              #Cliente es una empresa
                    info_empresa = Empresa.find(Cliente.find(cliente).empresa_id)
                    rif_ci = info_empresa.rif
                end				
                nombre_beneficiario = solicitud.nombre
                registrado = false

            self.create(
                    :fecha => Time.now,
                    :numero_solicitud=> nro_solicitud,
                    :numero_prestamo=> numero_prestamo,
                    :rif_ci=> rif_ci[0,15],
                    :nombre_beneficiario=> nombre_beneficiario[0,255],
                    :monto=> monto,
                    :forma_desembolso=> forma_desembolso,
                    :tipo_transaccion=> tipo_transaccion,
                    :registrado=> registrado,
                    :cuenta_presupuestaria=>cuenta_presupuestaria[0,20] 
                )
                return true
	
        else
        #caso parcial
    
                    # Ubicando Info del Cliente
            if prestamo.solicitud.por_inventario
            monto = 0
            else
            monto=monto_revocar.to_f
            end
            cliente = solicitud.cliente_id
            logger.info "CLIENTE =========> " << cliente.to_s
            if Cliente.find(cliente).empresa_id.nil?
                # Cliente es una persona natural
              info_beneficiario = Persona.find(Cliente.find(cliente).persona_id)
                    rif_ci = info_beneficiario.cedula_nacionalidad.to_s + '-' + info_beneficiario.cedula.to_s
                else		
              #Cliente es una empresa
                    info_empresa = Empresa.find(Cliente.find(cliente).empresa_id)
                    rif_ci = info_empresa.rif
                end				
                nombre_beneficiario = solicitud.nombre
                registrado = false

            self.create(
                    :fecha => Time.now,
                    :numero_solicitud=> nro_solicitud,
                    :numero_prestamo=> numero_prestamo,
                    :rif_ci=> rif_ci[0,15],
                    :nombre_beneficiario=> nombre_beneficiario[0,255],
                    :monto=> monto,
                    :forma_desembolso=> forma_desembolso,
                    :tipo_transaccion=> tipo_transaccion,
                    :registrado=> registrado,
                    :cuenta_presupuestaria=>cuenta_presupuestaria[0,20] 
                )
                return true
        end  
    
    
    end  






end



# == Schema Information
#
# Table name: siga_causado
#
#  id                    :integer         not null, primary key
#  fecha                 :date            not null
#  numero_solicitud      :integer         not null
#  numero_prestamo       :integer(8)      not null
#  rif_ci                :string(15)      not null
#  nombre_beneficiario   :string(255)     not null
#  monto                 :decimal(16, 2)  default(0.0), not null
#  forma_desembolso      :string(1)       not null
#  tipo_transaccion      :string(1)       not null
#  registrado            :boolean         default(FALSE), not null
#  fecha_registro        :date
#  cuenta_presupuestaria :string(20)
#

