# encoding: utf-8

#
# autor: Luis Rojas
# clase: SolicitudAspectosEvaluar
# descripción: Migración a Rails 3
#
class SolicitudAspectosEvaluar < ActiveRecord::Base
  
  self.table_name = 'solicitud_aspectos_evaluar'
  
  attr_accessible :id, :solicitud_id, :aspectos_resguardo_institucional_id, :evaluado, :tipo

  belongs_to :solicitud
  belongs_to :aspectos_resguardo_institucional

  validates_presence_of :solicitud_id,
    :message => "^ Número de Solicitud es requerido"

  validates_presence_of :aspectos_resguardo_institucional_id,
    :message => "^ Aspecto a Evaluar es requerido"

  def actualizar_credito
    total = SolicitudAspectosEvaluar.count(:conditions=>["tipo = 'A' and solicitud_id = ?", self.solicitud_id])
    check = SolicitudAspectosEvaluar.count(:conditions=>["tipo = 'A' and evaluado = true and solicitud_id = ?", self.solicitud_id])
    return (100 * check) / total
  end

  def actualizar_resguardo
    total = SolicitudAspectosEvaluar.count(:conditions=>["tipo = 'R' and solicitud_id = ?", self.solicitud_id]) + 1
    check = SolicitudAspectosEvaluar.count(:conditions=>["tipo = 'R' and evaluado = true and solicitud_id = ?", self.solicitud_id])
    if SolicitudResguardo.count(:conditions=>['solicitud_id = ?', self.solicitud_id]) > 0
      check += 1
    end
    return (100 * check) / total
  end
  
  def self.search(search, page, orden)
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden, :include => [:sub_rubro, :actividad, :scoring_aceptacion, :comite, :estatus, :origen_fondo, :region, :unidad_produccion, :ciudad, :municipio, :parroquia, :causa_rechazo, :causa_diferimiento, :modalidad_financiamiento, :sector, :sub_sector, :rubro, :oficina, :cliente, :programa, :partida_presupuestaria]
  end

end


# == Schema Information
#
# Table name: solicitud_aspectos_evaluar
#
#  id                                  :integer         not null, primary key
#  solicitud_id                        :integer         not null
#  aspectos_resguardo_institucional_id :integer         not null
#  evaluado                            :boolean         default(FALSE)
#  tipo                                :string(1)       default("A")
#

