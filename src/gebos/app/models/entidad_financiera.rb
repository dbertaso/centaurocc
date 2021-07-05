# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::EntidadFinanciera
# descripción: Migración a Rails 3
#
class EntidadFinanciera < ActiveRecord::Base

  self.table_name = 'entidad_financiera'
  
  attr_accessible :id,
				  :nombre,
				  :alias,
				  :privado,
				  :activo,
				  :cuenta_contable_id,
				  :codigo_d3,
				  :codigo_banco_sigesp,
				  :activo_banmujer,
				  :consolidado,
				  :nombre_contacto,
				  :gerencia_contacto,
				  :telefono_contacto,
				  :rif_usec,
				  :codban_usec,
				  :sinc_usec,
				  :recaudador,
				  :cod_swift,
				  :auxiliar_contable,
				  :alias_f,
				  :nombre_f,
          :convenio_domiciliacion
  
  
  has_many :cuenta_bancaria

  has_many :cuenta_bcv

  validates :nombre,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " <<I18n.t('Sistema.Body.Modelos.Errores.es_requerido')},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"},
    :uniqueness=>{:message =>I18n.t('Sistema.Body.Vistas.General.nombre') << " " <<I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}    

  validates :alias,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.alias') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre_corto')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"},
    :uniqueness=>{:message =>I18n.t('Sistema.Body.Vistas.General.alias') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}

  validates :cod_swift,
      :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero')}/, :allow_blank => true,
      :message => I18n.t('Sistema.Body.Modelos.Errores.formato_cod_swift_invalido')}
  
  validates :nombre_contacto,
      :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank => true,
      :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.contacto')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}

  validates :gerencia_contacto,
      :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank => true,
      :message => "#{I18n.t('Sistema.Body.Vistas.General.gerencia')} #{I18n.t('Sistema.Body.Vistas.General.contacto')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}

  validates :telefono_contacto,
      :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_telefono_multi')}/, :allow_blank => true,
      :message => "#{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('Sistema.Body.Vistas.General.contacto')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}

  validates :auxiliar_contable,
    :uniqueness=> {:allow_blank => true, :message =>I18n.t('Sistema.Body.Vistas.ReglaContable.Etiquetas.auxiliar_contable') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}    


  def alias_f=(alias_o)
    self.alias = alias_o.upcase
  end

  def alias_f
    self.alias.upcase unless self.alias.nil?
  end

  def nombre_f=(nombre)
    self.nombre = nombre.upcase
  end

  def nombre_f
    self.nombre.upcase unless self.nombre.nil?
  end

  def self.sincronizar_ultrasec
    logger.debug "EntidadFinanciera.sincronizar_ultrasec"
        sincronizados = 0
        nuevos = 0
        modificados = 0
        errores = 0
        usec_bancos    = UltrasecBanco.find(:all)
        usec_bancos.each do |usec_banco|
          begin
            transaction do
              logger.debug "Sincronizando banco " << usec_banco.tx_banco
              gebos_ef = EntidadFinanciera.find_by_codban_usec(usec_banco.co_banco)
              #Entidad financiera no sicronizada /o/ no existe
              if gebos_ef.nil?

                e = EntidadFinanciera.new(
                  {
                    :nombre => "#{usec_banco.tx_banco} (#{usec_banco.co_banco})",
                    :alias => "#{usec_banco.co_banco}",
                    :activo => true,
                    :consolidado => false,
                    :nombre_contacto => usec_banco.nm_contacto,
                    :telefono_contacto => usec_banco.tl_banco1,
                    :rif_usec => usec_banco.nu_rif,
                    :codban_usec => usec_banco.co_banco,
                    :sinc_usec => true,
                  }
                )
                e.save!
                e.reload
                e.add_cuenta_bcv(
                  CuentaBcv.new(
                    {
                      :entidad_financiera_id => e.id,
                      :numero => usec_banco.nu_cta_bcv,
                      :tipo => 'C',
                      :activo => true
                    }
                  )
                ) unless usec_banco.nu_cta_bcv.nil? ||  usec_banco.nu_cta_bcv.size < 20
                e.save!
                nuevos += 1
                logger.debug "Banco nuevo: " << e.inspect
              else
                modificado = false
                params_ef = {}
                logger.debug "NOMBRE GEBOS " << gebos_ef.nombre
                logger.debug "NOMBRE USEC " << "#{usec_banco.tx_banco} (#{usec_banco.co_banco})"
                if gebos_ef.nombre != "#{usec_banco.tx_banco} (#{usec_banco.co_banco})"
                  logger.debug "Nombre modificado"
                  params_ef[:nombre] = usec_banco.tx_banco
                  modificado = true
                end

                if gebos_ef.nombre_contacto != usec_banco.nm_contacto
                  logger.debug "Nombre contacto modificado"
                  params_ef[:nombre_contacto] = usec_banco.nm_contacto
                  modificado = true
                end

                if gebos_ef.telefono_contacto != usec_banco.tl_banco1
                  logger.debug "Telefono contacto modificado"
                  params_ef[:telefono_contacto] = usec_banco.tl_banco1
                  modificado = true
                end

                if gebos_ef.rif_usec != usec_banco.nu_rif
                  logger.debug "Rif modificado"
                  params_ef[:rif_usec] = usec_banco.nu_rif
                  modificado = true
                end

                if modificado
                  gebos_ef.update_attributes(params_ef)
                end

                #Sincronización de cuentas bancarias
                unless usec_banco.nu_cta_bcv.nil? || usec_banco.nu_cta_bcv.size < 20
                  #usec_banco registra una cuenta válida para gebos
                  cuenta_bcv = gebos_ef.cuentas_bcv.find_by_numero(usec_banco.nu_cta_bcv)
                  if cuenta_bcv.nil?
                    logger.debug "Cuenta modificada"
                    #cuenta bancaria no registrada. Registrar
                    gebos_ef.add_cuenta_bcv(
                      CuentaBcv.new(
                        {
                          :entidad_financiera_id => gebos_ef.id,
                          :numero => usec_banco.nu_cta_bcv,
                          :tipo => 'I',
                          :activo => true
                        }
                      )
                    )
                    modificado = true
                  end
                end

                if modificado
                  gebos_ef.save!
                  logger.debug "Banco modificado: " << gebos_ef.inspect
                  modificados += 1
                end
              end
          end
          rescue Exception => e
            logger.error e.message
            logger.error e.backtrace.join("\n")
            errores += 1
          end
          sincronizados += 1
      end
      logger.debug "TOTAL: #{sincronizados} NUEVOS: #{nuevos} MODIFICADOS: #{modificados} ERRORES: #{errores}"

  end

  def add_cuenta_bcv(cuenta)
    logger.debug "CUENTA " << cuenta.inspect
    if self.cuenta_bcv.find(cuenta.id)
      errors.add(:entidad_financiera, I18n.t('Sistema.Body.Vistas.General.la') << " " << I18n.t('Sistema.Body.Vistas.General.cuenta') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe'))
      return false
    end
    rescue
      cuentas_bcv << cuenta
  end

  validate :validate
  
  def validate
  end


  def self.search(search, page, orden)    

    conditions=search  
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden
  end


end



# == Schema Information
#
# Table name: entidad_financiera
#
#  id                  :integer         not null, primary key
#  nombre              :string(80)      not null
#  alias               :string(20)
#  privado             :boolean
#  activo              :boolean         default(TRUE)
#  cuenta_contable_id  :integer
#  codigo_d3           :string(10)
#  codigo_banco_sigesp :integer(10)     default(0)
#  activo_banmujer     :boolean         default(TRUE)
#  consolidado         :boolean
#  nombre_contacto     :string(100)
#  gerencia_contacto   :string(60)
#  telefono_contacto   :string(40)
#  rif_usec            :string(14)
#  codban_usec         :string(2)
#  sinc_usec           :boolean
#  recaudador          :boolean         default(FALSE)
#  cod_swift           :string(12)
#  auxiliar_contable   :string(7)
#

