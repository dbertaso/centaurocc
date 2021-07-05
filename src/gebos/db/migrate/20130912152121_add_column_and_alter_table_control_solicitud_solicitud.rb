# encoding: utf-8
class AddColumnAndAlterTableControlSolicitudSolicitud < ActiveRecord::Migration
  def up
  
  execute "
ALTER TABLE solicitud ADD COLUMN referencia_revocatoria_liquidacion character varying(100);
COMMENT ON COLUMN solicitud.referencia_revocatoria_liquidacion IS 'Campo de referencia del pago de la transferencia o del cheque que se hizo administrativamente antes de revocar parcialmente el trámite';
ALTER TABLE solicitud ADD COLUMN fecha_pago_revocatoria_liquidacion date;
COMMENT ON COLUMN solicitud.fecha_pago_revocatoria_liquidacion IS 'Campo donde se especifica la fecha real del pago de la transferencia o cheque que se hizo administrativamente antes de revocar parcialmente el trámite';

DROP VIEW if exists view_consulta_evento;
    
    ALTER TABLE control_solicitud
   ALTER COLUMN comentario TYPE character varying(1800);
    
    CREATE OR REPLACE VIEW view_consulta_evento AS
    SELECT control_solicitud.solicitud_id, control_solicitud.accion AS accion2, control_solicitud.fecha AS fecha_evento, estatus_origen.nombre AS estatus_origen, estatus_destino.nombre AS estatus_destino, 
        CASE
            WHEN diferimiento_renuncia.causa_diferimiento_id IS NOT NULL THEN 'Diferimiento'::text
            WHEN diferimiento_renuncia.causa_renuncia_id IS NOT NULL THEN 'Renuncia'::text
            WHEN control_solicitud.estatus_id < control_solicitud.estatus_origen_id THEN 'Deshacer'::text
            ELSE 'Avance'::text
        END AS accion, control_solicitud.comentario AS observacion, usuario.nombre_usuario AS cuenta_usuario
   FROM control_solicitud
   LEFT JOIN diferimiento_renuncia ON diferimiento_renuncia.control_solicitud_id = control_solicitud.id
   LEFT JOIN estatus estatus_origen ON estatus_origen.id = control_solicitud.estatus_origen_id
   LEFT JOIN estatus estatus_destino ON estatus_destino.id = control_solicitud.estatus_id
   JOIN usuario ON usuario.id = control_solicitud.usuario_id;

"
  
  end

  def down
  end
end
