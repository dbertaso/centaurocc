# encoding: utf-8

#
# autor: Luis Rojas
# clase: PartidaPresupuestaria
# descripción: Migración a Rails 3
#
class PartidaPresupuestaria < ActiveRecord::Base
  
  self.table_name = 'partida_presupuestaria'
  
  
  attr_accessible :id,
                  :nombre,
                  :proyecto,
                  :accion_especifica,
                  :partida,
                  :generica,
                  :especifica,
                  :sub_especifica,
                  :denominacion,
                  :plazo_ciclo,
                  :programa_id



  validates_uniqueness_of :nombre, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
  
  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :accion_especifica, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.accion_especifica')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :proyecto, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.proyecto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :generica, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.generica')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :especifica, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.especifica')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :sub_especifica, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.sub_especifica')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :denominacion, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.denominacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.denominacion')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}

  validates_numericality_of :partida, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.partida')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"

  validates_numericality_of :generica,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.generica')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"

  validates_numericality_of :especifica,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.especifica')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"

  validates_numericality_of :sub_especifica,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.sub_especifica')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"

  validates_numericality_of :proyecto,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.proyecto')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"
  
  validates_numericality_of :accion_especifica,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.accion_especifica')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"
  
#nuevo codigo agregado el 21/05/2013
  validates_presence_of :plazo_ciclo,
    :message => " #{I18n.t('Sistema.Body.Vistas.ReglaContable.Etiquetas.plazo_ciclo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    
  validates_presence_of :programa_id,
    :message => " #{I18n.t('Sistema.Body.Vistas.General.programa')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"  
    
  validates_length_of :proyecto, :is => 4, :message => "#{I18n.t('Sistema.Body.Vistas.General.proyecto')} #{I18n.t('Sistema.Body.Controladores.PartidaPresupuestaria.Rangos.de_cuatro')}"  

  # fin nuevo codigo agregado el 21/05/2013 

    def before_save
        
        self.proyecto=self.proyecto.upcase
        
        if self.accion_especifica.to_i < 10  
         if self.accion_especifica.to_s.length!=2
            self.accion_especifica="0"+self.accion_especifica.to_s 
         end
        end 
        
        if self.partida.to_i < 10 
         if self.partida.to_s.length!=3
            self.partida="00"+self.partida.to_s 
         end
        elsif self.partida.to_i < 100
         if self.partida.to_s.length!=3
            self.partida="0"+self.partida.to_s 
         end
        end
        
        if self.generica.to_i < 10 
         if self.generica.to_s.length!=2
            self.generica="0"+self.generica.to_s 
         end
        end
        
        if self.especifica.to_i < 10 
         if self.especifica.to_s.length!=2
            self.especifica="0"+self.especifica.to_s
         end 
        end
        
        if self.sub_especifica.to_i < 10 
         if self.sub_especifica.to_s.length!=2
            self.sub_especifica="0"+self.sub_especifica.to_s
         end
        end
    end
  
  
  def validate
    unless self.nombre.nil? || self.nombre.empty?
      a = self.nombre[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:partida_presupuestaria, "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}")
      end
    end
    unless self.denominacion.nil? || self.denominacion.empty?
      a = self.denominacion[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:partida_presupuestaria, "#{I18n.t('Sistema.Body.Vistas.General.denominacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}")
      end
    end
  
   unless self.proyecto.nil? || self.proyecto.empty?
      a = self.proyecto[/^[a-zA-Z0-9]+$/]
      if a.nil?
        errors.add(:partida_presupuestaria, "#{I18n.t('Sistema.Body.Vistas.General.proyecto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}")
      end
    end
  
    unless self.accion_especifica.nil? || self.accion_especifica.empty?
      a = self.accion_especifica[/^(-)*[0-9]+$/]      
      unless a.nil? || a=="-0"
          b = self.accion_especifica.to_i          
          unless (b>=0 && b<=99)
            errors.add(:partida_presupuestaria, "#{I18n.t('Sistema.Body.Vistas.General.accion_especifica')}: #{I18n.t('Sistema.Body.Controladores.PartidaPresupuestaria.Rangos.de_cero_noventa')}")
          end
      else
        errors.add(:partida_presupuestaria, "#{I18n.t('Sistema.Body.Vistas.General.accion_especifica')}: #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}")
      end   
    end
  
    unless self.partida.nil? || self.partida.empty?
      a = self.partida[/^(-)*[0-9]+$/]      
      unless a.nil? || (a=="-00" || a=="-0")
          b = self.partida.to_i          
          unless (b>=0 && b<=999)
            errors.add(:partida_presupuestaria, "#{I18n.t('Sistema.Body.Vistas.General.partida')}: #{I18n.t('Sistema.Body.Controladores.PartidaPresupuestaria.Rangos.de_cero_noveciento')}")
          end
      else
        errors.add(:partida_presupuestaria, "#{I18n.t('Sistema.Body.Vistas.General.partida')}: #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}")
      end   
    end
  
    unless self.generica.nil? || self.generica.empty?
      a = self.generica[/^(-)*[0-9]+$/]      
      unless a.nil? || a=="-0" 
          b = self.generica.to_i          
          unless (b>=0 && b<=99)
            errors.add(:partida_presupuestaria, "#{I18n.t('Sistema.Body.Vistas.General.generica')}: #{I18n.t('Sistema.Body.Controladores.PartidaPresupuestaria.Rangos.de_cero_noventa')}")
          end
      else
        errors.add(:partida_presupuestaria, "#{I18n.t('Sistema.Body.Vistas.General.generica')}: #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}")
      end   
    end
    
    unless self.especifica.nil? || self.especifica.empty?
      a = self.especifica[/^(-)*[0-9]+$/]      
      unless a.nil? || a=="-0"
          b = self.especifica.to_i          
          unless (b>=0 && b<=99)
            errors.add(:partida_presupuestaria, "#{I18n.t('Sistema.Body.Vistas.General.especifica')}: #{I18n.t('Sistema.Body.Controladores.PartidaPresupuestaria.Rangos.de_cero_noventa')}")
          end
      else
        errors.add(:partida_presupuestaria, "#{I18n.t('Sistema.Body.Vistas.General.especifica')}: #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}")
      end   
    end
    
    unless self.sub_especifica.nil? || self.sub_especifica.empty?
      a = self.sub_especifica[/^(-)*[0-9]+$/]      
      unless a.nil? || a=="-0"
          b = self.sub_especifica.to_i          
          unless (b>=0 && b<=99)
            errors.add(:partida_presupuestaria, "#{I18n.t('Sistema.Body.Vistas.General.sub_especifica')}: #{I18n.t('Sistema.Body.Controladores.PartidaPresupuestaria.Rangos.de_cero_noventa')}")
          end
      else
        errors.add(:partida_presupuestaria, "#{I18n.t('Sistema.Body.Vistas.General.sub_especifica')}: #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}")
      end   
    end
    
    
  end

  def cuenta_presupuestaria
  
    cuenta = self.proyecto.to_s
    cuenta << "-" << self.accion_especifica.to_s
    cuenta << "-" << self.partida.to_s
    cuenta << "." << self.generica.to_s
    cuenta << "." << self.especifica.to_s
    cuenta << "." << self.sub_especifica.to_s
    
    return cuenta
  end

  def numero_partida
    numero = self.partida.to_s
    numero << "." << self.generica.to_s
    numero << "." << self.especifica.to_s
    numero << "." << self.sub_especifica.to_s
    return numero
  end

  def get_arreglo_partidas()
    partidas = PartidaPresupuestaria.find(:all)
    partidas.collect! {|x| [x.nombre, x.id]}
    return partidas
  end
  

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end


end

# == Schema Information
#
# Table name: partida_presupuestaria
#
#  id                :integer         not null, primary key
#  nombre            :string(70)
#  proyecto          :string(50)
#  accion_especifica :string(50)
#  partida           :string(50)
#  generica          :string(50)
#  especifica        :string(50)
#  sub_especifica    :string(50)
#  denominacion      :string(100)
#  plazo_ciclo       :string(1)
#  programa_id       :integer
#

