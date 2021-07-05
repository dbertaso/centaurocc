# encoding: utf-8
class ProduccionLecheCarne < ActiveRecord::Base

  self.table_name = 'produccion_leche_carne'
  
  attr_accessible :id,
    :seguimiento_visita_id,
    :prod_diaria_leche_plantas_estado,
    :prod_diaria_leche_vendida_terceros,
    :prod_diaria_leche_finca,
    :total_litros_dia_leche,
    :l_vaca_total_dia,
    :calidad_ordenio,
    :observaciones_ordenio,
    :carne_plantas_estado,
    :carne_anual_terceros,
    :carne_anual_finca,
    :carne_peso_diario_promedio_ganancia,
    :carne_peso_promedio_matadero,
    :carne_total_arrime_anual,
    :observaciones_prod_carne,
    :total_l_dia
  
  
  belongs_to :seguimiento_visita


  validates :seguimiento_visita_id, :presence => {
    :message => I18n.t('Sistema.Body.Modelos.DescripcionesEspecificas.Errores.presence_seguimiento_visita')}
  
  validates :prod_diaria_leche_plantas_estado, :numericality =>{:numericality => true, 
    :only_integer => false, :allow_blank=>true, :message => "#{I18n.t('Sistema.Body.Modelos.ProduccionLecheCarne.Columnas.prod_diaria_leche_plantas_estado')} #{I18n.t('errors.messages.invalid')}"}  
  
  validates :prod_diaria_leche_vendida_terceros, :numericality =>{:numericality => true, 
    :only_integer => false, :allow_blank=>true, :message => "#{I18n.t('Sistema.Body.Modelos.ProduccionLecheCarne.Columnas.prod_diaria_leche_vendida_terceros')} #{I18n.t('errors.messages.invalid')}"}  

  validates :prod_diaria_leche_finca, :numericality =>{:numericality => true,  :only_integer => false, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ProduccionLecheCarne.Columnas.prod_diaria_leche_finca')} #{I18n.t('errors.messages.invalid')}"}  

  validates :total_litros_dia_leche, :numericality =>{:numericality => true,  :only_integer => false, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ProduccionLecheCarne.Columnas.total_litros_dia_leche')} #{I18n.t('errors.messages.invalid')}"}  
      
  validates :l_vaca_total_dia, :numericality =>{:numericality => true,  :only_integer => false, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ProduccionLecheCarne.Columnas.l_vaca_total_dia')} #{I18n.t('errors.messages.invalid')}"}  

  validates :carne_plantas_estado, :numericality =>{:numericality => true,  :only_integer => false, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ProduccionLecheCarne.Columnas.carne_plantas_estado')} #{I18n.t('errors.messages.invalid')}"}  
     
  validates :carne_anual_terceros, :numericality =>{:numericality => true,  :only_integer => false, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ProduccionLecheCarne.Columnas.carne_anual_terceros')} #{I18n.t('errors.messages.invalid')}"}  

  validates :carne_anual_finca, :numericality =>{:numericality => true,  :only_integer => false, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ProduccionLecheCarne.Columnas.carne_anual_finca')} #{I18n.t('errors.messages.invalid')}"}  
     
  validates :carne_peso_diario_promedio_ganancia, :numericality =>{:numericality => true,  :only_integer => false, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ProduccionLecheCarne.Columnas.carne_peso_diario_promedio_ganancia')} #{I18n.t('errors.messages.invalid')}"}  
 
  validates :carne_peso_promedio_matadero, :numericality =>{:numericality => true,  :only_integer => false, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ProduccionLecheCarne.Columnas.carne_peso_promedio_matadero')} #{I18n.t('errors.messages.invalid')}"}  
      
  validates :carne_total_arrime_anual, :numericality =>{:numericality => true,  :only_integer => false, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ProduccionLecheCarne.Columnas.carne_total_arrime_anual')} #{I18n.t('errors.messages.invalid')}"}  

      


  def prod_diaria_leche_plantas_estado_fm
    format_fm(self.prod_diaria_leche_plantas_estado)
  end

  def prod_diaria_leche_vendida_terceros_fm
    format_fm(self.prod_diaria_leche_vendida_terceros)
  end

  def prod_diaria_leche_finca_fm
    format_fm(self.prod_diaria_leche_finca)
  end

  def total_litros_dia_leche_fm
    format_fm(self.total_litros_dia_leche)
  end

  def l_vaca_total_dia_fm
    format_fm(self.l_vaca_total_dia)
  end

  def carne_plantas_estado_fm
    format_fm(self.carne_plantas_estado)
  end

  def carne_anual_terceros_fm
    format_fm(self.carne_anual_terceros)
  end

  def carne_anual_finca_fm
    format_fm(self.carne_anual_finca)
  end

  def carne_peso_diario_promedio_ganancia_fm
    format_fm(self.carne_peso_diario_promedio_ganancia)
  end

  def carne_peso_promedio_matadero_fm
    format_fm(self.carne_peso_promedio_matadero)
  end

  def carne_total_arrime_anual_fm
    format_fm(self.carne_total_arrime_anual)
  end

  def total_l_dia_fm
    format_fm(self.total_l_dia)
  end


end

# == Schema Information
#
# Table name: produccion_leche_carne
#
#  id                                  :integer         not null, primary key
#  seguimiento_visita_id               :integer         not null
#  prod_diaria_leche_plantas_estado    :float           default(0.0), not null
#  prod_diaria_leche_vendida_terceros  :float           default(0.0), not null
#  prod_diaria_leche_finca             :float           default(0.0), not null
#  total_litros_dia_leche              :float           default(0.0), not null
#  l_vaca_total_dia                    :float           default(0.0), not null
#  calidad_ordenio                     :string(1)
#  observaciones_ordenio               :text
#  carne_plantas_estado                :float           default(0.0), not null
#  carne_anual_terceros                :float           default(0.0), not null
#  carne_anual_finca                   :float           default(0.0), not null
#  carne_peso_diario_promedio_ganancia :float           default(0.0), not null
#  carne_peso_promedio_matadero        :float           default(0.0), not null
#  carne_total_arrime_anual            :float           default(0.0), not null
#  observaciones_prod_carne            :text
#  total_l_dia                         :float           default(0.0), not null
#

