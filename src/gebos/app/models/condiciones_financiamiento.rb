# encoding: utf-8
#
# autor: Diego Bertaso
# clase: CondicionesFinanciamiento
# descripción: Migración a Rails 3
# fecha: 2012-11-19
#

class CondicionesFinanciamiento < ActiveRecord::Base

    self.table_name = 'condiciones_financiamiento'

    attr_accessible :id,
                    :sector_id,
                    :sub_sector_id,
                    :rubro_id,
                    :plazo,
                    :plazo_desde,
                    :plazo_hasta,
                    :periodo_gracia,
                    :periodo_gracia_desde,
                    :periodo_gracia_hasta,
                    :pago_unico,
                    :frecuencia_pago,
                    :activo,
                    :diferir_intereses,
                    :formula_id,
                    :frecuencia_pago_w,
                    :sub_rubro_id,
                    :actividad_id,
                    :programa_id

    belongs_to :rubro
    belongs_to :sector
    belongs_to :sub_sector
    belongs_to :sub_rubro
    belongs_to :actividad
    belongs_to :formula
    belongs_to :programa

    validates :programa,
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.programa')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

    validates :sector,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.Form.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

    validates :sub_sector,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.Form.sub_sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

    validates :rubro,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.Form.rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

    validates :sub_rubro,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.Form.sub_rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

    validates :actividad,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.Form.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

    validates :plazo,
    :numericality => {:only_integer => true, :greater_than => 0, :message => I18n.t('Sistema.Body.Modelos.CondicionesFinanciamiento.Errores.plazo_debe_ser_entero_mayor_cero')}


    validate :validate
    before_create :before_create


  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort, :include =>[:sector, :sub_sector, :rubro, :sub_rubro, :actividad, :programa]
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort, :include =>[:sector, :sub_sector, :rubro, :sub_rubro, :actividad, :programa]

    end

  end

 def frecuencia_pago_w

  case self.frecuencia_pago

    when 0
      I18n.t('Sistema.Body.General.Periodos.pago_unico')
    when 1
      I18n.t('Sistema.Body.General.Periodos.mensual')
    when 2
      I18n.t('Sistema.Body.General.Periodos.bimestral')
    when 3
      I18n.t('Sistema.Body.General.Periodos.trimestral')
    when 5
      I18n.t('Sistema.Body.General.Periodos.pentamestral')
    when 6
      I18n.t('Sistema.Body.General.Periodos.semestral')
    when 12
      I18n.t('Sistema.Body.General.Periodos.anual')
  end

 end

 def before_create

    valid = true

    condicion = CondicionesFinanciamiento.find_by_programa_id_and_rubro_id_and_sub_rubro_id_and_actividad_id_and_sector_id_and_sub_sector_id(self.programa_id, self.rubro_id,self.sub_rubro_id,self.actividad_id, self.sector_id, self.sub_sector_id)

    if !condicion.nil?
      self.errors.add(:condiciones_financiamiento,I18n.t('Sistema.Body.Modelos.CondicionesFinanciamiento.Errores.condicion_ya_existe'))
      valid = false
    end

    return valid
 end

def plazo_total

  unless self.plazo.nil? && self.periodo_gracia.nil?
    self.plazo + self.periodo_gracia
  end
  
end 
  
  def validate
    valid = true
   
    producto = Producto.first(:conditions => ["programa_id = ? and sector_id = ? and sub_sector_id = ? ",self.programa_id, self.sector_id, self.sub_sector_id] )

    unless producto.nil?

      unless self.plazo == 0

        if self.plazo.to_i < producto.plazo_minimo.to_i

          self.errors.add(:condiciones_financiamiento, I18n.t('Sistema.Body.Modelos.CondicionesFinanciamiento.Errores.plazo_menor_que_minimo') )
          valid = false

        end

        if self.plazo.to_i > producto.plazo_maximo.to_i
          self.errors.add(:condiciones_financiamiento, I18n.t('Sistema.Body.Modelos.CondicionesFinanciamiento.Errores.plazo_mayor_que_maximo') )
          valid = false
        end
      end

      unless self.periodo_gracia.to_i == 0

        if self.periodo_gracia.to_i > producto.meses_gracia.to_i
          self.errors.add(:condiciones_financiamiento, I18n.t('Sistema.Body.Modelos.CondicionesFinanciamiento.Errores.plazo_gracia_mayor_que_maximo') )
          valid = false

        end
      end
    end

   if self.plazo == 0
     
      if self.plazo_desde > self.plazo_hasta
        
        self.errors.add(:condiciones_financiamiento, I18n.t('Sistema.Body.Modelos.CondicionesFinanciamiento.Errores.plazo_desde_mayor_plazo_hasta') )
        valid = false
        
      end
      
    end

   if self.periodo_gracia == 0

     
      if self.periodo_gracia_desde > self.plazo_hasta
        self.errors.add(:condiciones_financiamiento, I18n.t('Sistema.Body.Modelos.CondicionesFinanciamiento.Errores.periodo_gracia_mayor_plazo_hasta') )
        valid = false
      end
      
    end
      
    
    if self.plazo == 0 && self.periodo_gracia == 0
        self.errors.add(:condiciones_financiamiento, I18n.t('Sistema.Body.Modelos.CondicionesFinanciamiento.Errores.plazo_gracia_plazo_no_pueden_ser_cero'))
        valid = false
    end
    
    if self.periodo_gracia > 0 && self.frecuencia_pago != 0

      dif = self.periodo_gracia.to_i % self.frecuencia_pago.to_i
      if dif != 0
        self.errors.add(:condiciones_financiamiento, I18n.t('Sistema.Body.Modelos.CondicionesFinanciamiento.Errores.periodo_gracia_no_divisible'))
        valid = false
      end
    end

    if self.periodo_gracia_desde > 0 && self.frecuencia_pago != 0
    
      dif = self.periodo_gracia_desde.to_i % self.frecuencia_pago.to_i
      if dif != 0
        self.errors.add(:condiciones_financiamiento, 'El período de gracia desde no es divisible por la frecuencia de pago')
        valid = false
      end
    end

    if self.periodo_gracia_hasta > 0 && self.frecuencia_pago != 0
    
      dif = self.periodo_gracia_hasta.to_i % self.frecuencia_pago.to_i
      if dif != 0
        self.errors.add(:condiciones_financiamiento, 'El período de gracia hasta no es divisible por la frecuencia de pago')
        valid = false
      end
    end

    if self.plazo > 0 && self.frecuencia_pago != 0

      dif = self.plazo.to_i % self.frecuencia_pago.to_i
      if dif != 0
        self.errors.add(:condiciones_financiamiento, I18n.t('Sistema.Body.Modelos.CondicionesFinanciamiento.Errores.plazo_no_divisible'))
        valid = false
      end
    end

    if self.plazo_desde > 0 && self.frecuencia_pago != 0
    
      dif = self.plazo_desde.to_i % self.frecuencia_pago.to_i
      if dif != 0
        self.errors.add(:condiciones_financiamiento, 'El plazo desde no es divisible por la frecuencia de pago')
        valid = false
      end
    end

    if self.plazo_hasta > 0 && self.frecuencia_pago != 0
    
      dif = self.plazo_hasta.to_i % self.frecuencia_pago.to_i
      if dif != 0
        self.errors.add(:condiciones_financiamiento, 'El plazo hasta no es divisible por la frecuencia de pago')
        valid = false
      end
    end

    return valid

  end


end





# == Schema Information
#
# Table name: condiciones_financiamiento
#
#  id                   :integer         not null, primary key
#  sector_id            :integer         not null
#  sub_sector_id        :integer         not null
#  rubro_id             :integer         not null
#  plazo                :integer         default(0)
#  plazo_desde          :integer         default(0)
#  plazo_hasta          :integer         default(0)
#  periodo_gracia       :integer         default(0)
#  periodo_gracia_desde :integer         default(0)
#  periodo_gracia_hasta :integer         default(0)
#  pago_unico           :boolean         default(FALSE)
#  frecuencia_pago      :integer         default(1)
#  activo               :boolean         default(TRUE)
#  diferir_intereses    :boolean         default(FALSE), not null
#  formula_id           :integer         default(1), not null
#  sub_rubro_id         :integer
#  actividad_id         :integer
#  programa_id          :integer
#

