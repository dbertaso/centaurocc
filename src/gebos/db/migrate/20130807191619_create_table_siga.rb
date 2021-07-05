class CreateTableSiga < ActiveRecord::Migration
  def up
  execute "  

    DROP TABLE IF EXISTS siga_causado;
    DROP TABLE IF EXISTS SIGA_causado;
    DROP TABLE IF EXISTS siga_compromiso;
    DROP TABLE IF EXISTS SIGA_compromiso;
    DROP TABLE IF EXISTS siga_pagado;
    DROP TABLE IF EXISTS SIGA_pagado;
    
    
CREATE TABLE siga_causado
(
  id serial NOT NULL,
  fecha date NOT NULL, -- Fecha de registro del causado
  numero_solicitud integer NOT NULL, -- Numero del tramite
  numero_prestamo bigint NOT NULL, -- Numero del prestamos asociado al tramite
  rif_ci character varying(15) NOT NULL, -- Rif o cedula de identidad del beneficiario
  nombre_beneficiario character varying(255) NOT NULL, -- Nombre del Beneficiario asociado al tramite
  monto numeric(16,2) NOT NULL DEFAULT 0, -- monto causado, monto del desembolso
  forma_desembolso character(1) NOT NULL, -- Tipo de desembolso T=Transferencia, I=Insumo
  tipo_transaccion character(1) NOT NULL, -- Tipo Transaccion  C=Causado, R=Reverso
  registrado boolean NOT NULL DEFAULT false, -- Marca que indica cuando SIGA ha procesado el registro
  fecha_registro date, -- Fecha en que SIGA procesa el registro
  CONSTRAINT siga_causado_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE siga_causado
  IS 'Tabla para el registro de la informacion que servira de insumo al sistema SIGA para la generacion del causado';
COMMENT ON COLUMN siga_causado.fecha IS 'Fecha de registro del causado';
COMMENT ON COLUMN siga_causado.numero_solicitud IS 'Numero del tramite';
COMMENT ON COLUMN siga_causado.numero_prestamo IS 'Numero del prestamos asociado al tramite';
COMMENT ON COLUMN siga_causado.rif_ci IS 'Rif o cedula de identidad del beneficiario';
COMMENT ON COLUMN siga_causado.nombre_beneficiario IS 'Nombre del Beneficiario asociado al tramite';
COMMENT ON COLUMN siga_causado.monto IS 'monto causado, monto del desembolso';
COMMENT ON COLUMN siga_causado.forma_desembolso IS 'Tipo de desembolso T=Transferencia, I=Insumo';
COMMENT ON COLUMN siga_causado.tipo_transaccion IS 'Tipo Transaccion  C=Causado, R=Reverso';
COMMENT ON COLUMN siga_causado.registrado IS 'Marca que indica cuando SIGA ha procesado el registro';
COMMENT ON COLUMN siga_causado.fecha_registro IS 'Fecha en que SIGA procesa el registro';


CREATE TABLE siga_compromiso
(
  id serial NOT NULL,
  fecha date NOT NULL, -- Fecha de registro del compromiso
  numero_solicitud integer NOT NULL, -- Numero del tramite
  nombre_programa character varying(255) NOT NULL, -- Nombre del Programa asociado al tramite
  cuenta_presupuestaria character varying(20) NOT NULL, -- cuenta presupuestaria
  monto numeric(16,2) NOT NULL DEFAULT 0, -- monto aprobado de la solicitud
  rif_ci character varying(15) NOT NULL, -- Rif o cedula de identidad del beneficiario
  nombre_beneficiario character varying(255) NOT NULL, -- Nombre del Beneficiario asociado al tramite
  tipo_transaccion character(1) NOT NULL, -- Tipo Transaccion C=Compromiso, R=Reverso
  registrado boolean NOT NULL DEFAULT false, -- Marca que indica cuando SIGA ha procesado el registro
  fecha_registro date, -- Fecha en que SIGA procesa el registro
  CONSTRAINT siga_compromiso_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE siga_compromiso
  IS 'Tabla para el registro de la informacion que servira de insumo al sistema SIGA para la generacion del compromiso';
COMMENT ON COLUMN siga_compromiso.fecha IS 'Fecha de registro del compromiso';
COMMENT ON COLUMN siga_compromiso.numero_solicitud IS 'Numero del tramite';
COMMENT ON COLUMN siga_compromiso.nombre_programa IS 'Nombre del Programa asociado al tramite';
COMMENT ON COLUMN siga_compromiso.cuenta_presupuestaria IS 'cuenta presupuestaria';
COMMENT ON COLUMN siga_compromiso.monto IS 'monto aprobado de la solicitud';
COMMENT ON COLUMN siga_compromiso.rif_ci IS 'Rif o cedula de identidad del beneficiario';
COMMENT ON COLUMN siga_compromiso.nombre_beneficiario IS 'Nombre del Beneficiario asociado al tramite';
COMMENT ON COLUMN siga_compromiso.tipo_transaccion IS 'Tipo Transaccion C=Compromiso, R=Reverso';
COMMENT ON COLUMN siga_compromiso.registrado IS 'Marca que indica cuando SIGA ha procesado el registro';
COMMENT ON COLUMN siga_compromiso.fecha_registro IS 'Fecha en que SIGA procesa el registro';


CREATE TABLE siga_pagado
(
  id serial NOT NULL,
  numero_solicitud integer NOT NULL, -- Numero del tramite
  numero_prestamo bigint NOT NULL, -- Numero del prestamos asociado al tramite
  cuenta_presupuestaria character varying(20) NOT NULL, -- Cuenta presupuestaria
  forma_desembolso character(1) NOT NULL, -- Tipo de desembolso T=Transferencia, I=Insumo
  tipo_transaccion character(1) NOT NULL, -- Tipo Transaccion P=Pagado, R=Reverso
  rif_ci character varying(15) NOT NULL, -- Rif o cedula de identidad del beneficiario
  nombre_beneficiario character varying(255) NOT NULL, -- Nombre del Beneficiario asociado al tramite
  monto numeric(16,2) NOT NULL DEFAULT 0, -- Monto pagado
  fecha date, -- Fecha del cheque emitido por SIGA o fecha efectiva de la transferencia
  nro_orden_pago character varying(15), -- Numero Orden de Pago que genero SIGA
  nro_cheque character varying(15), -- Numero de cheque emitido por SIGA
  entidad_financiera character varying(100), -- Nombre del Banco de emision del cheque, dato generado por el Sistema SIGA
  registrado boolean NOT NULL DEFAULT false, -- Marca que indica cuando GEBOS EZ ha procesado el registro
  fecha_registro date, -- Fecha en que GEBOS EZ procesa el registro
  fecha_actualizacion_siga date, -- Fecha en que SIGA actualiza el registro
  CONSTRAINT siga_pagado_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE siga_pagado
  IS 'Tabla para el registro de la informacion por parte de SIGA y que servira de insumo al sistema GEBOS EZ para el pagado';
COMMENT ON COLUMN siga_pagado.numero_solicitud IS 'Numero del tramite';
COMMENT ON COLUMN siga_pagado.numero_prestamo IS 'Numero del prestamos asociado al tramite';
COMMENT ON COLUMN siga_pagado.cuenta_presupuestaria IS 'Cuenta presupuestaria';
COMMENT ON COLUMN siga_pagado.forma_desembolso IS 'Tipo de desembolso T=Transferencia, I=Insumo';
COMMENT ON COLUMN siga_pagado.tipo_transaccion IS 'Tipo Transaccion P=Pagado, R=Reverso';
COMMENT ON COLUMN siga_pagado.rif_ci IS 'Rif o cedula de identidad del beneficiario';
COMMENT ON COLUMN siga_pagado.nombre_beneficiario IS 'Nombre del Beneficiario asociado al tramite';
COMMENT ON COLUMN siga_pagado.monto IS 'Monto pagado';
COMMENT ON COLUMN siga_pagado.fecha IS 'Fecha del cheque emitido por SIGA o fecha efectiva de la transferencia';
COMMENT ON COLUMN siga_pagado.nro_orden_pago IS 'Numero Orden de Pago que genero SIGA';
COMMENT ON COLUMN siga_pagado.nro_cheque IS 'Numero de cheque emitido por SIGA';
COMMENT ON COLUMN siga_pagado.entidad_financiera IS 'Nombre del Banco de emision del cheque, dato generado por el Sistema SIGA';
COMMENT ON COLUMN siga_pagado.registrado IS 'Marca que indica cuando GEBOS EZ ha procesado el registro';
COMMENT ON COLUMN siga_pagado.fecha_registro IS 'Fecha en que GEBOS EZ procesa el registro';
COMMENT ON COLUMN siga_pagado.fecha_actualizacion_siga IS 'Fecha en que SIGA actualiza el registro';


"
  end

  def down
	execute "DROP table siga_causado;
    DROP table SIGA_causado;
    DROP TABLE  siga_compromiso;
    DROP TABLE  siga_pagado;"
  end
end
