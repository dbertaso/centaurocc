# encoding: utf-8
class Siniestro < ActiveRecord::Base

  self.table_name = 'siniestro'
  
  attr_accessible :id, 
    :solicitud_id,
    :cliente_id,
    :seguimiento_visita_id,
    :fecha_siniestro,
    :fecha_notificacion,
    :fecha_siembra,
    :fecha_cosecha,
    :nombre_notificador,
    :causa_siniestro_id,
    :direccion_siniestro,
    :descripcion_siniestro,
    :tipo_perdida_id,
    :unidades_adquiridas,
    :unidades_aprobadas,
    :unidades_siniestradas,
    :estatus_id,
    :decision,
    :porcentaje_perdida,
    :hectareas_aprobadas,
    :hectareas_sembradas,
    :hectareas_siniestradas
    

    belongs_to :solicitud
  belongs_to :estatus
  belongs_to :seguimiento_visita
  belongs_to :cliente
  belongs_to :prestamo
  belongs_to :recaudo_siniestro
  belongs_to :siniestro_recaudo
  #belongs_to :cliente, :class_name => "Cliente", :foreign_key => "cliente_id"
  belongs_to :tipo_perdida          
  belongs_to :causa_siniestro
  belongs_to :siniestro_detalle_item
  has_one    :analista_siniestro


  validates_presence_of :tipo_perdida_id, :message => ' es requerido'
  validates_presence_of :causa_siniestro_id, :message=> ' es requerido'

  validates_length_of :descripcion_siniestro, :minimum => 1, :allow_nil => false,:message=>"Deben de ser no menor a 1 caracteres."

  validates_length_of :descripcion_siniestro, :maximum => 240, :allow_nil => false,:message=>"Deben de ser no mayor a 240 caracteres."

  validates_length_of :direccion_siniestro, :minimum => 1, :allow_nil => false,:message=>"Deben de ser no menor a 1 caracteres."

  validates_length_of :direccion_siniestro, :maximum => 240, :allow_nil => false,:message=>"Deben de ser no mayor a 240 caracteres."

  validates_length_of :nombre_notificador, :minimum => 1, :allow_nil => false,:message=>"Deben de ser no menor a 1 caracteres."

  validates_length_of :nombre_notificador, :maximum => 100, :allow_nil => false,:message=>"Deben de ser no mayor a 100 caracteres."

  validates_length_of :informacion_infraestructura_siniestrada, :maximum => 1000, :allow_nil => false,:message=>"Deben de ser no mayor a 1000 caracteres."


  validates_numericality_of :porcentaje_perdida, :message =>"Solo pueden ser carácteres numéricos"

  validates_numericality_of :unidades_aprobadas, :message =>"Solo pueden ser carácteres numéricos"

  validates_numericality_of :unidades_adquiridas, :message =>"Solo pueden ser carácteres numéricos"

  validates_numericality_of :unidades_siniestradas, :message =>"Solo pueden ser carácteres numéricos"

  validates_numericality_of :hectareas_sembradas, :message =>"Solo pueden ser carácteres numéricos"

  validates_numericality_of :hectareas_siniestradas, :message =>"Solo pueden ser carácteres numéricos"

  validates_numericality_of :hectareas_aprobadas, :message =>"Solo pueden ser carácteres numéricos"

  validates_inclusion_of :porcentaje_perdida, :in => 0..100, :message => "el rango de valores consta de 0 a 100"

  validates_inclusion_of :unidades_aprobadas, :in => 0..1000000, :message => "el rango de valores consta de 0 a 1000000"

  validates_inclusion_of :unidades_adquiridas, :in => 0..1000000, :message => "el rango de valores consta de 0 a 1000000"

  validates_inclusion_of :unidades_siniestradas, :in => 0..1000000, :message => "el rango de valores consta de 0 a 1000000"

  validates_inclusion_of :hectareas_sembradas, :in => 1..1000000, :message => "el rango de valores consta de 1 a 1000000"

  validates_inclusion_of :hectareas_siniestradas, :in => 1..1000000, :message => "el rango de valores consta de 1 a 1000000"

  validates_inclusion_of :hectareas_aprobadas, :in => 1..1000000, :message => "el rango de valores consta de 1 a 1000000"


  def before_save    
    seguimiento_cultivo = SeguimientoCultivo.find_by_seguimiento_visita_id(self.seguimiento_visita_id)    
    superficie_sembrada = seguimiento_cultivo.superficie_sembrada unless seguimiento_cultivo.nil?
    
    pastizales_potreros = PastizalesPotreros.find_by_seguimiento_visita_id(self.seguimiento_visita_id)    
    semovientes         = Semovientes.find_by_seguimiento_visita_id(self.seguimiento_visita_id)

    #Semovientes, Pastizales potreros
    if (!semovientes.nil?  || !pastizales_potreros.nil? )
      if (self.unidades_siniestradas.nil? && self.hectareas_siniestradas.nil? )
        errors.add(nil,"Debe ingresar las hectareas siniestradas o las unidades siniestradas")
      end
      errors.add(nil,"Debe ingresar valores mayores a cero") if (self.unidades_siniestradas==0 || self.hectareas_siniestradas==0 )
      unless semovientes.nil?
        cant_total= semovientes.cant_hembras.to_i + semovientes.cant_machos.to_i
        errors.add(nil,"La unidad siniestrada debe ser menor que la unidade adquirida") if self.unidades_siniestradas.to_i > cant_total.to_i
      end
      errors.add(nil,"La superficie siniestrada debe ser menor que la superficie sembrada") if self.hectareas_siniestradas.to_f > pastizales_potreros.superficie.to_f if !pastizales_potreros.nil?
    end
    
    #Cultivo
    if !seguimiento_cultivo.nil?
      errors.add(nil,"La superficie siniestrada debe ser menor que la superficie sembrada") if self.hectareas_siniestradas.to_f > superficie_sembrada.to_f
      errors.add(nil,"Debe ingresar el total de la superficie siniestrada") if self.hectareas_siniestradas.nil?
    end

    errors.add(nil, "Causa Siniestro: Debe seleccionar un tipo de siniestro.") if self.causa_siniestro_id.nil?
    errors.add(nil, "Solicitud: No existe una solicitud asociada.") if self.solicitud_id.nil? || self.solicitud_id.to_s.empty?
    errors.add(nil, "Fecha de Ocurrencia: Debe ingresar la fecha en que ocurrió el siniestro.") if self.fecha_siniestro_f.nil? || self.fecha_siniestro_f.to_s.empty?
    errors.add(nil, "Fecha de Notificación: Debe ingresar la fecha de notificación.") if self.fecha_notificacion_f.nil? || self.fecha_notificacion_f.to_s.empty?
    errors.add(nil, "Descripción: Debe ingresar una descripción.") if self.descripcion_siniestro.to_s.empty?    
    if !self.fecha_notificacion_f.nil? && !self.fecha_notificacion_f.empty? && !self.fecha_siniestro_f.to_s.nil?  && !self.fecha_siniestro_f.to_s.empty?
      if self.fecha_notificacion_f < self.fecha_siniestro_f
        errors.add(nil, "Fecha: La fecha de notificación debe ser posterior a la fecha del siniestro.")
      end      
    end    
    total_errors = (errors.size>0) ? false : true        
    return total_errors    
  end
  
  ##################################
  ###### Hectareas
  ##################################
  ####  validacion  de los flotantes
  
  def porcentaje_perdida_f=(valor)
    self.porcentaje_perdida = valor.sub(',', '.')
  end
  
  def porcentaje_perdida_f
    sprintf('%01.2f', self.porcentaje_perdida).sub('.', ',') unless self.porcentaje_perdida.nil?
  end  
  
  def hectareas_aprobadas_f=(valor)
    self.hectareas_aprobadas = valor.sub(',', '.')
  end
  
  def hectareas_aprobadas_f
    sprintf('%01.2f', self.hectareas_aprobadas).sub('.', ',') unless self.hectareas_aprobadas.nil?
  end
  
  def hectareas_aprobadas_fm
    unless self.hectareas_aprobadas.nil?
      valor = sprintf('%01.2f', self.hectareas_aprobadas).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end




  def hectareas_sembradas_f=(valor)
    self.hectareas_sembradas = valor.sub(',', '.')
  end
  
  def hectareas_sembradas_f
    sprintf('%01.2f', self.hectareas_sembradas).sub('.', ',') unless self.hectareas_sembradas.nil?
  end
  
  def hectareas_sembradas_fm
    unless self.hectareas_sembradas.nil?
      valor = sprintf('%01.2f', self.hectareas_sembradas).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end


=begin
#  def hectareas_siniestradas_f=(valor)
#    self.hectareas_siniestradas = valor.sub(',', '.')
#  end
#
#  def hectareas_siniestradas_f
#    sprintf('%01.2f', self.hectareas_siniestradas).sub('.', ',') unless self.hectareas_siniestradas.nil?
#  end
=end

  
  def hectareas_siniestradas_f=(valor)
    logger.debug "AQUI.................................." << valor.inspect
    self.hectareas_siniestradas = valor.sub(',', '.')
  end
  
  def hectareas_siniestradas_f
    sprintf('%01.2f', self.hectareas_siniestradas).sub('.', ',') unless self.hectareas_siniestradas.nil?
  end

  def hectareas_siniestradas_fm
    unless self.hectareas_siniestradas.nil?
      valor = sprintf('%01.2f', self.hectareas_siniestradas).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end


  
  ##################################
  ####    Fechas
  ##################################
  
  def fecha_siniestro_f=(fecha)
    self.fecha_siniestro = fecha
  end
  

  def unidades_aprobadas_f=(valor)
    self.unidades_aprobadas = valor.sub(',', '.')
  end

  def unidades_aprobadas_f
    sprintf('%01.2f', self.unidades_aprobadas).sub('.', ',') unless self.unidades_aprobadas.nil?
  end

  def unidades_adquiridas_f=(valor)
    self.unidades_adquiridas = valor.sub(',', '.')
  end

  def unidades_adquiridas_f
    sprintf('%01.2f', self.unidades_adquiridas).sub('.', ',') unless self.unidades_adquiridas.nil?
  end

  def unidades_siniestradas_f=(valor)
    self.unidades_siniestradas = valor.sub(',', '.')
  end

  def unidades_siniestradas_f
    sprintf('%01.2f', self.unidades_siniestradas).sub('.', ',') unless self.unidades_siniestradas.nil?
  end


  #validar fecha de siembra

#  validates_date :fecha_siniestro,
#    :message => ": Debe ingresar la fecha de ocurrencia (dd/mm/aaaa)",
#    :before => Proc.new { 0.day.from_now.to_date }, :before_message => 'no puede ser posterior a la fecha actual'

#  validates_date :fecha_siniestro,
#    :message => " es inválida (dd/mm/aaaa)",
#    :before => :fecha_notificacion, :before_message => 'no puede ser posterior a la fecha de notificacion'


  def fecha_siniestro_f=(fecha)
    self.fecha_siniestro = fecha
  end


  def fecha_siniestro_f
    self.fecha_siniestro.strftime('%d/%m/%Y') unless self.fecha_siniestro.nil?
  end

  def fecha_siniestro_f
    self.fecha_siniestro.strftime('%d/%m/%Y') unless self.fecha_siniestro.nil?
  end


=begin  
#  validates_date :fecha_notificacion,
#    :message => " es inválida (dd/mm/aaaa)",
#    :after => :fecha_siniestro, :after_message => 'no puede ser anterior a la fecha del siniestro'
=end

  def fecha_notificacion_f=(fecha)
    self.fecha_notificacion = fecha
  end

  def fecha_notificacion_f
    self.fecha_notificacion.strftime('%d/%m/%Y') unless self.fecha_notificacion.nil?
  end

=begin
#  validates_date :fecha_notificacion,
#    :message => " :Debe ingresar la fecha de notificación (dd/mm/aaaa)",
#    :after => Proc.new { 1.day.from_now.to_date }, :after_message => 'no puede ser posterior a la fecha actual'
#
=end
  
  def fecha_notificacion_f=(fecha)
    self.fecha_notificacion = fecha
  end

  def fecha_notificacion_f
    self.fecha_notificacion.strftime('%d/%m/%Y') unless self.fecha_notificacion.nil?
  end
  
end

# == Schema Information
#
# Table name: siniestro
#
#  id                                      :integer         not null, primary key
#  solicitud_id                            :integer         not null
#  prestamo_id                             :integer         not null
#  cliente_id                              :integer         not null
#  seguimiento_visita_id                   :integer         not null
#  fecha_siniestro                         :date            not null
#  fecha_notificacion                      :date            not null
#  fecha_siembra                           :date
#  fecha_cosecha                           :date
#  nombre_notificador                      :string(100)     not null
#  causa_siniestro_id                      :integer
#  direccion_siniestro                     :text            not null
#  descripcion_siniestro                   :text            not null
#  tipo_perdida_id                         :integer         not null
#  unidades_adquiridas                     :integer
#  unidades_aprobadas                      :integer
#  unidades_siniestradas                   :integer
#  estatus_id                              :integer         not null
#  decision                                :string(1)       not null
#  porcentaje_perdida                      :float
#  hectareas_aprobadas                     :float
#  hectareas_sembradas                     :float
#  hectareas_siniestradas                  :float
#  usuario_id                              :integer
#  informacion_infraestructura_siniestrada :text
#  analista_siniestro_id                   :integer
#

# == Schema Information
#
# Table name: siniestro
#
#  id                                      :integer         not null, primary key
#  solicitud_id                            :integer         not null
#  prestamo_id                             :integer         not null
#  cliente_id                              :integer         not null
#  seguimiento_visita_id                   :integer         not null
#  fecha_siniestro                         :date            not null
#  fecha_notificacion                      :date            not null
#  fecha_siembra                           :date
#  fecha_cosecha                           :date
#  nombre_notificador                      :string(100)     not null
#  causa_siniestro_id                      :integer
#  direccion_siniestro                     :text            not null
#  descripcion_siniestro                   :text            not null
#  tipo_perdida_id                         :integer         not null
#  unidades_adquiridas                     :integer
#  unidades_aprobadas                      :integer
#  unidades_siniestradas                   :integer
#  estatus_id                              :integer         not null
#  decision                                :string(1)       not null
#  porcentaje_perdida                      :float
#  hectareas_aprobadas                     :float
#  hectareas_sembradas                     :float
#  hectareas_siniestradas                  :float
#  usuario_id                              :integer
#  informacion_infraestructura_siniestrada :text
#  analista_siniestro_id                   :integer
#

