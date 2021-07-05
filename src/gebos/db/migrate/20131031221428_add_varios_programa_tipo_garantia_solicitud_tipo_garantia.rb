class AddVariosProgramaTipoGarantiaSolicitudTipoGarantia < ActiveRecord::Migration
  def up
    execute"
    --LA TABLA PROGRAMA TIPO GASTO NO TENIA PRIMARY KEY Y REVENTABA

ALTER TABLE programa_tipo_gasto ADD PRIMARY KEY (id);

--SE AGREGO RELACION GARANTIA A PROGRAMA TIPO GARANTIA

ALTER TABLE programa_tipo_garantia ADD COLUMN relacion_garantia numeric(16,2) DEFAULT 0;

--SE AGREGARON COLUMNAS A LA TABLA SOLICITUD TIPO GARANTIA

ALTER TABLE solicitud_tipo_garantia ADD COLUMN relacion_garantia double precision DEFAULT 0;
ALTER TABLE solicitud_tipo_garantia ADD COLUMN programa_tipo_garantia_id integer;
ALTER TABLE solicitud_tipo_garantia ALTER COLUMN tipo_garantia_id DROP NOT NULL;

ALTER TABLE solicitud_tipo_garantia DROP CONSTRAINT fk_solicitud_tipo_garantia;
ALTER TABLE solicitud_tipo_garantia ADD FOREIGN KEY (programa_tipo_garantia_id) REFERENCES programa_tipo_garantia (id) ON UPDATE NO ACTION ON DELETE NO ACTION;
   
    "
  end

  def down
  end
end
