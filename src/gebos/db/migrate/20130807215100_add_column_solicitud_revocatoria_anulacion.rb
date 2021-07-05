# encoding: utf-8

class AddColumnSolicitudRevocatoriaAnulacion < ActiveRecord::Migration
  def up
    
    execute "
              ALTER TABLE solicitud ADD COLUMN fecha_hora_revocatoria_anulacion timestamp without time zone;
              ALTER TABLE solicitud ADD COLUMN usuario_responsable_revocatoria_anulacion integer;
              ALTER TABLE solicitud ADD COLUMN causa_revocatoria_anulacion text;
              ALTER TABLE solicitud ADD COLUMN justificacion_revocatoria_anulacion text;
              
              COMMENT ON COLUMN solicitud.fecha_hora_revocatoria_anulacion IS 'Atributo usado para registrar la hora y fecha en que se haga una anulación o revocatoria del trámite';
              COMMENT ON COLUMN solicitud.usuario_responsable_revocatoria_anulacion IS 'Atributo usado para registrar el usuario que hizo la anulación o revocatoria del trámite';
              COMMENT ON COLUMN solicitud.causa_revocatoria_anulacion IS 'Atributo usado para registrar la causa por la cual se hizo la anulación o revocatoria del trámite';
              COMMENT ON COLUMN solicitud.justificacion_revocatoria_anulacion IS 'Atributo usado para registrar la justificación por la cual se hizo la anulación o revocatoria del trámite';
            "

  end

  def down
  end
end
