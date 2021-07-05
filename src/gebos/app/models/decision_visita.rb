# encoding: utf-8
class DecisionVisita < ActiveRecord::Base
  
  self.table_name = 'decision_visita'
  
  attr_accessible :id, 
    :seguimiento_visita_id,
    :labor_visitas_previas,
    :continuidad_financiamiento,
    :caso_medida_id,
    :justificacion,
    :labores_por_realizar,
    :recomendaciones,
    :recomienda_generar_desembolso

  belongs_to :seguimiento_visita
  belongs_to :caso_medida

  validates :seguimiento_visita_id, :presence => {
    :message => I18n.t('Sistema.Body.Modelos.DescripcionesEspecificas.Errores.presence_seguimiento_visita')}


  def validar_casos_medidas(params)
    success = true
    casos_medidas = params[:decision_visita][:casos_medidas_id]
    justificacion = params[:decision_visita][:justificacion]
    unless casos_medidas.nil? || casos_medidas.empty?
      if justificacion.empty?
        errors.add(:decision_visita, I18n.t('Sistema.Body.Modelos.DecisionVisita.Errores.justificacion_requerida'))
        success = false
      end
    end
    return success
  end

  def validar_recomendacion
    if self.recomienda_generar_desembolso == false
      desembolso = Desembolso.find_by_seguimiento_visita_id(self.seguimiento_visita_id)
      unless desembolso.nil?
        ActiveRecord::Base.connection.execute("delete from desembolso_detalle where desembolso_id = #{desembolso.id}")
        ActiveRecord::Base.connection.execute("delete from desembolso where id = #{desembolso.id}")
      end
      despacho = OrdenDespacho.find_by_seguimiento_visita_id(self.seguimiento_visita_id)
      unless despacho.nil?
        ActiveRecord::Base.connection.execute("delete from orden_despacho_detalle where orden_despacho_id = #{despacho.id}")
        ActiveRecord::Base.connection.execute("delete from orden_despacho where id = #{despacho.id}")
      end

    end

  end


end





# == Schema Information
#
# Table name: decision_visita
#
#  id                            :integer         not null, primary key
#  seguimiento_visita_id         :integer         not null
#  labor_visitas_previas         :boolean         default(FALSE), not null
#  continuidad_financiamiento    :boolean         default(TRUE), not null
#  caso_medida_id                :integer
#  justificacion                 :text
#  labores_por_realizar          :text
#  recomendaciones               :text
#  recomienda_generar_desembolso :boolean         default(FALSE), not null
#

