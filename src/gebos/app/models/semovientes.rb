# encoding: utf-8
class Semovientes < ActiveRecord::Base

  attr_accessible :id, 
    :seguimiento_visita_id,
    :cantidad_becerra,
    :condicion_corporal_becerra,
    :peso_promedio_becerra,
    :cantidad_becerro,
    :condicion_corporal_becerro,
    :peso_promedio_becerro,
    :cantidad_mauta,
    :condicion_corporal_mauta,
    :peso_promedio_mauta,
    :cantidad_maute,
    :condicion_corporal_maute,
    :peso_promedio_maute,
    :cantidad_novilla,
    :condicion_corporal_novilla,
    :peso_promedio_novilla,
    :cantidad_novillo,
    :condicion_corporal_novillo,
    :peso_promedio_novillo,
    :cantidad_retajo,
    :condicion_corporal_retajo,
    :peso_promedio_retajo,
    :cantidad_toro,
    :condicion_corporal_toro,
    :peso_promedio_toro,
    :cantidad_vaca_seca,
    :condicion_corporal_vaca_seca,
    :peso_promedio_vaca_seca,
    :cantidad_vaca_ordenio,
    :condicion_corporal_vaca_ordenio,
    :peso_promedio_vaca_ordenio,
    :cantidad_porcinos,
    :cantidad_conejos,
    :cantidad_caballos,
    :cantidad_aves,
    :cantidad_burro,
    :cantidad_mula,
    :cantidad_ovino,
    :cantidad_caprino,
    :cantidad_caninos,
    :cantidad_felinos,
    :otra_especie,
    :cantidad_otra_especie,
    :porcentaje_preniez,
    :dias_intervalo_partos,
    :cant_animales_adquiridos,
    :cant_hembras,
    :cant_machos,
    :fecha_adquisicion_semovientes,
    :cant_animales_marcados_hierro_fondas,
    :anamnesis_diagnostico,
    :cantidad_becerra, 
    :peso_promedio_becerra_f, 
    :peso_promedio_becerro_f, 
    :peso_promedio_maute_f, 
    :peso_promedio_mauta_f, 
    :peso_promedio_novillo_f, 
    :peso_promedio_novilla_f, 
    :peso_promedio_retajo_f, 
    :peso_promedio_toro_f, 
    :peso_promedio_vaca_seca_f, 
    :peso_promedio_vaca_ordenio_f, 
    :porcentaje_preniez_f, 
    :fecha_adquisicion_semovientes_f
  

  belongs_to :seguimiento_visita

  
  validates :seguimiento_visita_id, :presence => {
    :message => I18n.t('Sistema.Body.Modelos.DescripcionesEspecificas.Errores.presence_seguimiento_visita')}

  validates :anamnesis_diagnostico, :presence =>{
    :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.anamnesis_diagnostico')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}  
  
  validates :cantidad_becerra, :numericality =>{:numericality => true, :allow_blank => true,
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.becerra')} #{I18n.t('errors.messages.invalid')}"}  
  
  validates :cantidad_becerro,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.becerro')} #{I18n.t('errors.messages.invalid')}"}    
 
  validates :cantidad_maute,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.maute')} #{I18n.t('errors.messages.invalid')}"}    
 
  validates :cantidad_mauta,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.mauta')} #{I18n.t('errors.messages.invalid')}"}    
 
  validates :cantidad_novilla,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.novilla')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_novillo,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.novillo')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_retajo,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.retajo')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_toro,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.toro')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_vaca_seca,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.vaca_seca')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_vaca_ordenio,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.vaca_ordenio')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_porcinos,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.porcinos')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_conejos,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.conejos')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_caballos,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.caballos')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_aves,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.aves')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_burro,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.burro')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_mula,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.mula')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_ovino,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.ovino')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_caprino,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.caprino')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_caninos,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.caninos')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_felinos,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.felinos')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cantidad_otra_especie,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.otra_especie')} #{I18n.t('errors.messages.invalid')}"}    

  validates :peso_promedio_becerra,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.becerra')} #{I18n.t('errors.messages.invalid')}"}    

  validates :peso_promedio_becerro,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.becerro')} #{I18n.t('errors.messages.invalid')}"}    

  validates :peso_promedio_maute,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.maute')} #{I18n.t('errors.messages.invalid')}"}    

  validates :peso_promedio_mauta,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.mauta')} #{I18n.t('errors.messages.invalid')}"}    

  validates :peso_promedio_novilla,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.novilla')} #{I18n.t('errors.messages.invalid')}"}    

  validates :peso_promedio_novillo,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.novillo')} #{I18n.t('errors.messages.invalid')}"}    
  
  validates :peso_promedio_retajo,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.retajo')} #{I18n.t('errors.messages.invalid')}"}    
 
  validates :peso_promedio_toro,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.toro')} #{I18n.t('errors.messages.invalid')}"}    
  
  validates :peso_promedio_vaca_seca,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.vaca_seca')} #{I18n.t('errors.messages.invalid')}"}    
 
  validates :peso_promedio_vaca_ordenio,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.vaca_ordenio')} #{I18n.t('errors.messages.invalid')}"}    
 
  validates :porcentaje_preniez,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.porcentaje_preniez')} #{I18n.t('errors.messages.invalid')}"}    
  
  validates :dias_intervalo_partos,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.dias_intervalo_partos')} #{I18n.t('errors.messages.invalid')}"}    
 
  validates :cant_animales_adquiridos,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cant_animales_adquiridos')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cant_hembras,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.hembras')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cant_machos,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cantidad_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.machos')} #{I18n.t('errors.messages.invalid')}"}    

  validates :cant_animales_marcados_hierro_fondas,:numericality =>{:numericality => true, 
    :only_integer => true, :message => "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.cant_animales_marcados_hierro_fondas')} #{I18n.t('errors.messages.invalid')}"}    


  validates :fecha_adquisicion_semovientes,
    :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.fecha_adquisicion_semovientes')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 0.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.Errores.fecha_no_posterior_fecha_actual')}
 


  def fecha_adquisicion_semovientes_f=(fecha)
    self.fecha_adquisicion_semovientes = fecha
  end

  def fecha_adquisicion_semovientes_f
    format_fecha(self.fecha_adquisicion_semovientes)
  end

  def peso_promedio_becerra_f=(valor)
    self.peso_promedio_becerra = format_valor(valor)
  end

  def peso_promedio_becerra_f
    format_f(self.peso_promedio_becerra)
  end


  def peso_promedio_becerra_fm
    format_fm(self.peso_promedio_becerra)
  end



  def peso_promedio_becerro_f=(valor)
    self.peso_promedio_becerro = format_valor(valor)
  end

  def peso_promedio_becerro_f
    format_f(self.peso_promedio_becerro)
  end


  def peso_promedio_becerro_fm
    format_fm(self.peso_promedio_becerro)
  end

  def peso_promedio_maute_f=(valor)
    self.peso_promedio_maute = format_valor(valor)
  end

  def peso_promedio_maute_f
    format_f(self.peso_promedio_maute)
  end

  def peso_promedio_maute_fm
    format_fm(self.peso_promedio_maute)
  end

  def peso_promedio_mauta_f=(valor)
    self.peso_promedio_mauta = format_valor(valor)
  end

  def peso_promedio_mauta_f
    format_f(self.peso_promedio_mauta)
  end


  def peso_promedio_mauta_fm
    format_fm(self.peso_promedio_mauta)
  end

  def peso_promedio_novillo_f=(valor)
    self.peso_promedio_novillo = format_valor(valor)
  end

  def peso_promedio_novillo_f
    format_f(self.peso_promedio_novillo)
  end

  def peso_promedio_novillo_fm
    format_fm(self.peso_promedio_novillo)
  end

  def peso_promedio_novilla_f=(valor)
    self.peso_promedio_novilla = format_valor(valor)
  end

  def peso_promedio_novilla_f
    format_f(self.peso_promedio_novilla)
  end

  def peso_promedio_novilla_fm
    format_fm(self.peso_promedio_novilla)
  end

  def peso_promedio_retajo_f=(valor)
    self.peso_promedio_retajo = format_valor(valor)
  end

  def peso_promedio_retajo_f
    format_f(self.peso_promedio_retajo)
  end

  def peso_promedio_retajo_fm
    format_fm(self.peso_promedio_retajo)
  end

  def peso_promedio_toro_f=(valor)
    self.peso_promedio_toro = format_valor(valor)
  end

  def peso_promedio_toro_f
    format_f(self.peso_promedio_toro)
  end

  def peso_promedio_toro_fm
    format_fm(self.peso_promedio_toro)
  end

  def peso_promedio_vaca_seca_f=(valor)
    self.peso_promedio_vaca_seca = format_valor(valor)
  end

  def peso_promedio_vaca_seca_f
    format_f(self.peso_promedio_vaca_seca)
  end

  def peso_promedio_vaca_seca_fm
    format_fm(self.peso_promedio_vaca_seca)
  end

  def peso_promedio_vaca_ordenio_f=(valor)
    self.peso_promedio_vaca_ordenio = format_valor(valor)
  end

  def peso_promedio_vaca_ordenio_f
    format_f(self.peso_promedio_vaca_ordenio)
  end

  def peso_promedio_vaca_ordenio_fm
    format_fm(self.peso_promedio_vaca_ordenio)
  end

  def porcentaje_preniez_f=(valor)
    self.porcentaje_preniez = format_valor(valor)
  end

  def porcentaje_preniez_f
    format_f(self.porcentaje_preniez)
  end

  def validar_inventario(inventario)
    logger.debug "********" << inventario.inspect
    logger.debug inventario.class

    cantidad_becerra = inventario[:cantidad_becerra].to_i
    cantidad_becerro = inventario[:cantidad_becerro].to_i
    cantidad_mauta = inventario[:cantidad_mauta].to_i
    cantidad_maute = inventario[:cantidad_maute].to_i
    cantidad_novilla = inventario[:cantidad_novilla].to_i
    cantidad_novillo = inventario[:cantidad_novillo].to_i
    cantidad_retajo = inventario[:cantidad_retajo].to_i
    cantidad_toro = inventario[:cantidad_toro].to_i
    cantidad_vaca_seca = inventario[:cantidad_vaca_seca].to_i
    cantidad_vaca_ordenio = inventario[:cantidad_vaca_ordenio].to_i

    total_hierro_fondas = inventario[:cant_animales_marcados_hierro_fondas].to_i
    total_hembras = (cantidad_vaca_ordenio.to_i + cantidad_vaca_seca.to_i + cantidad_novilla.to_i + cantidad_mauta.to_i + cantidad_becerra.to_i)
    total_machos = (cantidad_toro.to_i + cantidad_retajo.to_i + cantidad_novillo.to_i + cantidad_maute.to_i + cantidad_becerro.to_i)
    total_inventario = (total_hembras.to_i + total_machos.to_i)

    success = true
    errores = 0
    if (total_hierro_fondas.to_i > total_inventario.to_i)
      logger.debug "ocurrio"
      errors.add(:semovientes,  I18n.t('Sistema.Body.Modelos.Semovientes.Errores.cantidad_animales_marcados_hierro_fondas'))
      errores += 1
    end

    if (cantidad_becerra.to_i > 0)
      if (inventario[:condicion_corporal_becerra].nil?  || inventario[:condicion_corporal_becerra].empty? )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.condicion_corporal')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.becerra')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end

      if (inventario[:peso_promedio_becerra_f].nil?  || inventario[:peso_promedio_becerra_f].empty? ||inventario[:peso_promedio_becerra_f].to_f == 0.00 )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.becerra')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    end

    if (cantidad_becerro.to_i > 0)
      if (inventario[:condicion_corporal_becerro].nil?  || inventario[:condicion_corporal_becerro].empty? )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.condicion_corporal')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.becerro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end

      if (inventario[:peso_promedio_becerro_f].nil?  || inventario[:peso_promedio_becerro_f].empty? ||inventario[:peso_promedio_becerro_f].to_f == 0.00 )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.becerro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    end

    if (cantidad_maute.to_i > 0)
      if (inventario[:condicion_corporal_maute].nil?  || inventario[:condicion_corporal_maute].empty? )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.condicion_corporal')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.maute')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end

      if (inventario[:peso_promedio_maute_f].nil?  || inventario[:peso_promedio_maute_f].empty? ||inventario[:peso_promedio_maute_f].to_f == 0.00 )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.maute')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    end

    if (cantidad_mauta.to_i > 0)
      if (inventario[:condicion_corporal_mauta].nil?  || inventario[:condicion_corporal_mauta].empty? )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.condicion_corporal')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.mauta')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end

      if (inventario[:peso_promedio_mauta_f].nil?  || inventario[:peso_promedio_mauta_f].empty? ||inventario[:peso_promedio_mauta_f].to_f == 0.00 )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.mauta')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    end

    if (cantidad_novillo.to_i > 0)
      if (inventario[:condicion_corporal_novillo].nil?  || inventario[:condicion_corporal_novillo].empty? )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.condicion_corporal')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.novillo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end

      if (inventario[:peso_promedio_novillo_f].nil?  || inventario[:peso_promedio_novillo_f].empty? ||inventario[:peso_promedio_novillo_f].to_f == 0.00 )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.novillo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    end

    if (cantidad_novilla.to_i > 0)
      if (inventario[:condicion_corporal_novilla].nil?  || inventario[:condicion_corporal_novilla].empty? )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.condicion_corporal')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.novilla')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end

      if (inventario[:peso_promedio_novilla_f].nil?  || inventario[:peso_promedio_novilla_f].empty? ||inventario[:peso_promedio_novilla_f].to_f == 0.00 )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.novilla')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    end

    if (cantidad_retajo.to_i > 0)
      if (inventario[:condicion_corporal_retajo].nil?  || inventario[:condicion_corporal_retajo].empty? )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.condicion_corporal')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.retajo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end

      if (inventario[:peso_promedio_retajo_f].nil?  || inventario[:peso_promedio_retajo_f].empty? ||inventario[:peso_promedio_retajo_f].to_f == 0.00 )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.retajo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    end

    if (cantidad_toro.to_i > 0)
      if (inventario[:condicion_corporal_toro].nil?  || inventario[:condicion_corporal_toro].empty? )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.condicion_corporal')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.toro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end

      if (inventario[:peso_promedio_toro_f].nil?  || inventario[:peso_promedio_toro_f].empty? ||inventario[:peso_promedio_toro_f].to_f == 0.00 )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.toro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    end
    if (cantidad_vaca_seca.to_i > 0)
      if (inventario[:condicion_corporal_vaca_seca].nil?  || inventario[:condicion_corporal_vaca_seca].empty? )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.condicion_corporal')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.vaca_seca')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end

      if (inventario[:peso_promedio_vaca_seca_f].nil?  || inventario[:peso_promedio_vaca_seca_f].empty? ||inventario[:peso_promedio_vaca_seca_f].to_f == 0.00 )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.vaca_seca')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    end
    if (cantidad_vaca_ordenio.to_i > 0)
      if (inventario[:condicion_corporal_vaca_ordenio].nil?  || inventario[:condicion_corporal_vaca_ordenio].empty? )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.condicion_corporal')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.vaca_ordenio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end

      if (inventario[:peso_promedio_vaca_ordenio_f].nil?  || inventario[:peso_promedio_vaca_ordenio_f].empty? ||inventario[:peso_promedio_vaca_ordenio_f].to_f == 0.00 )
        errors.add(:semovientes,  "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.peso_promedio_de')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.vaca_ordenio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    end

    if (inventario[:dias_intervalo_partos].to_i > 100)
      errors.add(:semovientes, "#{I18n.t('Sistema.Body.Modelos.Semovientes.Columnas.dias_intervalo_partos')} #{I18n.t('Sistema.Body.Modelos.Semovientes.Errores.valor_no_puede_ser_mayor')}")
      errores += 1
    end


    if (errores > 0)
      success = false
    else
      self.cant_hembras = total_hembras
      self.cant_machos = total_machos
      success = true
    end
    return success
  end


end




# == Schema Information
#
# Table name: semovientes
#
#  id                                   :integer         not null, primary key
#  seguimiento_visita_id                :integer         not null
#  cantidad_becerra                     :integer         default(0), not null
#  condicion_corporal_becerra           :string(3)
#  peso_promedio_becerra                :float           default(0.0), not null
#  cantidad_becerro                     :integer         default(0), not null
#  condicion_corporal_becerro           :string(3)
#  peso_promedio_becerro                :float           default(0.0), not null
#  cantidad_mauta                       :integer         default(0), not null
#  condicion_corporal_mauta             :string(3)
#  peso_promedio_mauta                  :float           default(0.0), not null
#  cantidad_maute                       :integer         default(0), not null
#  condicion_corporal_maute             :string(3)
#  peso_promedio_maute                  :float           default(0.0), not null
#  cantidad_novilla                     :integer         default(0), not null
#  condicion_corporal_novilla           :string(3)
#  peso_promedio_novilla                :float           default(0.0), not null
#  cantidad_novillo                     :integer         default(0), not null
#  condicion_corporal_novillo           :string(3)
#  peso_promedio_novillo                :float           default(0.0), not null
#  cantidad_retajo                      :integer         default(0), not null
#  condicion_corporal_retajo            :string(3)
#  peso_promedio_retajo                 :float           default(0.0), not null
#  cantidad_toro                        :integer         default(0), not null
#  condicion_corporal_toro              :string(3)
#  peso_promedio_toro                   :float           default(0.0), not null
#  cantidad_vaca_seca                   :integer         default(0), not null
#  condicion_corporal_vaca_seca         :string(3)
#  peso_promedio_vaca_seca              :float           default(0.0), not null
#  cantidad_vaca_ordenio                :integer         default(0), not null
#  condicion_corporal_vaca_ordenio      :string(3)
#  peso_promedio_vaca_ordenio           :float           default(0.0), not null
#  cantidad_porcinos                    :integer         default(0), not null
#  cantidad_conejos                     :integer         default(0), not null
#  cantidad_caballos                    :integer         default(0), not null
#  cantidad_aves                        :integer         default(0), not null
#  cantidad_burro                       :integer         default(0), not null
#  cantidad_mula                        :integer         default(0), not null
#  cantidad_ovino                       :integer         default(0), not null
#  cantidad_caprino                     :integer         default(0), not null
#  cantidad_caninos                     :integer         default(0), not null
#  cantidad_felinos                     :integer         default(0), not null
#  otra_especie                         :string(25)
#  cantidad_otra_especie                :integer         default(0), not null
#  porcentaje_preniez                   :float           default(0.0), not null
#  dias_intervalo_partos                :integer         default(0), not null
#  cant_animales_adquiridos             :integer         default(0), not null
#  cant_hembras                         :integer         default(0), not null
#  cant_machos                          :integer         default(0), not null
#  fecha_adquisicion_semovientes        :date
#  cant_animales_marcados_hierro_fondas :integer
#  anamnesis_diagnostico                :text
#

