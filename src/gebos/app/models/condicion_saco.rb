# encoding: utf-8
class CondicionSaco < ActiveRecord::Base
  
  self.table_name = 'condicion_saco'
  
  attr_accessible :id,
  :nombre,
  :porcentaje,
  :activo,
  :acta_silo_id,
  :silo_id,
  :porcentaje_f


  belongs_to :silo
  belongs_to :acta_silo
   
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.porcentaje')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  


  def porcentaje_f=(valor)
    self.porcentaje = valor
  end
  def porcentaje_f
    if self.porcentaje == 0 || self.porcentaje.nil?
      return '0.00'
    else
      valor = format_sep(self.porcentaje)
      return valor
    end
  end
  
  
  def validate
    unless self.nombre.nil? || self.nombre.empty?
      a = self.nombre[/#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/]
      if a.nil?
        errors.add(:condicion_saco, I18n.t('Sistema.Body.Modelos.Errores.nombre_invalido'))
      end
    end
    unless self.porcentaje.nil?
      if self.porcentaje <= 0
        errors.add(:condicion_saco, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.porcentaje_mayor_cero'))
      end
    end
   
  end


  def before_save
    self.nombre = mayuscula(self.nombre)
    if self.id.nil?
        condicion = CondicionSaco.count(:conditions=>["silo_id = #{self.silo_id} and acta_silo_id = #{self.acta_silo_id} and nombre = '#{self.nombre}'"])
        unless condicion == 0
          errors.add(:condicion_saco, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.silo_posee_condicion_saco_registrada'))
          return false
        end
    end
    unless self.id.nil?
        condicion = CondicionSaco.count(:conditions=>["id <> #{self.id} and silo_id = #{self.silo_id} and acta_silo_id = #{self.acta_silo_id} and nombre = '#{self.nombre}'"])
        logger.info"XXXXX==========>>>>>"<<condicion.inspect
        if condicion > 0
          errors.add(:condicion_saco, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.silo_posee_condicion_saco_registrada'))
          return false
        end
    end
  end
  
  after_save :antes_guardar
  
  def antes_guardar
    self.nombre = mayuscula(self.nombre)
  end

  def mayuscula(texto)
    unless texto.nil?
      texto  = texto.gsub('á', 'Á')
      texto  = texto.gsub('é', 'É')
      texto  = texto.gsub('í', 'Í')
      texto  = texto.gsub('ó', 'Ó')
      texto  = texto.gsub('ú', 'Ú')
      texto  = texto.upcase
    end
    return texto
  end

  
  def eliminar(id)
    begin
      boleta = BoletaArrime.count(:conditions=>"condicion_saco_id = #{id}")
      if boleta > 0
        errors.add(:condicion_saco, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.condicion_saco_utilizada'))
        return false
      else
        condicion = CondicionSaco.find(id)
        transaction do
          condicion.destroy
          return true
        end
      end
    rescue
      errors.add(:condicion_saco, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.condicion_saco_utilizada'))
      return false
    end
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort, :include => [:silo, :acta_silo],
      :select=>'condicion_saco.*'
  end
  
  
  

end





# == Schema Information
#
# Table name: condicion_saco
#
#  id           :integer         not null, primary key
#  nombre       :string(25)      not null
#  porcentaje   :decimal(16, 2)  default(0.0)
#  activo       :boolean         default(TRUE)
#  acta_silo_id :integer
#  silo_id      :integer
#

