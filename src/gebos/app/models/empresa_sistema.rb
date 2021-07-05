# encoding: utf-8
#
# autor: Luis Rojas
# clase: Contratista
# descripción: Creado en Rails 3
# fecha: 2014-03-06
#

class EmpresaSistema < ActiveRecord::Base

  self.table_name = 'empresa_sistema'

  attr_accessible :id, :rif, :nombre_corto, :nombre, :direccion, :telefono, :representante_legal, :rif_1, :rif_2, :rif_3, :activo
  
  validates :rif, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.rif')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_rif')}/, :allow_blank => true,
    :message => I18n.t('Sistema.Body.Modelos.Empresa.Errores.rif_no_valido')},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.rif')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}
  
  validates :nombre_corto, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.abreviado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..50, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.abreviado')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.abreviado')} #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :nombre, :presence => { :message => I18n.t('Sistema.Body.Modelos.Errores.nombre_requerido')},
    :length => { :in => 3..100, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :direccion, :presence => { :message => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"},
    :length => { :in => 3..100, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :telefono, :presence => {:message=> I18n.t('Sistema.Body.Vistas.General.telefono') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')},
    :length => { :in => 11..11, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :representante_legal, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.representante_legal')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..100, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.representante_legal')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.representante_legal')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.representante_legal')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  def rif_1=(valor)
    @rif_1 = valor
  end

  def rif_1
    unless self.rif.nil?
      self.rif.slice(0,1)
    end
  end


  def rif_2=(valor)
    @rif_2 = valor
  end

  def rif_2
    unless self.rif.nil?
      self.rif.slice(2,8)
    end
  end

  def rif_3=(valor)
    @rif_3 = valor
  end

  def rif_3
    unless self.rif.nil?
      self.rif.slice(11,1)
    end
  end
  
  def eliminar(id)
    begin
      empresa_sistema = EmpresaSistema.find(id)
      transaction do
        empresa_sistema.destroy
        return true
      end
    rescue
      errors.add('empresa_sistema', I18n.t('Sistema.Body.Modelos.Errores.no_se_puede_eliminar_registro'))
      return false
    end
  end
                
  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end

end
# == Schema Information
#
# Table name: empresa_sistema
#
#  id                  :integer         not null, primary key
#  rif                 :string(12)      not null
#  nombre_corto        :string(50)      not null
#  nombre              :string(100)     not null
#  direccion           :string(300)     not null
#  telefono            :string(11)      not null
#  representante_legal :string(100)     not null
#  activo              :boolean         default(TRUE)
#

