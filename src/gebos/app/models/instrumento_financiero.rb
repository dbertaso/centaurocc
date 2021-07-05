# encoding: utf-8
#
# autor: Diego Bertaso
# clase: InstrumentoFinanciero
# descripción: Migración a Rails 3
#

class InstrumentoFinanciero < ActiveRecord::Base

  self.table_name = 'instrumento_financiero'

  attr_accessible :id,
                  :descripcion,
                  :activo,
                  :descripcion_f

  validate :descripcion, 
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length =>  {
                  :in => 1..25, 
                    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.descripcion')}  #{I18n.t('errors.messages.too_short.other')}",
                    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.descripcion')}  #{I18n.t('errors.messages.too_long.other')}"
                },
    :uniqueness =>  {:message=> "#{I18n.t('Sistema.Body.Vistas.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
                    }
  
  def descripcion_f=(descripcion)
    self.descripcion = descripcion.upcase
  end
    
  def descripcion_f
    self.descripcion.upcase unless self.descripcion.nil?
  end
  
  def after_initialize
    if new_record?
      self.activo = true
    end
  end

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end

end

# == Schema Information
#
# Table name: instrumento_financiero
#
#  id          :integer         not null, primary key
#  descripcion :string(25)      not null
#  activo      :boolean         not null
#

