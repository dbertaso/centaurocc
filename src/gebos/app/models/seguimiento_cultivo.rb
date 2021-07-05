# encoding: utf-8
class SeguimientoCultivo < ActiveRecord::Base

  self.table_name = 'seguimiento_cultivo'
  
  attr_accessible :id,
    :seguimiento_visita_id,
    :fecha_siembra,
    :edad_cultivo,
    :superficie_sin_labores,
    :superficie_semillero,
    :superficie_preparada,
    :superficie_cosechada,
    :superficie_sembrada,
    :superficie_efectiva,
    :superficie_perdida,
    :rendimientos_estimados,
    :fecha_estimada_cosecha,
    :superficie_sembrada_f, 
    :fecha_siembra_f, 
    :fecha_estimada_cosecha_f, 
    :superficie_preparada_f, 
    :superficie_sin_labores_f, 
    :superficie_semillero_f, 
    :superficie_cosechada_f, 
    :rendimientos_estimados_f

  belongs_to :seguimiento_visita
  has_one :descripciones_especificas

  
  validates :superficie_semillero, :numericality =>{:numericality => true, :allow_blank=>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.superficie_semillero')} #{I18n.t('errors.messages.invalid')}" }
  
  validates :superficie_semillero, :numericality =>{:numericality => true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.superficie_semillero')} #{I18n.t('errors.messages.invalid')}" }
  
  validates :superficie_sin_labores, :numericality =>{:numericality => true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.superficie_sin_labores')} #{I18n.t('errors.messages.invalid')}" }
 
  validates :superficie_preparada, :numericality =>{:numericality => true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.superficie_preparada')} #{I18n.t('errors.messages.invalid')}" }
  
  validates :superficie_cosechada, :numericality =>{:numericality => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.superficie_cosechada')} #{I18n.t('errors.messages.invalid')}" }
  
  validates :superficie_sembrada, :numericality =>{:numericality => true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.superficie_cosechada')} #{I18n.t('errors.messages.invalid')}" }
  
  validates :superficie_efectiva, :numericality =>{:numericality => true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.superficie_efectiva')} #{I18n.t('errors.messages.invalid')}" }
  
  validates :superficie_perdida, :numericality =>{:numericality => true, :allow_blank=>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.superficie_perdida')} #{I18n.t('errors.messages.invalid')}" }

  validates :superficie_recomendada, :numericality =>{:numericality => true, :only_integer =>false, :allow_blank=>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.superficie_recomendada')} #{I18n.t('errors.messages.invalid')}" }
  
  validates :rendimientos_estimados, :numericality =>{:numericality => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.:rendimientos_estimados')} #{I18n.t('errors.messages.invalid')}" }
  
  validates :fecha_siembra,
    :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.fecha_siembra')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 0.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.fecha_siembra')} #{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.fecha_no_posterior_fecha_actual')}"}

  validates :fecha_siembra,
    :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.fecha_siembra')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => :fecha_registro, :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.fecha_siembra')} #{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.fecha_no_posterior_fecha_registro')}"}

  validates :fecha_estimada_cosecha ,
    :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.fecha_estimada_cosecha')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"}

  
  
  validate :block_valida
  
  def block_valida
    logger.info"XXXXXXXXXXXX============== BLOCK===============>>>>>"
    if (self.fecha_estimada_cosecha < self.fecha_siembra)
      errors.add(:seguimiento_cultivo, "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.fecha_estimada_cosecha')} #{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.fecha_estimada_no_anterior_siembra')}")
    end
  end


  def fecha_registro
    self.seguimiento_visita.fecha_registro
  end 

  def fecha_siembra_f=(fecha)
    self.fecha_siembra = fecha
  end

  def fecha_siembra_f
    format_fecha(self.fecha_siembra)
  end

  def fecha_estimada_cosecha_f=(fecha)
    self.fecha_estimada_cosecha = fecha
  end

  def fecha_estimada_cosecha_f
    format_fecha(self.fecha_estimada_cosecha)
  end

  def superficie_semillero_f=(valor)
    self.superficie_semillero = format_valor(valor)
  end

  def superficie_semillero_f
    format_f3(self.superficie_semillero)
  end

  def superficie_semillero_fm
    format_fm3(self.superficie_semillero)
  end




  def superficie_sin_labores_f=(valor)
    self.superficie_sin_labores = format_valor(valor)
  end

  def superficie_sin_labores_f
    format_f3(self.superficie_sin_labores)
  end

  def superficie_sin_labores_fm
    format_fm3(self.superficie_sin_labores)
  end



  def superficie_preparada_f=(valor)
    self.superficie_preparada = format_valor(valor)
  end

  def superficie_preparada_f
    format_f3(self.superficie_preparada)
  end

  def superficie_preparada_fm
    format_fm3(self.superficie_preparada)
  end



  def superficie_cosechada_f=(valor)
    self.superficie_cosechada = format_valor(valor)
  end

  def superficie_cosechada_f
    format_f3(self.superficie_cosechada)
  end

  def superficie_cosechada_fm
    format_fm3(self.superficie_cosechada)
  end



  def superficie_sembrada_f=(valor)
    self.superficie_sembrada = format_valor(valor)
  end

  def superficie_sembrada_f
    format_f3(self.superficie_sembrada)
  end

  def superficie_sembrada_fm
    format_fm3(self.superficie_sembrada)
  end


  def superficie_efectiva_f=(valor)
    self.superficie_efectiva = format_valor(valor)
  end

  def superficie_efectiva_f
    format_f3(self.superficie_efectiva)
  end


  def superficie_efectiva_fm
    format_fm3(self.superficie_efectiva)
  end



  def superficie_perdida_f=(valor)
    self.superficie_perdida = format_valor(valor)
  end

  def superficie_perdida_f
    format_f3(self.superficie_perdida)
  end

  def superficie_perdida_fm
    format_fm3(self.superficie_perdida)
  end


  def superficie_recomendada_f=(valor)
    self.superficie_recomendada = format_valor(valor)
  end

  def superficie_recomendada_f
    format_f3(self.superficie_recomendada)
  end

  def superficie_recomendada_fm
    format_fm3(self.superficie_recomendada)
  end


  def rendimientos_estimados_f=(valor)
    self.rendimientos_estimados = format_valor(valor)
  end

  def rendimientos_estimados_f
    format_f(self.rendimientos_estimados)
  end


  def rendimientos_estimados_fm
    format_fm(self.rendimientos_estimados)
  end


  def validar_superficie(seguimiento_cultivo,fecha_estimada, total_hectareas_recomendadas, params)

    success = true
    errores = 0

    total_hectareas_recomendadas = (total_hectareas_recomendadas.to_f + seguimiento_cultivo[:superficie_recomendada_f].to_f)

    fecha_estimada_cosecha = seguimiento_cultivo[:fecha_estimada_cosecha_f].split("/")
    unless (fecha_estimada_cosecha.empty? || fecha_estimada_cosecha.nil?)
      fecha_estimada_cosecha = (fecha_estimada_cosecha[2]+"-"+fecha_estimada_cosecha[1]+"-"+fecha_estimada_cosecha[0]).to_date
    end

    if fecha_estimada.class.name == "String"
      logger.debug "String"
      fecha_estimada = fecha_estimada.to_s.split("/")
      unless (fecha_estimada.empty? ||fecha_estimada.nil?)
        fecha_estimada = (fecha_estimada[2]+"-"+fecha_estimada[1]+"-"+fecha_estimada[0]).to_date
        fecha_estimada = fecha_estimada -1

      end

    end

    logger.debug "+++++++++++++"
    logger.debug params[:id].to_s
    seguimiento = SeguimientoVisita.find(params[:id])
    logger.debug "+++++++++++++"
    logger.debug seguimiento_cultivo
    logger.info"XXXXXXXXX-Sin-Labores-========>>>>>>"<<seguimiento_cultivo[:superficie_sin_labores_f].to_d.inspect
    unless seguimiento_cultivo[:superficie_sin_labores_f].to_d <= seguimiento.solicitud.hectareas_recomendadas.to_d
      errors.add(:seguimiento_cultivo, I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.superficie_sin_labores_no_puede_ser_mayor_superficie_recomendada'))
      errores += 1
    end
    ######
    logger.info "=====> semillero 1"<< "'" << seguimiento_cultivo[:superficie_semillero_f].inspect << "'"
    logger.info "=====> semillero 2"<< "'" << params[:seguimiento_cultivo][:superficie_semillero_f].inspect << "'"

    if seguimiento_cultivo[:superficie_semillero_f].empty?
      parametro_superficie_semillero_f = "0,00"
    else
      parametro_superficie_semillero_f = seguimiento_cultivo[:superficie_semillero_f]
    end
    logger.info "=====> semillero 3 "<< parametro_superficie_semillero_f.inspect
    #####
    unless parametro_superficie_semillero_f.to_d <= seguimiento.solicitud.hectareas_recomendadas.to_d
      errors.add(:seguimiento_cultivo, I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.superficie_semillero_no_mayor_superficie_recomendada'))
      errores += 1
    end
    unless seguimiento_cultivo[:superficie_preparada_f].nil?
      unless seguimiento_cultivo[:superficie_preparada_f].to_d <= seguimiento.solicitud.hectareas_recomendadas.to_d
        #logger.info"XXXXXXXXXXXXXXXXXXXXXX====================Valor-SP======================>>>"<<seguimiento_cultivo[:superficie_preparada_f].to_f
        #logger.info"XXXXXXXXXXXXXXXXXXXXXX====================Valor-HR======================>>>"<<seguimiento.solicitud.hectareas_recomendadas.to_f
        errors.add(:seguimiento_cultivo, I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.superdicie_preparada_no_mayor_superficie_recomendada'))
        errores += 1
      end
    end
    unless seguimiento_cultivo[:superficie_sembrada_f].nil?
      unless seguimiento_cultivo[:superficie_sembrada_f].to_d <= seguimiento.solicitud.hectareas_recomendadas.to_d
        errors.add(:seguimiento_cultivo, I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.superficie_sembrada_no_mayor_superficie_recomendada'))
        errores += 1
      end
    end

    unless seguimiento_cultivo[:superficie_perdida_f].nil?
      unless seguimiento_cultivo[:superficie_perdida_f].to_d <= seguimiento_cultivo[:superficie_sembrada_f].to_d
        errors.add(:seguimiento_cultivo, I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.superficie_perdida_no_mayor_superficie_sembrada'))
        errores += 1
      end
    end
    unless seguimiento_cultivo[:superficie_perdida_f].nil?
      unless seguimiento_cultivo[:superficie_perdida_f].to_d <= seguimiento_cultivo[:superficie_cosechada_f].to_d
        errors.add(:seguimiento_cultivo, I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.superficie_cosechada_no_mayor_superficie_efectiva'))
        errores += 1
      end
    end
    unless seguimiento_cultivo[:superficie_cosechada_f].nil?
      unless seguimiento_cultivo[:superficie_cosechada_f].to_d <= params[:superficie_efectiva].to_d
        errors.add(:seguimiento_cultivo, I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.superficie_cosechada_no_mayor_superficie_efectiva'))
        errores += 1
      end
    end
    unless seguimiento_cultivo[:superficie_cosechada_f].nil?
      unless seguimiento_cultivo[:superficie_cosechada_f].to_d <= seguimiento_cultivo[:superficie_sembrada_f].to_d
        errors.add(:seguimiento_cultivo, I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.superficie_cosechada_no_mayor_superficie_sembrada'))
        errores += 1
      end
    end


    if fecha_estimada_cosecha.class.name == "String" ||fecha_estimada_cosecha.class.name == "Array"
      if fecha_estimada_cosecha.empty?
        errors.add(:seguimiento_cultivo,"#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.fecha_estimada_cosecha')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}")
        errores += 1
      end
    elsif fecha_estimada_cosecha.class.name == "Date"
      if fecha_estimada_cosecha.nil?
        errors.add(:seguimiento_cultivo, "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.fecha_estimada_cosecha')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}")
        errores += 1
      end
    end

    if (errores > 0)
      success = false
    end
    return success
    
  end

  def validar_recomendar(params)
    success = true
    errores = 0
 
    #logger.info "=====> recomendada 1"<< "'" << params[:seguimiento_cultivo][:superficie_recomendada_f].to_s << "'"
    if params[:seguimiento_cultivo][:superficie_recomendada_f].empty?
      errors.add(:seguimiento_cultivo, "#{I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Columnas.superficie_recomendada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}")
      errores += 1
    else
      parametro_superficie_recomendada_f = params[:seguimiento_cultivo][:superficie_recomendada_f]
      logger.info "=====> recomendada 2 "<< parametro_superficie_recomendada_f.to_s
      siniestro = Siniestro.find_by_seguimiento_visita_id(self.seguimiento_visita.id)
      if siniestro.nil?
        hectareas_siniestradas = "0,00"
      else
        hectareas_siniestradas = siniestro.hectareas_siniestradas
      end
      logger.info "=====> Siniestrada " << hectareas_siniestradas.to_s
      unless parametro_superficie_recomendada_f.to_d <= (self.superficie_efectiva.to_d - hectareas_siniestradas.to_d)
        errors.add(:seguimiento_cultivo, I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.error_superficie_recomendar'))
        errores += 1
      else
        self.superficie_recomendada_f = parametro_superficie_recomendada_f
        self.save
      end
    end

    if (errores > 0)
      success = false

    end
    return success
  end



end


# == Schema Information
#
# Table name: seguimiento_cultivo
#
#  id                     :integer         not null, primary key
#  seguimiento_visita_id  :integer         not null
#  fecha_siembra          :date
#  edad_cultivo           :integer         default(0), not null
#  superficie_sin_labores :float           default(0.0), not null
#  superficie_semillero   :float           default(0.0), not null
#  superficie_preparada   :float           default(0.0), not null
#  superficie_cosechada   :float           default(0.0), not null
#  superficie_sembrada    :float           default(0.0), not null
#  superficie_efectiva    :float           default(0.0), not null
#  superficie_perdida     :float           default(0.0), not null
#  rendimientos_estimados :float           default(0.0), not null
#  fecha_estimada_cosecha :date
#  superficie_recomendada :float           default(0.0), not null
#

