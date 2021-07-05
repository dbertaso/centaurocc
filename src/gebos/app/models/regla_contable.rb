# encoding: UTF-8

#
# autor: Diego Bertaso
# clase: ReglaContable
# descripción: Migración a Rails 3
#

class ReglaContable < ActiveRecord::Base

  self.table_name = 'regla_contable'
  
  attr_accessible :id,
                  :transaccion_contable_id,
                  :fuente_recursos_id,
                  :sector_economico_id,
                  :estatus,
                  :secuencia,
                  :tipo_movimiento,
                  :codigo_contable,
                  :auxiliar_contable,
                  :fin_codigo,
                  :tipo_monto,
                  :modalidad_pago,
                  :entidad_financiera_id,
                  :reestructurado,
                  :plazos,
                  :programa_id
                  
  belongs_to :programa
  belongs_to :transaccion_contable
  belongs_to :origen_fondo
  

  validates :fuente_recursos_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ReglaContable.Etiquetas.institucion_origen')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :programa, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ReglaContable.Etiquetas.programa')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :tipo_monto, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ReglaContable.Etiquetas.monto_contabilizar')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :estatus, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ReglaContable.Etiquetas.estatus_financiamiento')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :plazos, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ReglaContable.Etiquetas.plazo_ciclo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :secuencia, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ReglaContable.Etiquetas.secuencia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    #:uniqueness => {scope => [:transaccion_contable_id, :fuente_recursos_id, :programa_id, :estatus, :modalidad_pago, :reestructurado, :plazos], 
                            #:message => I18n.t('Sistema.Body.Modelos.ReglaContable.Errores.secuencia_usada')}

  validates :codigo_contable, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ReglaContable.Etiquetas.codigo_contable')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}


  validates_uniqueness_of :transaccion_contable_id, :scope=>[ :fuente_recursos_id, :programa_id, :estatus, :secuencia, :tipo_movimiento, :modalidad_pago, :codigo_contable, :plazos],
    :message => I18n.t("#{I18n.t('Sistema.Body.Controladores.Contabilidad.ReglaContable.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}")


  def self.search(search, page, sort, joins)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :joins => joins, :order => sort,
      :select=>'regla_contable.*, 
                programa.nombre as programa_nombre, 
                moneda.nombre as moneda_nombre, 
                tc.nombre as nombre_transaccion'
  end
  
  after_initialize :after_initialize
  validate :validate
  
  def after_initialize
  
    #self.modalidad_pago = 'X' unless self.modalidad_pago.nil?
    
    if self.modalidad_pago.nil? || self.modalidad_pago.empty?
      self.modalidad_pago = 'X'
    end
    
  end
  
  def nombre_fuente

     case self.fuente_recursos_id

       when 1
         I18n.t('Sistema.Body.Institucion.fondas')
       when 2
         I18n.t('Sistema.Body.Institucion.agro')
       when 3
         I18n.t('Sistema.Body.Institucion.fondafa')
     end

  end

  
  def nombre_transaccion
  
    self.transaccion_contable.nombre
  end
  
  def nombre_plazo
  
    unless plazos.nil?
      if self.plazos == 'C'
        I18n.t('Sistema.Body.TipoPlazo.corto')
      else
        I18n.t('Sistema.Body.TipoPlazo.largo')
      end
    end
    
  end
  
  def nombre_reestructurado

     case self.reestructurado

       when 'N'
         I18n.t('Sistema.Body.TipoFinanciamiento.normal')
       when 'R'
         I18n.t('Sistema.Body.TipoFinanciamiento.reestructurado')
     end

  end

  def nombre_programa

    self.programa.nombre

  end

  def nombre_monto

    case self.tipo_monto

    when "MP"
       I18n.t('Sistema.Body.Montos.monto_transaccion')

    when "MC"
      I18n.t('Sistema.Body.Montos.capital')

    when "IO"
      I18n.t('Sistema.Body.Montos.interes_ordinario')

    when "ID"
      I18n.t('Sistema.Body.Montos.interes_diferido')

    when "IM"
      I18n.t('Sistema.Body.Montos.interes_mora')

    when "MD"

       I18n.t('Sistema.Body.Montos.monto_desembolso')

    when "MG"

      I18n.t('Sistema.Body.Montos.monto_gasto')
      
    when "MS"

      I18n.t('Sistema.Body.Montos.monto_sras')

    when "ME"

      I18n.t('Sistema.Body.Montos.monto_excedente')
      
    when "MB"

      I18n.t('Sistema.Body.Montos.monto_boleta')
    end

  end

  def modalidad_pago_w

    unless self.modalidad_pago.nil?
      case self.modalidad_pago

        when 'A'

          I18n.t('Sistema.Body.ModalidadPago.arrime')

        when 'D'
          I18n.t('Sistema.Body.ModalidadPago.domicializacion')

        when 'O'
          I18n.t('Sistema.Body.ModalidadPago.orden_despacho')

        when 'R'

          I18n.t('Sistema.Body.ModalidadPago.deposito')

        when 'X'
          I18n.t('Sistema.Body.General.no_aplica')

        when 'Z'
          I18n.t('Sistema.Body.ModalidadPago.devengo')

      end
      
    end

  end

  def nombre_estatus

    case self.estatus

      when "V"
        I18n.t('Sistema.Body.EstatusPrestamo.vigente')

      when "E"
        I18n.t('Sistema.Body.EstatusPrestamo.vencido')

      when "C"
        I18n.t('Sistema.Body.EstatusPrestamo.cancelado')

      when "K"

        I18n.t('Sistema.Body.EstatusPrestamo.castigado')

      when  "L"
        I18n.t('Sistema.Body.EstatusPrestamo.litigio')

      when  "P"
        I18n.t('Sistema.Body.EstatusPrestamo.cambio_estatus')
         
      when  "X"
        I18n.t('Sistema.Body.General.no_aplica')

     end

  end

  def validate

    @cuenta_contable = CuentaContable.find_by_codigo(self.codigo_contable)

    if self.tipo_movimiento.nil? || self.tipo_movimiento == '0'

      errors.add(:regla_contable, I18n.t('Sistema.Body.Modelos.ReglaContable.Errores.tipo_movimiento_invalido'))
    end

    if @cuenta_contable.nil?

      errors.add(:regla_contable, "#{I18n.t('Sistema.Body.Modelos.ReglaContable.Errores.codigo_contable_no_registrado')} - #{self.codigo_contable}")
    end

    errors.empty?

  end

end

# == Schema Information
#
# Table name: regla_contable
#
#  id                      :integer         not null, primary key
#  fuente_recursos_id      :integer         not null
#  estatus                 :string(1)       not null
#  secuencia               :integer         not null
#  tipo_movimiento         :string(1)       default("D")
#  codigo_contable         :string(25)      not null
#  auxiliar_contable       :string(7)
#  tipo_monto              :string(2)
#  modalidad_pago          :string(1)
#  entidad_financiera_id   :integer         default(0)
#  reestructurado          :string(1)       default("N")
#  programa_id             :integer
#  transaccion_contable_id :integer
#  plazos                  :string(1)
#

