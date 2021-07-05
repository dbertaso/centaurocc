# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Estatus
# descripcion: Migracion a Rails 3
#
class Estatus < ActiveRecord::Base

  self.table_name = 'estatus'

  attr_accessible :id, 
                  :nombre, 
                  :descripcion,
                  :area, 
                  :const_id,
                  :activo


  has_many :solicitud

  validates :nombre,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}

  def self.search(search, page, sort)
    paginate  :per_page => @records_by_page, 
              :page => page,
              :conditions => search, 
              :order => sort
  end
  
end


# == Schema Information
#
# Table name: estatus
#
#  id          :integer         not null, primary key
#  nombre      :text            not null
#  descripcion :string(200)     not null
#  area        :string(100)
#  const_id    :string(6)
#  activo      :boolean         default(FALSE)
#

