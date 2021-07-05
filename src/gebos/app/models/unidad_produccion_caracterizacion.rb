# encoding: utf-8
class UnidadProduccionCaracterizacion < ActiveRecord::Base
  
  self.table_name = 'unidad_produccion_caracterizacion'
  
  attr_accessible :id,
				  :solicitud_id,
				  :unidad_produccion_id,
				  :seguimiento_visita_id,
				  :permisologia_agua,
				  :observaciones_permisologia,
				  :vialidad_condicion,
				  :suelo_ph,
				  :riego_actual,
				  :tipo_riego_actual_id,
				  :condicion_riego_actual,
				  :requiere_riego,
				  :tipo_riego_requerido_id,
				  :superficie_riego_propuesto,
				  :condiciones_climaticas,
				  :posee_drenaje,
				  :tipo_drenaje_id,
				  :superficie_drenaje,
				  :condicion_drenaje,
				  :rubros_vegetales,
				  :rubros_animales,
				  :porcentaje_vegetacion_baja,
				  :porcentaje_vegetacion_media,
				  :porcentaje_vegetacion_alta,
				  :superficie_total,
				  :superficie_aprovechable,
				  :vialidad_distancia,
				  :superficie_riego_actual

  belongs_to :solicitud
  belongs_to :unidad_produccion
  belongs_to :seguimiento_visita
  belongs_to :tipo_drenaje
  belongs_to :tipo_riego_actual, :class_name=>'TipoRiego', :foreign_key =>'tipo_riego_actual_id'
  belongs_to :tipo_riego_propuesto, :class_name=>'TipoRiego', :foreign_key =>'tipo_riego_requerido_id'
  
  validates_numericality_of :superficie_total,
       :only_integer => false, :allow_nil => true,
       :message => " número inválido"     
       
  validates_presence_of :superficie_aprovechable, 
        :message => "^ No puede ser vacia o cero"


  validates_numericality_of :superficie_aprovechable,
       :only_integer => false, :allow_nil => true,
       :message => " número inválido" 


  validates_numericality_of :vialidad_distancia,
       :only_integer => false, :allow_nil => true,
       :message => " número inválido"        
       
  validates_numericality_of :superficie_riego_actual,
       :only_integer => false, :allow_nil => true,
       :message => " número inválido" 
       
  validates_numericality_of :superficie_riego_propuesto,
       :only_integer => false, :allow_nil => true,
       :message => " número inválido" 
       
  validates_numericality_of :superficie_drenaje,
       :only_integer => false, :allow_nil => true,
       :message => " número inválido" 
       
  validates_numericality_of :porcentaje_vegetacion_baja,
       :only_integer => false, :allow_nil => true,
       :message => " número inválido"      
    
  validates_numericality_of :porcentaje_vegetacion_media,
       :only_integer => false, :allow_nil => true,
       :message => " número inválido" 
       
  validates_numericality_of :porcentaje_vegetacion_alta,
       :only_integer => false, :allow_nil => true,
       :message => " número inválido"
       
  #validates_presence_of :vialidad_condicion, 
  #      :message => "^ Debe seleccionar las condiciones de la vialidad"
        
  #validates_presence_of :condiciones_climaticas, 
  #      :message => " es requerido"
                    
  def vialidad_condicion_w
    if self.vialidad_condicion == 'E'
      return 'Excelente'
    elsif self.vialidad_condicion == 'B'
      return 'Bueno'
    elsif self.vialidad_condicion == 'R'
      return 'Regular'
    elsif self.vialidad_condicion == 'M'
      return 'Malo'
    end
  end
  
  def actualizar(params)

    self.permisologia_agua = params[:unidad_produccion_caracterizacion][:permisologia_agua]
    self.observaciones_permisologia = params[:unidad_produccion_caracterizacion][:observaciones_permisologia]
    self.vialidad_condicion = params[:unidad_produccion_caracterizacion][:vialidad_condicion]
    #logger.debug params[:unidad_produccion_caracterizacion][:vialidad_condicion].to_s << "................................." << self.vialidad_condicion.to_s
    self.suelo_ph = params[:unidad_produccion_caracterizacion][:suelo_ph]
    self.riego_actual = params[:unidad_produccion_caracterizacion][:riego_actual]
    self.tipo_riego_actual_id = params[:unidad_produccion_caracterizacion][:tipo_riego_actual_id]
    self.condicion_riego_actual = params[:unidad_produccion_caracterizacion][:condicion_riego_actual]
    self.requiere_riego = params[:unidad_produccion_caracterizacion][:requiere_riego]
    self.tipo_riego_requerido_id = params[:unidad_produccion_caracterizacion][:tipo_riego_requerido_id]
    self.superficie_riego_propuesto = params[:unidad_produccion_caracterizacion][:superficie_riego_propuesto]
    self.condiciones_climaticas = params[:unidad_produccion_caracterizacion][:condiciones_climaticas]
    #logger.debug params[:unidad_produccion_caracterizacion][:condiciones_climaticas].to_s << "................................." << self.condiciones_climaticas.to_s
    self.posee_drenaje = params[:unidad_produccion_caracterizacion][:posee_drenaje]
    self.tipo_drenaje_id = params[:unidad_produccion_caracterizacion][:tipo_drenaje_id]
    self.superficie_drenaje = params[:unidad_produccion_caracterizacion][:superficie_drenaje]
    self.condicion_drenaje = params[:unidad_produccion_caracterizacion][:condicion_drenaje]
    self.rubros_vegetales = params[:unidad_produccion_caracterizacion][:rubros_vegetales]
    self.rubros_animales = params[:unidad_produccion_caracterizacion][:rubros_animales]
    self.porcentaje_vegetacion_baja = params[:unidad_produccion_caracterizacion][:porcentaje_vegetacion_baja]
    self.porcentaje_vegetacion_media = params[:unidad_produccion_caracterizacion][:porcentaje_vegetacion_media]
    self.porcentaje_vegetacion_alta = params[:unidad_produccion_caracterizacion][:porcentaje_vegetacion_alta]
    self.superficie_total = params[:unidad_produccion_caracterizacion][:superficie_total]

    if params[:unidad_produccion_caracterizacion][:superficie_aprovechable].to_s == ""

      errors.add(:unidad_produccion_caracterizacion, "#{I18n.t('Sistema.Body.Vistas.General.superficie')} #{I18n.t('Sistema.Body.Vistas.General.aprovechable')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}")
      return false
    else
      if params[:unidad_produccion_caracterizacion][:superficie_aprovechable].to_s =="0"    
      errors.add(:unidad_produccion_caracterizacion, "#{I18n.t('Sistema.Body.Vistas.General.superficie')} #{I18n.t('Sistema.Body.Vistas.General.aprovechable')} #{I18n.t('Sistema.Body.Modelos.General.debe_ser_mayor_cero')}")
      return false
      else     
       self.superficie_aprovechable = params[:unidad_produccion_caracterizacion][:superficie_aprovechable]
      end
    end


    self.vialidad_distancia = params[:unidad_produccion_caracterizacion][:vialidad_distancia]
    self.superficie_riego_actual = params[:unidad_produccion_caracterizacion][:superficie_riego_actual]

     
     validacion1 = true
     if self.riego_actual == false   
       self.tipo_riego_actual_id = nil
       self.superficie_riego_actual = nil
       self.condicion_riego_actual = nil
       validacion1 = true
     else
       if self.superficie_riego_actual.nil? 
        self.superficie_riego_actual = 0 
       end
       if self.tipo_riego_actual_id.nil? or self.superficie_riego_actual.nil? or self.condicion_riego_actual.nil? 
         errors.add(:unidad_produccion_caracterizacion, "Complete la información del sistema de riego actual")
         validacion1 = false
       end
     end
     
     validacion2 = true
     if self.requiere_riego == false   
        self.tipo_riego_requerido_id = nil
        self.superficie_riego_propuesto = nil
        validacion2 = true
     else
         if self.superficie_riego_propuesto.nil? 
          self.superficie_riego_propuesto = 0 
         end
         if self.tipo_riego_requerido_id.nil? or self.superficie_riego_propuesto.nil?
           errors.add(:unidad_produccion_caracterizacion, "Complete la información del sistema de riego propuesto")
           validacion2 = false
         end
     end
    
    validacion3 = true
     if self.posee_drenaje == false   
          self.tipo_drenaje_id = nil
          self.superficie_drenaje = 0
          self.condicion_drenaje = nil
          validacion3 = true
      else
          if self.superficie_drenaje.nil?
           self.superficie_drenaje = 0
          end
          if self.tipo_drenaje_id.nil? or self.superficie_drenaje.nil? or self.condicion_drenaje.nil?
            errors.add(:unidad_produccion_caracterizacion, "Complete la información del sistema de drenaje")
            validacion3 = false
          end
      end
        
      if self.superficie_total == nil
       self.superficie_total = 0
      end
      if self.superficie_aprovechable == nil
       self.superficie_aprovechable = 0 
      end
      if self.superficie_riego_actual != nil
       riego_actual = self.superficie_riego_actual 
      else
       riego_actual = 0
      end
      if self.superficie_riego_propuesto != nil
       riego_propuesto = self.superficie_riego_propuesto
      else
       riego_propuesto = 0
      end

   
    if riego_actual + riego_propuesto > self.superficie_aprovechable
      errors.add(:unidad_produccion_caracterizacion, "La suma de la superficie del sistema de riego actual mas el propuesto no debe ser mayor a la superficie aprovechable")
      validacion4 = false
    else
      validacion4 = true
    end
  
    if self.superficie_total < self.superficie_aprovechable
      errors.add(:unidad_produccion_caracterizacion, "La superficie total de la unidad de producción no debe ser menor a la superficie aprovechable")
      validacion5 = false
    else
      validacion5 = true
    end
    
    
    if self.superficie_drenaje > self.superficie_aprovechable
      errors.add(:unidad_produccion_caracterizacion, "La superficie del sistema de drenaje no debe ser mayor a la superficie aprovechable")
      validacion6 = false
    else
      validacion6 = true
    end

    if self.condiciones_climaticas == "" 
      errors.add(:unidad_produccion_caracterizacion, "El campo condiciones climáticas es requerido")
      validacion7 = false
    else
      validacion7 = true
    end
    if self.vialidad_condicion.nil?
      errors.add(:unidad_produccion_caracterizacion, "El campo vialidad condición es requerido")
       validacion8 = false
    else
      validacion8 = true
    end

    if validacion1 == true and validacion2 == true and validacion3 == true and validacion4 == true and validacion5 == true and validacion6 == true and validacion7 == true and validacion8 == true
      if self.save
        if self.superficie_total != nil
          @unidad_produccion = UnidadProduccion.find(self.unidad_produccion_id)
          @unidad_produccion.total_hectareas = self.superficie_total
          @unidad_produccion.save
        else
          return true
        end
        return true
      else
        return false
      end
    else
      return false    
    end
    
  end


  def condicion_drenaje_w
    if self.condicion_drenaje == 'E'
      return 'Excelente'
    elsif self.condicion_drenaje == 'B'
      return 'Bueno'
    elsif self.condicion_drenaje == 'R'
      return 'Regular'
    elsif self.condicion_drenaje == 'M'
      return 'Malo'
    end
  end

  def condicion_riego_actual_w
    if self.condicion_riego_actual == 'E'
      return 'Excelente'
    elsif self.condicion_riego_actual == 'B'
      return 'Bueno'
    elsif self.condicion_riego_actual == 'R'
      return 'Regular'
    elsif self.condicion_riego_actual == 'M'
      return 'Malo'
    end
  end


  def cantidad_por_hectarea_f
    sprintf('%01.2f', self.cantidad_por_hectarea).sub('.', ',') unless self.cantidad_por_hectarea.nil?
  end
    
  def cantidad_por_hectarea_fm
    unless self.cantidad_por_hectarea.nil?
      valor = sprintf('%01.2f', self.cantidad_por_hectarea).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end 
end



# == Schema Information
#
# Table name: unidad_produccion_caracterizacion
#
#  id                          :integer         not null, primary key
#  solicitud_id                :integer         not null
#  unidad_produccion_id        :integer         not null
#  seguimiento_visita_id       :integer
#  permisologia_agua           :boolean
#  observaciones_permisologia  :text
#  vialidad_condicion          :text
#  suelo_ph                    :text
#  riego_actual                :boolean
#  tipo_riego_actual_id        :integer
#  condicion_riego_actual      :text
#  requiere_riego              :boolean
#  tipo_riego_requerido_id     :integer
#  superficie_riego_propuesto  :float
#  condiciones_climaticas      :text
#  posee_drenaje               :boolean
#  tipo_drenaje_id             :integer
#  superficie_drenaje          :float
#  condicion_drenaje           :text
#  rubros_vegetales            :text
#  rubros_animales             :text
#  porcentaje_vegetacion_baja  :float
#  porcentaje_vegetacion_media :float
#  porcentaje_vegetacion_alta  :float
#  superficie_total            :float
#  superficie_aprovechable     :float
#  vialidad_distancia          :float
#  superficie_riego_actual     :float
#

