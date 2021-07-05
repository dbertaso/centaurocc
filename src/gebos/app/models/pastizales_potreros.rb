# encoding: utf-8
class PastizalesPotreros < ActiveRecord::Base

  self.table_name = 'pastizales_potreros'
  
  attr_accessible :id,
    :seguimiento_visita_id,
    :nro_lote,
    :tipo_pasto_forraje_id,
    :superficie,
    :especie_variedad_pasto_id,
    :sistema_riego,
    :fecha_siembra,
    :fecha_corte,
    :condicion_pasto,
    :cantidad_potreros,
    :nro_potrero_cerca_electrica,
    :nro_potrero_cerca_tradicional,
    :fertilizacion,
    :tipo_fertilizacion_id,
    :descripcion_fertilizacion,
    :descripcion_observado,
    :fecha_siembra_f,
    :fecha_corte_f,
    :superficie_f,
    :superficie_fm,
    :nro_potrero_cerca_tradicional_sist_riego,
    :nro_potrero_cerca_electrica_sist_riego
    
  
  belongs_to :seguimiento_visita
  belongs_to :tipo_pasto_forraje
  belongs_to :especie_variedad_pasto


  validates :seguimiento_visita_id, :presence => {
    :message => I18n.t('Sistema.Body.Modelos.DescripcionesEspecificas.Errores.presence_seguimiento_visita')}

  validates :tipo_pasto_forraje_id, :presence => {
      :message => "#{I18n.t('Sistema.Body.Controladores.TipoPastoForraje.FormTitles.form_title_records')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :especie_variedad_pasto_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.especie_variedad_pasto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :condicion_pasto, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.condiciones_pasto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :superficie, :numericality =>{:numericality => true, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.superficie')} #{I18n.t('errors.messages.invalid')}"}

  validates :cantidad_potreros, :numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.cantidad_potreros')} #{I18n.t('errors.messages.invalid')}"}
  
  validates :nro_potrero_cerca_electrica, :numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.nro_potrero_cerca_electrica')} #{I18n.t('errors.messages.invalid')}"}
  
  validates :nro_potrero_cerca_tradicional, :numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.nro_potrero_cerca_tradicional')} #{I18n.t('errors.messages.invalid')}"}

  validates :fecha_siembra,
    :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.fecha_siembra')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 0.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.fecha_siembra')} #{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.fecha_no_posterior_fecha_actual')}"}

  validates :fecha_corte, :allow_blank =>true,
    :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.fecha_corte')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :after_or_equal_to => Proc.new { Time.now }, :message => "#{I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.fecha_corte')} #{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.fecha_no_anterior_fecha_actual')}"}



  def fecha_siembra_f=(fecha)
    self.fecha_siembra = fecha
  end

  def fecha_siembra_f
    format_fecha(self.fecha_siembra)
  end

  def fecha_corte_f=(fecha)
    self.fecha_corte = fecha
  end

  def fecha_corte_f
    format_fecha(self.fecha_corte)
  end

  def sistema_riego_w
    resultado = ""
    resultado = I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.sistema_riego_si') if self.sistema_riego == true
    resultado = I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.sistema_riego_no') if self.sistema_riego == false
    return resultado

  end

  def condicion_pasto_w
    resultado = " "
    resultado = I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.condicion_pasto_excelente') if self.condicion_pasto == "E"
    resultado = I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.condicion_pasto_bueno') if self.condicion_pasto == "B"
    resultado = I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.condicion_pasto_regular') if self.condicion_pasto == "R"
    resultado = I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.condicion_pasto_malo') if self.condicion_pasto == "M"
    return resultado
  end

  def fertilizacion_w
    resultado = ""
    resultado = I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.sistema_riego_si') if self.fertilizacion == true
    resultado = I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.sistema_riego_no') if self.fertilizacion == false
    return resultado

  end

  def tipo_fertilizacion_w
    resultado = " "
    resultado = I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.tipo_fertilizacion_organica') if self.tipo_fertilizacion_id == 1
    resultado = I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.tipo_fertilizacion_quimica') if self.tipo_fertilizacion_id == 2
    resultado = I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.tipo_fertilizacion_mixta') if self.tipo_fertilizacion_id == 3
    return resultado
  end



  def superficie_f=(valor)
    self.superficie = format_valor(valor)
  end

  def superficie_f
    format_f3(self.superficie)
  end

  def superficie_fm
    format_fm3(self.superficie)
  end

  def validar_sist_riego(params, visita,nro_lote)
    success =true
    visitas = SeguimientoVisita.find(visita)
    total_hectareas = PastizalesPotreros.sum(:superficie, :conditions=>"seguimiento_visita_id=#{visita} and nro_lote <> #{nro_lote}" )
    if total_hectareas.nil?
      total_hectareas = 0
    end
    unless params[:pastizales_potreros][:nro_potrero_cerca_electrica_sist_riego].to_i <= params[:pastizales_potreros][:nro_potrero_cerca_electrica].to_i
      errors.add(:pastizales_potreros, I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.nro_potreros_cerca_electrica'))
      success = false
    end
    unless params[:pastizales_potreros][:nro_potrero_cerca_tradicional_sist_riego].to_i <= params[:pastizales_potreros][:nro_potrero_cerca_tradicional].to_i
      errors.add(:pastizales_potreros, I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.nro_potreros_cerca_tradicional'))
      success = false
    end
    unless (params[:pastizales_potreros][:superficie_f].to_f + total_hectareas.to_f) <= visitas.solicitud.unidad_produccion.total_hectareas.to_f
      errors.add(:pastizales_potreros, I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.sumatoria_superficie_potreros'))
      success = false
    end


    return success
  end

  def validar_fertilizacion(fertilizacion,tipo,descripcion)
    logger.debug "tipo"
    logger.debug  tipo.class
    logger.debug descripcion.class

    success = true
    unless fertilizacion == 'false'
      if (tipo == 0 )
        errors.add(:pastizales_potreros,"#{I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.tipo_fertilizacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        success = false
      end
      if (descripcion.empty? || descripcion.nil?)
        errors.add(:pastizales_potreros,"#{I18n.t('Sistema.Body.Modelos.PastizalesPotreros.Columnas.descripcion_fertilizacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        success = false
      end
    else
      self.tipo_fertilizacion_id = 0
      success = true

    end
    return success
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'*'
  end

end




# == Schema Information
#
# Table name: pastizales_potreros
#
#  id                                       :integer         not null, primary key
#  seguimiento_visita_id                    :integer         not null
#  nro_lote                                 :integer         not null
#  tipo_pasto_forraje_id                    :integer         not null
#  superficie                               :float           default(0.0), not null
#  especie_variedad_pasto_id                :integer         not null
#  sistema_riego                            :boolean         default(TRUE), not null
#  fecha_siembra                            :date
#  fecha_corte                              :date
#  condicion_pasto                          :string(1)       default("E"), not null
#  cantidad_potreros                        :integer         default(0), not null
#  nro_potrero_cerca_electrica              :integer         default(0), not null
#  nro_potrero_cerca_tradicional            :integer         default(0), not null
#  fertilizacion                            :boolean         default(TRUE), not null
#  tipo_fertilizacion_id                    :integer
#  descripcion_fertilizacion                :text
#  descripcion_observado                    :text
#  nro_potrero_cerca_electrica_sist_riego   :integer         default(0), not null
#  nro_potrero_cerca_tradicional_sist_riego :integer         default(0), not null
#

