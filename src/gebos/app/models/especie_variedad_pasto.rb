# encoding: utf-8

#
# autor: Diego Bertaso
# clase: EspecieVariedadPasto
# descripción: Migración a Rails 3
#
class EspecieVariedadPasto < ActiveRecord::Base

  self.table_name = 'especie_variedad_pasto'

  attr_accessible :id,
                  :descripcion,
                  :tipo_pasto_forraje_id

  belongs_to :tipo_pasto_forraje
  has_one :pastizales_potreros


    validates :tipo_pasto_forraje_id,
    :presence => {:message => I18n.t('Sistema.Body.Controladores.EspecieVariedadPasto.FormTitles.form_title_record') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}

    validates_length_of :descripcion, :within => 4..100, :allow_nil => false,
    :too_long => I18n.t('Sistema.Body.General.descripcion')  << " " << I18n.t('errors.messages.too_long.other').to_s,
  :too_short => I18n.t('Sistema.Body.General.descripcion')  << " " <<  I18n.t('errors.messages.too_short.other').to_s

  validates :descripcion,
    :uniqueness=>{:message => I18n.t('Sistema.Body.General.descripcion') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort, :include => [:tipo_pasto_forraje]
  end

end


# == Schema Information
#
# Table name: especie_variedad_pasto
#
#  id                    :integer         not null, primary key
#  descripcion           :string(30)      not null
#  tipo_pasto_forraje_id :integer
#

