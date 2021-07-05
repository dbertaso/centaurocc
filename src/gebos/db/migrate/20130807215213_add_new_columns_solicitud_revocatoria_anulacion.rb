# encoding: utf-8

class AddNewColumnsSolicitudRevocatoriaAnulacion < ActiveRecord::Migration
  def up
    
    execute "
              ALTER TABLE solicitud ADD COLUMN fecha_aprobacion_oficio_revocatoria_anulacion date;
              ALTER TABLE solicitud ADD COLUMN numero_oficio_revocatoria_anulacion character varying(20);
              
              COMMENT ON COLUMN solicitud.fecha_aprobacion_oficio_revocatoria_anulacion IS 'Atributo usado para registrar la fecha del oficio por la cual se aprobó la anulación o revocatoria del trámite';
              COMMENT ON COLUMN solicitud.numero_oficio_revocatoria_anulacion IS 'Atributo usado para registrar el número de oficio por la cual se aprobó la anulación o revocatoria del trámite';
            "

  end

  def down
  end
end
