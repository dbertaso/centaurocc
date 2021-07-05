# encoding: utf-8
class AgrupacionMenuConfiguracion < ActiveRecord::Migration
  def up

    execute "

      update menu set nombre = 'Configuración de Reposición de Inventario'
      where nombre = 'Configuración de Existencia';

      update menu set nombre = 'Producción', orden = 8
      where nombre = 'Control de Visitas';

      update menu set nombre = 'Hierro Institucional'
      where nombre = 'Hierro Fondas';

      update menu set nombre = 'Producción' where id = 761;

      -- Borrando opción de menú duplicada

      delete from menu where id = 820;
      delete from opcion where id = 1034;
      delete from menu where id = 824
      delete from opcion where id = 1038;

      insert into menu (nombre,parent_id,orden) values ('Arrime',59,1);
      insert into menu (nombre,parent_id,orden) values ('Beneficiario',59,2);
      insert into menu (nombre,parent_id,orden) values ('Consultoría Jurídica',59,3);
      insert into menu (nombre,parent_id,orden) values ('Finanzas',59,4);
      insert into menu (nombre,parent_id,orden) values ('Garantías',59,5);
      insert into menu (nombre,parent_id,orden) values ('Maquinarias',59,6);
      insert into menu (nombre,parent_id,orden) values ('Presupuesto',59,7);

      -- Agrupación Menu Financiamiento

      update menu set parent_id = 703 where nombre = 'Causas de Renuncia';
      update menu set parent_id = 703 where nombre = 'Causales de Anulación y/o Revocatoria';
      update menu set parent_id = 703 where nombre = 'Firmas Autorizadas';
      update menu set parent_id = 703, nombre = 'Miembros de Comité' where nombre = 'Miembro de Comité';
      update menu set parent_id = 703, nombre = 'Origen de los Fondos' where nombre = 'Orígenes de Fondo';
      update menu set parent_id = 703 where nombre = 'Recaudos';
      update menu set parent_id = 703, nombre = 'Riesgo y Provisión Instiucional' where nombre = 'Riesgo y Provisión PROPIO';
      update menu set parent_id = 703, nombre = 'Riesgo y Provisión Sudeban' where nombre = 'Riesgo y Provisión SUDEBAN';
      update menu set parent_id = 703 where nombre = 'Rol en el Comité';
      update menu set parent_id = 703 where nombre = 'Tipo de Gasto';
      update menu set parent_id = 703 where nombre = 'Monedas';
      update menu set parent_id = 703 where nombre = 'Hierro Institucional';

      -- Agrupación Menu Producción

      update menu set parent_id = 761 where nombre = 'Técnico de Campo';
      update menu set parent_id = 761 where nombre = 'Especie de Variedad de Pasto';
      update menu set parent_id = 761 where nombre = 'Proveedor Marino';
      update menu set parent_id = 761 where nombre = 'Casa Proveedora';
      update menu set parent_id = 761 where nombre = 'Condición de Pasto';

      -- Agrupación Menu Consultoría Jurídica

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Consultoría Jurídica') 
      where nombre = 'Abogados';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Consultoría Jurídica') 
      where nombre = 'Editor de Contratos';

      -- Agrupación Menú Maquinaria

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Maquinarias') 
      where nombre = 'Almacén Maquinaria';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Maquinarias'),
          nombre = 'Convenios'
      where nombre = 'Convenios de Maquinarias e Equipos';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Maquinarias'),
          nombre = 'Empresas de Transporte'
      where nombre = 'Empresa de Transporte';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Maquinarias'),
          nombre = 'Imputaciones'
      where nombre = 'Imputaciones de Maquinarias';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Maquinarias'),
          nombre = 'Marca'
      where nombre = 'Marca de Maquinaria';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Maquinarias'),
          nombre = 'Modelo'
      where nombre = 'Modelo de Maquinaria';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Maquinarias') 
      where nombre = 'Registro de Inventario';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Maquinarias'),
          nombre = 'Tipo'
      where nombre = 'Tipo de Maquinarias';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Maquinarias') 
      where nombre = 'Configuración de Reposición de Inventario';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Maquinarias') 
      where nombre = 'Consulta de Facturas Confirmadas';

      -- Agrupación Menu Beneficiario

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Beneficiario') 
      where nombre = 'Comunidades Indígenas';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Beneficiario') 
      where nombre = 'Experiencia';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Beneficiario') 
      where nombre = 'Formación';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Beneficiario') 
      where nombre = 'Tipo de Documento';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Beneficiario') 
      where nombre = 'Idiomas';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Beneficiario') 
      where nombre = 'Tipo de Organización';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Beneficiario') 
      where nombre = 'Tenencia de la Unidad de Producción';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Beneficiario') 
      where nombre = 'Nacionalidad';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Beneficiario') 
      where nombre = 'País';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Beneficiario') 
      where nombre = 'Profesiones';

      -- Agrupación Menú Presupuesto

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Presupuesto' and parent_id = 59) 
      where nombre = 'Partidas Presupuestarias';

      -- Agrupación Menú Arrime

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Arrime' and parent_id = 59) 
      where nombre = 'Silo';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Arrime' and parent_id = 59) 
      where nombre = 'Gaceta Oficial';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Arrime' and parent_id = 59) 
      where nombre = 'Plantillas de Boleta';

      -- Agrupación Menú Finanzas

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Finanzas' and parent_id = 59),
          nombre = 'Cuentas en Banco'
      where nombre = 'Cuentas en bancos';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Finanzas' and parent_id = 59) 
      where nombre = 'Entidades Financieras';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Finanzas' and parent_id = 59),
          nombre = 'Instrumentos Financieros'
      where nombre = 'Instrumento Financiero';

      -- Agrupación Menú Garantías

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Garantías' and parent_id = 59),
          nombre = 'Instrumentos Financieros'
      where nombre = 'Tipo de Garantía';

      update 
          menu 
      set 
          parent_id = (select id from menu where nombre = 'Garantías' and parent_id = 59)
      where nombre = 'Peritos';

      -- Opciones que se omitirán del menú

      delete from menu where nombre = 'Tipo Movimientos Fideicomiso';
      delete from menu where nombre = 'Tipo de Crédito';
      delete from menu where nombre = 'Scoring Aceptacion';
      delete from menu where nombre = 'Recaudos de Avalúos e Inspecciones';
      delete from menu where nombre = 'Porcentaje de Ganancia';
      delete from menu where nombre = 'Modalidades de Financiamiento';
      delete from menu where nombre = 'Medidas de Financiamiento';
      delete from menu where nombre = 'Matriz de Garantías';
      delete from menu where nombre = 'Insumos Internos del Expediente';
      delete from menu where nombre = 'Condiciones de Evaluación del Crédito';
      delete from menu where nombre = 'Causas de Rechazo de Préstamos';
      delete from menu where nombre = 'Causas de Diferimiento de Préstamos';
      delete from menu where nombre = 'Causas de Devolución al Beneficiario';
      delete from menu where nombre = 'Fideicomiso';

      update opcion set nombre = 'Hierro Institucional'
      where nombre = 'Hierro Fondas';

      update menu set nombre = 'Riesgo y Provisión Institucional' where id = 612;
      update opcion set nombre = 'Riesgo y Provisión Institucional where id = 727;

      update menu orden = 10 where id = 742;
      update menu orden = 20 where id = 707;
      update menu orden = 30 where id = 730;
      update menu orden = 40 where id = 733;
      update menu orden = 50 where id = 715;
      update menu orden = 60 where id = 714;
      update menu orden = 70 where id = 818;
      update menu orden = 80 where id = 734;
      update menu orden = 90 where id = 762;
      update menu orden = 100 where id = 755;
      update menu orden = 110 where id = 749;
      update menu orden = 120 where id = 746;
      update menu orden = 130 where id = 719;
      update menu orden = 140 where id = 756;
      update menu orden = 150 where id = 747;
      update menu orden = 160 where id = 631;
      update menu orden = 170 where id = 739;
      update menu orden = 180 where id = 735;
      update menu orden = 190 where id = 639;
      update menu orden = 200 where id = 711;
      update menu orden = 210 where id = 712;
      update menu orden = 220 where id = 722;
      update menu orden = 230 where id = 731;
      update menu orden = 240 where id = 745;
      update menu orden = 250 where id = 748;
      update menu orden = 260 where id = 737;
      update menu orden = 270 where id = 736;
      update menu orden = 280 where id = 738;
      update menu orden = 290 where id = 708;
      update menu orden = 300 where id = 627;
      update menu orden = 310 where id = 743;
      update menu orden = 320 where id = 732;
      update menu orden = 330 where id = 717;

      update menu orden = 10 where id = 851;
      update menu orden = 20 where id = 513;
      update menu orden = 30 where id = 709;
      update menu orden = 40 where id = 728;
      update menu orden = 50 where id = 727;
      update menu orden = 60 where id = 686;
      update menu orden = 70 where id = 753;
      update menu orden = 80 where id = 597;
      update menu orden = 90 where id = 861;
      update menu orden = 100 where id = 68;
      update menu orden = 110 where id = 62;
      update menu orden = 120 where id = 612;
      update menu orden = 130 where id = 611;
      update menu orden = 140 where id = 822;
      update menu orden = 150 where id = 704;
      update menu orden = 160 where id = 65;
      update menu orden = 170 where id = 706;

      update menu set orden = 10 where id = 877;
      update menu set orden = 20 where id = 878;
      update menu set orden = 30 where id = 879;
      update menu set orden = 40 where id = 689;
      update menu set orden = 50 where id = 703;
      update menu set orden = 60 where id = 880;
      update menu set orden = 70 where id = 881;
      update menu set orden = 80 where id = 882;
      update menu set orden = 90 where id = 883;
      update menu set orden = 100 where id = 761;

    "
  end

  def down
  end
end
