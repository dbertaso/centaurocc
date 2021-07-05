# encoding: utf-8

#
# 
# clase: ViewReestructuracionDetalle
# descripción: Migración a Rails 3
#

class ViewReestructuracionDetalle < ActiveRecord::Base

  self.table_name = 'view_reestructuracion_detalle'
  
  attr_accessible :solicitud_nueva_id,:id,:cliente_id,:numero,:programa_id,:fecha_solicitud,:fecha_registro,:monto_solicitado,:monto_aprobado,:nombre_proyecto,:objetivo_proyecto,:justificacion,:aporte_social,:monto_propuesta_social,:estatus,:numero_comite_estadal,:numero_comite_nacional,:fecha_comite_estadal,:fecha_comite_nacional,:fecha_solicitud_desembolso,:comentario_directorio,:causa_rechazo_id,:causa_diferimiento_id,:parroquia_id,:ciudad_id,:municipio_id,:estatus_directorio,:intermediado,:modalidad_financiamiento_id,:origen_fondo_id,:porcentaje_cooperativa,:porcentaje_empresa,:monto_cliente,:liberada,:causa_liberacion,:aumento_capital,:estatus_comite,:estatus_modificacion,:estatus_comite_temporal,:causa_diferimiento_comite_id,:migrado_d3,:causa_rechazo_comite_id,:codigo_d3,:codigo_presupuesto_d3,:descripcion_presupuesto_d3,:tipo_comite,:tir,:van,:tiempo_recuperacion,:estatus_id,:fecha_actual_estatus,:fecha_firma_contrato,:cuenta_matriz_id,:numero_origen,:banco_origen,:transcriptor,:fecha_aprobacion,:fecha_liquidacion,:ups_id,:observacion,:numero_grupo,:numero_empresa,:control,:mision_id,:analista_consejo,:comite_id,:decision_comite,:comentario_comite,:numero_acta_resumen_comite,:estatus_desembolso_id,:control_certificacion,:control_disponibilidad,:numero_acta_liquidacion,:fecha_acta_liquidacion,:region_id,:certificado_presupuesto,:monto_analista,:scoring_aceptacion_id,:monto_actuales,:monto_proyecto,:calificacion_cuantitativa,:calificacion_cualitativa,:calificacion_social,:destino_credito,:tipo_iniciativa_id,:usuario_pre_evaluacion,:partida_presupuestaria_id,:consultoria,:decision_final,:confirmacion,:avaluo_obra_civil,:usuario_resguardo,:reestructuracion_solicitud_id,:monto_ampliacion,:no_visto,:oficina_id,:unidad_produccion_id,:sector_id,:sub_sector_id,:rubro_id,:empresa_integrante_id,:instancia_comite,:decision_comite_estadal,:decision_comite_nacional,:comite_estadal_id,:comentario_comite_estadal,:comentario_comite_nacional,:hectareas_recomendadas,:semovientes_recomendados,:folio_autenticacion,:tomo_autenticacion,:abogado_id,:codigo_sras,:enviado_suscripcion,:ruta_contrato,:ruta_acta_entrega,:ruta_nota_autenticacion,:fecha_nota_autenticacion,:hectareas_solicitadas,:semovientes_solicitados,:por_inventario,:fecha_a_entrega,:conf_maquinaria,:sub_rubro_id,:actividad_id,:rubro

end



# == Schema Information
#
# Table name: view_reestructuracion_detalle
#
#  solicitud_nueva_id            :integer
#  id                            :integer
#  cliente_id                    :integer
#  numero                        :integer
#  programa_id                   :integer
#  fecha_solicitud               :date
#  fecha_registro                :date
#  monto_solicitado              :float
#  monto_aprobado                :float
#  nombre_proyecto               :string(400)
#  objetivo_proyecto             :string(400)
#  justificacion                 :text
#  aporte_social                 :float
#  monto_propuesta_social        :float
#  estatus                       :string(1)
#  numero_comite_estadal         :string(20)
#  numero_comite_nacional        :string(15)
#  fecha_comite_estadal          :date
#  fecha_comite_nacional         :date
#  fecha_solicitud_desembolso    :date
#  comentario_directorio         :string(400)
#  causa_rechazo_id              :integer
#  causa_diferimiento_id         :integer
#  parroquia_id                  :integer
#  ciudad_id                     :integer
#  municipio_id                  :integer
#  estatus_directorio            :string(1)
#  intermediado                  :boolean
#  modalidad_financiamiento_id   :integer
#  origen_fondo_id               :integer
#  porcentaje_cooperativa        :float
#  porcentaje_empresa            :float
#  monto_cliente                 :float
#  liberada                      :boolean
#  causa_liberacion              :string(1)
#  aumento_capital               :float
#  estatus_comite                :string(1)
#  estatus_modificacion          :string(1)
#  estatus_comite_temporal       :string(1)
#  causa_diferimiento_comite_id  :integer
#  migrado_d3                    :boolean
#  causa_rechazo_comite_id       :integer
#  codigo_d3                     :string(10)
#  codigo_presupuesto_d3         :string(2)
#  descripcion_presupuesto_d3    :string(100)
#  tipo_comite                   :string(1)
#  tir                           :decimal(16, 2)
#  van                           :decimal(16, 2)
#  tiempo_recuperacion           :integer
#  estatus_id                    :integer
#  fecha_actual_estatus          :date
#  fecha_firma_contrato          :date
#  cuenta_matriz_id              :integer
#  numero_origen                 :integer
#  banco_origen                  :string(25)
#  transcriptor                  :string(25)
#  fecha_aprobacion              :date
#  fecha_liquidacion             :date
#  ups_id                        :integer
#  observacion                   :string(250)
#  numero_grupo                  :integer
#  numero_empresa                :integer
#  control                       :boolean
#  mision_id                     :integer
#  analista_consejo              :string(25)
#  comite_id                     :integer
#  decision_comite               :string(1)
#  comentario_comite             :string(400)
#  numero_acta_resumen_comite    :string(15)
#  estatus_desembolso_id         :integer
#  control_certificacion         :boolean
#  control_disponibilidad        :boolean
#  numero_acta_liquidacion       :string(15)
#  fecha_acta_liquidacion        :date
#  region_id                     :integer
#  certificado_presupuesto       :boolean
#  monto_analista                :float
#  scoring_aceptacion_id         :integer
#  monto_actuales                :float
#  monto_proyecto                :float
#  calificacion_cuantitativa     :float
#  calificacion_cualitativa      :float
#  calificacion_social           :float
#  destino_credito               :string(400)
#  tipo_iniciativa_id            :integer
#  usuario_pre_evaluacion        :string(30)
#  partida_presupuestaria_id     :integer
#  consultoria                   :boolean
#  decision_final                :boolean
#  confirmacion                  :boolean
#  avaluo_obra_civil             :boolean
#  usuario_resguardo             :string(30)
#  reestructuracion_solicitud_id :integer(8)
#  monto_ampliacion              :decimal(16, 2)
#  no_visto                      :boolean
#  oficina_id                    :integer
#  unidad_produccion_id          :integer
#  sector_id                     :integer
#  sub_sector_id                 :integer
#  rubro_id                      :integer
#  empresa_integrante_id         :integer
#  instancia_comite              :boolean
#  decision_comite_estadal       :string(1)
#  decision_comite_nacional      :string(1)
#  comite_estadal_id             :integer
#  comentario_comite_estadal     :text
#  comentario_comite_nacional    :text
#  hectareas_recomendadas        :decimal(14, 3)
#  semovientes_recomendados      :decimal(14, 2)
#  folio_autenticacion           :integer
#  tomo_autenticacion            :integer
#  abogado_id                    :integer
#  codigo_sras                   :integer(8)
#  enviado_suscripcion           :boolean
#  ruta_contrato                 :text
#  ruta_acta_entrega             :text
#  ruta_nota_autenticacion       :text
#  fecha_nota_autenticacion      :date
#  hectareas_solicitadas         :float
#  semovientes_solicitados       :integer
#  por_inventario                :boolean
#  fecha_a_entrega               :date
#  conf_maquinaria               :boolean
#  sub_rubro_id                  :integer
#  actividad_id                  :integer
#  rubro                         :string(100)
#

