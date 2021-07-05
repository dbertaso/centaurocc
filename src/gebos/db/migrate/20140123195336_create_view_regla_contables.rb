class CreateViewReglaContables < ActiveRecord::Migration
  def change

    execute "

              DROP VIEW if exists view_regla_contable;
              
              CREATE VIEW view_regla_contable as
                  SELECT rc.id as rc_id, 
                         fuente_recursos_id, 
                         estatus,
                         secuencia,
                         tipo_movimiento, 
                         codigo_contable,
                         cc.nombre as codigo_descripcion,
                         rc.auxiliar_contable as auxiliar_contable,
                         tipo_monto, 
                         modalidad_pago, 
                         entidad_financiera_id,
                         case
                          when ef.nombre isnull
                          then 'no aplica'
                          else ef.nombre
                         end as entidad_nombre,
                         reestructurado, 
                         programa_id, 
                         transaccion_contable_id, 
                         plazos,
                         programa.nombre as programa_nombre,
                         moneda.nombre as moneda_nombre,
                         moneda.abreviatura as moneda_abreviatura,
                         tc.nombre as nombre_transaccion
                    FROM regla_contable rc
                          inner join programa on (rc.programa_id = programa.id)
                          inner join moneda on (programa.moneda_id = moneda.id)
                          inner join transaccion_contable tc on (rc.transaccion_contable_id = tc.id)
                          inner join cuenta_contable cc on (cc.codigo = rc.codigo_contable)
                          left join entidad_financiera ef on (rc.entidad_financiera_id = ef.id);
    "
  end
end
