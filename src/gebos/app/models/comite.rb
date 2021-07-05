# encoding: utf-8

# 
# clase: Comite
# descripción: Migración a Rails 3
#

class Comite < ActiveRecord::Base  
  
  self.table_name = 'comite'

  attr_accessible :id,
                  :numero,
                  :fecha_apertura,
                  :vigente,
                  :hora_apertura,
                  :minuto_apertura,
                  :meridiano_apertura,
                  :lugar,
                  :direccion,
                  :compromiso_presupu,
                  :fecha_compromiso_presup,
                  :instancia_tipo_id,
                  :fecha_apertura_f
  
  
  #attr_accessor :comite_nro
  belongs_to :presupuesto_comite
  belongs_to :instancia_tipo
  has_many :comite_miembro
  has_one :punto_cuenta
  has_many :solicitud
  has_many :comite_decision_historico
  
  def  get_instancia_tipo(valor) 
    resultado = InstanciaTipo.find(self.instancia_tipo_id)
    if !resultado.nil?
      resultado = resultado.nombre
    end
    return resultado
  end
  
  def fecha_apertura_f=(fecha)
    unless fecha.nil? || fecha.empty?      
      fecha =  fecha[6,4] + '/' + fecha[3,2] + '/' + fecha[0,2]
    end
    self.fecha_apertura = fecha
  end
  
  def fecha_apertura_f
    format_fecha(self.fecha_apertura)    
  end  
  
  before_update :antes_actualizar
  
  def antes_actualizar             
    mensaje="#{I18n.t('Sistema.Body.Vistas.General.el')} #{I18n.t('Sistema.Body.Vistas.Form.valor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"
    errors.add(:comite, "#{I18n.t('Sistema.Body.Modelos.ItemAtributo.Tipo.fecha')}: #{mensaje}") if self.fecha_apertura.to_s.empty?
    errors.add(:comite, "#{I18n.t('Sistema.Body.Vistas.General.hora')}: #{mensaje}") if self.hora_apertura.to_s.empty? || self.hora_apertura.to_i > 12
    errors.add(:comite, "#{I18n.t('datetime.prompts.minute')}: #{mensaje}") if self.minuto_apertura.to_s.empty? || self.minuto_apertura.to_i > 59
    errors.add(:comite, "#{I18n.t('Sistema.Body.Vistas.General.lugar')}: #{mensaje}") if self.lugar.to_s.empty?
    errors.add(:comite, "#{I18n.t('Sistema.Body.General.direccion')}: #{mensaje}") if self.direccion.to_s.empty?
    comite_miembro=ComiteMiembro.find_by_comite_id(self.id,:conditions=>"firma=true")
    errors.add(:comite, I18n.t('Sistema.Body.Vistas.InstanciaComiteNacional.Errores.debe_agregar_integrante')) if comite_miembro.nil?
    if errors.size > 0
      return false
    else
      return true
    end
  end

  
  ##############################
  #  Crea el comite nacional. ##
  ##############################
  
  def crear_comite_nacional session
  
    transaction do
    
      begin
      
        #ciudad = Ciudad.find(:first, :conditions=>['ciudad.id=?',Oficina.find(session[:oficina]).ciudad_id.to_s],:include=>:estado)
        oficina_id=session[:oficina].to_s
        ########################################
        #1 Verificar si el comite esta cerrado.
        Comite.connection.execute("LOCK comite in ACCESS EXCLUSIVE MODE;")
        ComiteDecisionHistorico.connection.execute("LOCK comite_decision_historico in ACCESS EXCLUSIVE MODE;")
        comite=Comite.find(:first,:include=>['comite_decision_historico'],:conditions=>" comite_decision_historico.tipo_comite='n' ",:order=>"comite.id desc")
        if !comite.nil?
          if comite.vigente==true
            return I18n.t('Sistema.Body.Vistas.InstanciaComiteNacional.Errores.llenar_datos_instancia')
          else
            ##################################################################
            #2 Todos los tramites del ultimo comite deben tener una decision.
            total=ComiteDecisionHistorico.count(:conditions=>"tipo_comite='n' and comite_id=#{comite.id} ")
            total_decision=ComiteDecisionHistorico.count(:conditions=>"tipo_comite='n' and decision is not null and comite_id=#{comite.id} ")
            if total.to_i!=total_decision.to_i
              return I18n.t('Sistema.Body.Vistas.InstanciaComiteNacional.Errores.datos_creados_deben_tener_decision')
            end
          end
        end
      
        condicion=" estatus_id=10034 and comite_estadal_id is not null and ( comite_id IS NULL or decision_comite_nacional='D' ) "
      
        solicitudes=Solicitud.find(:all,:conditions=>condicion)
    
        if !solicitudes.nil? && !solicitudes.empty?
          ParametroGeneral.connection.execute("LOCK parametro_general in ACCESS EXCLUSIVE MODE;")
          parametro_general=ParametroGeneral.find(:first)
          semilla = parametro_general.numeracion_instancia_nacional.to_i + 1
          anio    = ParametroGeneral.find(:first).anio_constitucion_comite_vigente
          numero  = semilla.to_s+"-"+anio.to_s
          parametro_general.numeracion_instancia_nacional = semilla
          parametro_general.save!
          comite  = Comite.new
          comite.attributes = {:numero=>numero,:instancia_tipo_id=> 5,:vigente=>true}
          comite.save!
          
          params = {
            :p_numero_comite=>numero,
            :p_comite_id=>comite.id,
            :p_tipo=>'N',
            :p_oficina_id=>0
          }
          
          ejecutar = execute_sp('apertura_comite', params.values_at(
                :p_numero_comite,
                :p_comite_id,
                :p_tipo,
                :p_oficina_id))
          
          logger.info "Ejecutar =======> #{ejecutar.to_s}"
          
              #solicitudes.each { |x|          
                #x.numero_comite_nacional     = numero
                #x.comite_id                  = comite.id
                #x.decision_comite_nacional   = nil
                #x.comentario_comite_nacional = nil
                #x.save!
                #ComiteDecisionHistorico.create(
                  #:solicitud_id=> x.id,
                  #:comite_id   => comite.id,
                  #:tipo_comite => 'n',
                  #:oficina_id  => x.oficina_id
                #)
              #}
          return 1
        else
          return I18n.t('Sistema.Body.Vistas.InstanciaComiteNacional.Errores.no_existen_tramites_para_nuevo_comite')
        end
      rescue=>detail
        return I18n.t('Sistema.Body.Vistas.InstanciaComiteNacional.Errores.error_en_creacion') + detail.message.to_s
        
      end       #------> Fin del Begin
     
    end        #------> Fin transacion do
    
  end          #---- Fin del método comite_nacional
  
  #############################
  #  Crea el comite estadal. ##
  #############################
  def crear_comite session
  
    transaction do     
       
      begin    
      
        ciudad     = Ciudad.find(:first, :conditions=>['ciudad.id=?',Oficina.find(session[:oficina]).ciudad_id.to_s],:include=>:estado)
        oficina_id = session[:oficina].to_s
        ########################################
        #1 Verificar si el comite esta cerrado.    
        Comite.connection.execute("LOCK comite in ACCESS EXCLUSIVE MODE;")
        ComiteDecisionHistorico.connection.execute("LOCK comite_decision_historico in ACCESS EXCLUSIVE MODE;")
        comite=Comite.find(:first,:include=>['comite_decision_historico'],      
          :conditions=>" comite_decision_historico.tipo_comite='e' and comite_decision_historico.oficina_id=#{oficina_id} ",
          :order=>"comite.id desc")
        if !comite.nil?      
          if comite.vigente==true
            return I18n.t('Sistema.Body.Vistas.InstanciaComiteNacional.Errores.llenar_datos_instancia')
          else
            ##################################################################
            #2 Todos los tramites del ultimo comite deben tener una decision.        
            total=ComiteDecisionHistorico.count(:conditions=>"tipo_comite='e' and oficina_id=#{oficina_id} and comite_id=#{comite.id} ")
            total_decision=ComiteDecisionHistorico.count(:conditions=>"tipo_comite='e' and oficina_id=#{oficina_id} and decision is not null and comite_id=#{comite.id} ")
            if total.to_i!=total_decision.to_i
              return I18n.t('Sistema.Body.Vistas.InstanciaComiteNacional.Errores.datos_creados_deben_tener_decision')
            end       
          end
        end
    
        solicitudes=Solicitud.find(:all,:conditions=>"estatus_id=10033 and oficina_id=#{oficina_id} and ( comite_estadal_id IS NULL or decision_comite_estadal='D' ) ")
    
        #-----------------------------------
        #-- Se agregan las solicitudes.   --
        #-----------------------------------
        if !solicitudes.nil? && !solicitudes.empty?

          Estado.connection.execute("LOCK estado in ACCESS EXCLUSIVE MODE;")
          estado  = Estado.find(:first,:conditions=>"id=#{ciudad[:estado_id]}")
          semilla = estado.numeracion_instancia.to_i + 1
          anio    = ParametroGeneral.find(:first).anio_constitucion_comite_vigente
          numero_comite  = semilla.to_s+"-"+anio.to_s
          estado.numeracion_instancia = semilla
          estado.save!
          comite  = Comite.new
          comite.attributes = {:numero=>numero_comite,:instancia_tipo_id=> 4,:vigente=>true}
          comite.save!

          params = {
            :p_numero_comite=>numero_comite,
            :p_comite_id=>comite.id,
            :p_tipo=>'E',
            :p_oficina_id=>oficina_id
          }
          
          ejecutar = execute_sp('apertura_comite', params.values_at(
                :p_numero_comite,
                :p_comite_id,
                :p_tipo,
                :p_oficina_id))
          
          return 1
          
        else
        
          return I18n.t('Sistema.Body.Vistas.InstanciaComiteNacional.Errores.no_existen_tramites_para_nuevo_comite')
          
        end      #----> if !solicitudes.nil? && !solicitudes.empty?
        
      rescue 
      
        return I18n.t('Sistema.Body.Vistas.InstanciaComiteNacional.Errores.error_en_creacion') 
        
      end     #---- Fin del Begin
      
    end       #---- Fin transaction do
    
  end         #---- Fin del método comite_estadal
  
  def self.eliminar_comite comite_id, comite_estadal_id
    total = Solicitud.count(:conditions=>" comite_estadal_id=#{comite_estadal_id} ")
    transaction do
      if total==0
        # Estadal
        if comite_id.nil?
          comite = Comite.find_by_id(comite_estadal_id)
          ComiteDecisionHistorico.find_by_sql("delete from comite_decision_historico where comite_id=#{comite_estadal_id}")
          ComiteMiembro.find_by_sql("delete from comite_miembro where comite_id=#{comite_estadal_id}")
          comite.destroy          
        end        
      end
    end
  end
  
  ###############################################
  # Cantidad de solicitudes con y sin decision ##
  ###############################################
  def cantidad_solicitudes tipo, session
    #ciudad   = Ciudad.find(:first, :conditions=>['ciudad.id=?',session[:oficina][:ciudad_id].to_s],:include=>:estado)
    oficina_id=session[:oficina].to_s
    estado= tipo=='e' ? " and oficina_id=#{oficina_id} " : ""
    total=ComiteDecisionHistorico.count(:conditions=>" tipo_comite='#{tipo}' and comite_id=#{self.id} #{estado} ")
    total_decision=ComiteDecisionHistorico.count(:conditions=>" tipo_comite='#{tipo}' and comite_id=#{self.id} and decision is not null #{estado} ")    
    {:total=>total,:total_con_decision=>total_decision}    
  end
  
  def monto_solicitudes(tipo)
    moneda_id = ParametroGeneral.first.moneda.id
    if tipo == 'N'
      total = Solicitud.sum('monto_solicitado', :conditions=>"moneda_id = #{moneda_id} and id in (select solicitud_id from comite_decision_historico where comite_id = #{self.id})")
    else
      total = Solicitud.sum('monto_solicitado', :conditions=>"moneda_id <> #{moneda_id} and id in (select solicitud_id from comite_decision_historico where comite_id = #{self.id})")
    end
#    total=ComiteDecisionHistorico.sum('monto_solicitado',:include=>[:Solicitud],:conditions=>"comite_decision_historico.comite_id=#{self.id}")
    return format_fm(total) if !total.nil?
    return format_fm(0) if total.nil?
  end

  ##############################################################################
  
  def hay_solicitudes_sin_asignar?
    resultado = false
    solicitudes_no_asignadas = Solicitud.find(:all, :conditions => "((estatus_id = #{self.instancia_tipo.estatus_id} AND comite_id IS NULL))")
    resultado =true if !solicitudes_no_asignadas[0].nil?
    return resultado
  end

  def get_numeros_comites()
    numeros_comite = Comite.find(:all, :conditions => 'vigente = false')
    numeros_comite.collect! {|x| [x.numero, x.id]}
    return numeros_comite
  end 

  def numero_comite()
    return self.numero.split("-")[0]
  end

  def proximo_numero_resolucion()
    correlativo = Solicitud.find(:all, :conditions => "numero_resolucion_comite <> '' AND comite_id = #{self.id} AND (decision_comite = 'A' OR decision_comite = 'C')").length + 1
    anio = ParametroGeneral.find(:all)[0].anio_constitucion_comite_vigente
    numero_comite().to_s + "." + correlativo.to_s + "-" + anio.to_s
  end
  
  def obtener_miembros(rol)
    str_final = ""
    miembros_comite = ComiteMiembro.find_by_sql("select nombre, apellido from miembro_comite where id IN (select miembro_comite_id from comite_miembro where comite_id = #{self.id} AND rol = '#{rol}');")
    miembros_comite.collect! {|x| x.nombre + ' ' + x.apellido}

    for nombre in miembros_comite
      str_final += nombre + ',' 
    end

    str_final[str_final.length-1] = ""
    return str_final    
  end


  def self.search(search, page, orden)    

    conditions=search  
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden, :include => [:comite_decision_historico,:instancia_tipo]
  end


end

# == Schema Information
#
# Table name: comite
#
#  id                 :integer         not null, primary key
#  numero             :string(15)      not null
#  fecha_apertura     :date
#  vigente            :boolean         not null
#  hora_apertura      :integer
#  minuto_apertura    :integer
#  meridiano_apertura :string(2)
#  lugar              :string(250)
#  direccion          :string(400)
#  instancia_tipo_id  :integer
#  punto_cuenta_id    :integer
#


