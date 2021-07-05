# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20200725021812) do

  create_table "abogado", :force => true do |t|
    t.string  "nombre",       :limit => 100
    t.string  "impreabogado", :limit => 15
    t.string  "cedula",       :limit => 10
    t.integer "oficina_id"
    t.string  "telefono",     :limit => 20
    t.boolean "activo"
  end

  create_table "accion", :force => true do |t|
    t.string "nombre",         :limit => 50, :null => false
    t.string "nombre_sistema", :limit => 50, :null => false
  end

  create_table "accion_contable", :force => true do |t|
    t.integer "condicion_contable_id",                                 :null => false
    t.integer "cuenta_contable_id"
    t.integer "campo_cuenta_id"
    t.integer "campo_contable_id",                                     :null => false
    t.integer "orden",                                                 :null => false
    t.string  "tipo",                  :limit => 1,                    :null => false
    t.boolean "cuenta_por_campo",                   :default => false
  end

  create_table "acta", :id => false, :force => true do |t|
    t.integer "id",                      :null => false
    t.string  "tipo_acta", :limit => 25
    t.text    "contenido"
  end

  create_table "acta_directorio_ejecutivo", :id => false, :force => true do |t|
    t.integer "acta_directorio_ejecutivo_id", :limit => 8, :null => false
    t.text    "base1"
    t.text    "base2"
    t.text    "base3"
    t.integer "id",                                        :null => false
  end

  create_table "acta_silo", :force => true do |t|
    t.integer "silo_id",             :null => false
    t.integer "ciclo_productivo_id", :null => false
    t.integer "nro_acta"
    t.date    "fecha_inicio",        :null => false
    t.date    "fecha_fin"
    t.boolean "status"
    t.integer "actividad_id"
  end

  create_table "actividad", :force => true do |t|
    t.string  "nombre",              :limit => 150,                    :null => false
    t.string  "descripcion",         :limit => 300,                    :null => false
    t.boolean "activo",                             :default => true
    t.integer "codigo_d3"
    t.boolean "paquete",                            :default => false
    t.boolean "paquetizado",                        :default => false
    t.integer "ciclo_productivo_id"
    t.integer "codigo",                             :default => 0
    t.integer "sub_rubro_id"
    t.string  "plazo_ciclo",         :limit => 1
  end

  add_index "actividad", ["sub_rubro_id", "nombre"], :name => "actividad_uq_nombre"

  create_table "actividad_economica", :force => true do |t|
    t.string  "ciiu",                :limit => 4,   :null => false
    t.string  "descripcion",         :limit => 500, :null => false
    t.integer "sector_economico_id",                :null => false
    t.integer "sector_tipo_id"
  end

  create_table "actividad_oficina", :force => true do |t|
    t.integer "actividad_id",                   :null => false
    t.integer "oficina_id",                     :null => false
    t.boolean "activo",       :default => true, :null => false
  end

  create_table "acumulado", :id => false, :force => true do |t|
    t.integer "id",                                   :null => false
    t.integer "anio",                :default => 0,   :null => false
    t.integer "mes",                 :default => 0,   :null => false
    t.integer "trimestre",           :default => 0,   :null => false
    t.integer "semestre",            :default => 0,   :null => false
    t.integer "creditos_realizados", :default => 0,   :null => false
    t.integer "creditos_aprobados",  :default => 0,   :null => false
    t.integer "creditos_diferidos",  :default => 0,   :null => false
    t.integer "creditos_rechazados", :default => 0,   :null => false
    t.float   "monto_liquidado",     :default => 0.0, :null => false
  end

  create_table "acumulado_agrupacion_industrial", :id => false, :force => true do |t|
    t.integer "id",                                        :null => false
    t.integer "anio",                     :default => 0,   :null => false
    t.integer "mes",                      :default => 0,   :null => false
    t.integer "trimestre",                :default => 0,   :null => false
    t.integer "semestre",                 :default => 0,   :null => false
    t.integer "agrupacion_industrial_id",                  :null => false
    t.integer "creditos_realizados",      :default => 0,   :null => false
    t.integer "creditos_aprobados",       :default => 0,   :null => false
    t.integer "creditos_diferidos",       :default => 0,   :null => false
    t.integer "creditos_rechazados",      :default => 0,   :null => false
    t.float   "monto_liquidado",          :default => 0.0, :null => false
  end

  create_table "acumulado_entidad_financiera", :id => false, :force => true do |t|
    t.integer "id",                                     :null => false
    t.integer "anio",                  :default => 0,   :null => false
    t.integer "mes",                   :default => 0,   :null => false
    t.integer "trimestre",             :default => 0,   :null => false
    t.integer "semestre",              :default => 0,   :null => false
    t.integer "entidad_financiera_id",                  :null => false
    t.integer "creditos_realizados",   :default => 0,   :null => false
    t.integer "creditos_aprobados",    :default => 0,   :null => false
    t.integer "creditos_diferidos",    :default => 0,   :null => false
    t.integer "creditos_rechazados",   :default => 0,   :null => false
    t.float   "monto_liquidado",       :default => 0.0, :null => false
  end

  create_table "acumulado_programa", :id => false, :force => true do |t|
    t.integer "id",                                   :null => false
    t.integer "anio",                :default => 0,   :null => false
    t.integer "mes",                 :default => 0,   :null => false
    t.integer "trimestre",           :default => 0,   :null => false
    t.integer "semestre",            :default => 0,   :null => false
    t.integer "programa_id",                          :null => false
    t.integer "creditos_realizados", :default => 0,   :null => false
    t.integer "creditos_aprobados",  :default => 0,   :null => false
    t.integer "creditos_diferidos",  :default => 0,   :null => false
    t.integer "creditos_rechazados", :default => 0,   :null => false
    t.float   "monto_liquidado",     :default => 0.0, :null => false
  end

  create_table "acumulado_region", :id => false, :force => true do |t|
    t.integer "id",                                   :null => false
    t.integer "anio",                :default => 0,   :null => false
    t.integer "mes",                 :default => 0,   :null => false
    t.integer "trimestre",           :default => 0,   :null => false
    t.integer "semestre",            :default => 0,   :null => false
    t.integer "region_id",                            :null => false
    t.integer "creditos_realizados", :default => 0,   :null => false
    t.integer "creditos_aprobados",  :default => 0,   :null => false
    t.integer "creditos_diferidos",  :default => 0,   :null => false
    t.integer "creditos_rechazados", :default => 0,   :null => false
    t.float   "monto_liquidado",     :default => 0.0, :null => false
  end

  create_table "acumulado_tamano_empresa", :id => false, :force => true do |t|
    t.integer "id",                                                :null => false
    t.integer "anio",                             :default => 0,   :null => false
    t.integer "mes",                              :default => 0,   :null => false
    t.integer "trimestre",                        :default => 0,   :null => false
    t.integer "semestre",                         :default => 0,   :null => false
    t.string  "tamano",              :limit => 1, :default => "P"
    t.integer "creditos_realizados",              :default => 0,   :null => false
    t.integer "creditos_aprobados",               :default => 0,   :null => false
    t.integer "creditos_diferidos",               :default => 0,   :null => false
    t.integer "creditos_rechazados",              :default => 0,   :null => false
    t.float   "monto_liquidado",                  :default => 0.0, :null => false
  end

  create_table "acumulado_tipo_cliente", :id => false, :force => true do |t|
    t.integer "id",                                   :null => false
    t.integer "anio",                :default => 0,   :null => false
    t.integer "mes",                 :default => 0,   :null => false
    t.integer "trimestre",           :default => 0,   :null => false
    t.integer "semestre",            :default => 0,   :null => false
    t.integer "tipo_cliente_id",                      :null => false
    t.integer "creditos_realizados", :default => 0,   :null => false
    t.integer "creditos_aprobados",  :default => 0,   :null => false
    t.integer "creditos_diferidos",  :default => 0,   :null => false
    t.integer "creditos_rechazados", :default => 0,   :null => false
    t.float   "monto_liquidado",     :default => 0.0, :null => false
  end

  create_table "acumulado_tipo_credito", :id => false, :force => true do |t|
    t.integer "id",                                   :null => false
    t.integer "anio",                :default => 0,   :null => false
    t.integer "mes",                 :default => 0,   :null => false
    t.integer "trimestre",           :default => 0,   :null => false
    t.integer "semestre",            :default => 0,   :null => false
    t.integer "tipo_credito_id",                      :null => false
    t.integer "creditos_realizados", :default => 0,   :null => false
    t.integer "creditos_aprobados",  :default => 0,   :null => false
    t.integer "creditos_diferidos",  :default => 0,   :null => false
    t.integer "creditos_rechazados", :default => 0,   :null => false
    t.float   "monto_liquidado",     :default => 0.0, :null => false
  end

  create_table "agencia_bancaria", :force => true do |t|
    t.string  "codigo",                :limit => 40
    t.string  "nombre",                :limit => 100
    t.string  "direccion",             :limit => 250
    t.integer "entidad_financiera_id"
    t.boolean "activo"
    t.integer "estado_id"
    t.integer "ciudad_id"
    t.integer "municipio_id"
  end

  create_table "agrupacion_industrial", :force => true do |t|
    t.string "nombre",      :limit => 40,  :null => false
    t.string "descripcion", :limit => 300, :null => false
  end

  add_index "agrupacion_industrial", ["nombre"], :name => "agrupacion_industrial_uq_nombre", :unique => true

  create_table "almacen_maquinaria", :force => true do |t|
    t.string  "nombre",                        :limit => 60
    t.string  "direccion",                     :limit => 250
    t.string  "telefono_1",                    :limit => 11
    t.string  "telefono_2",                    :limit => 11
    t.string  "persona_contacto",              :limit => 60
    t.string  "rif",                           :limit => 15
    t.boolean "activo"
    t.integer "estado_id"
    t.integer "ciudad_id"
    t.integer "municipio_id"
    t.integer "contrato_maquinaria_equipo_id"
  end

  add_index "almacen_maquinaria", ["nombre"], :name => "almacen_maquinaria_uq_nombre"

  create_table "almacen_maquinaria_sucursal", :force => true do |t|
    t.string  "nombre",                :limit => 100
    t.integer "estado_id"
    t.integer "municipio_id"
    t.integer "ciudad_id"
    t.text    "direccion"
    t.string  "persona_contacto",      :limit => 100
    t.string  "telefono",              :limit => 11
    t.boolean "activo"
    t.integer "almacen_maquinaria_id"
  end

  create_table "analisis_conclusion", :force => true do |t|
    t.integer "numero",                                  :null => false
    t.string  "nombre", :limit => 200,                   :null => false
    t.boolean "activo",                :default => true, :null => false
  end

  add_index "analisis_conclusion", ["numero"], :name => "analisis_conclusion_uk", :unique => true

  create_table "analisis_topico", :force => true do |t|
    t.string  "nombre",      :limit => 100,                    :null => false
    t.string  "descripcion", :limit => 250,                    :null => false
    t.boolean "activo",                     :default => false, :null => false
  end

  add_index "analisis_topico", ["nombre"], :name => "analisis_topico_uk", :unique => true

  create_table "analista_cobranzas", :force => true do |t|
    t.integer "usuario_id",                                         :null => false
    t.string  "estatus",            :limit => 1,                    :null => false
    t.boolean "senal_supervisor",                 :default => true, :null => false
    t.integer "sector_id"
    t.integer "sub_sector_id"
    t.integer "rubro_id"
    t.integer "sub_rubro_id"
    t.integer "actividad_id"
    t.string  "primer_nombre",      :limit => 30
    t.string  "segundo_nombre",     :limit => 30
    t.string  "primer_apellido",    :limit => 30
    t.string  "segundo_apellido",   :limit => 30
    t.string  "letra_cedula",       :limit => 1
    t.integer "cedula"
    t.integer "cantidad_cobranzas",               :default => 0
    t.integer "carga_trabajo",                    :default => 0
  end

  create_table "analista_siniestro", :force => true do |t|
    t.integer "usuario_id", :null => false
    t.integer "pendientes"
    t.integer "atendidos"
  end

  create_table "area_influencia_tecnico", :force => true do |t|
    t.integer "estado_id",        :null => false
    t.integer "municipio_id",     :null => false
    t.integer "parroquia_id",     :null => false
    t.integer "tecnico_campo_id", :null => false
  end

  create_table "arrime_conjunto", :force => true do |t|
    t.string  "letra_cedula",          :limit => 1
    t.integer "cedula"
    t.string  "primer_nombre",         :limit => 60,                                                   :null => false
    t.string  "segundo_nombre",        :limit => 60
    t.string  "primer_apellido",       :limit => 60,                                                   :null => false
    t.string  "segundo_apellido",      :limit => 60
    t.decimal "peso_condicionado",                   :precision => 16, :scale => 2, :default => 0.0
    t.integer "boleta_arrime_id",                                                                      :null => false
    t.boolean "financiamiento_fondas",                                              :default => false
  end

  create_table "arte_pesca", :force => true do |t|
    t.boolean "es_propia"
    t.string  "nombre_arte_pesca",     :limit => 160
    t.integer "cantidad"
    t.float   "largo"
    t.float   "ancho"
    t.float   "alto"
    t.string  "luz_maya",              :limit => 160
    t.integer "nro_anzuelo"
    t.integer "cantidad_anzuelos"
    t.string  "material_linea_madre",  :limit => 160
    t.string  "material",              :limit => 160
    t.string  "tipo_cordel",           :limit => 160
    t.integer "nro_cordel"
    t.integer "tipo_nylon_id"
    t.integer "seguimiento_visita_id"
    t.integer "embarcacion_id"
    t.string  "condicion",             :limit => 20
    t.integer "tipo_arte_pesca_id"
  end

  create_table "asiento_contable", :force => true do |t|
    t.integer "comprobante_contable_id",               :null => false
    t.float   "monto",                                 :null => false
    t.string  "tipo",                    :limit => 1,  :null => false
    t.string  "codigo_contable",         :limit => 25
    t.string  "auxiliar_contable",       :limit => 20
  end

  create_table "aspectos_resguardo_institucional", :force => true do |t|
    t.string "nombre", :limit => 100
  end

  create_table "atributos_proyecto", :force => true do |t|
    t.string "nombre", :limit => 50
  end

  create_table "autorizacion", :force => true do |t|
    t.integer  "usuario_id"
    t.datetime "creacion"
    t.datetime "vencimiento"
    t.string   "estatus",           :limit => 1,   :default => "E"
    t.string   "descripcion",       :limit => 300
    t.integer  "opcion_accion_id"
    t.integer  "referencia_id"
    t.integer  "usuario_aprobo_id"
    t.string   "observaciones",     :limit => 300
    t.float    "monto"
    t.integer  "prestamo_numero"
  end

  create_table "banco_origen", :force => true do |t|
    t.string "nombre", :limit => 40
  end

  add_index "banco_origen", ["nombre"], :name => "uk_banco_origen", :unique => true

  create_table "boleta_arrime", :force => true do |t|
    t.integer "solicitud_id",                                                                                 :null => false
    t.integer "silo_id",                                                                                      :null => false
    t.integer "cliente_id",                                                                                   :null => false
    t.integer "rubro_id",                                                                                     :null => false
    t.time    "hora_registro"
    t.string  "placa_vehiculo",              :limit => 15,                                                    :null => false
    t.string  "letra_cedula_conductor",      :limit => 1,                                                     :null => false
    t.integer "cedula_conductor",                                                                             :null => false
    t.string  "nombre_conductor",            :limit => 100,                                                   :null => false
    t.string  "numero_ticket",               :limit => 15,                                                    :null => false
    t.string  "guia_movilizacion",           :limit => 20,                                                    :null => false
    t.string  "numero_acta",                 :limit => 20,                                                    :null => false
    t.text    "causa"
    t.string  "clase",                       :limit => 1
    t.string  "resultado",                   :limit => 30
    t.integer "tecnico_campo_id"
    t.date    "fecha_entrada",                                                                                :null => false
    t.date    "fecha_salida",                                                                                 :null => false
    t.decimal "valor_total_entrada",                        :precision => 16, :scale => 2
    t.decimal "valor_total_salida",                         :precision => 16, :scale => 2
    t.decimal "peso_neto",                                  :precision => 16, :scale => 2
    t.decimal "peso_acondicionado",                         :precision => 16, :scale => 2
    t.boolean "confirmacion",                                                              :default => false, :null => false
    t.date    "fecha_confirmacion"
    t.decimal "peso_vehiculo",                              :precision => 16, :scale => 2, :default => 0.0
    t.decimal "peso_remolque",                              :precision => 16, :scale => 2, :default => 0.0
    t.decimal "peso_vehiculo_salida",                       :precision => 16, :scale => 2, :default => 0.0
    t.decimal "peso_remolque_salida",                       :precision => 16, :scale => 2, :default => 0.0
    t.integer "usuario_id"
    t.string  "estatus",                     :limit => 1
    t.date    "fecha_decision"
    t.string  "nro_acta_rechazo",            :limit => 15
    t.string  "causa_rechazo"
    t.boolean "arrime_conjunto"
    t.decimal "valor_arrime",                               :precision => 16, :scale => 2
    t.decimal "peso_acondicionado_liquidar",                :precision => 16, :scale => 2, :default => 0.0
    t.integer "detalle_precio_gaceta_id"
    t.boolean "conjunto_verificado",                                                       :default => false, :null => false
    t.integer "sub_rubro_id"
    t.integer "actividad_id"
    t.integer "ciclo_productivo_id"
    t.time    "hora_entrada_silo"
    t.time    "hora_entrada_peso"
    t.time    "hora_salida_peso"
    t.decimal "peso_tara",                                  :precision => 16, :scale => 2, :default => 0.0
    t.decimal "peso_bruto",                                 :precision => 16, :scale => 2, :default => 0.0
    t.integer "secos"
    t.decimal "total_secos",                                :precision => 16, :scale => 2, :default => 0.0
    t.decimal "total_kg",                                   :precision => 16, :scale => 2, :default => 0.0
    t.integer "condicion_saco_id"
    t.integer "mojados"
    t.decimal "total_mojados",                              :precision => 16, :scale => 2, :default => 0.0
    t.integer "total_sacos"
    t.decimal "peso_ajustado",                              :precision => 16, :scale => 2, :default => 0.0
    t.decimal "porcentaje_aplicado_seco",                   :precision => 16, :scale => 2, :default => 0.0
    t.decimal "porcentaje_aplicado_mojado",                 :precision => 16, :scale => 2, :default => 0.0
    t.integer "acta_silo_id"
    t.integer "humedos"
    t.decimal "total_humedos",                              :precision => 16, :scale => 2, :default => 0.0
    t.decimal "porcentaje_aplicado_humedo",                 :precision => 16, :scale => 2, :default => 0.0
    t.integer "detalle_convenio_silo_id"
  end

  add_index "boleta_arrime", ["guia_movilizacion"], :name => "boleta_arrime_uq_guia_movilizacion"

  create_table "boleta_arrime_laboratorio", :force => true do |t|
    t.integer "boleta_arrime_id",                                                              :null => false
    t.decimal "porcentaje_humedad",             :precision => 5, :scale => 2, :default => 0.0
    t.decimal "porcentaje_impureza",            :precision => 5, :scale => 2, :default => 0.0
    t.decimal "olor_id",                        :precision => 5, :scale => 2, :default => 0.0
    t.decimal "aspecto_sensorial_id",           :precision => 5, :scale => 2, :default => 0.0
    t.decimal "porcentaje_blanco_total",        :precision => 5, :scale => 2, :default => 0.0
    t.decimal "porcentaje_granos_enteros",      :precision => 5, :scale => 2, :default => 0.0
    t.decimal "porcentaje_granos_yesosos",      :precision => 5, :scale => 2, :default => 0.0
    t.decimal "porcentaje_granos_panza_blanca", :precision => 5, :scale => 2, :default => 0.0
    t.decimal "porcentaje_granos_punta_negra",  :precision => 5, :scale => 2, :default => 0.0
    t.decimal "porcentaje_granos_danados",      :precision => 5, :scale => 2, :default => 0.0
    t.decimal "porcentaje_granos_rojos",        :precision => 5, :scale => 2, :default => 0.0
    t.decimal "porcentaje_granos_verdes",       :precision => 5, :scale => 2, :default => 0.0
    t.decimal "porcentaje_granos_sin_cascara",  :precision => 5, :scale => 2, :default => 0.0
    t.decimal "porcentaje_granos_infectados",   :precision => 5, :scale => 2, :default => 0.0
    t.decimal "porcentaje_granos_manchados",    :precision => 5, :scale => 2, :default => 0.0
    t.decimal "porcentaje_semillas_objetables", :precision => 5, :scale => 2, :default => 0.0
  end

  create_table "boleta_laboratorio_algodon", :force => true do |t|
    t.integer "boleta_arrime_id",                                                  :null => false
    t.decimal "humedad",           :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "humedad_absoluta",  :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "impureza",          :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "impureza_absoluta", :precision => 16, :scale => 2, :default => 0.0, :null => false
  end

  create_table "boleta_laboratorio_arroz", :force => true do |t|
    t.integer "boleta_arrime_id",                                                                    :null => false
    t.decimal "humedad",                             :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "impureza",                            :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "blanco_total",                        :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "enteros",                             :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "yesosos",                             :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "panza_blanca",                        :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "punta_negra",                         :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "danados",                             :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "rojos",                               :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "verdes",                              :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "sin_cascara",                         :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "manchados",                           :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "infectados",                          :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "semillas_objetables",                 :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.string  "luv",                  :limit => nil
    t.string  "olor",                 :limit => 20
    t.string  "aspecto",              :limit => 20
    t.decimal "rendimiento",                         :precision => 16, :scale => 2, :default => 0.0
    t.decimal "yesosos_panza_blanca",                :precision => 16, :scale => 2, :default => 0.0
    t.decimal "partidos",                            :precision => 16, :scale => 2, :default => 0.0
    t.decimal "peso_especifico",                     :precision => 16, :scale => 2, :default => 0.0
  end

  create_table "boleta_laboratorio_maiz", :force => true do |t|
    t.integer "boleta_arrime_id",                                                                       :null => false
    t.decimal "humedad",                                :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "impureza",                               :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "germinados_danados",                     :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "danados_insectos",                       :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "quemados",                               :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "danados_microorganismos",                :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "partidos",                               :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "cristalizados",                          :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "amilaceos",                              :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "mezcla_color",                           :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "infectados",                             :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "danados_total",                          :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "semillas_objetables",                    :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.string  "luv",                     :limit => nil
    t.string  "olor",                    :limit => 20
    t.string  "aspecto",                 :limit => 20
    t.decimal "danados_calor",                          :precision => 16, :scale => 2, :default => 0.0
    t.string  "aflatoxina",              :limit => 6
    t.decimal "sensorial",                              :precision => 16, :scale => 2, :default => 0.0
    t.decimal "hongos",                                 :precision => 16, :scale => 2, :default => 0.0
    t.decimal "hibrido",                                :precision => 16, :scale => 2, :default => 0.0
    t.decimal "remolque",                               :precision => 16, :scale => 2, :default => 0.0
    t.decimal "motriz",                                 :precision => 16, :scale => 2, :default => 0.0
  end

  create_table "boleta_laboratorio_sorgo", :force => true do |t|
    t.integer "boleta_arrime_id",                                                                       :null => false
    t.decimal "humedad",                                :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "impureza",                               :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "germinados_danados",                     :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "danados_insectos",                       :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "quemados",                               :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "danados_microorganismos",                :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "partidos",                               :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "cristalizados",                          :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "amilaceos",                              :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "mezcla_color",                           :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "infectados",                             :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "danados_total",                          :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "semillas_objetables",                    :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.string  "luv",                     :limit => nil
  end

  create_table "calidad_agua_alimento", :force => true do |t|
    t.string  "condiciones",           :limit => 50
    t.float   "temperatura"
    t.float   "ph"
    t.float   "oxigeno_disuelto"
    t.string  "alimento_disponible",   :limit => 120
    t.float   "consumo_diario"
    t.integer "dias_duracion"
    t.integer "solicitud_id"
    t.integer "seguimiento_visita_id"
  end

  create_table "campo_contable", :force => true do |t|
    t.integer "transaccion_contable_id",                                       :null => false
    t.string  "nombre",                  :limit => 50,                         :null => false
    t.string  "nombre_sistema",          :limit => 50,                         :null => false
    t.string  "descripcion",             :limit => 250
    t.string  "tipo",                    :limit => nil, :default => "varchar"
    t.integer "orden",                                  :default => 1
  end

  create_table "caracterizacion_fuente_agua", :force => true do |t|
    t.integer "tipo_fuente_agua_id",                  :null => false
    t.integer "unidad_produccion_caracterizacion_id", :null => false
    t.text    "descripcion_otro"
  end

  create_table "caracterizacion_tipo_suelo", :force => true do |t|
    t.integer "tipo_suelo_id",                        :null => false
    t.integer "unidad_produccion_caracterizacion_id", :null => false
    t.float   "porcentaje"
  end

  create_table "caracterizacion_tipo_topografia", :force => true do |t|
    t.integer "tipo_topografia_id",                   :null => false
    t.integer "unidad_produccion_caracterizacion_id", :null => false
    t.text    "descripcion_otro"
    t.float   "porcentaje"
  end

  create_table "caracterizacion_tipo_vialidad", :force => true do |t|
    t.integer "tipo_vialidad_id",                     :null => false
    t.integer "unidad_produccion_caracterizacion_id", :null => false
    t.text    "descripcion_otro"
  end

  create_table "cargo", :force => true do |t|
    t.string "descripcion", :limit => 70, :null => false
    t.string "const_id",    :limit => 10
  end

  create_table "casa_proveedora", :force => true do |t|
    t.string  "nombre",                  :limit => 100,                                                  :null => false
    t.string  "rif",                     :limit => 20,                                                   :null => false
    t.string  "descripcion",             :limit => 300
    t.string  "persona_contacto",        :limit => 100,                                                  :null => false
    t.string  "email_contacto",          :limit => 100
    t.string  "enlace_internet",         :limit => 100
    t.string  "telefono_oficina",        :limit => 12,                                                   :null => false
    t.string  "telefono_celular",        :limit => 12
    t.string  "telefono_fax",            :limit => 12
    t.string  "codigo_postal",           :limit => 8,                                                    :null => false
    t.string  "avenida",                 :limit => 300,                                                  :null => false
    t.string  "edificio",                :limit => 100
    t.string  "piso",                    :limit => 3
    t.string  "numero",                  :limit => 10
    t.boolean "activo",                                                                :default => true
    t.integer "ciudad_id",                                                                               :null => false
    t.integer "municipio_id",                                                                            :null => false
    t.integer "parroquia_id",                                                                            :null => false
    t.string  "tipo_pago",               :limit => 1,                                                    :null => false
    t.string  "tipo_cuenta",             :limit => 1
    t.string  "numero_cuenta",           :limit => 20
    t.date    "fecha_convenio"
    t.integer "estado_id"
    t.integer "entidad_financiera_id"
    t.decimal "anticipo",                               :precision => 16, :scale => 2, :default => 0.0
    t.decimal "pagos",                                  :precision => 16, :scale => 2, :default => 0.0
    t.decimal "disponible",                             :precision => 16, :scale => 2, :default => 0.0
    t.integer "pago_contra_anticipo_id"
  end

  create_table "caso_medida", :force => true do |t|
    t.string  "nombre",      :limit => 100
    t.string  "descripcion", :limit => 100
    t.boolean "activo"
  end

  create_table "catalogo", :force => true do |t|
    t.text    "descripcion"
    t.string  "chasis",                          :limit => 30
    t.string  "serial",                          :limit => 30
    t.string  "estatus",                         :limit => 1,                                  :default => "L"
    t.date    "fecha_carga",                                                                                      :null => false
    t.date    "fecha_reserva"
    t.date    "fecha_aprobado"
    t.date    "fecha_entregado"
    t.integer "contrato_maquinaria_equipo_id",                                                                    :null => false
    t.integer "solicitud_id"
    t.integer "clase_id",                                                                                         :null => false
    t.integer "pais_id"
    t.string  "puerto_llegada",                  :limit => 200
    t.string  "movilizado",                      :limit => 250
    t.string  "nombre_buque",                    :limit => 200
    t.date    "fecha_llegada"
    t.string  "numero_factura",                  :limit => 20
    t.float   "flete"
    t.float   "seguro"
    t.float   "por_seguro"
    t.float   "por_flete"
    t.float   "monto_dolares"
    t.float   "gastos_administrativos"
    t.float   "impuesto"
    t.float   "almacenamiento"
    t.float   "monto_real"
    t.integer "imputaciones_maquinaria_id"
    t.integer "almacen_maquinaria_id"
    t.integer "codigo"
    t.integer "marca_maquinaria_id"
    t.integer "modelo_id"
    t.boolean "operativo",                                                                     :default => true
    t.boolean "con_fallas",                                                                    :default => false
    t.boolean "falta_mantenimiento",                                                           :default => false
    t.text    "observaciones"
    t.decimal "monto",                                          :precision => 16, :scale => 2
    t.float   "por_gastos_administrativos"
    t.float   "por_nacionalizacion"
    t.float   "por_almacenamiento"
    t.integer "almacen_maquinaria_sucursal_id"
    t.integer "usuario_ultima_actualizacion_id"
    t.integer "usuario_asignacion_id"
    t.integer "moneda_id"
  end

  create_table "causa_condicionamiento", :force => true do |t|
    t.string  "nombre",      :limit => 80,                     :null => false
    t.string  "descripcion", :limit => 1000
    t.boolean "activo",                      :default => true
    t.string  "tipo",        :limit => 1,    :default => "A"
  end

  add_index "causa_condicionamiento", ["nombre"], :name => "causa_condicionamiento_uq_nombre", :unique => true

  create_table "causa_devolucion_cliente", :force => true do |t|
    t.string  "nombre",      :limit => 80,  :null => false
    t.string  "descripcion", :limit => 200, :null => false
    t.boolean "activo",                     :null => false
  end

  create_table "causa_diferimiento", :force => true do |t|
    t.string  "nombre",      :limit => 80,                    :null => false
    t.string  "descripcion", :limit => 200
    t.boolean "activo",                     :default => true
  end

  add_index "causa_diferimiento", ["nombre"], :name => "causa_diferimiento_uq_nombre", :unique => true

  create_table "causa_rechazo", :force => true do |t|
    t.string  "nombre",      :limit => 80,                    :null => false
    t.string  "descripcion", :limit => 200
    t.boolean "activo",                     :default => true
  end

  add_index "causa_rechazo", ["nombre"], :name => "causa_rechazo_uq_nombre", :unique => true

  create_table "causa_renuncia", :force => true do |t|
    t.string  "nombre",      :limit => 80,  :null => false
    t.string  "descripcion", :limit => 200, :null => false
    t.boolean "activo",                     :null => false
  end

  create_table "causa_siniestro", :force => true do |t|
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion"
    t.boolean "activo",                     :default => true, :null => false
  end

  add_index "causa_siniestro", ["nombre"], :name => "ix_causa_siniestro_nombre", :unique => true

  create_table "causales_anulacion_revocatoria", :force => true do |t|
    t.boolean "anulacion",           :default => false
    t.boolean "revocatoria_parcial", :default => false
    t.boolean "revocatoria_total",   :default => false
    t.text    "causa"
  end

  create_table "ciclo_productivo", :force => true do |t|
    t.string  "nombre",      :limit => 50,                    :null => false
    t.string  "descripcion", :limit => 250,                   :null => false
    t.integer "mes_inicio"
    t.integer "mes_fin"
    t.boolean "activo",                     :default => true
  end

  add_index "ciclo_productivo", ["nombre"], :name => "ciclo_uk", :unique => true

  create_table "ciiu", :force => true do |t|
    t.string  "codigo",      :limit => 15,  :null => false
    t.string  "nombre",      :limit => 50,  :null => false
    t.integer "parent_id"
    t.string  "descripcion", :limit => 400, :null => false
  end

  add_index "ciiu", ["codigo"], :name => "ciiu_uq_codigo", :unique => true

  create_table "ciudad", :force => true do |t|
    t.integer "estado_id"
    t.string  "nombre",            :limit => 40, :null => false
    t.string  "codigo_ine",        :limit => 10
    t.string  "estado_codigo_ine", :limit => 10
  end

  add_index "ciudad", ["estado_id", "nombre"], :name => "ciudad_uq_nombre", :unique => true
  add_index "ciudad", ["estado_id"], :name => "ciudad_estado_id_idx"

  create_table "clase", :force => true do |t|
    t.string  "nombre",             :limit => 100,                    :null => false
    t.string  "descripcion"
    t.boolean "activo",                            :default => false, :null => false
    t.integer "tipo_maquinaria_id",                                   :null => false
  end

  create_table "clasificacion", :force => true do |t|
    t.string "descripcion", :limit => 100, :null => false
  end

  create_table "cliente", :force => true do |t|
    t.integer "tipo_cliente_id"
    t.integer "persona_id"
    t.integer "empresa_id"
    t.string  "type",                  :limit => 15,                    :null => false
    t.integer "entidad_financiera_id"
    t.string  "tipo_cuenta",           :limit => 1,  :default => "C"
    t.string  "numero_cuenta",         :limit => 20
    t.string  "codigo_d3",             :limit => 10
    t.boolean "migrado_d3",                          :default => false
    t.integer "nro_expediente",                      :default => 0
    t.integer "agencia_bancaria_id"
    t.boolean "moroso",                              :default => false, :null => false
    t.boolean "reestructurado",                      :default => false, :null => false
    t.boolean "viable",                              :default => true,  :null => false
    t.boolean "es_pescador",                         :default => false, :null => false
    t.date    "fecha_registro"
  end

  create_table "cliente_antecedente", :force => true do |t|
    t.integer "cliente_id",                                          :null => false
    t.integer "entidad_financiera_id",                               :null => false
    t.date    "fecha_aprobacion",                                    :null => false
    t.float   "monto_aprobado"
    t.string  "estatus",               :limit => 1, :default => "V"
  end

  create_table "codigo_contable", :force => true do |t|
    t.string "nombre", :limit => 100, :null => false
    t.string "codigo", :limit => 20,  :null => false
  end

  add_index "codigo_contable", ["codigo"], :name => "uk_codigo_contable_codigo", :unique => true
  add_index "codigo_contable", ["nombre"], :name => "uk_codigo_contable_nombre", :unique => true

  create_table "comite", :force => true do |t|
    t.string  "numero",             :limit => 15,  :null => false
    t.date    "fecha_apertura"
    t.boolean "vigente",                           :null => false
    t.integer "hora_apertura"
    t.integer "minuto_apertura"
    t.string  "meridiano_apertura", :limit => 2
    t.string  "lugar",              :limit => 250
    t.string  "direccion",          :limit => 400
    t.integer "instancia_tipo_id"
    t.integer "punto_cuenta_id"
  end

  create_table "comite_decision_historico", :force => true do |t|
    t.string  "decision",       :limit => 1
    t.integer "comite_id"
    t.integer "solicitud_id"
    t.date    "fecha_decision"
    t.integer "oficina_id",                  :null => false
    t.string  "tipo_comite",    :limit => 1, :null => false
    t.text    "comentario"
  end

  create_table "comite_decision_historico_total", :force => true do |t|
    t.string  "decision",       :limit => 1
    t.integer "comite_id"
    t.integer "solicitud_id"
    t.date    "fecha_decision"
    t.integer "oficina_id",                  :null => false
    t.string  "tipo_comite",    :limit => 1, :null => false
    t.text    "comentario"
  end

  create_table "comite_miembro", :force => true do |t|
    t.integer "miembro_comite_id", :null => false
    t.integer "comite_id",         :null => false
    t.date    "fecha_ingreso",     :null => false
    t.boolean "firma"
    t.integer "rol_comite_id"
  end

  create_table "complemento_decision", :force => true do |t|
    t.integer "solicitud_id"
    t.boolean "obligacion_correspondencia_social"
    t.string  "beneficiario",                         :limit => 50
    t.string  "concepto",                             :limit => 400
    t.boolean "publicidad"
    t.integer "publicidad_tipo",                                     :default => 0
    t.boolean "obligacion_capital_social"
    t.float   "porcentaje_obligacion_capital_social"
    t.string  "notas",                                :limit => 400
    t.boolean "indicador",                                           :default => false
    t.text    "notas_instancia_revisora_1"
    t.text    "notas_instancia_revisora_2"
  end

  create_table "complemento_decision_causa_condicionamiento", :force => true do |t|
    t.integer "complemento_decision_id"
    t.integer "causa_condicionamiento_id"
  end

  create_table "comprobante_contable", :force => true do |t|
    t.date    "fecha_registro",                                           :null => false
    t.date    "fecha_comprobante",                                        :null => false
    t.date    "fecha_envio"
    t.boolean "enviado",                               :default => false
    t.integer "numero_lote_envio"
    t.float   "total_debe"
    t.float   "total_haber"
    t.integer "numero_contabilidad"
    t.integer "unidad_asiento"
    t.integer "prestamo_id"
    t.integer "factura_id"
    t.integer "anio"
    t.integer "transaccion_id"
    t.boolean "reversado",                             :default => false
    t.boolean "reverso",                               :default => false
    t.integer "comprobante_reverso_id"
    t.integer "comprobante_reversado_id"
    t.text    "referencia"
    t.string  "estatus",                  :limit => 1
    t.integer "transaccion_contable_id",                                  :null => false
  end

  create_table "compromiso_pago", :force => true do |t|
    t.integer "telecobranzas_id",                                                                      :null => false
    t.integer "prestamo_id",                                                                           :null => false
    t.date    "fecha_pago",                                                                            :null => false
    t.date    "fecha_limite_pago",                                                                     :null => false
    t.decimal "monto_pago",                            :precision => 16, :scale => 2,                  :null => false
    t.string  "estatus",                  :limit => 1,                                                 :null => false
    t.text    "observacion"
    t.decimal "monto_efectivamente_pago",              :precision => 16, :scale => 2, :default => 0.0
  end

  create_table "comunidad_indigena", :force => true do |t|
    t.integer "estado_id"
    t.integer "municipio_id"
    t.integer "parroquia_id"
    t.string  "pueblo_indigena",    :limit => 30
    t.text    "comunidad_indigena"
  end

  create_table "condicion_contable", :force => true do |t|
    t.string  "nombre",                  :limit => 50,                    :null => false
    t.string  "descripcion",             :limit => 250
    t.boolean "activo",                                 :default => true
    t.text    "condicion"
    t.integer "transaccion_contable_id",                                  :null => false
  end

  create_table "condicion_desembolso", :force => true do |t|
    t.string  "nombre",      :limit => 80,                    :null => false
    t.string  "descripcion", :limit => 200
    t.boolean "activo",                     :default => true
  end

  add_index "condicion_desembolso", ["nombre"], :name => "condicion_desembolso_uq_nombre", :unique => true

  create_table "condicion_pasto", :force => true do |t|
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion"
    t.boolean "activo",                     :default => true
  end

  add_index "condicion_pasto", ["nombre"], :name => "condicion_pasto_uq_nombre", :unique => true

  create_table "condicion_saco", :force => true do |t|
    t.string  "nombre",       :limit => 25,                                                  :null => false
    t.decimal "porcentaje",                 :precision => 16, :scale => 2, :default => 0.0
    t.boolean "activo",                                                    :default => true
    t.integer "acta_silo_id"
    t.integer "silo_id"
  end

  create_table "condicionamiento", :force => true do |t|
    t.integer "solicitud_id",                                            :null => false
    t.integer "causa_condicionamiento_id",                               :null => false
    t.date    "fecha_tope"
    t.string  "tipo",                      :limit => 1, :default => "d"
  end

  create_table "condicionamientos_narrativa_libre", :force => true do |t|
    t.text "condicionamientos_desembolso"
    t.text "condicionamientos_financiamiento"
  end

  create_table "condicionamientos_narrativa_libre_solicitud", :force => true do |t|
    t.integer "solicitud_id"
    t.text    "condicionamiento_desembolso"
    t.text    "condicionamiento_financiamiento"
  end

  create_table "condiciones_acuicultura", :force => true do |t|
    t.integer "tipo_especie_id"
    t.integer "solicitud_id"
    t.integer "calidad_agua_id"
    t.float   "espejo_agua"
    t.float   "espejo_agua_up"
    t.float   "espejo_agua_produccion"
    t.integer "duracion_ciclo"
    t.integer "lagunas_efectivas"
    t.integer "lagunas_totales"
    t.float   "peso_cosecha"
    t.float   "densidad_siembra"
    t.integer "seguimiento_visita_id"
  end

  create_table "condiciones_especies", :force => true do |t|
    t.integer "tipo_especie_acuicultura_id",                :null => false
    t.integer "unidad_produccion_condicion_acuicultura_id", :null => false
    t.text    "descripcion_otro"
  end

  create_table "condiciones_especies_solicitadas", :force => true do |t|
    t.integer "tipo_especie_acuicultura_id",                :null => false
    t.integer "unidad_produccion_condicion_acuicultura_id", :null => false
    t.text    "descripcion_otro"
  end

  create_table "condiciones_financiamiento", :force => true do |t|
    t.integer "sector_id",                               :null => false
    t.integer "sub_sector_id",                           :null => false
    t.integer "rubro_id",                                :null => false
    t.integer "plazo",                :default => 0
    t.integer "plazo_desde",          :default => 0
    t.integer "plazo_hasta",          :default => 0
    t.integer "periodo_gracia",       :default => 0
    t.integer "periodo_gracia_desde", :default => 0
    t.integer "periodo_gracia_hasta", :default => 0
    t.boolean "pago_unico",           :default => false
    t.integer "frecuencia_pago",      :default => 1
    t.boolean "activo",               :default => true
    t.boolean "diferir_intereses",    :default => false, :null => false
    t.integer "formula_id",           :default => 1,     :null => false
    t.integer "sub_rubro_id"
    t.integer "actividad_id"
    t.integer "programa_id"
  end

  create_table "condiciones_fuente_agua", :force => true do |t|
    t.integer "tipo_fuente_agua_id",                        :null => false
    t.integer "unidad_produccion_condicion_acuicultura_id", :null => false
    t.text    "descripcion_otro"
  end

  create_table "condiciones_sistema_cultivo_actual", :force => true do |t|
    t.integer "tipo_sistema_acuicultura_id",                :null => false
    t.integer "unidad_produccion_condicion_acuicultura_id", :null => false
    t.text    "descripcion_otro"
  end

  create_table "condiciones_tipo_suelo", :force => true do |t|
    t.integer "tipo_suelo_id",                              :null => false
    t.integer "unidad_produccion_condicion_acuicultura_id", :null => false
    t.float   "porcentaje"
  end

  create_table "condiciones_tipo_topografia", :force => true do |t|
    t.integer "tipo_topografia_id",                         :null => false
    t.integer "unidad_produccion_condicion_acuicultura_id", :null => false
    t.text    "descripcion_otro"
    t.float   "porcentaje"
  end

  create_table "condiciones_tipo_vialidad", :force => true do |t|
    t.integer "tipo_vialidad_id",                           :null => false
    t.integer "unidad_produccion_condicion_acuicultura_id", :null => false
    t.text    "descripcion_otro"
  end

  create_table "conexionws", :force => true do |t|
    t.string "llamada",    :limit => 1000, :null => false
    t.string "log",        :limit => 2000, :null => false
    t.date   "timestamps"
  end

  create_table "configuracion_avance", :force => true do |t|
    t.integer "estatus_origen_id"
    t.integer "estatus_destino_id"
    t.boolean "condicionado"
    t.integer "programa_id",        :default => 0,         :null => false
    t.text    "ruta_primaria"
    t.text    "accion",             :default => "avanzar"
  end

  create_table "configuracion_reverso", :force => true do |t|
    t.integer "estatus_origen_id"
    t.integer "estatus_destino_id"
    t.boolean "condicionado"
    t.integer "programa_id",        :default => 0,          :null => false
    t.text    "ruta_primaria"
    t.text    "accion",             :default => "reversar"
  end

  create_table "configurador", :force => true do |t|
    t.integer "estado_id",                                                                      :null => false
    t.integer "oficina_id",                                                                     :null => false
    t.integer "sector_id",                                                                      :null => false
    t.integer "sub_sector_id",                                                                  :null => false
    t.integer "rubro_id",                                                                       :null => false
    t.integer "partida_id",                                                                     :null => false
    t.integer "item_id",                                                                        :null => false
    t.integer "unidad_medida_id",                                                               :null => false
    t.decimal "costo_fijo",                     :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "costo_minimo",                   :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.decimal "costo_maximo",                   :precision => 16, :scale => 2, :default => 0.0, :null => false
    t.integer "numero_desembolso",                                             :default => 0,   :null => false
    t.text    "justificacion"
    t.integer "sub_rubro_id"
    t.integer "actividad_id"
    t.integer "moneda_id"
    t.string  "tipo_item",         :limit => 1
  end

  create_table "consulta", :force => true do |t|
    t.date   "fecha_actualizacion",               :null => false
    t.string "nombre",              :limit => 20, :null => false
  end

  create_table "consulta_campo", :force => true do |t|
    t.string  "tabla",       :limit => 40
    t.string  "campo",       :limit => 50
    t.integer "consulta_id",               :null => false
  end

  create_table "consulta_criterio", :force => true do |t|
    t.string  "tabla",       :limit => 40
    t.string  "campo",       :limit => 50
    t.string  "operador",    :limit => 2,  :default => "IG"
    t.string  "valor",       :limit => 50
    t.integer "consulta_id",                                 :null => false
    t.string  "anidacion",   :limit => 1,  :default => "A"
  end

  create_table "contrato", :force => true do |t|
    t.string   "const_id",           :limit => 7, :null => false
    t.datetime "fecha_creacion",                  :null => false
    t.datetime "fecha_modificacion",              :null => false
  end

  create_table "contrato_maquinaria_equipo", :force => true do |t|
    t.date   "fecha_contrato"
    t.string "numero_contrato", :limit => 30, :null => false
    t.string "nombre",                        :null => false
    t.string "rif",             :limit => 12
    t.string "naturaleza",      :limit => 1
    t.text   "descripcion"
  end

  create_table "contrato_seccion", :force => true do |t|
    t.integer  "contrato_id",                                        :null => false
    t.string   "const_id",           :limit => 7,                    :null => false
    t.boolean  "condicionado",                    :default => false
    t.text     "titulo",                                             :null => false
    t.text     "cuerpo",                                             :null => false
    t.datetime "fecha_creacion",                                     :null => false
    t.datetime "fecha_modificacion",                                 :null => false
  end

  create_table "control_asignacion", :force => true do |t|
    t.date    "fecha",                       :null => false
    t.integer "usuario_id",                  :null => false
    t.integer "solicitud_id",                :null => false
    t.string  "observacion",  :limit => 500
    t.boolean "asignacion"
    t.string  "unidad",       :limit => 1
  end

  create_table "control_cierre", :force => true do |t|
    t.date    "fecha_proceso",   :default => '1900-01-01'
    t.boolean "senal_enproceso", :default => false,        :null => false
    t.date    "fecha_ejecucion", :default => '1900-01-01', :null => false
    t.boolean "senal_cerrado",   :default => false,        :null => false
    t.boolean "senal_shell",     :default => true,         :null => false
    t.integer "ultimo_prestamo"
  end

  create_table "control_cierre_cartera", :force => true do |t|
    t.integer "mes",        :null => false
    t.integer "anno",       :null => false
    t.boolean "cerrado",    :null => false
    t.date    "fecha"
    t.integer "usuario_id"
  end

  create_table "control_cobranza", :force => true do |t|
    t.date    "fecha",                                                               :default => '1900-01-01'
    t.string  "archivo",               :limit => 100
    t.integer "procesamiento",                                                       :default => 0
    t.integer "numero_procesado",                                                    :default => 0
    t.decimal "monto_procesado"
    t.integer "numero_leido",                                                        :default => 0
    t.decimal "monto_leido",                          :precision => 16, :scale => 2, :default => 0.0
    t.date    "fecha_cierre",                                                        :default => '1900-01-01'
    t.integer "entidad_financiera_id"
    t.string  "numero_cuenta",         :limit => 20
    t.string  "tipo_cuenta",           :limit => 1
  end

  create_table "control_envio_abono_excedente_cosecha", :force => true do |t|
    t.date    "fecha",                                                               :default => '1900-01-01'
    t.string  "archivo",               :limit => 100
    t.integer "numero_procesado",                                                    :default => 0
    t.decimal "monto_procesado",                      :precision => 16, :scale => 2, :default => 0.0
    t.integer "entidad_financiera_id"
    t.integer "estatus"
    t.string  "tipo_operacion",        :limit => 1
    t.string  "numero_lote",           :limit => 20
  end

  create_table "control_envio_cobranza", :force => true do |t|
    t.date    "fecha",                                :default => '1900-01-01'
    t.string  "archivo",               :limit => 100
    t.integer "estatus_proceso",                      :default => 0
    t.integer "numero_procesado",                     :default => 0
    t.decimal "monto_procesado",                      :default => 0.0
    t.integer "entidad_financiera_id"
    t.date    "fecha_proceso",                        :default => '1900-01-01'
    t.string  "numero_cuenta",         :limit => 20
    t.string  "tipo_cuenta",           :limit => 1
  end

  create_table "control_envio_contabilidad", :force => true do |t|
    t.date    "fecha_inicio"
    t.date    "fecha_fin"
    t.text    "file_name"
    t.decimal "total_debe",     :precision => 16, :scale => 2
    t.decimal "total_haber",    :precision => 16, :scale => 2
    t.integer "cantidad_envio"
    t.decimal "diferencia",     :precision => 16, :scale => 2
    t.integer "usuario_id"
    t.date    "fecha_proceso"
  end

  create_table "control_envio_desembolso", :force => true do |t|
    t.date    "fecha",                                                               :default => '1900-01-01'
    t.string  "archivo",               :limit => 100
    t.integer "numero_procesado",                                                    :default => 0
    t.decimal "monto_procesado",                      :precision => 16, :scale => 2, :default => 0.0
    t.integer "entidad_financiera_id"
    t.integer "estatus"
  end

  create_table "control_impresion", :force => true do |t|
    t.integer "usuario_id",                 :null => false
    t.date    "fecha",                      :null => false
    t.integer "solicitud_id"
    t.string  "operacion",    :limit => 30, :null => false
  end

  create_table "control_montos_migracion", :force => true do |t|
    t.integer "numero_tramite"
    t.decimal "monto_banco",             :precision => 16, :scale => 2, :null => false
    t.decimal "monto_insumos",           :precision => 16, :scale => 2, :null => false
    t.decimal "monto_liquidado_banco",   :precision => 16, :scale => 2, :null => false
    t.decimal "monto_liquidado_insumos", :precision => 16, :scale => 2, :null => false
    t.decimal "monto_sras",              :precision => 16, :scale => 2
    t.date    "fecha"
  end

  add_index "control_montos_migracion", ["numero_tramite"], :name => "control_montos_migracion_uk_numero_tramite", :unique => true

  create_table "control_orden_despacho_insumo", :force => true do |t|
    t.date    "fecha",                                :default => '1900-01-01'
    t.string  "archivo",               :limit => 100
    t.integer "numero_procesado",                     :default => 0
    t.decimal "monto_procesado",                      :default => 0.0
    t.integer "entidad_financiera_id"
    t.integer "estatus"
  end

  create_table "control_solicitud", :force => true do |t|
    t.datetime "fecha",                             :null => false
    t.integer  "estatus_id",                        :null => false
    t.integer  "solicitud_id",                      :null => false
    t.integer  "usuario_id",                        :null => false
    t.integer  "estatus_origen_id"
    t.string   "comentario",        :limit => 1800
    t.string   "accion",            :limit => 50
  end

  create_table "convenio_silo", :force => true do |t|
    t.integer "silo_id",                           :null => false
    t.integer "usuario_id",                        :null => false
    t.integer "ciclo_productivo_id",               :null => false
    t.string  "numero_memorandum",   :limit => 25, :null => false
    t.date    "fecha_memorandum"
    t.date    "fecha_registro"
    t.date    "fecha_cierre"
    t.text    "observacion"
    t.boolean "status"
  end

  create_table "convertidor", :force => true do |t|
    t.integer "moneda_origen_id",  :null => false
    t.integer "moneda_destino_id", :null => false
    t.float   "valor",             :null => false
  end

  create_table "criterio_acumulado", :force => true do |t|
    t.integer "usuario_id",                                     :null => false
    t.string  "indicador",      :limit => 1, :default => "C"
    t.string  "agrupador",      :limit => 1, :default => "P"
    t.boolean "todos",                       :default => true
    t.string  "intervalo",      :limit => 1, :default => "M"
    t.integer "desde",                                          :null => false
    t.integer "hasta",                                          :null => false
    t.boolean "predeterminado",              :default => false
    t.integer "anio_desde",                                     :null => false
    t.integer "anio_hasta",                                     :null => false
    t.string  "grafico",        :limit => 3, :default => "C"
    t.integer "grafico_tamano",              :default => 600
    t.string  "grafico_fondo",  :limit => 4, :default => "BK"
  end

  create_table "criterio_acumulado_detalle", :id => false, :force => true do |t|
    t.integer "id",                                 :null => false
    t.integer "valor_entero"
    t.string  "valor_char",            :limit => 1
    t.integer "criterio_acumulado_id",              :null => false
  end

  create_table "criterio_repositorio", :force => true do |t|
    t.integer "usuario_id",                                     :null => false
    t.string  "indicador",      :limit => 1, :default => "L"
    t.string  "agrupador",      :limit => 1, :default => "P"
    t.boolean "todos",                       :default => true
    t.string  "intervalo",      :limit => 1, :default => "M"
    t.integer "desde",                                          :null => false
    t.integer "hasta",                                          :null => false
    t.boolean "predeterminado",              :default => false
    t.integer "anio_desde",                                     :null => false
    t.integer "anio_hasta",                                     :null => false
    t.string  "grafico",        :limit => 3, :default => "C"
    t.integer "grafico_tamano",              :default => 600
    t.string  "grafico_fondo",  :limit => 4, :default => "BK"
  end

  create_table "criterio_repositorio_detalle", :id => false, :force => true do |t|
    t.integer "id",                                 :null => false
    t.integer "valor_entero"
    t.string  "valor_char",            :limit => 1
    t.integer "criterio_acumulado_id",              :null => false
  end

  create_table "cronograma_desembolso", :id => false, :force => true do |t|
    t.integer "id",                :null => false
    t.integer "rubro_id",          :null => false
    t.integer "numero_desembolso", :null => false
    t.integer "dias"
  end

  create_table "cuenta_bancaria", :force => true do |t|
    t.string  "numero",                :limit => 20,                   :null => false
    t.string  "tipo",                  :limit => 1,                    :null => false
    t.date    "fecha_apertura"
    t.integer "entidad_financiera_id",                                 :null => false
    t.integer "agencia_bancaria_id"
    t.integer "cliente_id",                                            :null => false
    t.boolean "activo",                              :default => true, :null => false
  end

  create_table "cuenta_bcv", :force => true do |t|
    t.integer "entidad_financiera_id",                                  :null => false
    t.string  "tipo",                  :limit => 1,                     :null => false
    t.string  "numero",                :limit => 20,                    :null => false
    t.boolean "activo",                              :default => true
    t.boolean "recaudador",                          :default => false
  end

  create_table "cuenta_contable", :force => true do |t|
    t.string  "codigo",    :limit => 25,                    :null => false
    t.string  "nombre",                                     :null => false
    t.integer "parent_id"
    t.boolean "auxiliar",                :default => false
  end

  create_table "cuenta_contable_presupuesto", :force => true do |t|
    t.string  "codigo",             :limit => 20, :null => false
    t.integer "cuenta_contable_id"
    t.integer "anio"
  end

  create_table "cuenta_corresponsal", :force => true do |t|
    t.string  "numero",          :limit => 20
    t.string  "descripcion",     :limit => 30
    t.integer "tipo_moneda"
    t.integer "nucorrespo_usec"
    t.boolean "sinc_usec"
  end

  create_table "cuenta_matriz", :force => true do |t|
    t.integer "entidad_financiera_id",               :null => false
    t.integer "instrumento_id",                      :null => false
    t.string  "numero",                :limit => 20, :null => false
  end

  create_table "cultivo_laguna", :force => true do |t|
    t.string  "numero_laguna",         :limit => 20
    t.float   "espejo_agua"
    t.integer "cantidad_peces"
    t.date    "fecha_siembra"
    t.date    "fecha_cosecha"
    t.float   "peso_promedio"
    t.float   "kilo_cosechado"
    t.string  "coordenadas_utm",       :limit => 80
    t.integer "solicitud_id"
    t.integer "seguimiento_visita_id"
  end

  create_table "cuotas_dif", :id => false, :force => true do |t|
    t.integer "prestamo_numero",       :limit => 8
    t.decimal "valor_cuota",                        :precision => 16, :scale => 2
    t.decimal "amortizado",                         :precision => 16, :scale => 2
    t.decimal "interes_corriente",                  :precision => 16, :scale => 2
    t.decimal "interes_intermediario",              :precision => 16, :scale => 2
    t.decimal "cuota_nueva",                        :precision => 16, :scale => 2
    t.decimal "cuota_diferencia",                   :precision => 16, :scale => 2
  end

  create_table "datos_formacion", :force => true do |t|
    t.string  "registra_ventas",                 :limit => 1
    t.string  "registra_gastos",                 :limit => 1
    t.string  "oficio_formacion",                :limit => 250
    t.boolean "salud_sexual"
    t.boolean "conocimiento_ley_igualdad"
    t.boolean "conocimiento_ley_organica"
    t.boolean "conocimiento_contraloria_social"
    t.boolean "leido_constitucion"
    t.integer "persona_id",                                     :null => false
  end

  create_table "datos_socio_economico", :force => true do |t|
    t.string  "jefe",                            :limit => 1
    t.integer "cantidad_persona_depende"
    t.boolean "depende_conyuge"
    t.boolean "depende_hija"
    t.boolean "depende_hijo"
    t.boolean "depende_madre"
    t.boolean "depende_padre"
    t.boolean "depende_sobrino"
    t.boolean "depende_otros"
    t.string  "quien_aporta_mas",                :limit => 1
    t.boolean "pertenece_religiosa"
    t.boolean "pertenece_consejo_comunal"
    t.boolean "pertenece_politico"
    t.boolean "pertenece_cultural"
    t.boolean "pertenece_mesas_tecnicas"
    t.string  "ingreso_familiar",                :limit => 1
    t.string  "ingreso_individual",              :limit => 1
    t.integer "distribucion_alimentacion"
    t.integer "distribucion_transporte"
    t.integer "distribucion_salud"
    t.integer "distribucion_vivienda"
    t.integer "distribucion_educacion"
    t.integer "distribucion_aseo_personal"
    t.integer "distribucion_publico"
    t.integer "distribucion_vestido"
    t.integer "distribucion_recreacion"
    t.integer "distribucion_otros"
    t.string  "frecuencia_solicita_atecion",     :limit => 50
    t.string  "centro_salud_acude",              :limit => 1
    t.boolean "proteccion_especial"
    t.string  "actividad_recreacion",            :limit => 250
    t.boolean "ahorra"
    t.integer "persona_id"
    t.decimal "cuanto_ahorra",                                  :precision => 18, :scale => 0
    t.boolean "discapacidad_sensorial"
    t.boolean "discapacidad_motriz"
    t.boolean "discapacidad_intelectual"
    t.boolean "depende_usuaria"
    t.boolean "pertenece_otro"
    t.boolean "recreacion_deporte"
    t.boolean "recreacion_musica"
    t.boolean "recreacion_teatro"
    t.boolean "recreacion_cine"
    t.boolean "recreacion_ver_tv"
    t.boolean "recreacion_lectura"
    t.boolean "recreacion_otro"
    t.boolean "discapacidad_sensorial_propia"
    t.boolean "discapacidad_motriz_propia"
    t.boolean "discapacidad_intelectual_propia"
  end

  create_table "decision_visita", :force => true do |t|
    t.integer "seguimiento_visita_id",                            :null => false
    t.boolean "labor_visitas_previas",         :default => false, :null => false
    t.boolean "continuidad_financiamiento",    :default => true,  :null => false
    t.integer "caso_medida_id"
    t.text    "justificacion"
    t.text    "labores_por_realizar"
    t.text    "recomendaciones"
    t.boolean "recomienda_generar_desembolso", :default => false, :null => false
  end

  create_table "departamento", :force => true do |t|
    t.string  "nombre",             :limit => 50,  :null => false
    t.string  "descripcion",        :limit => 300, :null => false
    t.string  "tipo",               :limit => 1
    t.integer "empresa_sistema_id"
  end

  add_index "departamento", ["nombre"], :name => "departamento_uq_nombre", :unique => true

  create_table "descripciones_especificas", :force => true do |t|
    t.integer "seguimiento_visita_id"
    t.integer "seguimiento_cultivo_id"
    t.text    "descripcion"
    t.text    "comportamiento_agronomico"
    t.text    "factores_condicionantes"
    t.text    "labores_beneficiario"
  end

  create_table "desembolso", :force => true do |t|
    t.integer "numero",                                                 :null => false
    t.integer "prestamo_id",                                            :null => false
    t.integer "solicitud_id",                                           :null => false
    t.string  "modalidad",             :limit => 1
    t.float   "monto"
    t.date    "fecha_valor"
    t.date    "fecha_envio"
    t.date    "fecha_recepcion"
    t.integer "entidad_financiera_id"
    t.string  "tipo_cuenta",           :limit => 1
    t.string  "numero_cuenta",         :limit => 20
    t.boolean "realizado",                           :default => false
    t.integer "usuario_id"
    t.integer "seguimiento_visita_id",                                  :null => false
    t.text    "observacion"
    t.string  "tipo_cheque",           :limit => 1
    t.string  "referencia",            :limit => 30
    t.boolean "confirmado",                          :default => false
    t.date    "fecha_registro"
  end

  create_table "desembolso_detalle", :force => true do |t|
    t.integer "desembolso_id",                                    :null => false
    t.integer "plan_inversion_id",                                :null => false
    t.decimal "monto",             :precision => 16, :scale => 2, :null => false
  end

  create_table "desvio_silo", :force => true do |t|
    t.integer "solicitud_id",                          :null => false
    t.integer "silo_origen_id",                        :null => false
    t.integer "silo_destino_id",                       :null => false
    t.integer "cliente_id",                            :null => false
    t.integer "actividad_id",                          :null => false
    t.time    "hora_desvio"
    t.string  "placa_vehiculo",         :limit => 15,  :null => false
    t.string  "letra_cedula_conductor", :limit => 1,   :null => false
    t.integer "cedula_conductor",                      :null => false
    t.string  "nombre_conductor",       :limit => 100, :null => false
    t.string  "guia_movilizacion",      :limit => 20,  :null => false
    t.string  "numero_acta_desvio",     :limit => 20,  :null => false
    t.text    "causa_desvio"
    t.date    "fecha_desvio",                          :null => false
    t.integer "usuario_id"
  end

  create_table "detalle_convenio_silo", :force => true do |t|
    t.integer "convenio_silo_id",                                                              :null => false
    t.integer "actividad_id",                                                                  :null => false
    t.integer "usuario_id",                                                                    :null => false
    t.string  "tipo_clase_grado", :limit => 1,                                                 :null => false
    t.decimal "valor",                         :precision => 16, :scale => 2, :default => 0.0, :null => false
  end

  create_table "detalle_precio_gaceta", :force => true do |t|
    t.integer "precio_gaceta_id",              :null => false
    t.integer "actividad_id",                  :null => false
    t.string  "tipo_clase",       :limit => 1, :null => false
    t.float   "valor",                         :null => false
  end

  add_index "detalle_precio_gaceta", ["precio_gaceta_id", "tipo_clase", "actividad_id"], :name => "ix_uq_valor_gaceta", :unique => true

  create_table "detalle_reestructuracion", :force => true do |t|
    t.datetime "fecha",                                    :null => false
    t.integer  "estatus_id",                               :null => false
    t.integer  "solicitud_id",                             :null => false
    t.string   "motivo",                    :limit => 1,   :null => false
    t.string   "observaciones",             :limit => 400
    t.integer  "causa_renuncia_id"
    t.integer  "causa_reestructuracion_id"
    t.integer  "prestamo_id"
    t.integer  "numero_acta"
  end

  create_table "diferimiento_renuncia", :force => true do |t|
    t.integer "solicitud_id"
    t.integer "causa_diferimiento_id"
    t.integer "causa_renuncia_id"
    t.string  "observacion",                         :null => false
    t.integer "estatus_origen_id"
    t.integer "estatus_destino_id"
    t.date    "fecha"
    t.string  "usuario",               :limit => 25
    t.integer "control_solicitud_id"
  end

  create_table "disponibilidad_tesoreria", :force => true do |t|
    t.date    "fecha_solicitud",                                                      :null => false
    t.date    "fecha_real",                                                           :null => false
    t.decimal "monto",              :precision => 16, :scale => 2,                    :null => false
    t.decimal "monto_comprometido", :precision => 16, :scale => 2, :default => 0.0
    t.boolean "confirmado",                                        :default => false
    t.text    "observaciones"
    t.date    "fecha_aplicado"
  end

  create_table "documento", :force => true do |t|
    t.string  "nombre",      :limit => 80
    t.string  "descripcion", :limit => 200
    t.boolean "activo"
  end

  create_table "eje", :force => true do |t|
    t.string "nombre", :limit => 100
  end

  create_table "embarcacion", :force => true do |t|
    t.string  "nombre_embarcacion",          :limit => 120
    t.string  "matricula",                   :limit => 20
    t.integer "tipo_embarcacion_id"
    t.integer "tipo_material_id"
    t.boolean "es_propia"
    t.decimal "eslora",                                     :precision => 16, :scale => 2
    t.decimal "manga",                                      :precision => 16, :scale => 2
    t.decimal "puntal",                                     :precision => 16, :scale => 2
    t.integer "cantidad_tripulantes"
    t.decimal "uab",                                        :precision => 16, :scale => 2
    t.integer "autonomia_pesca"
    t.integer "proveedor_marino_id"
    t.integer "solicitud_id"
    t.integer "seguimiento_visita_id"
    t.string  "puerto_base",                 :limit => 180
    t.string  "condicion",                   :limit => 20
    t.string  "coordenadas_utm_puerto_base", :limit => 80
    t.float   "capacidad_combustible"
    t.string  "lugares_pesca",               :limit => 120
    t.integer "estado_id"
    t.integer "municipio_id"
    t.integer "parroquia_id"
  end

  create_table "empleado_silo", :force => true do |t|
    t.integer "silo_id",                                              :null => false
    t.string  "letra_cedula",        :limit => 1,                     :null => false
    t.integer "cedula",                                               :null => false
    t.string  "primer_nombre",       :limit => 20,                    :null => false
    t.string  "segundo_nombre",      :limit => 20
    t.string  "primer_apellido",     :limit => 20,                    :null => false
    t.string  "segundo_apellido",    :limit => 20
    t.date    "fecha_nacimiento"
    t.integer "edad"
    t.string  "estado_civil",        :limit => 1
    t.string  "telefono_habitacion", :limit => 12
    t.string  "telefono_celular",    :limit => 12
    t.string  "correo_electronico",  :limit => 50
    t.integer "estado_id",                                            :null => false
    t.integer "municipio_id",                                         :null => false
    t.integer "parroquia_id",                                         :null => false
    t.string  "direccion",           :limit => 300
    t.integer "profesion_id",                                         :null => false
    t.string  "cargo",               :limit => 1
    t.boolean "activo",                             :default => true
    t.string  "sexo",                :limit => 1
  end

  create_table "empresa", :force => true do |t|
    t.string  "nombre",                                                          :null => false
    t.string  "alias",                         :limit => 150
    t.string  "rif",                           :limit => 15
    t.string  "codigo_nacionalidad",           :limit => 5
    t.date    "fecha_constitucion"
    t.date    "fecha_inicio_operaciones"
    t.date    "fecha_vencimiento"
    t.float   "capital_suscrito"
    t.float   "capital_pagado"
    t.integer "cantidad_empleados_femeninos",  :limit => 2
    t.integer "cantidad_empleados_masculinos", :limit => 2
    t.float   "volumen_facturacion"
    t.string  "tamano",                        :limit => 1,   :default => "P"
    t.string  "numero_patente",                :limit => 15
    t.string  "numero_sunacop",                :limit => 15
    t.string  "web_site",                      :limit => 80
    t.integer "cantidad_accionistas",          :limit => 2
    t.string  "frente",                        :limit => 1
    t.integer "sector_industrial_id"
    t.string  "producto",                      :limit => 500
    t.integer "empresa_direccion_id"
    t.string  "clasificacion_siex",            :limit => 1
    t.string  "codigo_d3",                     :limit => 10
    t.string  "nombre_registro_mercantil",     :limit => 80
    t.string  "direccion_registro_mercantil",  :limit => 150
    t.integer "estado_registro_id"
    t.integer "ciudad_registro_id"
    t.integer "municipio_registro_id"
    t.integer "parroquia_registro_id"
    t.string  "nro_registro_mercantil",        :limit => 20
    t.string  "nro_folio_inicial",             :limit => 10
    t.string  "nro_folio_final",               :limit => 10
    t.string  "nro_protocolo",                 :limit => 10
    t.string  "nro_tomo",                      :limit => 10
    t.string  "nro_trimestre",                 :limit => 2
    t.date    "fecha_registro_mercantil"
    t.string  "anio_registro_mercantil",       :limit => 10
    t.string  "objeto_social"
    t.string  "nit",                           :limit => 15
    t.string  "numero_certificado",            :limit => 15
    t.integer "cant_socios_femeninos"
    t.integer "cant_socios_masculinos"
    t.string  "tipo_comunidad",                :limit => 1
    t.integer "tipo_empresa_id"
    t.integer "clasificacion_id"
    t.integer "sector_economico_id"
    t.integer "actividad_economica_id"
    t.integer "rama_actividad_economica_id"
    t.boolean "uso_calculadora"
    t.boolean "uso_maquina_escribir"
    t.boolean "uso_computadora"
    t.boolean "uso_equipos_especiales"
    t.boolean "uso_ninguno"
    t.boolean "uso_otro"
    t.string  "descripcion_otro",              :limit => 250
    t.integer "numero"
    t.text    "objeto"
    t.integer "cant_miembros"
    t.integer "numero_familias"
    t.integer "numero_viviendas"
    t.integer "cant_productores"
    t.boolean "foto_confirmacion",                            :default => false
    t.boolean "huella_confirmacion",                          :default => false
  end

  add_index "empresa", ["actividad_economica_id"], :name => "empresa_activ_econ_id_idx"
  add_index "empresa", ["nombre"], :name => "empresa_uq_nombre", :unique => true
  add_index "empresa", ["sector_economico_id"], :name => "empresa_sector_econ_id_idx"

  create_table "empresa_direccion", :force => true do |t|
    t.integer "empresa_id",                                                                            :null => false
    t.integer "ciudad_id"
    t.integer "municipio_id"
    t.integer "parroquia_id"
    t.string  "avenida",               :limit => 300,                                                  :null => false
    t.string  "edificio",              :limit => 300,                                                  :null => false
    t.string  "zona",                  :limit => 300,                                                  :null => false
    t.string  "referencia",            :limit => 300
    t.string  "codigo_postal",         :limit => 8,                                                    :null => false
    t.string  "tipo",                  :limit => 1,                                                    :null => false
    t.boolean "correspondencia"
    t.boolean "activo",                                                              :default => true
    t.string  "piso",                  :limit => 3
    t.string  "numero",                :limit => 10
    t.string  "ubicacion_geografica",  :limit => 1
    t.string  "tenencia",              :limit => 1
    t.string  "tipo_inmueble",         :limit => 1
    t.float   "espacio_aproximado_m2"
    t.decimal "alquiler_mensual",                     :precision => 16, :scale => 2
    t.integer "region_id"
    t.integer "eje_id"
    t.boolean "unidad_negocio"
  end

  create_table "empresa_email", :force => true do |t|
    t.string  "email",      :limit => 80, :null => false
    t.integer "empresa_id",               :null => false
    t.string  "tipo",       :limit => 1,  :null => false
    t.string  "facebook",   :limit => 80
    t.string  "twitter",    :limit => 80
  end

  create_table "empresa_integrante", :force => true do |t|
    t.integer "persona_id"
    t.integer "empresa_id",                                                :null => false
    t.float   "porcentaje_participacion"
    t.string  "cargo",                    :limit => 40
    t.string  "departamento",             :limit => 40
    t.boolean "contacto",                               :default => false
    t.string  "type",                     :limit => 26,                    :null => false
    t.integer "empresa_relacionada_id"
    t.integer "instancia_empresa_id"
  end

  add_index "empresa_integrante", ["empresa_id", "persona_id"], :name => "integrante_uq_tipo", :unique => true

  create_table "empresa_integrante_tipo", :force => true do |t|
    t.integer "empresa_integrante_id",                               :null => false
    t.string  "tipo",                  :limit => 1, :default => "A"
  end

  add_index "empresa_integrante_tipo", ["empresa_integrante_id", "tipo"], :name => "empresa_integrante_tipo_uq_tipo", :unique => true

  create_table "empresa_sistema", :force => true do |t|
    t.string  "rif",                 :limit => 12,                    :null => false
    t.string  "nombre_corto",        :limit => 50,                    :null => false
    t.string  "nombre",              :limit => 100,                   :null => false
    t.string  "direccion",           :limit => 300,                   :null => false
    t.string  "telefono",            :limit => 11,                    :null => false
    t.string  "representante_legal", :limit => 100,                   :null => false
    t.boolean "activo",                             :default => true
  end

  create_table "empresa_telefono", :force => true do |t|
    t.string  "numero",               :limit => 15,                    :null => false
    t.string  "tipo",                 :limit => 1,                     :null => false
    t.integer "empresa_id",                                            :null => false
    t.integer "empresa_direccion_id"
    t.string  "codigo",               :limit => 4,                     :null => false
    t.boolean "fax",                                :default => false
  end

  create_table "empresa_transporte", :force => true do |t|
    t.string  "nombre_empresa",   :limit => 100,                   :null => false
    t.string  "rif",              :limit => 20,                    :null => false
    t.string  "nit",              :limit => 20,                    :null => false
    t.string  "email_contacto",   :limit => 100
    t.string  "enlace_internet",  :limit => 100
    t.string  "telefono_oficina", :limit => 12,                    :null => false
    t.string  "telefono_celular", :limit => 12
    t.string  "telefono_fax",     :limit => 12
    t.string  "descripcion"
    t.string  "tipo_transporte",  :limit => 100
    t.integer "estado_id",                                         :null => false
    t.integer "ciudad_id",                                         :null => false
    t.integer "municipio_id",                                      :null => false
    t.integer "parroquia_id",                                      :null => false
    t.string  "avenida",          :limit => 300,                   :null => false
    t.string  "edificio",         :limit => 100
    t.string  "piso",             :limit => 3
    t.string  "numero",           :limit => 10
    t.boolean "activo",                          :default => true
  end

  add_index "empresa_transporte", ["nombre_empresa"], :name => "empresa_transporte_uq_nombre_empresa", :unique => true

  create_table "empresa_transporte_maquinaria", :force => true do |t|
    t.string  "nombre",           :limit => 100
    t.string  "direccion",        :limit => 250
    t.string  "telefono",         :limit => 11
    t.string  "rif",              :limit => 15
    t.string  "persona_contacto", :limit => 60
    t.boolean "activo"
    t.integer "estado_id"
    t.integer "ciudad_id"
    t.integer "municipio_id"
  end

  add_index "empresa_transporte_maquinaria", ["nombre"], :name => "empresa_transporte_maquinaria_uq_nombre", :unique => true

  create_table "encuesta_visita", :force => true do |t|
    t.integer "analisis_conclusion_id", :null => false
    t.boolean "respuesta"
    t.integer "seguimiento_visita_id",  :null => false
  end

  create_table "encuesta_visita_topico", :force => true do |t|
    t.integer "analisis_topico_id",                 :null => false
    t.string  "respuesta",             :limit => 1
    t.integer "seguimiento_visita_id",              :null => false
  end

  create_table "entidad_financiera", :force => true do |t|
    t.string  "nombre",                 :limit => 80,                                                    :null => false
    t.string  "alias",                  :limit => 20
    t.boolean "privado"
    t.boolean "activo",                                                               :default => true
    t.integer "cuenta_contable_id"
    t.string  "codigo_d3",              :limit => 10
    t.decimal "codigo_banco_sigesp",                   :precision => 10, :scale => 0, :default => 0
    t.boolean "activo_banmujer",                                                      :default => true
    t.boolean "consolidado"
    t.string  "nombre_contacto",        :limit => 100
    t.string  "gerencia_contacto",      :limit => 60
    t.string  "telefono_contacto",      :limit => 40
    t.string  "rif_usec",               :limit => 14
    t.string  "codban_usec",            :limit => 2
    t.boolean "sinc_usec"
    t.boolean "recaudador",                                                           :default => false
    t.string  "cod_swift",              :limit => 12
    t.string  "auxiliar_contable",      :limit => 7
    t.boolean "convenio_domiciliacion",                                               :default => false
  end

  add_index "entidad_financiera", ["codban_usec"], :name => "idx_entidad_financiera_cod_ban", :unique => true
  add_index "entidad_financiera", ["codban_usec"], :name => "unique_codban_usec", :unique => true

  create_table "equipo_seguridad", :force => true do |t|
    t.string  "modelo",                :limit => 160,                    :null => false
    t.string  "numero_serial",         :limit => 100,                    :null => false
    t.integer "cantidad"
    t.integer "ano"
    t.integer "seguimiento_visita_id"
    t.integer "embarcacion_id"
    t.integer "tipo_equipo_id"
    t.string  "condicion",             :limit => 20
    t.string  "descripcion",           :limit => 160
    t.boolean "es_propio"
    t.boolean "con_gps",                              :default => false
  end

  create_table "especialidad_tecnico", :force => true do |t|
    t.integer "sector_id",                  :null => false
    t.string  "nombre",      :limit => 100
    t.string  "descripcion"
    t.boolean "activo"
    t.integer "codigo_d3"
  end

  create_table "especie", :force => true do |t|
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion"
    t.boolean "activo",                     :default => true
  end

  add_index "especie", ["nombre"], :name => "especie_uq_nombre", :unique => true

  create_table "especie_variedad_pasto", :force => true do |t|
    t.string  "descripcion",           :limit => 30, :null => false
    t.integer "tipo_pasto_forraje_id"
  end

  create_table "estacion", :force => true do |t|
    t.string  "nombre",                  :limit => 50,                   :null => false
    t.string  "ip_address",              :limit => 20
    t.string  "mac_address",             :limit => 20
    t.integer "oficina_departamento_id",                                 :null => false
    t.integer "tipo_estacion_id"
    t.boolean "activo",                                :default => true
  end

  create_table "estado", :force => true do |t|
    t.integer "pais_id",                                           :null => false
    t.integer "region_id",                                         :null => false
    t.string  "nombre",               :limit => 40,                :null => false
    t.string  "codigo_d3",            :limit => 2
    t.integer "numeracion_instancia",               :default => 0
    t.string  "codigo_ine",           :limit => 10
  end

  add_index "estado", ["codigo_ine"], :name => "estado_uq_codigo_ine", :unique => true
  add_index "estado", ["pais_id", "nombre"], :name => "estado_uq_nombre", :unique => true

  create_table "estatus", :force => true do |t|
    t.text    "nombre",                                        :null => false
    t.string  "descripcion", :limit => 200,                    :null => false
    t.string  "area",        :limit => 100
    t.string  "const_id",    :limit => 6
    t.boolean "activo",                     :default => false
  end

  add_index "estatus", ["const_id"], :name => "unique_const_id", :unique => true

  create_table "estructura_costo", :force => true do |t|
    t.string  "costo",        :limit => 100, :null => false
    t.integer "costo_id",                    :null => false
    t.decimal "anno1"
    t.decimal "anno2"
    t.decimal "anno3"
    t.decimal "anno4"
    t.decimal "anno5"
    t.decimal "anno6"
    t.integer "solicitud_id",                :null => false
  end

  create_table "estudio_mercado", :force => true do |t|
    t.string  "estudio_demanda", :limit => 500, :null => false
    t.string  "estudio_oferta",  :limit => 500, :null => false
    t.string  "canales",         :limit => 500, :null => false
    t.integer "solicitud_id",                   :null => false
  end

  create_table "etiquetas", :force => true do |t|
    t.string "descripcion",                :null => false
    t.string "etiqueta",    :limit => 100, :null => false
  end

  create_table "evaluacion", :force => true do |t|
    t.integer "solicitud_id",   :null => false
    t.date    "fecha_creacion"
  end

  create_table "evaluacion_analisis_costos", :force => true do |t|
    t.integer "evaluacion_id",                                         :null => false
    t.integer "anio_base"
    t.float   "factor_mejora"
    t.string  "evaluacion_precios",     :limit => 1,  :default => "C"
    t.integer "numero_anios"
    t.float   "islr"
    t.float   "tir"
    t.string  "proyecto",               :limit => 15, :default => "N"
    t.integer "unidades_producidas_1"
    t.integer "unidades_producidas_2"
    t.integer "unidades_producidas_3"
    t.integer "unidades_inventario_1"
    t.integer "unidades_inventario_2"
    t.integer "unidades_inventario_3"
    t.float   "precio_inventario_1"
    t.float   "precio_inventario_2"
    t.float   "precio_inventario_3"
    t.float   "inversion_realizada_1"
    t.float   "inversion_realizada_2"
    t.float   "inversion_realizada_3"
    t.float   "inversion_por_realizar"
    t.float   "costos_variables_1"
    t.float   "costos_variables_2"
    t.float   "costos_variables_3"
    t.float   "costos_directos_1"
    t.float   "costos_directos_2"
    t.float   "costos_directos_3"
    t.float   "meta_utilidad_1"
    t.float   "meta_utilidad_2"
    t.float   "meta_utilidad_3"
    t.float   "meta_utilidad_4"
  end

  create_table "evaluacion_cualitativa", :force => true do |t|
    t.integer "evaluacion_id",                                                           :null => false
    t.integer "modalidad_financiamiento",                    :limit => 2, :default => 1
    t.integer "empleos_actuales",                            :limit => 2, :default => 0
    t.integer "empleos_generar",                             :limit => 2, :default => 0
    t.integer "rubros_financiar",                            :limit => 2, :default => 1
    t.integer "tamano_empresa",                              :limit => 2, :default => 1
    t.integer "sector_empresa",                              :limit => 2, :default => 1
    t.integer "principal_producto_fabricado",                :limit => 2, :default => 1
    t.integer "destino_economico_producto",                  :limit => 2, :default => 1
    t.integer "sustituye_importaciones",                     :limit => 2, :default => 1
    t.integer "componente_importado",                        :limit => 2
    t.integer "origen_materia_prima_importada",              :limit => 2, :default => 1
    t.integer "origen_materia_prima_nacional",               :limit => 2, :default => 1
    t.integer "destinara_porcentaje_produccion_exportacion", :limit => 2, :default => 1
    t.integer "participacion_accionaria",                    :limit => 2, :default => 1
    t.integer "porcentaje_aporte_comunidad",                 :limit => 2, :default => 1
    t.integer "experiencia_solicitante",                     :limit => 2, :default => 1
    t.integer "formacion_requerida_mano_obra",               :limit => 2, :default => 1
    t.integer "cantidad_misiones_sociales",                  :limit => 2, :default => 1
    t.integer "formacion_actual_aprendices",                 :limit => 2, :default => 1
    t.integer "leyes_trabajo",                               :limit => 2, :default => 1
    t.integer "leyes_ambientales",                           :limit => 2, :default => 1
    t.integer "normas_higiene_seguridad",                    :limit => 2, :default => 1
    t.float   "porcentaje_exportacion"
  end

  create_table "evaluacion_financiera", :force => true do |t|
    t.integer "evaluacion_id",      :null => false
    t.float   "activo_circulante"
    t.float   "valor_inventario"
    t.float   "pasivo_corto_plazo"
  end

  create_table "evaluacion_flujo_caja", :force => true do |t|
    t.integer "evaluacion_id",    :null => false
    t.float   "tasa_lr"
    t.float   "tmar"
    t.float   "tasa_reinversion"
    t.float   "tasa_prestamo"
  end

  create_table "evaluacion_flujo_caja_detalle", :force => true do |t|
    t.integer "evaluacion_flujo_caja_id", :null => false
    t.float   "monto"
    t.float   "variacion"
    t.integer "periodo"
  end

  create_table "evaluacion_plan_inversion", :force => true do |t|
    t.integer "evaluacion_id",         :null => false
    t.float   "ingresos_esperados"
    t.float   "gastos_capitalizables"
    t.float   "porcentaje_islr"
    t.float   "rentabilidad_esperada"
  end

  create_table "evento", :force => true do |t|
    t.string "descripcion", :null => false
  end

  create_table "execedentesap", :id => false, :force => true do |t|
    t.integer "numero",   :limit => 8,                                :default => 0
    t.decimal "saldosap",              :precision => 16, :scale => 2, :default => 0.0
  end

  create_table "experiencia", :force => true do |t|
    t.string "nombre", :limit => 100, :null => false
  end

  create_table "factura", :force => true do |t|
    t.integer "numero",                                                                :default => 0
    t.date    "fecha",                                                                                             :null => false
    t.date    "fecha_realizacion"
    t.date    "fecha_contable"
    t.integer "pago_cliente_id"
    t.integer "desembolso_id"
    t.integer "prestamo_id",                                                                                       :null => false
    t.string  "tipo",                     :limit => 1,                                 :default => "D"
    t.decimal "monto",                                  :precision => 16, :scale => 2, :default => 0.0
    t.boolean "proceso_nocturno",                                                      :default => false
    t.integer "prestamo_modificacion_id"
    t.decimal "remanente_por_aplicar",                  :precision => 16, :scale => 2, :default => 0.0
    t.string  "analista",                 :limit => 50
    t.text    "comentario_analista"
    t.string  "estado",                   :limit => 20
    t.string  "sector_economico",         :limit => 50
    t.string  "distincion_cobranza",      :limit => 3
    t.string  "codigo_contable",          :limit => 10,                                :default => "000.000"
    t.boolean "consultoria_juridica",                                                  :default => false
    t.string  "estado_geografico",        :limit => 20,                                :default => "AMAZONAS INI"
    t.decimal "abono_capital",                          :precision => 16, :scale => 2, :default => 0.0
    t.integer "tipo_cartera_id",                                                       :default => 1
    t.boolean "recuperaciones",                                                        :default => false
    t.decimal "pago_capital",                           :precision => 16, :scale => 2, :default => 0.0
    t.decimal "pago_interes",                           :precision => 16, :scale => 2, :default => 0.0
    t.decimal "pago_mora",                              :precision => 16, :scale => 2, :default => 0.0
    t.decimal "monto_banco",                            :precision => 16, :scale => 2
    t.decimal "monto_sras",                             :precision => 16, :scale => 2
    t.decimal "monto_insumos",                          :precision => 16, :scale => 2
    t.decimal "monto_inventario",                       :precision => 16, :scale => 2, :default => 0.0
    t.decimal "monto_gastos",                           :precision => 16, :scale => 2, :default => 0.0,            :null => false
    t.boolean "pago_al_dia",                                                           :default => false,          :null => false
  end

  create_table "factura_orden_despacho", :force => true do |t|
    t.integer "orden_despacho_detalle_id"
    t.string  "item_nombre",                 :limit => 100,                                                   :null => false
    t.integer "unidad_medida_id",                                                                             :null => false
    t.decimal "cantidad",                                   :precision => 16, :scale => 2,                    :null => false
    t.decimal "costo_real",                                 :precision => 16, :scale => 2,                    :null => false
    t.decimal "monto_financiamiento",                       :precision => 16, :scale => 2,                    :null => false
    t.integer "casa_proveedora_id"
    t.integer "sucursal_casa_proveedora_id"
    t.string  "numero_factura",              :limit => 20
    t.decimal "monto_factura",                              :precision => 16, :scale => 2,                    :null => false
    t.decimal "cantidad_factura",                           :precision => 16, :scale => 2
    t.date    "fecha_factura"
    t.date    "fecha_emision"
    t.boolean "confirmada",                                                                :default => false, :null => false
    t.string  "secuencia",                   :limit => 100
    t.boolean "emitida",                                                                   :default => false, :null => false
    t.integer "factura_estatus_id",                                                        :default => 0
    t.text    "observacion"
  end

  create_table "faenas_pesca", :force => true do |t|
    t.float   "ganancia_por_unidad"
    t.float   "gasto_por_unidad"
    t.string  "destino_captura",       :limit => 160,                                :null => false
    t.integer "tiempo_expiracion"
    t.integer "tipo_especie_id"
    t.integer "seguimiento_visita_id"
    t.integer "embarcacion_id"
    t.integer "faenas_mensual"
    t.float   "captura_campana"
    t.float   "captura_estimada"
    t.decimal "precio_x_kg",                          :precision => 16, :scale => 2
  end

  create_table "fianza", :force => true do |t|
    t.integer "garantia_id",                              :null => false
    t.boolean "validacion_recaudos",   :default => false
    t.integer "empresa_integrante_id",                    :null => false
  end

  create_table "ficha_resumen", :force => true do |t|
    t.integer "solicitud_id"
    t.decimal "monto_credito_recomendado",                        :precision => 16, :scale => 2
    t.text    "destino_credito"
    t.integer "modalidad_financiamiento_id"
    t.decimal "capital_social",                                   :precision => 16, :scale => 2
    t.decimal "capital_suscrito",                                 :precision => 16, :scale => 2
    t.decimal "capital_pagado",                                   :precision => 16, :scale => 2
    t.integer "unidades_actuales"
    t.integer "unidades_proyecto"
    t.decimal "monto_actuales",                                   :precision => 16, :scale => 2
    t.decimal "monto_proyecto",                                   :precision => 16, :scale => 2
    t.decimal "van",                                              :precision => 16, :scale => 2
    t.decimal "tir",                                              :precision => 16, :scale => 2
    t.integer "clasificacion_riesgo_id"
    t.string  "calificacion_cuantitativa",          :limit => 50
    t.string  "calificacion_cualitativa",           :limit => 50
    t.string  "calificacion_social",                :limit => 50
    t.boolean "atributo_expansion",                                                              :default => false
    t.boolean "atributo_competitividad",                                                         :default => false
    t.boolean "atributo_innovacion_tecnologica",                                                 :default => false
    t.boolean "atributo_diversificacion",                                                        :default => false
    t.boolean "atributo_transferencia_tecnologica",                                              :default => false
    t.boolean "atributo_desarrollo_tecnologico",                                                 :default => false
    t.integer "scoring_aceptacion_id",                                                           :default => 1
  end

  create_table "fideicomiso", :force => true do |t|
    t.integer "entidad_financiera_id",                                       :null => false
    t.integer "programa_id",                                                 :null => false
    t.date    "fecha_creacion"
    t.date    "fecha_ultima_actualizacion"
    t.float   "porcentaje"
    t.float   "monto_disponible"
    t.float   "subcuenta_banco"
    t.float   "subcuenta_insumos"
    t.float   "subcuenta_sras"
    t.float   "subcuenta_gastos"
    t.boolean "activo",                                   :default => false
    t.string  "numero_fideicomiso",         :limit => 20
  end

  create_table "fideicomiso_cuentas", :force => true do |t|
    t.integer "fideicomiso_id", :null => false
    t.integer "cuenta_bcv_id",  :null => false
  end

  create_table "fideicomiso_movimientos", :force => true do |t|
    t.integer  "fideicomiso_id",           :null => false
    t.integer  "tipo_movimiento_id"
    t.integer  "nro_lote"
    t.datetime "fecha_movimiento"
    t.text     "referencia"
    t.text     "justificacion"
    t.float    "saldo_disponible_antes"
    t.float    "monto_operacion"
    t.float    "monto_banco"
    t.float    "monto_insumos"
    t.float    "monto_sras"
    t.float    "monto_gastos"
    t.float    "monto_primer_desembolso"
    t.float    "comision"
    t.float    "saldo_disponible_despues"
    t.integer  "usuario_id"
  end

  create_table "firma_autorizada", :force => true do |t|
    t.integer "cargo_id"
    t.string  "nombre",   :limit => 120
    t.string  "cedula",   :limit => 10
  end

  add_index "firma_autorizada", ["cargo_id"], :name => "uq_cargo_id", :unique => true

  create_table "fiscal", :id => false, :force => true do |t|
    t.integer "id",                                 :null => false
    t.string  "nombre",              :limit => 100, :null => false
    t.string  "letra_cedula_fiscal", :limit => 1,   :null => false
    t.integer "cedula_fiscal",                      :null => false
    t.string  "direccion",           :limit => 155, :null => false
    t.string  "telefono",            :limit => 15,  :null => false
    t.integer "usuario_id",                         :null => false
  end

  create_table "fiscal_silo", :id => false, :force => true do |t|
    t.integer "fiscal_id", :null => false
    t.integer "silo_id",   :null => false
  end

  create_table "formacion", :force => true do |t|
    t.string "nombre", :limit => 100, :null => false
  end

  create_table "formato_boleta", :force => true do |t|
    t.integer "usuario_id",                       :null => false
    t.boolean "status"
    t.integer "sector_id"
    t.integer "sub_sector_id"
    t.integer "rubro_id"
    t.integer "sub_rubro_id"
    t.integer "actividad_id"
    t.string  "formato_operacion", :limit => 200
  end

  create_table "formula", :force => true do |t|
    t.string "nombre",      :limit => 40,  :null => false
    t.string "descripcion", :limit => 200
  end

  add_index "formula", ["nombre"], :name => "formula_uq_nombre", :unique => true

  create_table "garantia", :force => true do |t|
    t.integer "solicitud_id",                                                      :null => false
    t.integer "tipo_garantia_id",                                                  :null => false
    t.date    "fecha_vida_util"
    t.boolean "validacion_facturas",                            :default => false
    t.boolean "validacion_declaracion",                         :default => false
    t.integer "ciudad_id"
    t.integer "municipio_id"
    t.integer "parroquia_id"
    t.string  "avenida",                         :limit => 40
    t.string  "edificio",                        :limit => 40
    t.string  "zona",                            :limit => 40
    t.string  "referencia",                      :limit => 40
    t.string  "codigo_postal",                   :limit => 8
    t.string  "telefono",                        :limit => 60
    t.string  "fax",                             :limit => 20
    t.string  "codigo_identificacion",           :limit => 15
    t.float   "monto_garantia"
    t.float   "porcentaje_reconocimiento"
    t.boolean "validacion_avaluo",                              :default => false
    t.integer "perito_id"
    t.string  "perito_externo_primer_nombre",    :limit => 20
    t.string  "perito_externo_segundo_nombre",   :limit => 20
    t.string  "perito_externo_primer_apellido",  :limit => 20
    t.string  "perito_externo_segundo_apellido", :limit => 20
    t.float   "monto_avaluo_inicial"
    t.float   "monto_avaluo_foncrei"
    t.date    "fecha_avaluo_inicial"
    t.date    "fecha_avaluo_foncrei"
    t.boolean "validacion_gravamen",                            :default => false
    t.boolean "validacion_garantia_futuro",                     :default => false
    t.integer "plazo",                           :limit => 2
    t.string  "condiciones",                     :limit => 500
    t.date    "fecha_constitucion"
    t.date    "fecha_autenticacion"
    t.integer "municipio_autenticacion_id"
    t.string  "numero_acta_autenticacion",       :limit => 20
    t.string  "tomo_autenticacion",              :limit => 20
    t.date    "fecha_protocolizacion"
    t.integer "municipio_protocolizacion_id"
    t.string  "numero_acta_protocolizacion",     :limit => 20
    t.string  "tomo_protocolizacion",            :limit => 20
    t.string  "protocolizacion",                 :limit => 20
    t.date    "poliza_seguro_fecha_desde"
    t.date    "poliza_seguro_fecha_hasta"
    t.string  "comentario",                      :limit => 500
    t.string  "estatus",                         :limit => 1
  end

  create_table "garantia_sector", :force => true do |t|
    t.integer "sub_sector_id",    :null => false
    t.integer "tipo_garantia_id", :null => false
  end

  create_table "gebos_auditoria", :force => true do |t|
    t.integer  "usuario_id",                                                            :null => false
    t.string   "usuario_nombre",      :limit => 200,                                    :null => false
    t.string   "usuario_ip",          :limit => 20
    t.string   "controlador",         :limit => 200
    t.string   "accion",              :limit => 200
    t.text     "url"
    t.string   "cantidad_parametros"
    t.text     "parametros"
    t.datetime "creado_el",                          :default => '2013-05-13 09:47:52'
  end

  create_table "gebos_contabilidad_dataload", :force => true do |t|
    t.integer  "usuario_id",                                         :null => false
    t.string   "tipo_movimiento"
    t.string   "nombre_archivo"
    t.integer  "numero_filas"
    t.string   "ruta_archivo"
    t.datetime "fecha_creacion",  :default => '2012-02-06 16:22:10'
  end

  create_table "gerencia", :force => true do |t|
    t.integer "solicitud_id",                  :null => false
    t.integer "departamento_id",               :null => false
    t.string  "persona",         :limit => 50
  end

  create_table "gestion_cobranza_observacion", :force => true do |t|
    t.integer "gestion_cobranza_id",                   :null => false
    t.text    "observacion"
    t.boolean "activo",              :default => true, :null => false
  end

  create_table "gestion_cobranzas", :force => true do |t|
    t.integer "analista_cobranza_id",                                                                         :null => false
    t.integer "prestamo_id",                                                                                  :null => false
    t.date    "fecha_registro",                                                                               :null => false
    t.integer "tipo_gestion_cobranza_id",                                                                     :null => false
    t.decimal "saldo_insoluto",                              :precision => 16, :scale => 2, :default => 0.0,  :null => false
    t.decimal "deuda",                                       :precision => 16, :scale => 2, :default => 0.0,  :null => false
    t.decimal "exigible",                                    :precision => 16, :scale => 2, :default => 0.0,  :null => false
    t.integer "cantidad_cuotas_prestamo",                                                   :default => 0,    :null => false
    t.integer "cantidad_cuotas_vencidas",                                                   :default => 0,    :null => false
    t.decimal "monto_capital_vencido",                       :precision => 16, :scale => 2, :default => 0.0,  :null => false
    t.decimal "monto_interes_vencido",                       :precision => 16, :scale => 2, :default => 0.0,  :null => false
    t.decimal "monto_interes_diferido_vencido",              :precision => 16, :scale => 2, :default => 0.0,  :null => false
    t.decimal "monto_interes_mora",                          :precision => 16, :scale => 2, :default => 0.0,  :null => false
    t.decimal "monto_capital_pagado",                        :precision => 16, :scale => 2, :default => 0.0,  :null => false
    t.decimal "monto_interes_pagado",                        :precision => 16, :scale => 2, :default => 0.0,  :null => false
    t.decimal "monto_interes_diferido_pagado",               :precision => 16, :scale => 2, :default => 0.0,  :null => false
    t.decimal "monto_interes_mora_pagado",                   :precision => 16, :scale => 2, :default => 0.0,  :null => false
    t.decimal "monto_liquidado",                             :precision => 16, :scale => 2, :default => 0.0,  :null => false
    t.string  "estatus_prestamo",               :limit => 1,                                                  :null => false
    t.integer "cantidad_veces_vigente",                                                     :default => 0,    :null => false
    t.integer "cantidad_veces_mora",                                                        :default => 0,    :null => false
    t.integer "cantidad_dias_mora_acumulados",                                              :default => 0,    :null => false
    t.date    "fecha_confirmacion"
    t.time    "hora_confirmacion",              :limit => 6
    t.boolean "activo",                                                                     :default => true, :null => false
    t.time    "hora_registro",                  :limit => 6
    t.text    "mensaje"
  end

  create_table "grupo", :force => true do |t|
    t.integer "numero"
  end

  create_table "grupo_familiar", :force => true do |t|
    t.string  "nombre_apellido",                 :limit => 100, :null => false
    t.string  "sexo",                            :limit => 1,   :null => false
    t.date    "fecha_nacimiento"
    t.string  "grado_instruccion_primaria",      :limit => 1
    t.string  "grado_instruccion_secundaria",    :limit => 1
    t.string  "grado_instruccion_medio",         :limit => 1
    t.string  "grado_instruccion_universitario", :limit => 1
    t.string  "grado_instruccion_superior",      :limit => 1
    t.string  "grado_instruccion_robinson1",     :limit => 1
    t.string  "grado_instruccion_robinson2",     :limit => 1
    t.string  "grado_instruccion_robinson3",     :limit => 1
    t.string  "grado_instruccion_ribas",         :limit => 1
    t.string  "grado_instruccion_sucre",         :limit => 1
    t.integer "persona_id",                                     :null => false
  end

  create_table "grupo_integrante", :force => true do |t|
    t.integer "grupo_id",   :null => false
    t.integer "persona_id", :null => false
    t.boolean "lider"
  end

  create_table "guia_catalogo", :force => true do |t|
    t.integer "catalogo_id"
    t.integer "guia_movilizacion_maquinaria_id"
    t.boolean "conforme"
  end

  create_table "guia_movilizacion_maquinaria", :force => true do |t|
    t.integer "solicitud_id"
    t.integer "empresa_transporte_maquinaria_id"
    t.integer "oficina_id"
    t.string  "ci_contacto_1",                    :limit => 10
    t.string  "ci_contacto_2",                    :limit => 10
    t.string  "nombre_contacto_1",                :limit => 60
    t.string  "nombre_contacto_2",                :limit => 60
    t.string  "telefono_contacto_1",              :limit => 11
    t.string  "telefono_contacto_2",              :limit => 11
    t.date    "fecha_emision"
    t.string  "destino",                          :limit => 1
    t.integer "unidad_produccion_id"
    t.string  "direccion_destino",                :limit => 250
    t.string  "telefono_destino",                 :limit => 11
    t.string  "estatus",                          :limit => 1
    t.integer "usuario_id"
    t.string  "numero_guia",                      :limit => 20
    t.string  "evento",                           :limit => 60
    t.string  "ci_nacionalidad_1",                :limit => 1
    t.string  "ci_nacionalidad_2",                :limit => 1
    t.date    "fecha_estimada"
  end

  add_index "guia_movilizacion_maquinaria", ["numero_guia"], :name => "guia_movilizacion_maquinaria_uq_numero_guia"

  create_table "hierro_fondas", :force => true do |t|
    t.string  "nombre_registro", :limit => 100
    t.integer "estado_id"
    t.integer "ciudad_id"
    t.integer "municipio_id"
    t.date    "fecha_registro"
    t.string  "numero",          :limit => 100
    t.integer "tomo"
    t.string  "protocolo",       :limit => 100
    t.boolean "activo"
  end

  create_table "historico_cambio_cuenta", :force => true do |t|
    t.integer  "usuario_id"
    t.integer  "persona_id"
    t.integer  "empresa_id"
    t.integer  "entidad_financiera_id_actual"
    t.integer  "entidad_financiera_id_ultima_modificacion"
    t.string   "tipo_cuenta_actual",                        :limit => 1
    t.string   "tipo_cuenta_ultima_modificacion",           :limit => 1
    t.string   "numero_cuenta_actual",                      :limit => 20
    t.string   "numero_cuenta_ultima_modificacion",         :limit => 20
    t.datetime "fecha_modificacion_actual"
    t.date     "fecha_ultima_modificacion"
    t.date     "fecha_apertura"
    t.text     "observaciones"
    t.integer  "cuenta_id"
    t.boolean  "activo_actual"
    t.boolean  "activo_ultima_modificacion"
  end

  create_table "historico_liquidacion_casa_proveedora", :force => true do |t|
    t.integer "solicitud_id",                                                                                         :null => false
    t.integer "prestamo_id",                                                                                          :null => false
    t.integer "casa_proveedora_id",                                                                                   :null => false
    t.date    "fecha_liquidacion"
    t.string  "archivo",                               :limit => 100
    t.decimal "monto_liquidacion",                                    :precision => 16, :scale => 2, :default => 0.0
    t.integer "entidad_financiera_liquidadora_id"
    t.string  "numero_factura",                        :limit => 8
    t.string  "numero_cuenta_liquidadora",             :limit => 20
    t.integer "entidad_financiera_casa_proveedora_id",                                                                :null => false
    t.string  "numero_cuenta_casa_proveedora",         :limit => 20,                                                  :null => false
  end

  create_table "historico_liquidacion_transferencia", :force => true do |t|
    t.integer "solicitud_id",                                                                                     :null => false
    t.integer "prestamo_id",                                                                                      :null => false
    t.integer "cliente_id",                                                                                       :null => false
    t.date    "fecha_liquidacion"
    t.string  "archivo",                           :limit => 100
    t.decimal "monto_liquidacion",                                :precision => 16, :scale => 2, :default => 0.0
    t.integer "entidad_financiera_liquidadora_id"
    t.string  "numero_cuenta_liquidadora",         :limit => 20
    t.integer "entidad_financiera_cliente_id",                                                                    :null => false
    t.string  "numero_cuenta_cliente",             :limit => 20,                                                  :null => false
  end

  create_table "idioma", :force => true do |t|
    t.string  "nombre",   :limit => 200
    t.string  "bandera",  :limit => 200
    t.string  "nemonico", :limit => 2
    t.boolean "activo"
  end

  add_index "idioma", ["nemonico"], :name => "nemonico_unico", :unique => true

  create_table "imputaciones_maquinaria", :force => true do |t|
    t.date   "fecha_registro"
    t.float  "seguro_nacional",                        :null => false
    t.float  "flete_nacional",                         :null => false
    t.float  "gastos_administrativos",                 :null => false
    t.float  "seguro_internacional",                   :null => false
    t.float  "flete_internacional",                    :null => false
    t.float  "nacionalizacion_impuestos",              :null => false
    t.float  "almacenamiento",                         :null => false
    t.text   "observacion",                            :null => false
    t.string "indicador",                 :limit => 1
  end

  create_table "instancia_empresa", :force => true do |t|
    t.string  "descripcion", :limit => 50, :null => false
    t.boolean "activo",                    :null => false
  end

  create_table "instancia_tipo", :force => true do |t|
    t.string  "nombre",     :limit => 20
    t.integer "estatus_id", :limit => 8,  :default => 1
  end

  create_table "instrumento_financiero", :force => true do |t|
    t.string  "descripcion", :limit => 25, :null => false
    t.boolean "activo",                    :null => false
  end

  create_table "insumos_internos", :force => true do |t|
    t.string  "nombre", :limit => 200,                    :null => false
    t.boolean "activo",                :default => false
  end

  create_table "item", :force => true do |t|
    t.integer "partida_id",                                                                           :null => false
    t.string  "nombre",                :limit => 100
    t.string  "descripcion"
    t.boolean "activo"
    t.integer "codigo_d3"
    t.integer "actividad_id",                                                                         :null => false
    t.integer "unidad_medida_id",                                                                     :null => false
    t.integer "numero_desembolso",                                                   :default => 0,   :null => false
    t.integer "codigo",                                                              :default => 0
    t.string  "tipo_item",             :limit => 1
    t.decimal "cantidad_por_hectarea",                :precision => 14, :scale => 2, :default => 1.0, :null => false
  end

  add_index "item", ["actividad_id", "partida_id", "codigo"], :name => "item_uq_codigo"
  add_index "item", ["actividad_id", "partida_id", "nombre"], :name => "item_uq_nombre"

  create_table "item_atributo", :force => true do |t|
    t.string  "nombre",      :limit => 40,                    :null => false
    t.string  "descripcion", :limit => 300
    t.boolean "activo",                     :default => true
    t.integer "item_id",                                      :null => false
    t.string  "tipo",        :limit => 1,   :default => "1"
    t.string  "tabla_combo", :limit => 100
  end

  add_index "item_atributo", ["nombre"], :name => "item_atributo_uq_nombre", :unique => true

  create_table "linderos_coordenadas", :force => true do |t|
    t.integer "solicitud_id",          :null => false
    t.integer "unidad_produccion_id",  :null => false
    t.integer "seguimiento_visita_id", :null => false
    t.text    "lindero_norte"
    t.text    "lindero_sur"
    t.text    "lindero_este"
    t.text    "lindero_oeste"
    t.text    "utm_norte"
    t.text    "utm_sur"
    t.text    "utm_este"
    t.text    "utm_oeste"
    t.boolean "direccion_correcta"
    t.boolean "superficie_correcta"
    t.boolean "lindero_correcto"
    t.text    "referencial_utm"
  end

  create_table "llamada_infructuosa", :force => true do |t|
    t.text    "descripcion",                   :null => false
    t.boolean "activo",      :default => true, :null => false
  end

  create_table "logws", :force => true do |t|
    t.string "log",        :limit => 2000, :null => false
    t.date   "timestamps"
  end

  create_table "m_clientes_no_migrados", :id => false, :force => true do |t|
    t.integer "id",                          :null => false
    t.string  "codigo_d3",    :limit => 10
    t.string  "rif",          :limit => 20
    t.string  "nombre",       :limit => 300
    t.string  "errores",      :limit => 500
    t.string  "fecha",        :limit => 20
    t.string  "tipo_error",   :limit => 1
    t.integer "numero_linea"
  end

  create_table "m_cuotas_no_migrados", :id => false, :force => true do |t|
    t.integer "id",                              :null => false
    t.integer "numero_prestamo",  :limit => 8
    t.integer "numero_cuota"
    t.string  "tipo_cuota",       :limit => 1
    t.string  "errores",          :limit => 500
    t.string  "tipo_error",       :limit => 1
    t.integer "numero_linea"
    t.integer "numero_solicitud", :limit => 8
  end

  create_table "m_direcciones_no_migrados", :id => false, :force => true do |t|
    t.integer "id",                        :null => false
    t.string  "codigo_d3",  :limit => 10
    t.string  "direccion",  :limit => 80
    t.string  "errores",    :limit => 500
    t.string  "tipo_error", :limit => 1
  end

  create_table "m_emails_no_migrados", :id => false, :force => true do |t|
    t.integer "id",                        :null => false
    t.string  "codigo_d3",  :limit => 10
    t.string  "email",      :limit => 100
    t.string  "errores",    :limit => 500
    t.string  "tipo_error", :limit => 1
  end

  create_table "m_integrantes_no_migrados", :force => true do |t|
    t.string  "rif",               :limit => 20,  :null => false
    t.string  "cedula_integrante", :limit => 100
    t.string  "nombre",            :limit => 100
    t.string  "errores",           :limit => 500
    t.string  "fecha",             :limit => 20
    t.integer "numero_linea"
  end

  create_table "m_items_no_migrados", :force => true do |t|
    t.string "codigo",            :limit => 50
    t.text   "descripcion_error"
    t.date   "fecha"
  end

  create_table "m_oficinas_no_migrados", :force => true do |t|
    t.integer "oficina_id"
    t.string  "nombre_oficina",    :limit => 100
    t.text    "descripcion_error"
    t.string  "tipo_error",        :limit => 1
    t.date    "fecha_proceso"
  end

  create_table "m_pago_parcial", :force => true do |t|
    t.string  "nombre",               :limit => 300,                                :null => false
    t.string  "documento",            :limit => 20,                                 :null => false
    t.integer "numero_prestamo",      :limit => 8
    t.decimal "monto_pago_parcial",                  :precision => 16, :scale => 2
    t.decimal "monto_capital_cuotas",                :precision => 16, :scale => 2
    t.decimal "saldo_deudor",                        :precision => 16, :scale => 2
  end

  create_table "m_pagos", :force => true do |t|
    t.string  "nombre",          :limit => 300,                                :null => false
    t.string  "documento",       :limit => 20,                                 :null => false
    t.integer "numero_prestamo", :limit => 8
    t.decimal "monto_pago",                     :precision => 16, :scale => 2
    t.string  "numero_voucher",  :limit => 100
    t.date    "fecha"
    t.string  "descripcion",     :limit => 300
    t.string  "tipo_error",      :limit => 1
  end

  create_table "m_personas_no_migrados", :id => false, :force => true do |t|
    t.integer "id",                          :null => false
    t.string  "cedula",       :limit => 12
    t.string  "nombre",       :limit => 300
    t.string  "errores",      :limit => 500
    t.string  "tipo_error",   :limit => 1
    t.integer "numero_linea"
  end

  create_table "m_plan_inversion_no_migrados", :id => false, :force => true do |t|
    t.integer "id",                          :null => false
    t.string  "codigo_d3",    :limit => 20
    t.string  "numero",       :limit => 10
    t.string  "errores",      :limit => 500
    t.string  "tipo_error",   :limit => 1
    t.integer "numero_linea"
    t.date    "fecha"
  end

  create_table "m_plan_no_migrados", :id => false, :force => true do |t|
    t.integer "id",                             :null => false
    t.integer "numero_prestamo"
    t.string  "errores",         :limit => 500
    t.integer "numero_linea"
  end

  create_table "m_prestamos_no_migrados", :id => false, :force => true do |t|
    t.integer "id",                          :null => false
    t.string  "codigo_d3",    :limit => 20
    t.integer "numero"
    t.string  "errores",      :limit => 500
    t.string  "tipo_error",   :limit => 1
    t.integer "numero_linea"
    t.date    "fecha"
  end

  create_table "m_rubros_no_migrados", :force => true do |t|
    t.string "codigo",            :limit => 15
    t.text   "descripcion_error"
    t.string "tipo_error",        :limit => 1
    t.date   "fecha"
  end

  create_table "m_solicitudes_no_migrados", :id => false, :force => true do |t|
    t.integer "id",                          :null => false
    t.string  "codigo_d3",    :limit => 20
    t.string  "numero",       :limit => 10
    t.string  "errores",      :limit => 500
    t.string  "tipo_error",   :limit => 1
    t.integer "numero_linea"
    t.date    "fecha"
  end

  create_table "m_telefonos_no_migrados", :id => false, :force => true do |t|
    t.integer "id",                                           :null => false
    t.string  "codigo_d3",  :limit => 10
    t.string  "telefono",   :limit => 40
    t.boolean "fax",                       :default => false
    t.string  "errores",    :limit => 500
    t.string  "tipo_error", :limit => 1
  end

  create_table "m_unidad_produccion_no_migrados", :id => false, :force => true do |t|
    t.integer "id",                          :null => false
    t.string  "codigo_d3",    :limit => 30
    t.string  "rif",          :limit => 20
    t.string  "nombre",       :limit => 300
    t.string  "errores",      :limit => 500
    t.string  "fecha",        :limit => 20
    t.string  "tipo_error",   :limit => 1
    t.integer "numero_linea"
  end

  create_table "manejo_instalaciones", :force => true do |t|
    t.integer "seguimiento_visita_id",                                        :null => false
    t.boolean "tecnologia_convenio",                       :default => false, :null => false
    t.boolean "plan_vacunacion",                           :default => false, :null => false
    t.boolean "inseminacion_artificial",                   :default => false, :null => false
    t.text    "descripcion_pajuela"
    t.boolean "sala_ordenio",                              :default => false, :null => false
    t.string  "tipo_ordenio",                 :limit => 2
    t.string  "calidad_ordenio",              :limit => 1
    t.boolean "refrescadero_leche",                        :default => false, :null => false
    t.string  "calidad_refrescadero",         :limit => 1
    t.boolean "registro",                                  :default => false, :null => false
    t.string  "calidad_registro",             :limit => 1
    t.boolean "alimento_concentrado",                      :default => false, :null => false
    t.string  "calidad_alimento_concentrado", :limit => 1
    t.boolean "otro_tipo_suplementacion",                  :default => false, :null => false
    t.text    "especificar_suplementacion"
    t.string  "calidad_suplementacion",       :limit => 1
    t.text    "descripcion_observado"
  end

  create_table "marca", :force => true do |t|
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion", :limit => 250,                   :null => false
    t.boolean "activo",                     :default => true, :null => false
  end

  add_index "marca", ["nombre"], :name => "marca_uk", :unique => true

  create_table "marca_maquinaria", :force => true do |t|
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion", :limit => 250,                   :null => false
    t.boolean "activo",                     :default => true, :null => false
  end

  add_index "marca_maquinaria", ["nombre"], :name => "marca_maquinaria_uq_nombre"

  create_table "materia_prima", :force => true do |t|
    t.string  "nombre",      :limit => 50,  :null => false
    t.string  "descripcion", :limit => 100, :null => false
    t.boolean "activo",                     :null => false
  end

  create_table "mensajes_correo", :force => true do |t|
    t.string  "nombre"
    t.text    "descripcion"
    t.boolean "activo"
  end

  create_table "mensajes_sms", :force => true do |t|
    t.string  "nombre"
    t.text    "descripcion"
    t.boolean "activo"
  end

  create_table "menu", :force => true do |t|
    t.string  "nombre",      :limit => 50,  :null => false
    t.string  "descripcion", :limit => 300
    t.integer "parent_id"
    t.integer "orden",                      :null => false
    t.integer "opcion_id"
    t.integer "menu_id"
  end

  create_table "mercado_productos", :force => true do |t|
    t.string  "producto",            :limit => 100, :null => false
    t.integer "capacidad_instalada",                :null => false
    t.integer "cantidad1"
    t.decimal "precio1"
    t.decimal "costo1"
    t.decimal "ganancia1"
    t.integer "cantidad2"
    t.decimal "precio2"
    t.decimal "costo2"
    t.decimal "ganancia2"
    t.integer "cantidad3"
    t.decimal "precio3"
    t.decimal "costo3"
    t.decimal "ganancia3"
    t.integer "cantidad4"
    t.decimal "precio4"
    t.decimal "costo4"
    t.decimal "ganancia4"
    t.integer "cantidad5"
    t.decimal "precio5"
    t.decimal "costo5"
    t.decimal "ganancia5"
    t.integer "cantidad6"
    t.decimal "precio6"
    t.decimal "costo6"
    t.decimal "ganancia6"
    t.integer "solicitud_id",                       :null => false
  end

  create_table "meta", :force => true do |t|
    t.date    "fecha_actualizacion",    :null => false
    t.integer "anio",                   :null => false
    t.integer "usuario_id",             :null => false
    t.float   "monto_liquidado"
    t.integer "numero_solicitudes"
    t.integer "numero_empresas"
    t.float   "monto_liquidado_min"
    t.float   "monto_liquidado_max"
    t.integer "numero_solicitudes_min"
    t.integer "numero_solicitudes_max"
    t.integer "numero_empresas_min"
    t.integer "numero_empresas_max"
  end

  create_table "meta_programa", :force => true do |t|
    t.integer "meta_id"
    t.date    "fecha_actualizacion", :null => false
    t.integer "usuario_id",          :null => false
    t.float   "monto_liquidado"
    t.integer "numero_solicitudes"
    t.integer "numero_empresas"
    t.integer "programa_id",         :null => false
  end

  create_table "meta_region", :force => true do |t|
    t.integer "meta_id"
    t.date    "fecha_actualizacion", :null => false
    t.integer "usuario_id",          :null => false
    t.float   "monto_liquidado"
    t.integer "numero_solicitudes"
    t.integer "numero_empresas"
    t.integer "region_id",           :null => false
  end

  create_table "meta_sector_industrial", :force => true do |t|
    t.integer "meta_id"
    t.date    "fecha_actualizacion",  :null => false
    t.integer "usuario_id",           :null => false
    t.float   "monto_liquidado"
    t.integer "numero_solicitudes"
    t.integer "numero_empresas"
    t.integer "sector_industrial_id", :null => false
  end

  create_table "meta_tipo_credito", :force => true do |t|
    t.integer "meta_id"
    t.date    "fecha_actualizacion", :null => false
    t.integer "usuario_id",          :null => false
    t.float   "monto_liquidado"
    t.integer "numero_solicitudes"
    t.integer "numero_empresas"
    t.integer "tipo_credito_id",     :null => false
  end

  create_table "meta_tipo_empresa", :force => true do |t|
    t.integer "meta_id"
    t.date    "fecha_actualizacion", :null => false
    t.integer "usuario_id",          :null => false
    t.float   "monto_liquidado"
    t.integer "numero_solicitudes"
    t.integer "numero_empresas"
    t.integer "tipo_empresa_id",     :null => false
  end

  create_table "meta_transaccion", :force => true do |t|
    t.string "nombre",      :limit => 50,  :null => false
    t.string "descripcion", :limit => 250
  end

  create_table "miembro_comite", :force => true do |t|
    t.string  "nombre",                  :limit => 60,  :null => false
    t.string  "apellido",                :limit => 60,  :null => false
    t.integer "cedula"
    t.string  "area",                    :limit => 100
    t.boolean "comite_reestructuracion"
  end

  create_table "mision", :force => true do |t|
    t.string  "nombre",      :limit => 60,  :null => false
    t.string  "descripcion", :limit => 100, :null => false
    t.boolean "activo",                     :null => false
  end

  create_table "modalidad_financiamiento", :force => true do |t|
    t.string  "nombre",      :limit => 40,                    :null => false
    t.string  "descripcion", :limit => 300,                   :null => false
    t.boolean "activo",                     :default => true
    t.string  "codigo_d3",   :limit => 20
  end

  add_index "modalidad_financiamiento", ["nombre"], :name => "modalidad_financiamiento_uq_nombre", :unique => true

  create_table "modelo", :force => true do |t|
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion", :limit => 250,                   :null => false
    t.boolean "activo",                     :default => true, :null => false
  end

  add_index "modelo", ["nombre"], :name => "modelo_uq_nombre"

  create_table "moneda", :force => true do |t|
    t.text    "nombre",                                     :null => false
    t.string  "abreviatura", :limit => 5,                   :null => false
    t.text    "ruta_icono"
    t.boolean "activo",                   :default => true, :null => false
  end

  create_table "motivo_visita", :force => true do |t|
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion", :limit => 250,                   :null => false
    t.boolean "activo",                     :default => true, :null => false
  end

  add_index "motivo_visita", ["nombre"], :name => "motivo_visita_uk", :unique => true

  create_table "motivos_atraso", :force => true do |t|
    t.text    "descripcion",                   :null => false
    t.boolean "activo",      :default => true, :null => false
  end

  create_table "motores", :force => true do |t|
    t.string  "modelo_motor",          :limit => 160, :null => false
    t.string  "numero_serial",         :limit => 100, :null => false
    t.integer "cantidad_motores"
    t.integer "ano"
    t.integer "proveedor_marino_id"
    t.integer "tipo_motor_id"
    t.integer "seguimiento_visita_id"
    t.integer "embarcacion_id"
    t.float   "potencia"
    t.string  "condicion",             :limit => 20
    t.string  "observacion",           :limit => 180
    t.boolean "es_propio"
  end

  create_table "municipio", :force => true do |t|
    t.integer "estado_id",                                      :null => false
    t.string  "nombre",            :limit => 40,                :null => false
    t.string  "codigo_d3",         :limit => 5
    t.integer "eje_id",                          :default => 1
    t.string  "codigo_ine",        :limit => 10
    t.string  "estado_codigo_ine", :limit => 10
  end

  add_index "municipio", ["codigo_ine"], :name => "municipio_uq_codigo_ine", :unique => true
  add_index "municipio", ["estado_id", "nombre"], :name => "municipio_uq_nombre", :unique => true

  create_table "nacionalidad", :force => true do |t|
    t.string "masculino", :limit => 100, :null => false
    t.string "femenino",  :limit => 100, :null => false
  end

  create_table "nemonico", :force => true do |t|
    t.string "nemonico",    :limit => 2,   :null => false
    t.string "nombre",      :limit => 50,  :null => false
    t.string "descripcion", :limit => 250, :null => false
  end

  add_index "nemonico", ["nemonico"], :name => "nemonico_uk", :unique => true

  create_table "oficina", :force => true do |t|
    t.string  "nombre",                           :limit => 80, :null => false
    t.integer "municipio_id",                                   :null => false
    t.integer "ciudad_id",                                      :null => false
    t.string  "cedula_nacionalidad",              :limit => 1
    t.integer "cedula_supervisor"
    t.string  "primer_nombre_supervisor",         :limit => 20
    t.string  "segundo_nombre_supervisor",        :limit => 20
    t.string  "primer_apellido_supervisor",       :limit => 20
    t.string  "segundo_apellido_supervisor",      :limit => 20
    t.string  "cedula_nacionalidad_jefe_brigada", :limit => 1
    t.integer "folio_autenticacion"
    t.integer "tomo_autenticacion"
    t.integer "cedula_jefe_brigada"
    t.string  "primer_nombre_jefe_brigada",       :limit => 20
    t.string  "segundo_nombre_jefe_brigada",      :limit => 20
    t.string  "primer_apellido_jefe_brigada",     :limit => 20
    t.string  "segundo_apellido_jefe_brigada",    :limit => 20
    t.integer "empresa_sistema_id"
  end

  create_table "oficina_area_influencia", :force => true do |t|
    t.integer "estado_id",    :null => false
    t.integer "municipio_id", :null => false
    t.integer "parroquia_id", :null => false
    t.integer "oficina_id",   :null => false
  end

  create_table "oficina_departamento", :force => true do |t|
    t.integer "oficina_id",      :null => false
    t.integer "departamento_id", :null => false
  end

  create_table "opcion", :force => true do |t|
    t.string  "nombre",          :limit => 250,                    :null => false
    t.string  "descripcion",     :limit => 400
    t.boolean "tiene_acciones",                 :default => false
    t.string  "ruta",            :limit => 250,                    :null => false
    t.integer "opcion_grupo_id",                                   :null => false
  end

  create_table "opcion_accion", :force => true do |t|
    t.integer "opcion_id",                                                :null => false
    t.integer "accion_id",                                                :null => false
    t.boolean "autorizacion",                          :default => false
    t.string  "autorizacion_tiempo_tipo", :limit => 1, :default => "D"
    t.integer "autorizacion_tiempo"
    t.boolean "autorizacion_extendida",                :default => false
  end

  create_table "opcion_estacion", :force => true do |t|
    t.integer "opcion_id",   :null => false
    t.integer "estacion_id", :null => false
  end

  create_table "opcion_grupo", :force => true do |t|
    t.string "nombre",      :limit => 50,  :null => false
    t.string "descripcion", :limit => 300
  end

  create_table "orden_abono_excedente_arrime", :force => true do |t|
    t.integer "solicitud_id",                                                                                    :null => false
    t.integer "prestamo_id",                                                                                     :null => false
    t.integer "cliente_id",                                                                                      :null => false
    t.date    "fecha_envio"
    t.integer "usuario_id",                                                                                      :null => false
    t.decimal "monto_abono",                                     :precision => 16, :scale => 2, :default => 0.0
    t.integer "estatus_id",                                                                                      :null => false
    t.date    "fecha_envio_banco"
    t.date    "fecha_valor"
    t.date    "fecha_abono_cuenta"
    t.integer "entidad_financiera_liquidadora_id"
    t.string  "numero_cuenta_liquidadora",         :limit => 20
    t.integer "entidad_financiera_cliente_id"
    t.string  "numero_cuenta_cliente",             :limit => 20
    t.string  "tipo_cheque",                       :limit => 1
    t.string  "referencia",                        :limit => 30
    t.string  "numero_lote",                       :limit => 20
    t.date    "fecha_registro_cheque"
  end

  create_table "orden_despacho", :force => true do |t|
    t.integer "solicitud_id",                                                                          :null => false
    t.integer "seguimiento_visita_id",                                                                 :null => false
    t.integer "prestamo_id",                                                                           :null => false
    t.string  "numero",                :limit => 32
    t.integer "estatus_id",                                                                            :null => false
    t.decimal "monto",                               :precision => 16, :scale => 2,                    :null => false
    t.text    "observacion"
    t.integer "estado_id",                                                                             :null => false
    t.integer "usuario_id",                                                                            :null => false
    t.date    "fecha_orden_despacho"
    t.date    "fecha_cierre"
    t.boolean "realizado",                                                          :default => false, :null => false
    t.date    "fecha_liquidacion"
    t.string  "tipo_pago",             :limit => 1
    t.text    "observacion_cerrado"
    t.integer "casa_proveedora_id"
  end

  create_table "orden_despacho_detalle", :force => true do |t|
    t.integer "orden_despacho_id"
    t.string  "item_nombre",          :limit => 100,                                                 :null => false
    t.integer "unidad_medida_id",                                                                    :null => false
    t.decimal "cantidad",                            :precision => 16, :scale => 2,                  :null => false
    t.decimal "costo_real",                          :precision => 16, :scale => 2,                  :null => false
    t.decimal "monto_financiamiento",                :precision => 16, :scale => 2,                  :null => false
    t.decimal "monto_facturacion",                   :precision => 16, :scale => 2,                  :null => false
    t.decimal "cantidad_facturacion",                :precision => 16, :scale => 2
    t.text    "observacion"
    t.integer "plan_inversion_id"
    t.decimal "monto_recomendado",                   :precision => 16, :scale => 3, :default => 0.0, :null => false
  end

  create_table "origen_fondo", :force => true do |t|
    t.string  "nombre",       :limit => 40,                    :null => false
    t.string  "descripcion",  :limit => 300,                   :null => false
    t.boolean "activo",                      :default => true
    t.integer "banco_origen"
    t.integer "codigo_d3",                   :default => 0
  end

  add_index "origen_fondo", ["nombre"], :name => "origen_fondo_uq_nombre", :unique => true

  create_table "otro_arrime", :force => true do |t|
    t.integer "solicitud_id",                                                                            :null => false
    t.integer "silo_id",                                                                                 :null => false
    t.integer "cliente_id",                                                                              :null => false
    t.integer "actividad_id",                                                                            :null => false
    t.time    "hora_registro"
    t.string  "placa_vehiculo",         :limit => 15,                                                    :null => false
    t.string  "letra_cedula_conductor", :limit => 1,                                                     :null => false
    t.integer "cedula_conductor",                                                                        :null => false
    t.string  "nombre_conductor",       :limit => 100,                                                   :null => false
    t.string  "numero_ticket",          :limit => 15,                                                    :null => false
    t.string  "guia_movilizacion",      :limit => 20,                                                    :null => false
    t.text    "observacion"
    t.string  "clase",                  :limit => 1
    t.string  "resultado",              :limit => 30
    t.date    "fecha_entrada",                                                                           :null => false
    t.date    "fecha_salida",                                                                            :null => false
    t.decimal "valor_total_entrada",                   :precision => 16, :scale => 2
    t.decimal "valor_total_salida",                    :precision => 16, :scale => 2
    t.decimal "peso_neto",                             :precision => 16, :scale => 2
    t.decimal "peso_acondicionado",                    :precision => 16, :scale => 2
    t.decimal "peso_vehiculo",                         :precision => 16, :scale => 2, :default => 0.0
    t.decimal "peso_remolque",                         :precision => 16, :scale => 2, :default => 0.0
    t.decimal "peso_vehiculo_salida",                  :precision => 16, :scale => 2, :default => 0.0
    t.decimal "peso_remolque_salida",                  :precision => 16, :scale => 2, :default => 0.0
    t.boolean "confirmacion",                                                         :default => false, :null => false
    t.date    "fecha_confirmacion"
    t.string  "estatus",                :limit => 1
    t.decimal "monto_arrime",                          :precision => 16, :scale => 2
    t.integer "usuario_id"
    t.date    "fecha_decision"
    t.string  "nro_acta_rechazo",       :limit => 15
    t.string  "causa_rechazo"
  end

  create_table "pago_cliente", :force => true do |t|
    t.date    "fecha",                                                                                 :null => false
    t.string  "modalidad",             :limit => 1,                                 :default => "O"
    t.float   "monto"
    t.integer "cliente_id",                                                                            :null => false
    t.integer "oficina_id"
    t.boolean "reversado",                                                          :default => false
    t.date    "fecha_contable"
    t.date    "fecha_realizacion",                                                                     :null => false
    t.string  "numero_voucher",        :limit => 20
    t.decimal "efectivo",                            :precision => 16, :scale => 2, :default => 0.0
    t.integer "entidad_financiera_id"
    t.integer "cuenta_bcv_id"
  end

  create_table "pago_contra_anticipo", :force => true do |t|
    t.integer "factura_orden_despacho_id"
    t.integer "usuario_id"
    t.integer "oficina_id"
    t.decimal "monto_anticipo",              :precision => 16, :scale => 2, :default => 0.0
    t.decimal "monto_pagos",                 :precision => 16, :scale => 2, :default => 0.0
    t.decimal "monto_disponible",            :precision => 16, :scale => 2, :default => 0.0
    t.integer "casa_proveedora_id"
    t.integer "sucursal_casa_proveedora_id"
  end

  create_table "pago_cuota", :force => true do |t|
    t.integer "plan_pago_cuota_id",                                                                     :null => false
    t.integer "pago_prestamo_id",                                                                       :null => false
    t.decimal "monto",                                :precision => 16, :scale => 2, :default => 0.0
    t.boolean "aplicado",                                                            :default => false
    t.decimal "interes_corriente",                    :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_diferido",                     :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_mora",                         :precision => 16, :scale => 2, :default => 0.0
    t.decimal "capital",                              :precision => 16, :scale => 2, :default => 0.0
    t.decimal "remanente_por_aplicar",                :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_desembolso",                   :precision => 16, :scale => 2, :default => 0.0
    t.decimal "cuota_extra",                          :precision => 16, :scale => 2, :default => 0.0
    t.string  "estatus_pago",          :limit => nil
    t.date    "fecha_vencimiento"
    t.date    "fecha_pago"
    t.integer "dias_atraso"
  end

  create_table "pago_forma", :force => true do |t|
    t.string  "forma",                 :limit => 1,  :default => "D"
    t.float   "monto"
    t.string  "referencia",            :limit => 25
    t.integer "entidad_financiera_id"
    t.integer "pago_cliente_id",                                      :null => false
  end

  create_table "pago_prestamo", :force => true do |t|
    t.decimal "monto",                      :precision => 16, :scale => 2, :default => 0.0
    t.integer "prestamo_id",                                                                :null => false
    t.decimal "interes_corriente",          :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_diferido",           :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_mora",               :precision => 16, :scale => 2, :default => 0.0
    t.decimal "capital",                    :precision => 16, :scale => 2, :default => 0.0
    t.integer "pago_cliente_id",                                                            :null => false
    t.decimal "remanente_por_aplicar",      :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_desembolso",         :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_causado",            :precision => 16, :scale => 2, :default => 0.0
    t.decimal "saldo_insoluto",             :precision => 16, :scale => 2, :default => 0.0
    t.text    "observacion_precancelacion"
  end

  create_table "pagos_compromiso", :force => true do |t|
    t.integer "compromiso_pago_id", :null => false
    t.integer "pago_cliente_id",    :null => false
    t.integer "pago_prestamo_id",   :null => false
  end

  create_table "pais", :force => true do |t|
    t.string "nombre",      :limit => 50, :null => false
    t.string "abreviacion", :limit => 2
  end

  add_index "pais", ["nombre"], :name => "pais_uq_nombre", :unique => true

  create_table "paquete", :force => true do |t|
    t.integer "estado_id",                     :null => false
    t.integer "oficina_id",                    :null => false
    t.integer "rubro_id",                      :null => false
    t.boolean "activo",     :default => false, :null => false
  end

  create_table "parametro_ambiental", :id => false, :force => true do |t|
    t.integer "id",                                      :null => false
    t.string  "nombre",  :limit => 100,                  :null => false
    t.integer "item",                                    :null => false
    t.integer "puntaje",                                 :null => false
    t.string  "tipo",    :limit => 2,   :default => "M"
  end

  create_table "parametro_general", :force => true do |t|
    t.float   "tasa_maxima_mora"
    t.integer "dias_gracia_mora",                                   :limit => 2
    t.string  "tipo_dia_gracia_mora",                               :limit => 1,                                  :default => "H"
    t.integer "detener_mora_edad",                                  :limit => 2
    t.integer "detener_mora_cuotas",                                :limit => 2
    t.float   "detener_mora_garantia"
    t.integer "dia_mes_primer_ciclo",                               :limit => 2,                                  :default => 16
    t.integer "dia_mes_segundo_ciclo",                              :limit => 2,                                  :default => 28
    t.float   "porcentaje_maximo_tapp"
    t.float   "porcentaje_minimo_tapp"
    t.integer "dias_vigencia_clave",                                :limit => 2,                                  :default => 30
    t.float   "monto_maximo_aprueba_comite"
    t.float   "monto_maximo_fianza_solidaria"
    t.boolean "exonerar_intereses_desembolso",                                                                    :default => true
    t.integer "numero_prestamo_inicial"
    t.integer "ultima_factura",                                                                                   :default => 0
    t.integer "plazo_maximo_prestamo_reestructurado",                                                             :default => 60
    t.date    "fecha_ultimo_cierre"
    t.date    "fecha_proximo_cierre"
    t.integer "max_integrantes_grupo",                              :limit => 2
    t.integer "min_integrantes_grupo",                              :limit => 2
    t.float   "monto_max_credito_integrante_uea"
    t.float   "monto_max_credito_coop"
    t.integer "numero_grupo_inicial"
    t.integer "anio_constitucion_comite_vigente",                   :limit => 2
    t.integer "numero_empresa"
    t.integer "cuotas_credito_vencido",                             :limit => 2
    t.integer "cuotas_credito_solvente",                            :limit => 2
    t.integer "numero_solicitud_inicial_uea",                       :limit => 8
    t.decimal "numero_solicitud_inicial_coop"
    t.decimal "numero_solicitud_inicial_indiv"
    t.integer "numero_comite_vigente"
    t.integer "numero_contrato_inicial",                            :limit => 8
    t.integer "numero_acta_uea",                                    :limit => 8
    t.integer "numero_acta_coop",                                   :limit => 8
    t.integer "numero_acta_indiv",                                  :limit => 8
    t.integer "numero_acta_liq_uea",                                :limit => 8
    t.integer "numero_acta_liq_indiv",                              :limit => 8
    t.integer "numero_acta_liq_coop",                               :limit => 8
    t.integer "cuotas_envio_cobro"
    t.integer "numero_acta_reestructuracion",                                                                     :default => 0
    t.string  "dia_facturacion",                                    :limit => 1,                                  :default => "F"
    t.boolean "penalizacion_mora",                                                                                :default => false
    t.integer "cuotas_pase_vencido",                                                                              :default => 0
    t.string  "firma_coordinacion_presupuestaria",                  :limit => 50
    t.integer "numeracion_instancia_firma_delegada",                :limit => 8,                                  :default => 1
    t.integer "numeracion_instancia_comite_credito",                :limit => 8,                                  :default => 1
    t.integer "numeracion_instancia_directorio",                    :limit => 8,                                  :default => 1
    t.integer "numeracion_instancia_fondos_autonomos",              :limit => 8,                                  :default => 1
    t.float   "banda_superior_fondos_autonomos"
    t.float   "banda_inferior_fondos_autonomos"
    t.float   "banda_superior_firma_delegada"
    t.float   "banda_inferior_firma_delegada"
    t.float   "banda_superior_comite_credito"
    t.float   "banda_inferior_comite_credito"
    t.float   "banda_superior_directorio"
    t.float   "banda_inferior_directorio"
    t.integer "numero_punto_inicial",                               :limit => 8,                                  :default => 1
    t.integer "numero_reunion_inicial",                             :limit => 8,                                  :default => 1
    t.string  "firma_presidente",                                   :limit => 50
    t.string  "firma_gerencia_cooperacion_financiamiento_nacional", :limit => 50
    t.integer "numero_seguimiento_inicial",                         :limit => 8,                                  :default => 1
    t.string  "firma_coordinacion_seguimiento",                     :limit => 50
    t.string  "firma_especialista_seguimiento",                     :limit => 50
    t.float   "tasa_conversion_unidades_tributarias",                                                             :default => 0.0
    t.string  "firma_vicepresidente",                               :limit => 50
    t.decimal "porcentaje_interes_a_reestructurar",                                :precision => 16, :scale => 2
    t.string  "notif_liquidacion",                                  :limit => 60
    t.string  "notif_tesoreria",                                    :limit => 60
    t.boolean "integracion_administrativo"
    t.string  "wsdl_administrativo",                                :limit => 100
    t.integer "numeracion_instancia_nacional"
    t.integer "codigo_tecnico_campo",                                                                             :default => 0
    t.decimal "porcentaje_sras_primer_ano",                                        :precision => 5,  :scale => 2, :default => 2.0,   :null => false
    t.decimal "porcentaje_sras_anos_subsiguientes",                                :precision => 5,  :scale => 2, :default => 0.5,   :null => false
    t.string  "nro_lote",                                           :limit => 8
    t.integer "caducidad_orden_despacho",                                                                         :default => 20
    t.integer "caducidad_casa_proveedora",                                                                        :default => 60
    t.text    "tipo_fuente"
    t.float   "margen_izquierdo"
    t.float   "margen_derecho"
    t.float   "margen_superior"
    t.float   "margen_inferior"
    t.float   "tamano_fuente"
    t.float   "interlineado"
    t.integer "codigo_seg",                                         :limit => 8
    t.decimal "valor_dolar",                                                       :precision => 10, :scale => 2, :default => 4.3
    t.float   "porcentaje_arrime_reestructuracion"
    t.integer "dias_max_vencimiento_ultima_cuota",                                                                :default => 15
    t.decimal "porcentaje_sras_maquinaria",                                        :precision => 5,  :scale => 2
    t.decimal "porcentaje_sras_maquinaria_primer_anno",                            :precision => 5,  :scale => 2, :default => 8.0
    t.decimal "porcentaje_sras_maquinaria_anno_subsiguientes",                     :precision => 5,  :scale => 2, :default => 0.5
    t.integer "nro_lote_fideicomiso"
    t.integer "rango_dias_compromiso_pago"
    t.integer "moneda_id"
    t.text    "nombre_institucion"
  end

  create_table "parametro_importado_exportado", :id => false, :force => true do |t|
    t.integer "id",       :null => false
    t.string  "nombre",   :null => false
    t.integer "item",     :null => false
    t.integer "exportar"
    t.integer "importar"
  end

  create_table "parametro_producto_fabricar", :id => false, :force => true do |t|
    t.integer "id",                     :null => false
    t.string  "codigo",    :limit => 4, :null => false
    t.string  "nombre",                 :null => false
    t.integer "item",                   :null => false
    t.integer "puntaje_1"
    t.integer "puntaje_2"
  end

  create_table "parametro_sector", :id => false, :force => true do |t|
    t.integer "id",                          :null => false
    t.string  "nombre",                      :null => false
    t.integer "item",                        :null => false
    t.integer "sustanciacion_importaciones", :null => false
    t.integer "desarrollo_humano"
    t.integer "grado_concentracion"
  end

  create_table "parametro_sectorial", :id => false, :force => true do |t|
    t.integer "id",                                     :null => false
    t.string  "nombre",                                 :null => false
    t.integer "item",                                   :null => false
    t.integer "puntaje"
    t.string  "tipo",    :limit => 2, :default => "PF"
  end

  create_table "parametro_social", :id => false, :force => true do |t|
    t.integer "id",                                      :null => false
    t.string  "nombre",  :limit => 100,                  :null => false
    t.integer "item",                                    :null => false
    t.integer "puntaje",                                 :null => false
    t.string  "tipo",    :limit => 2,   :default => "M"
  end

  create_table "parametro_tecnico", :id => false, :force => true do |t|
    t.integer "id",                                      :null => false
    t.string  "nombre",  :limit => 100,                  :null => false
    t.integer "item",                                    :null => false
    t.integer "puntaje",                                 :null => false
    t.string  "tipo",    :limit => 2,   :default => "M"
  end

  create_table "parroquia", :force => true do |t|
    t.integer "municipio_id",                       :null => false
    t.string  "nombre",               :limit => 40, :null => false
    t.string  "codigo_d3",            :limit => 7
    t.string  "codigo_ine",           :limit => 10
    t.string  "municipio_codigo_ine", :limit => 10
  end

  add_index "parroquia", ["municipio_id", "nombre"], :name => "parroquia_uq_nombre", :unique => true

  create_table "partida", :force => true do |t|
    t.string  "nombre",                  :limit => 100,                    :null => false
    t.string  "descripcion",             :limit => 300,                    :null => false
    t.boolean "financiamiento_integral",                :default => false, :null => false
    t.integer "codigo_d3"
    t.integer "rubro_id",                               :default => 0,     :null => false
    t.integer "codigo",                                 :default => 0
    t.integer "sub_rubro_id"
    t.integer "actividad_id"
  end

  add_index "partida", ["id", "rubro_id", "sub_rubro_id", "actividad_id"], :name => "partida_uq_rubro_sub_rubro_actividad", :unique => true
  add_index "partida", ["nombre", "rubro_id", "sub_rubro_id", "actividad_id"], :name => "partida_uq_nombre", :unique => true

  create_table "partida_presupuestaria", :force => true do |t|
    t.string  "nombre",            :limit => 70
    t.string  "proyecto",          :limit => 50
    t.string  "accion_especifica", :limit => 50
    t.string  "partida",           :limit => 50
    t.string  "generica",          :limit => 50
    t.string  "especifica",        :limit => 50
    t.string  "sub_especifica",    :limit => 50
    t.string  "denominacion",      :limit => 100
    t.string  "plazo_ciclo",       :limit => 1
    t.integer "programa_id"
  end

  create_table "pastizales_potreros", :force => true do |t|
    t.integer "seguimiento_visita_id",                                                   :null => false
    t.integer "nro_lote",                                                                :null => false
    t.integer "tipo_pasto_forraje_id",                                                   :null => false
    t.float   "superficie",                                            :default => 0.0,  :null => false
    t.integer "especie_variedad_pasto_id",                                               :null => false
    t.boolean "sistema_riego",                                         :default => true, :null => false
    t.date    "fecha_siembra"
    t.date    "fecha_corte"
    t.string  "condicion_pasto",                          :limit => 1, :default => "E",  :null => false
    t.integer "cantidad_potreros",                                     :default => 0,    :null => false
    t.integer "nro_potrero_cerca_electrica",                           :default => 0,    :null => false
    t.integer "nro_potrero_cerca_tradicional",                         :default => 0,    :null => false
    t.boolean "fertilizacion",                                         :default => true, :null => false
    t.integer "tipo_fertilizacion_id"
    t.text    "descripcion_fertilizacion"
    t.text    "descripcion_observado"
    t.integer "nro_potrero_cerca_electrica_sist_riego",                :default => 0,    :null => false
    t.integer "nro_potrero_cerca_tradicional_sist_riego",              :default => 0,    :null => false
  end

  create_table "performance_analista_cobranza", :force => true do |t|
    t.integer "analista_cobranzas_id",                                                        :null => false
    t.date    "fecha"
    t.integer "cantidad_intentos",                                           :default => 0,   :null => false
    t.integer "cantidad_contactos",                                          :default => 0,   :null => false
    t.integer "cantidad_contactos_exitosos",                                 :default => 0,   :null => false
    t.integer "cantidad_promesas_pago",                                      :default => 0,   :null => false
    t.decimal "porcentaje_contactos",          :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.decimal "porcentaje_contactos_exitosos", :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.decimal "porcentaje_promesas_pago",      :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.integer "cantidad_email_enviados",                                     :default => 0,   :null => false
    t.integer "cantidad_sms_enviados",                                       :default => 0,   :null => false
  end

  create_table "performance_cobranzas", :force => true do |t|
    t.integer "prestamo_id",                                                                                    :null => false
    t.integer "cliente_id",                                                                                     :null => false
    t.integer "cantidad_intentos",                                                             :default => 0,   :null => false
    t.integer "cantidad_contactos",                                                            :default => 0,   :null => false
    t.integer "cantidad_contactos_exitosos",                                                   :default => 0,   :null => false
    t.integer "cantidad_promesas_pago",                                                        :default => 0,   :null => false
    t.integer "cantidad_promesas_cumplidas",                                                   :default => 0,   :null => false
    t.integer "cantidad_promesas_cumplidas_parcialmente",                                      :default => 0,   :null => false
    t.integer "cantidad_promesas_incumplidas",                                                 :default => 0,   :null => false
    t.decimal "porcentaje_contactos",                            :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.decimal "porcentaje_contactos_exitosos",                   :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.decimal "porcentaje_promesas_pago",                        :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.decimal "porcentaje_promesas_pago_cumplidas",              :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.decimal "porcentaje_promesas_pago_incumplidas",            :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.decimal "porcentaje_promesas_pago_parcialmente_cumplidas", :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.integer "cantidad_email_enviados",                                                       :default => 0,   :null => false
    t.integer "cantidad_sms_enviados",                                                         :default => 0,   :null => false
  end

  create_table "perito", :force => true do |t|
    t.integer "cedula",                         :null => false
    t.string  "primer_nombre",    :limit => 20, :null => false
    t.string  "segundo_nombre",   :limit => 20
    t.string  "primer_apellido",  :limit => 20, :null => false
    t.string  "segundo_apellido", :limit => 20
  end

  create_table "persona", :force => true do |t|
    t.integer "cedula",                                                            :null => false
    t.string  "primer_nombre",                   :limit => 20,                     :null => false
    t.string  "segundo_nombre",                  :limit => 20
    t.string  "primer_apellido",                 :limit => 20,                     :null => false
    t.string  "segundo_apellido",                :limit => 20
    t.boolean "sexo",                                           :default => true
    t.string  "estado_civil",                    :limit => 1
    t.date    "fecha_nacimiento"
    t.boolean "venezolano",                                     :default => true
    t.integer "profesion_id"
    t.string  "ocupacion",                       :limit => 40
    t.string  "rif_personal",                    :limit => 12
    t.string  "cedula_nacionalidad",             :limit => 1
    t.integer "nacionalidad_id"
    t.boolean "grupo",                                          :default => false, :null => false
    t.string  "pais",                            :limit => 50
    t.string  "lugar_nacimiento",                :limit => 100
    t.integer "tiempo_profesion"
    t.string  "unidad_tiempo_profesion",         :limit => 10
    t.integer "cantidad_total_hijos"
    t.integer "cantidad_hijos"
    t.integer "cantidad_hijas"
    t.string  "grado_instruccion_primaria",      :limit => 1
    t.string  "grado_instruccion_secundaria",    :limit => 1
    t.string  "grado_instruccion_medio",         :limit => 1
    t.string  "grado_instruccion_universitario", :limit => 1
    t.string  "grado_instruccion_superior",      :limit => 1
    t.string  "grado_instruccion_robinson1",     :limit => 1
    t.string  "grado_instruccion_robinson2",     :limit => 1
    t.string  "grado_instruccion_robinson3",     :limit => 1
    t.string  "grado_instruccion_ribas",         :limit => 1
    t.string  "grado_instruccion_sucre",         :limit => 1
    t.string  "conyuge_cedula_nacionalidad",     :limit => 1
    t.string  "conyuge_cedula",                  :limit => 8
    t.string  "conyuge_nombre_apellido",         :limit => 100
    t.string  "conyuge_lugar_nacimiento",        :limit => 50
    t.string  "conyuge_nacionalidad",            :limit => 50
    t.string  "conyuge_profesion",               :limit => 50
    t.string  "conyuge_oficio",                  :limit => 50
    t.boolean "conyuge_trabaja"
    t.string  "conyuge_direccion_trabajo",       :limit => 250
    t.string  "conyuge_telefono",                :limit => 16
    t.boolean "discapacidad"
    t.string  "discapacidad_detalle",            :limit => 100
    t.integer "sector_economico_id"
    t.integer "actividad_economica_id"
    t.integer "rama_actividad_economica_id"
    t.string  "codigo_d3",                       :limit => 15
    t.string  "conyuge_celular",                 :limit => 25
    t.integer "prestamo_id"
    t.string  "pasaporte",                       :limit => 20
    t.string  "tipo_dependencia_laboral",        :limit => 50
    t.float   "monto_salario"
    t.float   "otros_ingresos"
    t.string  "conyuge_empresa",                 :limit => 100
    t.integer "pais_id"
    t.string  "nombre_organizacion",             :limit => 155
    t.string  "grado_instruccion",               :limit => 100
    t.boolean "foto_confirmacion",                              :default => false
    t.boolean "huella_confirmacion",                            :default => false
  end

  add_index "persona", ["actividad_economica_id"], :name => "persona_activ_econ_id_idx"
  add_index "persona", ["cedula"], :name => "persona_uq_cedula", :unique => true
  add_index "persona", ["sector_economico_id"], :name => "persona_sector_econ_id_idx"

  create_table "persona_atendio", :force => true do |t|
    t.text    "descripcion",                   :null => false
    t.boolean "activo",      :default => true, :null => false
  end

  create_table "persona_direccion", :force => true do |t|
    t.integer "persona_id",                                              :null => false
    t.integer "ciudad_id"
    t.integer "municipio_id"
    t.integer "parroquia_id"
    t.string  "avenida",               :limit => 300,                    :null => false
    t.string  "edificio",              :limit => 300,                    :null => false
    t.string  "zona",                  :limit => 300,                    :null => false
    t.string  "referencia",            :limit => 300
    t.string  "codigo_postal",         :limit => 8
    t.string  "tipo",                  :limit => 1,                      :null => false
    t.boolean "correspondencia",                      :default => false
    t.boolean "activo",                               :default => true
    t.string  "tipo_vivienda",         :limit => 1
    t.string  "piso",                  :limit => 3
    t.string  "numero",                :limit => 10
    t.string  "localidad",             :limit => 1
    t.string  "tenencia",              :limit => 1
    t.string  "ubicacion_geografica",  :limit => 1
    t.string  "tipo_comunidad",        :limit => 1
    t.boolean "unidad_negocio"
    t.integer "region_id"
    t.integer "comunidad_indigena_id"
  end

  create_table "persona_email", :force => true do |t|
    t.string  "email",      :limit => 80, :null => false
    t.string  "tipo",       :limit => 1,  :null => false
    t.integer "persona_id",               :null => false
    t.string  "facebook",   :limit => 80
    t.string  "twitter",    :limit => 80
  end

  create_table "persona_telefono", :force => true do |t|
    t.string  "codigo",               :limit => 4,                     :null => false
    t.string  "numero",               :limit => 15,                    :null => false
    t.string  "tipo",                 :limit => 1,                     :null => false
    t.integer "persona_id",                                            :null => false
    t.integer "persona_direccion_id"
    t.boolean "fax",                                :default => false
  end

  create_table "plan_inversion", :force => true do |t|
    t.integer "solicitud_id",                                                                           :null => false
    t.string  "estado_nombre",         :limit => 100,                                                   :null => false
    t.string  "oficina_nombre",        :limit => 100,                                                   :null => false
    t.string  "sector_nombre",         :limit => 100,                                                   :null => false
    t.string  "sub_sector_nombre",     :limit => 100,                                                   :null => false
    t.string  "rubro_nombre",          :limit => 100,                                                   :null => false
    t.string  "partida_nombre",        :limit => 100,                                                   :null => false
    t.string  "item_nombre",           :limit => 100,                                                   :null => false
    t.integer "unidad_medida_id",                                                                       :null => false
    t.integer "numero_desembolso",                                                   :default => 0,     :null => false
    t.decimal "costo_real",                           :precision => 16, :scale => 2, :default => 0.0,   :null => false
    t.decimal "cantidad",                             :precision => 16, :scale => 3, :default => 0.0
    t.decimal "monto_financiamiento",                 :precision => 16, :scale => 2, :default => 0.0
    t.decimal "monto_desembolsado",                   :precision => 16, :scale => 2, :default => 0.0
    t.string  "seriales",              :limit => nil
    t.string  "marcas",                :limit => nil
    t.string  "tipo_item",             :limit => 1
    t.decimal "cantidad_por_hectarea",                :precision => 16, :scale => 2, :default => 0.0,   :null => false
    t.decimal "costo_minimo",                         :precision => 16, :scale => 2, :default => 0.0,   :null => false
    t.decimal "costo_maximo",                         :precision => 16, :scale => 2, :default => 0.0,   :null => false
    t.decimal "cantidad_liquidada",                   :precision => 16, :scale => 2, :default => 0.0,   :null => false
    t.string  "sub_rubro_nombre",      :limit => 100
    t.string  "actividad_nombre",      :limit => 100
    t.boolean "inventario",                                                          :default => false
    t.string  "serial_motor",          :limit => 50
    t.string  "serial_chasis",         :limit => 50
    t.integer "casa_proveedora_id"
    t.string  "moneda",                :limit => 5
  end

  create_table "plan_pago", :force => true do |t|
    t.date    "fecha_inicio",                                                                                :null => false
    t.date    "fecha_fin",                                                                                   :null => false
    t.integer "prestamo_id",                                                                                 :null => false
    t.boolean "activo",                                                                   :default => true
    t.boolean "proyeccion",                                                               :default => true
    t.integer "plazo",                        :limit => 2
    t.float   "tasa"
    t.decimal "monto",                                     :precision => 16, :scale => 2, :default => 0.0
    t.integer "meses_gracia",                 :limit => 2
    t.integer "meses_muertos",                :limit => 2
    t.boolean "diferir_intereses",                                                        :default => false
    t.boolean "exonerar_intereses_diferidos",                                             :default => false
    t.float   "tasa_gracia"
    t.integer "frecuencia_pago",              :limit => 2,                                :default => 1
    t.integer "frecuencia_pago_gracia",       :limit => 2,                                :default => 1
    t.integer "dia_facturacion",              :limit => 2
    t.date    "fecha_evento",                                                                                :null => false
    t.string  "motivo_evento",                :limit => 1
    t.boolean "migrado_d3",                                                               :default => false
  end

  add_index "plan_pago", ["prestamo_id", "activo"], :name => "prestamo_ix"

  create_table "plan_pago_cuota", :force => true do |t|
    t.integer "plan_pago_id",                                                                                           :null => false
    t.date    "fecha"
    t.integer "numero",                           :limit => 2,                                :default => 1
    t.decimal "valor_cuota",                                   :precision => 16, :scale => 2, :default => 0.0
    t.decimal "amortizado",                                    :precision => 16, :scale => 2, :default => 0.0
    t.decimal "amortizado_acumulado",                          :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_corriente",                             :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_corriente_acumulado",                   :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_diferido",                              :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_mora",                                  :precision => 16, :scale => 2, :default => 0.0
    t.decimal "saldo_insoluto",                                :precision => 16, :scale => 2, :default => 0.0
    t.float   "tasa_periodo",                                                                 :default => 0.0
    t.string  "tipo_cuota",                       :limit => 1
    t.boolean "vencida",                                                                      :default => false
    t.string  "estatus_pago",                     :limit => 1,                                :default => "X"
    t.date    "fecha_ultimo_pago"
    t.decimal "pago_interes_mora",                             :precision => 16, :scale => 2, :default => 0.0
    t.decimal "pago_interes_corriente",                        :precision => 16, :scale => 2, :default => 0.0
    t.decimal "pago_interes_diferido",                         :precision => 16, :scale => 2, :default => 0.0
    t.decimal "pago_interes_corriente_acumulado",              :precision => 16, :scale => 2, :default => 0.0
    t.decimal "pago_capital",                                  :precision => 16, :scale => 2, :default => 0.0
    t.decimal "remanente_por_aplicar",                         :precision => 16, :scale => 2, :default => 0.0
    t.decimal "causado_no_devengado",                          :precision => 16, :scale => 2, :default => 0.0
    t.boolean "desembolso",                                                                   :default => false
    t.boolean "cambio_tasa",                                                                  :default => false
    t.boolean "abono_extraordinario",                                                         :default => false
    t.decimal "monto_desembolso",                              :precision => 16, :scale => 2, :default => 0.0
    t.decimal "monto_abono",                                   :precision => 16, :scale => 2, :default => 0.0
    t.integer "dias_mora",                        :limit => 2,                                :default => 0
    t.float   "tasa_nominal_anual",                                                           :default => 0.0
    t.decimal "interes_desembolso",                            :precision => 16, :scale => 2, :default => 0.0
    t.integer "cantidad_dias",                    :limit => 2,                                :default => 0
    t.decimal "pago_interes_desembolso",                       :precision => 16, :scale => 2, :default => 0.0
    t.boolean "cancelacion_prestamo",                                                         :default => false
    t.boolean "reclasificada",                                                                :default => false
    t.decimal "intereses_por_cobrar_al_30",                    :precision => 16, :scale => 2, :default => 0.0
    t.decimal "mora_exonerada",                                :precision => 16, :scale => 2, :default => 0.0
    t.boolean "migrado_d3",                                                                   :default => false
    t.boolean "bolivar_fuerte"
    t.date    "fecha_ultima_mora",                                                            :default => '1900-01-01'
    t.decimal "interes_ord_devengado_mes",                     :precision => 16, :scale => 2, :default => 0.0
    t.date    "fecha_ord_devengado"
    t.decimal "interes_ord_devengado_acum",                    :precision => 16, :scale => 2, :default => 0.0
    t.decimal "ajuste_devengo",                                :precision => 16, :scale => 2, :default => 0.0
    t.decimal "pago_total_cliente",                            :precision => 16, :scale => 2, :default => 0.0
    t.decimal "cuota_extra",                                   :precision => 16, :scale => 2, :default => 0.0
    t.decimal "pago_cuota_extra",                              :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_dif_devengado_mes",                     :precision => 16, :scale => 2, :default => 0.0
  end

  add_index "plan_pago_cuota", ["plan_pago_id"], :name => "plan_pago_ix"

  create_table "plan_pago_interes", :force => true do |t|
    t.integer "plan_pago_cuota_id",                    :null => false
    t.float   "monto"
    t.integer "tasa_valor_id",                         :null => false
    t.float   "tasa_valor"
    t.date    "fecha_inicio",                          :null => false
    t.date    "fecha_fin"
    t.float   "capital"
    t.boolean "reversado",          :default => false
  end

  create_table "plan_pago_mora", :force => true do |t|
    t.integer "plan_pago_cuota_id",                                 :null => false
    t.float   "monto"
    t.float   "tasa_valor"
    t.date    "fecha_inicio",                                       :null => false
    t.date    "fecha_fin"
    t.float   "capital"
    t.float   "valor"
    t.boolean "reversado",                       :default => false
    t.integer "dias",               :limit => 2
  end

  create_table "plantilla", :force => true do |t|
    t.string  "tipo_beneficiario", :limit => 1
    t.integer "sector_id"
    t.string  "nombre",                                            :null => false
    t.string  "encabezado",                                        :null => false
    t.string  "logotipo",                                          :null => false
    t.text    "documento",                                         :null => false
    t.boolean "definido",                       :default => false
    t.boolean "activo",                         :default => false
    t.string  "nemonico",          :limit => 2
  end

  create_table "porcentaje_ganancia", :force => true do |t|
    t.string "nombre", :limit => 100, :null => false
  end

  create_table "pre_chequeo", :force => true do |t|
    t.date    "fecha",                               :null => false
    t.string  "cedula_rif",          :limit => 12,   :null => false
    t.string  "nombre_empresa",      :limit => 100,  :null => false
    t.boolean "conforme",                            :null => false
    t.integer "solicitud_id"
    t.integer "cliente_id"
    t.string  "nacionalidad",        :limit => 1
    t.integer "programa_id"
    t.integer "sector_economico_id"
    t.integer "seccion_id"
    t.integer "tipo_cliente_id"
    t.string  "observaciones",       :limit => 1000
  end

  create_table "pre_chequeo_recaudo", :force => true do |t|
    t.integer "recaudo_id",                        :null => false
    t.boolean "entregado",                         :null => false
    t.integer "pre_chequeo_id",                    :null => false
    t.boolean "tramite",        :default => false
    t.boolean "no_aplica",      :default => false, :null => false
  end

  create_table "precio_gaceta", :force => true do |t|
    t.integer "gaceta_oficial", :null => false
    t.boolean "status"
    t.integer "usuario_id"
    t.date    "fecha_vigencia"
  end

  create_table "prestamo", :force => true do |t|
    t.integer "numero",                                     :limit => 8,                                                           :null => false
    t.decimal "monto_solicitado",                                         :precision => 16, :scale => 2, :default => 0.0
    t.decimal "monto_aprobado",                                           :precision => 16, :scale => 2, :default => 0.0
    t.date    "fecha_aprobacion"
    t.integer "formula_id"
    t.boolean "tasa_fija"
    t.integer "tasa_id"
    t.float   "diferencial_tasa"
    t.float   "tasa_referencia_inicial"
    t.integer "plazo",                                      :limit => 2,                                 :default => 0
    t.integer "meses_fijos_sin_cambio_tasa",                :limit => 2,                                 :default => 0
    t.boolean "meses_gracia_si",                                                                         :default => false
    t.integer "meses_gracia",                               :limit => 2,                                 :default => 0
    t.boolean "meses_muertos_si",                                                                        :default => false
    t.integer "meses_muertos",                              :limit => 2,                                 :default => 0
    t.integer "cliente_id",                                                                                                        :null => false
    t.integer "tipo_credito_id"
    t.integer "oficina_id",                                                                                                        :null => false
    t.integer "solicitud_id",                                                                                                      :null => false
    t.string  "estatus",                                    :limit => 1,                                 :default => "S"
    t.integer "tasa_mora_id"
    t.string  "forma_calculo_intereses",                    :limit => 1
    t.integer "base_calculo_intereses",                                                                  :default => 360
    t.boolean "permitir_abonos",                                                                         :default => true
    t.string  "abono_forma",                                :limit => 1,                                 :default => "P"
    t.float   "abono_porcentaje",                                                                        :default => 0.0
    t.integer "abono_cantidad_cuotas",                      :limit => 2,                                 :default => 0
    t.float   "abono_monto_minimo",                                                                      :default => 0.0
    t.integer "abono_lapso_minimo",                         :limit => 2,                                 :default => 0
    t.float   "abono_dias_vencimiento",                                                                  :default => 0.0
    t.boolean "exonerar_intereses_mora",                                                                 :default => false
    t.string  "base_cobro_mora",                            :limit => 1
    t.boolean "diferir_intereses",                                                                       :default => false
    t.boolean "exonerar_intereses_diferidos",                                                            :default => false
    t.integer "frecuencia_pago",                            :limit => 2,                                 :default => 0
    t.float   "tasa_valor",                                                                              :default => 0.0
    t.boolean "exonerar_intereses",                                                                      :default => false
    t.integer "numero_veces_mora",                          :limit => 2,                                 :default => 0
    t.date    "fecha_cambio_estatus",                                                                                              :null => false
    t.float   "tasa_inicial",                                                                            :default => 0.0
    t.float   "tasa_vigente",                                                                            :default => 0.0
    t.integer "dia_facturacion",                            :limit => 2,                                 :default => 0
    t.string  "estatus_desembolso",                         :limit => 1,                                 :default => "E"
    t.decimal "saldo_insoluto",                                           :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_vencido",                                          :precision => 16, :scale => 2, :default => 0.0
    t.integer "dias_mora",                                  :limit => 2,                                 :default => 0
    t.decimal "monto_mora",                                               :precision => 16, :scale => 2, :default => 0.0
    t.decimal "causado_no_devengado",                                     :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_diferido_vencido",                                 :precision => 16, :scale => 2, :default => 0.0
    t.decimal "remanente_por_aplicar",                                    :precision => 16, :scale => 2, :default => 0.0
    t.integer "cantidad_cuotas_vencidas",                   :limit => 2,                                 :default => 0
    t.decimal "monto_cuotas_vencidas",                                    :precision => 16, :scale => 2, :default => 0.0
    t.decimal "deuda",                                                    :precision => 16, :scale => 2, :default => 0.0
    t.decimal "exigible",                                                 :precision => 16, :scale => 2, :default => 0.0
    t.decimal "capital_vencido",                                          :precision => 16, :scale => 2, :default => 0.0
    t.date    "fecha_revision_tasa"
    t.float   "porcentaje_riesgo_foncrei"
    t.float   "porcentaje_riesgo_intermediario"
    t.float   "porcentaje_tasa_foncrei"
    t.float   "porcentaje_tasa_intermediario"
    t.integer "frecuencia_pago_intermediario",              :limit => 2
    t.boolean "intermediado",                                                                            :default => false
    t.integer "entidad_financiera_id"
    t.decimal "interes_desembolso_vencido",                               :precision => 16, :scale => 2, :default => 0.0
    t.string  "destinatario",                               :limit => 1,                                 :default => "E"
    t.date    "fecha_cobranza_intermediario"
    t.boolean "tasa_cero",                                                                               :default => false
    t.decimal "monto_liquidado",                                          :precision => 16, :scale => 2
    t.date    "fecha_liquidacion"
    t.boolean "liberada",                                                                                :default => false
    t.string  "causa_liberacion",                           :limit => 1,                                 :default => "R"
    t.decimal "aumento_capital",                                          :precision => 16, :scale => 2, :default => 0.0
    t.string  "reestructurado",                             :limit => 1,                                 :default => "N"
    t.integer "prestamo_origen_id"
    t.integer "prestamo_destino_id"
    t.float   "traslado_origen"
    t.float   "traslado_destino"
    t.boolean "tasa_forzada",                                                                            :default => false
    t.date    "tasa_forzada_fecha_vigencia"
    t.float   "tasa_forzada_monto"
    t.date    "fecha_inicio"
    t.date    "fecha_ultimo_cierre"
    t.boolean "migrado_d3",                                                                              :default => false
    t.string  "codigo_d3",                                  :limit => 20
    t.decimal "interes_diferido_por_vencer",                              :precision => 16, :scale => 2, :default => 0.0
    t.decimal "capital_pago_parcial",                                     :precision => 16, :scale => 2, :default => 0.0
    t.float   "saldo_capital",                                                                           :default => 0.0
    t.integer "meses_diferidos",                                                                         :default => 0
    t.boolean "senal_visita",                                                                            :default => false
    t.integer "numero_d3",                                  :limit => 8,                                 :default => 0
    t.decimal "porcentaje_riesgo_sudeban",                                :precision => 16, :scale => 6, :default => 0.0
    t.string  "clasificacion_riesgo_sudeban",               :limit => 4
    t.decimal "conversion_cuotas_mensuales_sudeban",                      :precision => 16, :scale => 2, :default => 0.0
    t.decimal "provision_individual_sudeban",                             :precision => 16, :scale => 2, :default => 0.0
    t.decimal "porcentaje_riesgo_bandes",                                 :precision => 16, :scale => 6, :default => 0.0
    t.string  "clasificacion_riesgo_bandes",                :limit => 4
    t.decimal "conversion_cuotas_mensuales_bandes",                       :precision => 16, :scale => 2, :default => 0.0
    t.decimal "provision_individual_bandes",                              :precision => 16, :scale => 2, :default => 0.0
    t.date    "fecha_base"
    t.integer "ultimo_desembolso",                                                                       :default => 9
    t.string  "codigo_contable",                            :limit => 6,                                 :default => "000000"
    t.string  "banco_origen",                               :limit => 25
    t.integer "tipo_cartera_id",                                                                         :default => 1
    t.decimal "abono_capital",                                            :precision => 16, :scale => 2, :default => 0.0
    t.integer "dias_demorado",                                                                           :default => 0
    t.integer "dias_vencido",                                                                            :default => 0
    t.integer "dias_vigente",                                                                            :default => 0
    t.integer "cuotas_pagadas",                                                                          :default => 0
    t.integer "cuotas_pendientes",                                                                       :default => 0
    t.integer "cuotas_especiales_pagadas",                                                               :default => 0
    t.integer "cuotas_especiales_vencidas",                                                              :default => 0
    t.integer "cuotas_especiales_pendientes",                                                            :default => 0
    t.decimal "capital_pagado",                                           :precision => 14, :scale => 2, :default => 0.0
    t.decimal "capital_por_pagar",                                        :precision => 14, :scale => 2, :default => 0.0
    t.decimal "intereses_pagados",                                        :precision => 16, :scale => 2, :default => 0.0
    t.decimal "mora_pagada",                                              :precision => 16, :scale => 2, :default => 0.0
    t.boolean "tipo_diferimiento",                                                                       :default => true
    t.decimal "porcentaje_diferimiento",                                  :precision => 5,  :scale => 2, :default => 0.0
    t.boolean "consolidar_deuda"
    t.decimal "pago_mora_migracion",                                      :precision => 16, :scale => 2, :default => 0.0
    t.integer "cuotas_pagadas_migracion",                                                                :default => 0
    t.decimal "monto_banco",                                              :precision => 16, :scale => 2
    t.decimal "monto_insumos",                                            :precision => 16, :scale => 2
    t.date    "fecha_vencimiento"
    t.decimal "monto_cuota",                                              :precision => 16, :scale => 2, :default => 0.0,          :null => false
    t.decimal "monto_cuota_gracia",                                       :precision => 16, :scale => 2, :default => 0.0,          :null => false
    t.integer "rubro_id",                                                                                                          :null => false
    t.integer "producto_id",                                                                             :default => 12,           :null => false
    t.decimal "monto_sras_primer_ano",                                    :precision => 16, :scale => 2, :default => 0.0
    t.decimal "monto_sras_anos_subsiguientes",                            :precision => 16, :scale => 2, :default => 0.0
    t.decimal "monto_sras_total",                                         :precision => 16, :scale => 2, :default => 0.0
    t.decimal "monto_facturado",                                          :precision => 16, :scale => 2, :default => 0.0
    t.decimal "monto_despachado",                                         :precision => 16, :scale => 2, :default => 0.0
    t.date    "fecha_instruccion_pago"
    t.boolean "instruccion_pago",                                                                        :default => false
    t.decimal "monto_inventario",                                         :precision => 16, :scale => 2
    t.decimal "monto_liquidado_insumos",                                  :precision => 16, :scale => 2, :default => 0.0
    t.integer "sub_rubro_id"
    t.integer "actividad_id"
    t.decimal "monto_gasto_total",                                        :precision => 16, :scale => 2, :default => 0.0,          :null => false
    t.integer "moneda_id",                                                                               :default => 1,            :null => false
    t.integer "cantidad_veces_mora",                                                                     :default => 0,            :null => false
    t.integer "cantidad_veces_vigente",                                                                  :default => 0,            :null => false
    t.integer "cantidad_dias_mora_acumulados",                                                           :default => 0,            :null => false
    t.integer "cantidad_compromisos_incumplidos",                                                        :default => 0,            :null => false
    t.integer "empresa_cobranza_id"
    t.decimal "tasa_conversion",                                          :precision => 16, :scale => 2, :default => 1.0,          :null => false
    t.date    "fecha_tasa_conversion",                                                                   :default => '2013-10-15', :null => false
    t.decimal "valor_moneda_nacional",                                    :precision => 16, :scale => 2
    t.decimal "porcentaje_veces_mora",                                    :precision => 5,  :scale => 2
    t.decimal "porcentaje_dias_mora",                                     :precision => 5,  :scale => 2
    t.decimal "indice_morosidad",                                         :precision => 5,  :scale => 2
    t.decimal "porcentaje_recuperacion_real_capital",                     :precision => 5,  :scale => 2
    t.decimal "porcentaje_recuperacion_esperada_capital",                 :precision => 5,  :scale => 2
    t.decimal "capital_cuotas_fecha",                                     :precision => 16, :scale => 2
    t.decimal "desviacion_recuperacion_capital",                          :precision => 5,  :scale => 2
    t.integer "dias_atraso_promedio"
    t.decimal "porcentaje_recuperacion_real_intereses",                   :precision => 5,  :scale => 2
    t.decimal "total_interes",                                            :precision => 16, :scale => 2
    t.decimal "porcentaje_recuperacion_esperado_intereses",               :precision => 5,  :scale => 2
    t.decimal "interes_cuota_fecha",                                      :precision => 16, :scale => 2
    t.decimal "desviacion_recuperacion_intereses",                        :precision => 5,  :scale => 2
    t.decimal "porcentaje_pagos_incumplidos",                             :precision => 5,  :scale => 2
    t.integer "analista_cobranzas_id"
  end

  add_index "prestamo", ["numero"], :name => "prestamo_uk_numero", :unique => true

  create_table "prestamo_comentario", :force => true do |t|
    t.string  "comentario",       :limit => 1000
    t.integer "prestamo_id",                      :null => false
    t.date    "fecha_aplicacion",                 :null => false
    t.integer "usuario_id",                       :null => false
  end

  create_table "prestamo_historico", :id => false, :force => true do |t|
    t.integer "id",                                                                                      :null => false
    t.integer "numero",                                     :limit => 8
    t.decimal "monto_solicitado",                                         :precision => 16, :scale => 2
    t.decimal "monto_aprobado",                                           :precision => 16, :scale => 2
    t.date    "fecha_aprobacion"
    t.integer "formula_id"
    t.boolean "tasa_fija"
    t.integer "tasa_id"
    t.float   "diferencial_tasa"
    t.float   "tasa_referencia_inicial"
    t.integer "plazo",                                      :limit => 2
    t.integer "meses_fijos_sin_cambio_tasa",                :limit => 2
    t.boolean "meses_gracia_si"
    t.integer "meses_gracia",                               :limit => 2
    t.boolean "meses_muertos_si"
    t.integer "meses_muertos",                              :limit => 2
    t.integer "cliente_id"
    t.integer "tipo_credito_id"
    t.integer "oficina_id"
    t.integer "solicitud_id"
    t.string  "estatus",                                    :limit => 1
    t.integer "tasa_mora_id"
    t.string  "forma_calculo_intereses",                    :limit => 1
    t.integer "base_calculo_intereses"
    t.boolean "permitir_abonos"
    t.string  "abono_forma",                                :limit => 1
    t.float   "abono_porcentaje"
    t.integer "abono_cantidad_cuotas",                      :limit => 2
    t.float   "abono_monto_minimo"
    t.integer "abono_lapso_minimo",                         :limit => 2
    t.float   "abono_dias_vencimiento"
    t.boolean "exonerar_intereses_mora"
    t.string  "base_cobro_mora",                            :limit => 1
    t.boolean "diferir_intereses"
    t.boolean "exonerar_intereses_diferidos"
    t.integer "frecuencia_pago",                            :limit => 2
    t.float   "tasa_valor"
    t.boolean "exonerar_intereses"
    t.integer "numero_veces_mora",                          :limit => 2
    t.date    "fecha_cambio_estatus"
    t.float   "tasa_inicial"
    t.float   "tasa_vigente"
    t.integer "dia_facturacion",                            :limit => 2
    t.string  "estatus_desembolso",                         :limit => 1
    t.decimal "saldo_insoluto",                                           :precision => 16, :scale => 2
    t.decimal "interes_vencido",                                          :precision => 16, :scale => 2
    t.integer "dias_mora",                                  :limit => 2
    t.decimal "monto_mora",                                               :precision => 16, :scale => 2
    t.decimal "causado_no_devengado",                                     :precision => 16, :scale => 2
    t.decimal "interes_diferido_vencido",                                 :precision => 16, :scale => 2
    t.decimal "remanente_por_aplicar",                                    :precision => 16, :scale => 2
    t.integer "cantidad_cuotas_vencidas",                   :limit => 2
    t.decimal "monto_cuotas_vencidas",                                    :precision => 16, :scale => 2
    t.decimal "deuda",                                                    :precision => 16, :scale => 2
    t.decimal "exigible",                                                 :precision => 16, :scale => 2
    t.decimal "capital_vencido",                                          :precision => 16, :scale => 2
    t.date    "fecha_revision_tasa"
    t.float   "porcentaje_riesgo_foncrei"
    t.float   "porcentaje_riesgo_intermediario"
    t.float   "porcentaje_tasa_foncrei"
    t.float   "porcentaje_tasa_intermediario"
    t.integer "frecuencia_pago_intermediario",              :limit => 2
    t.boolean "intermediado"
    t.integer "entidad_financiera_id"
    t.decimal "interes_desembolso_vencido",                               :precision => 16, :scale => 2
    t.string  "destinatario",                               :limit => 1
    t.date    "fecha_cobranza_intermediario"
    t.boolean "tasa_cero"
    t.decimal "monto_liquidado",                                          :precision => 16, :scale => 2
    t.date    "fecha_liquidacion"
    t.boolean "liberada"
    t.string  "causa_liberacion",                           :limit => 1
    t.decimal "aumento_capital",                                          :precision => 16, :scale => 2
    t.string  "reestructurado",                             :limit => 1
    t.integer "prestamo_origen_id"
    t.integer "prestamo_destino_id"
    t.float   "traslado_origen"
    t.float   "traslado_destino"
    t.boolean "tasa_forzada"
    t.date    "tasa_forzada_fecha_vigencia"
    t.float   "tasa_forzada_monto"
    t.date    "fecha_inicio"
    t.date    "fecha_ultimo_cierre"
    t.boolean "migrado_d3"
    t.string  "codigo_d3",                                  :limit => 20
    t.decimal "interes_diferido_por_vencer",                              :precision => 16, :scale => 2
    t.decimal "capital_pago_parcial",                                     :precision => 16, :scale => 2
    t.float   "saldo_capital"
    t.integer "meses_diferidos"
    t.boolean "senal_visita"
    t.integer "numero_d3",                                  :limit => 8
    t.decimal "porcentaje_riesgo_sudeban",                                :precision => 16, :scale => 6
    t.string  "clasificacion_riesgo_sudeban",               :limit => 4
    t.decimal "conversion_cuotas_mensuales_sudeban",                      :precision => 16, :scale => 2
    t.decimal "provision_individual_sudeban",                             :precision => 16, :scale => 2
    t.decimal "porcentaje_riesgo_bandes",                                 :precision => 16, :scale => 6
    t.string  "clasificacion_riesgo_bandes",                :limit => 4
    t.decimal "conversion_cuotas_mensuales_bandes",                       :precision => 16, :scale => 2
    t.decimal "provision_individual_bandes",                              :precision => 16, :scale => 2
    t.date    "fecha_base"
    t.integer "ultimo_desembolso"
    t.string  "codigo_contable",                            :limit => 6
    t.string  "banco_origen",                               :limit => 25
    t.integer "tipo_cartera_id"
    t.decimal "abono_capital",                                            :precision => 16, :scale => 2
    t.integer "dias_demorado"
    t.integer "dias_vencido"
    t.integer "dias_vigente"
    t.integer "cuotas_pagadas"
    t.integer "cuotas_pendientes"
    t.integer "cuotas_especiales_pagadas"
    t.integer "cuotas_especiales_vencidas"
    t.integer "cuotas_especiales_pendientes"
    t.decimal "capital_pagado",                                           :precision => 14, :scale => 2
    t.decimal "capital_por_pagar",                                        :precision => 14, :scale => 2
    t.decimal "intereses_pagados",                                        :precision => 16, :scale => 2
    t.decimal "mora_pagada",                                              :precision => 16, :scale => 2
    t.boolean "tipo_diferimiento"
    t.decimal "porcentaje_diferimiento",                                  :precision => 5,  :scale => 2
    t.boolean "consolidar_deuda"
    t.decimal "pago_mora_migracion",                                      :precision => 16, :scale => 2
    t.integer "cuotas_pagadas_migracion"
    t.decimal "monto_banco",                                              :precision => 16, :scale => 2
    t.decimal "monto_insumos",                                            :precision => 16, :scale => 2
    t.date    "fecha_vencimiento"
    t.decimal "monto_cuota",                                              :precision => 16, :scale => 2
    t.decimal "monto_cuota_gracia",                                       :precision => 16, :scale => 2
    t.integer "rubro_id"
    t.integer "producto_id"
    t.decimal "monto_sras_primer_ano",                                    :precision => 16, :scale => 2
    t.decimal "monto_sras_anos_subsiguientes",                            :precision => 16, :scale => 2
    t.decimal "monto_sras_total",                                         :precision => 16, :scale => 2
    t.decimal "monto_facturado",                                          :precision => 16, :scale => 2
    t.decimal "monto_despachado",                                         :precision => 16, :scale => 2
    t.date    "fecha_instruccion_pago"
    t.boolean "instruccion_pago"
    t.decimal "monto_inventario",                                         :precision => 16, :scale => 2
    t.decimal "monto_liquidado_insumos",                                  :precision => 16, :scale => 2
    t.integer "sub_rubro_id"
    t.integer "actividad_id"
    t.decimal "monto_gasto_total",                                        :precision => 16, :scale => 2
    t.integer "moneda_id"
    t.integer "cantidad_veces_mora"
    t.integer "cantidad_veces_vigente"
    t.integer "cantidad_dias_mora_acumulados"
    t.integer "cantidad_compromisos_incumplidos"
    t.integer "empresa_cobranza_id"
    t.decimal "tasa_conversion",                                          :precision => 16, :scale => 2
    t.date    "fecha_tasa_conversion"
    t.decimal "valor_moneda_nacional",                                    :precision => 16, :scale => 2
    t.decimal "porcentaje_veces_mora",                                    :precision => 5,  :scale => 2
    t.decimal "porcentaje_dias_mora",                                     :precision => 5,  :scale => 2
    t.decimal "indice_morosidad",                                         :precision => 5,  :scale => 2
    t.decimal "porcentaje_recuperacion_real_capital",                     :precision => 5,  :scale => 2
    t.decimal "porcentaje_recuperacion_esperada_capital",                 :precision => 5,  :scale => 2
    t.decimal "capital_cuotas_fecha",                                     :precision => 16, :scale => 2
    t.decimal "desviacion_recuperacion_capital",                          :precision => 5,  :scale => 2
    t.integer "dias_atraso_promedio"
    t.decimal "porcentaje_recuperacion_real_intereses",                   :precision => 5,  :scale => 2
    t.decimal "total_interes",                                            :precision => 16, :scale => 2
    t.decimal "porcentaje_recuperacion_esperado_intereses",               :precision => 5,  :scale => 2
    t.decimal "interes_cuota_fecha",                                      :precision => 16, :scale => 2
    t.decimal "desviacion_recuperacion_intereses",                        :precision => 5,  :scale => 2
    t.decimal "porcentaje_pagos_incumplidos",                             :precision => 5,  :scale => 2
    t.integer "analista_cobranzas_id"
    t.integer "ano",                                                                                     :null => false
    t.integer "mes",                                                                                     :null => false
  end

  create_table "prestamo_modificacion", :force => true do |t|
    t.float   "monto",                                     :default => 0.0
    t.date    "fecha_aprobacion"
    t.integer "formula_id"
    t.boolean "tasa_fija"
    t.integer "tasa_id"
    t.float   "diferencial_tasa",                          :default => 0.0
    t.integer "plazo",                        :limit => 2, :default => 0
    t.integer "meses_fijos_sin_cambio_tasa",  :limit => 2, :default => 0
    t.string  "estatus",                      :limit => 1, :default => "E"
    t.integer "tasa_mora_id"
    t.string  "base_cobro_mora",              :limit => 1
    t.integer "frecuencia_pago",              :limit => 2, :default => 0
    t.float   "tasa_inicial",                              :default => 0.0
    t.float   "tasa_referencia_inicial",                   :default => 0.0
    t.integer "prestamo_id",                                                  :null => false
    t.boolean "exonerar_intereses_mora",                   :default => false
    t.string  "tipo",                         :limit => 1, :default => "R"
    t.float   "aumento_capital",                           :default => 0.0
    t.integer "meses_muertos",                             :default => 0
    t.integer "traslado_prestamo_origen_id"
    t.integer "traslado_prestamo_destino_id"
    t.float   "traslado_monto",                            :default => 0.0
    t.integer "solicitud_id"
    t.float   "forzar_tasa_monto",                         :default => 0.0
    t.date    "forzar_tasa_fecha_vigencia"
    t.date    "fecha"
    t.boolean "forzar_tasa_fija",                          :default => false
    t.float   "saldo_insoluto",                            :default => 0.0
    t.float   "interes_diferido",                          :default => 0.0
    t.float   "interes_desembolso",                        :default => 0.0
    t.float   "interes_mora",                              :default => 0.0
    t.float   "interes_ordinario",                         :default => 0.0
    t.float   "interes_causado",                           :default => 0.0
    t.float   "remanente_por_aplicar",                     :default => 0.0
    t.float   "total_deuda",                               :default => 0.0
    t.integer "partida_id"
    t.integer "rubro_id"
  end

  create_table "prestamo_modificacion_rubro", :force => true do |t|
    t.integer "rubro_id",                 :null => false
    t.integer "prestamo_modificacion_id", :null => false
    t.float   "aporte_propio"
    t.float   "aporte_foncrei"
    t.float   "otras_fuentes"
    t.float   "valor_total"
    t.integer "empresa_integrante_id"
  end

  create_table "prestamo_modificacion_rubro_atributo", :force => true do |t|
    t.integer "rubro_atributo_id",                                                :null => false
    t.integer "prestamo_modificacion_rubro_id",                                   :null => false
    t.string  "valor_1",                        :limit => 100
    t.string  "valor_5",                        :limit => 500
    t.integer "valor_i"
    t.float   "valor_f"
    t.boolean "valor_b",                                       :default => false
    t.date    "valor_d"
  end

  create_table "prestamo_rubro", :force => true do |t|
    t.integer "rubro_id",                                                                   :null => false
    t.integer "prestamo_id",                                                                :null => false
    t.float   "aporte_propio"
    t.float   "aporte_foncrei"
    t.float   "otras_fuentes"
    t.float   "valor_total"
    t.integer "empresa_integrante_id"
    t.decimal "aporte_propio_ejecutado",    :precision => 16, :scale => 2, :default => 0.0
    t.decimal "aporte_propio_por_ejecutar", :precision => 16, :scale => 2, :default => 0.0
  end

  create_table "prestamo_rubro_atributo", :force => true do |t|
    t.integer "rubro_atributo_id",                                   :null => false
    t.integer "prestamo_rubro_id",                                   :null => false
    t.string  "valor_1",           :limit => 100
    t.string  "valor_5",           :limit => 500
    t.integer "valor_i"
    t.float   "valor_f"
    t.boolean "valor_b",                          :default => false
    t.date    "valor_d"
  end

  create_table "prestamo_tasa_historico", :force => true do |t|
    t.float   "tasa_cliente"
    t.integer "prestamo_id",  :null => false
    t.integer "tasa_id"
    t.date    "fecha",        :null => false
  end

  create_table "presupuesto_carga", :force => true do |t|
    t.integer "rubro_id",                                                        :null => false
    t.decimal "monto_presupuesto", :precision => 16, :scale => 2
    t.date    "fecha_registro"
    t.integer "usuario_id",                                                      :null => false
    t.integer "estado_id",                                                       :null => false
    t.integer "sub_rubro_id"
    t.integer "programa_id",                                      :default => 0, :null => false
  end

  create_table "presupuesto_comite", :force => true do |t|
    t.integer "comite_id"
    t.integer "programa_id"
    t.float   "monto"
    t.date    "fecha",             :null => false
    t.integer "cant_solicitudes"
    t.float   "monto_solicitudes"
    t.integer "cant_individual"
    t.float   "monto_individual"
    t.integer "cant_uea"
    t.float   "monto_uea"
    t.integer "cant_empresa"
    t.float   "monto_empresa"
  end

  create_table "presupuesto_pidan", :force => true do |t|
    t.integer "rubro_id",                                                           :null => false
    t.decimal "disponibilidad",     :precision => 16, :scale => 2
    t.integer "estado_id",                                                          :null => false
    t.decimal "presupuesto",        :precision => 16, :scale => 2,                  :null => false
    t.decimal "compromiso",         :precision => 16, :scale => 2,                  :null => false
    t.integer "sub_rubro_id"
    t.integer "programa_id",                                       :default => 0,   :null => false
    t.decimal "monto_liquidado",    :precision => 16, :scale => 2, :default => 0.0
    t.decimal "monto_por_liquidar", :precision => 16, :scale => 2, :default => 0.0
  end

  create_table "presupuesto_transferencia", :force => true do |t|
    t.integer "rubro_id_origen",                                                           :null => false
    t.integer "rubro_id_destino",                                                          :null => false
    t.decimal "monto_transferencia",         :precision => 16, :scale => 2,                :null => false
    t.date    "fecha_registro",                                                            :null => false
    t.integer "usuario_id",                                                                :null => false
    t.integer "estado_id_origen",                                                          :null => false
    t.integer "estado_id_destino",                                                         :null => false
    t.text    "observaciones_justificacion"
    t.integer "sub_rubro_id_origen"
    t.integer "sub_rubro_id_destino"
    t.integer "programa_id_origen",                                         :default => 0, :null => false
    t.integer "programa_id_destino",                                        :default => 0, :null => false
  end

  create_table "produccion_leche_carne", :force => true do |t|
    t.integer "seguimiento_visita_id",                                             :null => false
    t.float   "prod_diaria_leche_plantas_estado",                 :default => 0.0, :null => false
    t.float   "prod_diaria_leche_vendida_terceros",               :default => 0.0, :null => false
    t.float   "prod_diaria_leche_finca",                          :default => 0.0, :null => false
    t.float   "total_litros_dia_leche",                           :default => 0.0, :null => false
    t.float   "l_vaca_total_dia",                                 :default => 0.0, :null => false
    t.string  "calidad_ordenio",                     :limit => 1
    t.text    "observaciones_ordenio"
    t.float   "carne_plantas_estado",                             :default => 0.0, :null => false
    t.float   "carne_anual_terceros",                             :default => 0.0, :null => false
    t.float   "carne_anual_finca",                                :default => 0.0, :null => false
    t.float   "carne_peso_diario_promedio_ganancia",              :default => 0.0, :null => false
    t.float   "carne_peso_promedio_matadero",                     :default => 0.0, :null => false
    t.float   "carne_total_arrime_anual",                         :default => 0.0, :null => false
    t.text    "observaciones_prod_carne"
    t.float   "total_l_dia",                                      :default => 0.0, :null => false
  end

  create_table "producto", :force => true do |t|
    t.float   "monto_maximo"
    t.float   "monto_minimo"
    t.integer "plazo_maximo",                 :limit => 2
    t.integer "plazo_minimo",                 :limit => 2
    t.boolean "exonerar_intereses"
    t.boolean "tasa_fija",                                 :default => false
    t.integer "meses_fijos_sin_cambio_tasa",  :limit => 2
    t.string  "forma_calculo_intereses",      :limit => 1
    t.integer "base_calculo_intereses",                    :default => 360
    t.boolean "permitir_abonos",                           :default => false
    t.string  "abono_forma",                  :limit => 1, :default => "P"
    t.float   "abono_porcentaje"
    t.integer "abono_cantidad_cuotas",        :limit => 2
    t.float   "abono_monto_minimo"
    t.integer "abono_lapso_minimo",           :limit => 2
    t.integer "abono_dias_vencimiento",       :limit => 2
    t.boolean "exonerar_intereses_mora",                   :default => false
    t.string  "base_cobro_mora",              :limit => 1
    t.boolean "meses_gracia_si",                           :default => false
    t.integer "meses_gracia",                 :limit => 2
    t.boolean "diferir_intereses",                         :default => false
    t.boolean "exonerar_intereses_diferidos"
    t.boolean "meses_muertos_si",                          :default => false
    t.integer "meses_muertos",                :limit => 2
    t.float   "gastos_fijos"
    t.string  "gastos_forma_cobro",           :limit => 1
    t.boolean "fiador_si",                                 :default => false
    t.boolean "garantia_si",                               :default => false
    t.integer "programa_id",                                                  :null => false
    t.integer "sector_id",                                                    :null => false
    t.integer "sub_sector_id",                                                :null => false
    t.integer "sub_rubro_id"
    t.integer "actividad_id"
  end

  create_table "producto_formula", :id => false, :force => true do |t|
    t.integer "producto_id", :null => false
    t.integer "formula_id",  :null => false
  end

  add_index "producto_formula", ["producto_id", "formula_id"], :name => "producto_formula_uq", :unique => true

  create_table "producto_formulas", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "producto_partida", :force => true do |t|
    t.integer "producto_id", :null => false
    t.integer "partida_id",  :null => false
  end

  create_table "producto_partida_item", :force => true do |t|
    t.integer "producto_partida_id", :default => 0, :null => false
    t.integer "producto_id",                        :null => false
    t.integer "rubro_id",                           :null => false
    t.integer "partida_id",                         :null => false
    t.integer "item_id",                            :null => false
    t.integer "sub_rubro_id"
    t.integer "actividad_id"
  end

  create_table "producto_tipo_gasto", :force => true do |t|
    t.integer "tipo_gasto_id",                               :null => false
    t.integer "producto_id",                                 :null => false
    t.float   "porcentaje"
    t.float   "monto_fijo"
    t.string  "forma_cobro",   :limit => 1, :default => "3"
  end

  create_table "profesion", :force => true do |t|
    t.string "nombre",      :limit => 60,  :null => false
    t.string "descripcion", :limit => 400
  end

  create_table "proforma", :force => true do |t|
    t.string  "numero",             :limit => 30, :null => false
    t.date    "fecha_emision",                    :null => false
    t.date    "fecha_caduca",                     :null => false
    t.integer "usuario_id",                       :null => false
    t.integer "solicitud_id",                     :null => false
    t.integer "casa_proveedora_id"
  end

  create_table "programa", :force => true do |t|
    t.string  "nombre",                                                                                                 :null => false
    t.string  "alias",                                                                                                  :null => false
    t.string  "descripcion",                     :limit => 300
    t.float   "porcentaje_financiamiento"
    t.boolean "intermediado"
    t.float   "porcentaje_riesgo_foncrei"
    t.float   "porcentaje_riesgo_intermediario"
    t.float   "porcentaje_tasa_foncrei"
    t.float   "porcentaje_tasa_intermediario"
    t.integer "frecuencia_pago_intermediario",   :limit => 2,                                 :default => 1
    t.float   "porcentaje_tasa_tapp"
    t.boolean "activo",                                                                       :default => true
    t.integer "tipo_credito_id",                                                                                        :null => false
    t.integer "tasa_id",                                                                                                :null => false
    t.float   "diferencial_maximo_tasa"
    t.float   "diferencial_minimo_tasa"
    t.integer "tasa_mora_id",                                                                                           :null => false
    t.float   "diferencial_maximo_tasa_mora"
    t.float   "diferencial_minimo_tasa_mora"
    t.float   "relacion_garantia"
    t.boolean "solo_aprueba_directorio",                                                      :default => false
    t.boolean "cogestion",                                                                    :default => false
    t.string  "codigo_d3",                       :limit => 20
    t.text    "codestpro_sigesp"
    t.string  "spg_cuenta_sigesp",               :limit => 25
    t.date    "fecha_cierre",                                                                 :default => '1900-01-01'
    t.boolean "solo_aprueba_comite",                                                          :default => false
    t.boolean "aprueba_comite_directorio",                                                    :default => false
    t.float   "monto_max_presidencia"
    t.boolean "convenio"
    t.integer "ultimo_desembolso",                                                            :default => 0
    t.boolean "tipo_diferimiento",                                                            :default => true
    t.decimal "porcentaje_diferimiento",                        :precision => 5, :scale => 2, :default => 0.0
    t.string  "vinculo_tasa",                    :limit => 1,                                                           :null => false
    t.boolean "financiamiento_integral",                                                      :default => false,        :null => false
    t.string  "tamano_credito",                  :limit => 1
    t.integer "partida_presupuestaria_id",       :limit => 8
    t.integer "moneda_id",                                                                    :default => 0,            :null => false
  end

  add_index "programa", ["nombre"], :name => "programa_uq_nombre", :unique => true

  create_table "programa_mision", :force => true do |t|
    t.integer "programa_id"
    t.integer "mision_id"
  end

  create_table "programa_modalidad_financiamiento", :id => false, :force => true do |t|
    t.integer "programa_id",                 :null => false
    t.integer "modalidad_financiamiento_id", :null => false
  end

  create_table "programa_origen_fondo", :force => true do |t|
    t.integer "programa_id",                        :null => false
    t.integer "origen_fondo_id",                    :null => false
    t.integer "cuenta_contable_ingreso_interes_id"
    t.integer "cuenta_contable_capital_id"
    t.integer "cuenta_contable_capital_vencido_id"
  end

  create_table "programa_recaudo", :id => false, :force => true do |t|
    t.integer "programa_id", :null => false
    t.integer "recaudo_id",  :null => false
  end

  create_table "programa_tipo_cliente", :force => true do |t|
    t.integer "programa_id",     :null => false
    t.integer "tipo_cliente_id", :null => false
  end

  create_table "programa_tipo_garantia", :force => true do |t|
    t.integer "programa_id",                                                       :null => false
    t.integer "tipo_garantia_id",                                                  :null => false
    t.decimal "relacion_garantia", :precision => 16, :scale => 2, :default => 0.0
  end

  create_table "programa_tipo_gasto", :force => true do |t|
    t.integer "tipo_gasto_id",                                                              :null => false
    t.integer "programa_id",                                                                :null => false
    t.decimal "porcentaje",                 :precision => 16, :scale => 2
    t.decimal "monto_fijo",                 :precision => 16, :scale => 2
    t.string  "forma_cobro",   :limit => 1,                                :default => "3"
  end

  create_table "promotora", :force => true do |t|
    t.string  "nombre",                          :limit => 50,  :null => false
    t.string  "apellido",                        :limit => 50,  :null => false
    t.integer "estado_id",                                      :null => false
    t.integer "municipio_id",                                   :null => false
    t.integer "parroquia_id",                                   :null => false
    t.string  "direccion",                       :limit => 250, :null => false
    t.string  "correo",                          :limit => 80,  :null => false
    t.integer "cedula"
    t.integer "ciudad_id"
    t.string  "telefono_fijo",                   :limit => 16
    t.string  "telefono_movil",                  :limit => 16
    t.string  "lugar_nacimiento",                :limit => 100
    t.date    "fecha_nacimiento"
    t.integer "profesion_id"
    t.string  "grado_instruccion_primaria",      :limit => 1
    t.string  "grado_instruccion_secundaria",    :limit => 1
    t.string  "grado_instruccion_medio",         :limit => 1
    t.string  "grado_instruccion_universitario", :limit => 1
    t.string  "grado_instruccion_superior",      :limit => 1
    t.string  "grado_instruccion_robinson1",     :limit => 1
    t.string  "grado_instruccion_robinson2",     :limit => 1
    t.string  "grado_instruccion_robinson3",     :limit => 1
    t.string  "grado_instruccion_ribas",         :limit => 1
    t.string  "grado_instruccion_sucre",         :limit => 1
    t.string  "sexo",                            :limit => 1
    t.string  "estado_civil",                    :limit => 1
    t.integer "oficina_id"
  end

  add_index "promotora", ["cedula"], :name => "promotora_cedula_unique", :unique => true

  create_table "proveedor_marino", :force => true do |t|
    t.text    "nombre",                                           :null => false
    t.text    "direccion",                                        :null => false
    t.string  "rif",             :limit => 12
    t.boolean "propia",                                           :null => false
    t.boolean "asociado_fondas",               :default => false
  end

  create_table "puerto_base", :force => true do |t|
    t.string  "nombre_puerto",        :limit => 200, :null => false
    t.integer "unidad_produccion_id",                :null => false
  end

  create_table "punto_contacto", :force => true do |t|
    t.string  "apellidos",  :limit => 50, :null => false
    t.string  "nombres",    :limit => 50, :null => false
    t.string  "telefono",   :limit => 16, :null => false
    t.integer "persona_id",               :null => false
  end

  create_table "punto_cuenta", :force => true do |t|
    t.text "asunto"
    t.text "resumen_ejecutivo"
    t.text "recomendaciones"
    t.text "anexo"
  end

  create_table "punto_cuenta_siniestro", :force => true do |t|
    t.integer "siniestro_id",      :null => false
    t.integer "numero",            :null => false
    t.date    "fecha_elaboración"
    t.text    "asunto"
    t.integer "sintesis"
    t.text    "recomendaciones"
  end

  add_index "punto_cuenta_siniestro", ["numero"], :name => "punto_cuenta_siniestro_uq_numero", :unique => true

  create_table "rama_actividad_economica", :force => true do |t|
    t.string  "descripcion",            :limit => 100, :null => false
    t.integer "actividad_economica_id",                :null => false
  end

  create_table "recaudo", :force => true do |t|
    t.string  "nombre",              :limit => 90,                     :null => false
    t.string  "descripcion",         :limit => 300,                    :null => false
    t.boolean "activo",                             :default => true
    t.boolean "obligatorio",                        :default => false
    t.integer "tipo_cliente_id"
    t.date    "fecha_actualizacion"
    t.integer "sector_id"
    t.integer "sub_sector_id"
  end

  add_index "recaudo", ["nombre"], :name => "recaudo_uq_nombre", :unique => true

  create_table "recaudo_siniestro", :force => true do |t|
    t.integer "sector_id"
    t.string  "nombre",      :limit => 100,                    :null => false
    t.text    "descripcion",                                   :null => false
    t.boolean "obligatorio",                :default => false, :null => false
    t.boolean "activo",                     :default => true,  :null => false
  end

  add_index "recaudo_siniestro", ["nombre"], :name => "recaudo_siniestro_ix_nombre", :unique => true

  create_table "recaudos_avaluos_inspecciones", :force => true do |t|
    t.string  "descripcion",   :limit => 500
    t.boolean "obras_civiles"
  end

  create_table "recepcion_maquinaria", :force => true do |t|
    t.integer "guia_movilizacion_maquinaria_id"
    t.string  "cedula_receptor",                 :limit => 8
    t.date    "fecha_recepcion",                                :null => false
    t.date    "fecha_ingreso"
    t.integer "oficina_id",                                     :null => false
    t.text    "observaciones"
    t.integer "usuario_id"
    t.string  "nombe_receptor",                  :limit => 100, :null => false
    t.string  "telefono_receptor",               :limit => 11,  :null => false
    t.string  "hora_llegada",                    :limit => 5
    t.string  "hora_llegada_ampm",               :limit => 2
  end

  create_table "rechazo_cobranza", :force => true do |t|
    t.date    "fecha",                                :default => '1900-01-01'
    t.string  "archivo",               :limit => 100
    t.integer "prestamo_numero",       :limit => 8,   :default => 0
    t.integer "solicitud_numero",      :limit => 8,   :default => 0
    t.integer "cliente_id",                           :default => 0
    t.decimal "monto_pago",                           :default => 0.0
    t.integer "codigo_error",                         :default => 0
    t.string  "descripcion_error"
    t.integer "entidad_financiera_id",                :default => 0
  end

  create_table "rechazo_envio_comprobante", :force => true do |t|
    t.date    "fecha_comprobante"
    t.text    "referencia"
    t.text    "motivo"
    t.decimal "total_debe",        :precision => 16, :scale => 2
    t.decimal "total_haber",       :precision => 16, :scale => 2
    t.integer "numero"
    t.integer "usuario_id"
    t.date    "fecha_proceso"
  end

  create_table "rechazo_excedente_abono_arrime", :force => true do |t|
    t.date    "fecha",                                :default => '1900-01-01'
    t.string  "archivo",               :limit => 100
    t.integer "prestamo_numero",       :limit => 8,   :default => 0
    t.integer "solicitud_numero",      :limit => 8,   :default => 0
    t.integer "cliente_id",                           :default => 0
    t.decimal "monto_pago",                           :default => 0.0
    t.string  "descripcion_error"
    t.integer "entidad_financiera_id",                :default => 0
    t.boolean "procesado",                            :default => false
    t.string  "codigo_error",          :limit => 10
  end

  create_table "rechazo_liquidacion", :force => true do |t|
    t.date    "fecha",                                :default => '1900-01-01'
    t.string  "archivo",               :limit => 100
    t.integer "prestamo_numero",       :limit => 8,   :default => 0
    t.integer "solicitud_numero",      :limit => 8,   :default => 0
    t.integer "cliente_id",                           :default => 0
    t.decimal "monto_pago",                           :default => 0.0
    t.integer "codigo_error",                         :default => 0
    t.string  "descripcion_error"
    t.integer "entidad_financiera_id",                :default => 0
    t.boolean "procesado",                            :default => false
  end

  create_table "rechazo_liquidacion_casa_proveedora", :force => true do |t|
    t.date    "fecha"
    t.string  "archivo",               :limit => 100
    t.integer "prestamo_numero",       :limit => 8,                                  :default => 0
    t.integer "solicitud_numero",      :limit => 8,                                  :default => 0
    t.integer "casa_proveedora_id"
    t.string  "numero_factura",        :limit => 8
    t.decimal "monto_pago",                           :precision => 16, :scale => 2
    t.string  "codigo_error",          :limit => 10
    t.string  "descripcion_error"
    t.integer "entidad_financiera_id",                                               :default => 0
    t.string  "numero_cuenta",         :limit => 20
    t.boolean "procesado",                                                           :default => false
  end

  create_table "rechazos", :id => false, :force => true do |t|
    t.integer "prestamo_numero", :limit => 8,  :default => 0
    t.integer "empresa_id",      :limit => 8,  :default => 0
    t.integer "cliente_id",      :limit => 8,  :default => 0
    t.string  "codigo_d3",       :limit => 10
    t.string  "rif",             :limit => 15, :default => "-"
  end

  create_table "reestructuracion", :force => true do |t|
    t.date    "fecha_impresion_formato_solicitud"
    t.integer "estatus"
    t.integer "solicitud_id"
    t.integer "cliente_id"
    t.date    "fecha_aprobacion_comite"
    t.date    "fecha_envio_comite"
    t.string  "referencia_abono",                       :limit => nil
    t.decimal "monto_abono",                                           :precision => 16, :scale => 2, :default => 0.0
    t.date    "fecha_abono"
    t.decimal "interes_diferido",                                      :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_ordinarios",                                    :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_moratorio",                                     :precision => 16, :scale => 2, :default => 0.0
    t.decimal "interes_causado_no_devengado",                          :precision => 16, :scale => 2, :default => 0.0
    t.boolean "exonerado_interes_diferido"
    t.boolean "exonerado_interes_ordinarios"
    t.boolean "exonerado_interes_moratorio"
    t.boolean "exonerado_interes_causado_no_devengado"
    t.decimal "deuda",                                                 :precision => 16, :scale => 2, :default => 0.0
    t.decimal "monto_reestructurado",                                  :precision => 16, :scale => 2, :default => 0.0
    t.integer "formula_id"
    t.integer "frecuencia"
    t.integer "plazo"
    t.decimal "tasa",                                                  :precision => 16, :scale => 2, :default => 0.0
    t.integer "programa_id"
    t.integer "origen_fondo_id"
    t.integer "unidad_produccion_id"
    t.integer "modalidad_financiamiento_id"
    t.string  "objetivo_proyecto",                      :limit => nil
    t.integer "empresa_integrante_id"
    t.integer "sector_id"
    t.integer "sub_sector_id"
    t.integer "rubro_id"
    t.integer "sub_rubro_id"
    t.integer "actividad_id"
    t.decimal "saldo_insoluto",                                        :precision => 16, :scale => 2, :default => 0.0
    t.date    "fecha_impresion_propuesta"
    t.date    "fecha_impresion_contrato"
    t.date    "fecha_generacion_table"
    t.decimal "hectareas_solicitadas",                                 :precision => 14, :scale => 2
    t.integer "semovientes_solicitados"
    t.boolean "por_inventario",                                                                       :default => false
    t.date    "fecha_valor"
    t.boolean "viable",                                                                               :default => false
    t.integer "entidad_financiera_id",                                                                :default => 0,     :null => false
    t.string  "tipo",                                   :limit => 1
    t.string  "numero_cuenta",                          :limit => 20
  end

  create_table "reestructuracion_detalle", :force => true do |t|
    t.integer "reestructuracion_id"
    t.integer "solicitud_nueva_id"
    t.integer "solicitud_origen_id"
  end

  create_table "regimen_propiedad", :force => true do |t|
    t.string  "nombre",      :limit => 80,                    :null => false
    t.string  "descripcion", :limit => 200
    t.boolean "activo",                     :default => true
    t.integer "tasa_id",                                      :null => false
  end

  create_table "regimen_tipo_cliente", :force => true do |t|
    t.integer "regimen_propiedad_id", :null => false
    t.integer "tipo_cliente_id",      :null => false
  end

  add_index "regimen_tipo_cliente", ["regimen_propiedad_id", "tipo_cliente_id"], :name => "uq_regimen_tipo_cliente", :unique => true

  create_table "region", :force => true do |t|
    t.integer "pais_id",               :null => false
    t.string  "nombre",  :limit => 40, :null => false
  end

  add_index "region", ["pais_id", "nombre"], :name => "region_uq_nombre", :unique => true

  create_table "registro_mercantil", :force => true do |t|
    t.string  "tipo",                          :limit => 1,  :null => false
    t.date    "fecha_registro",                              :null => false
    t.string  "numero",                        :limit => 20, :null => false
    t.string  "nro_tomo",                      :limit => 20
    t.string  "nro_protocolo",                 :limit => 20
    t.string  "nombre_registro",               :limit => 80
    t.integer "estado_id"
    t.integer "ciudad_id"
    t.integer "duracion_empresa"
    t.date    "fecha_vencimiento"
    t.date    "fecha_cierre"
    t.float   "capital_suscrito"
    t.float   "capital_pagado"
    t.string  "nro_folio_inicial",             :limit => 20
    t.string  "nro_folio_final",               :limit => 20
    t.string  "nro_trimestre",                 :limit => 1
    t.string  "nro_anno",                      :limit => 20
    t.integer "empresa_id"
    t.integer "persona_id"
    t.integer "tipo_documento_id"
    t.integer "tenencia_unidad_produccion_id"
    t.integer "unidad_produccion_id"
    t.integer "municipio_id"
  end

  create_table "regla_contable", :force => true do |t|
    t.integer "fuente_recursos_id",                                     :null => false
    t.string  "estatus",                 :limit => 1,                   :null => false
    t.integer "secuencia",                                              :null => false
    t.string  "tipo_movimiento",         :limit => 1,  :default => "D"
    t.string  "codigo_contable",         :limit => 25,                  :null => false
    t.string  "auxiliar_contable",       :limit => 7
    t.string  "tipo_monto",              :limit => 2
    t.string  "modalidad_pago",          :limit => 1
    t.integer "entidad_financiera_id",                 :default => 0
    t.string  "reestructurado",          :limit => 1,  :default => "N"
    t.integer "programa_id"
    t.integer "transaccion_contable_id"
    t.string  "plazos",                  :limit => 1
  end

  create_table "reportes_cartera", :primary_key => "id_reporte", :force => true do |t|
    t.text    "nombre_reporte"
    t.text    "sentencia_reporte"
    t.text    "descripcion_reporte"
    t.decimal "carpeta",             :default => 0.0
  end

  create_table "repositorio", :id => false, :force => true do |t|
    t.integer "id",                                                          :null => false
    t.integer "anio",                                       :default => 0,   :null => false
    t.integer "mes",                                        :default => 0,   :null => false
    t.integer "prestamo_id",                                                 :null => false
    t.string  "estatus",                       :limit => 1, :default => "V"
    t.float   "monto_liquidado",                            :default => 0.0, :null => false
    t.integer "cantidad_empleados_femeninos",               :default => 0,   :null => false
    t.integer "cantidad_empleados_masculinos",              :default => 0,   :null => false
    t.float   "valor_tasa",                                 :default => 0.0, :null => false
    t.integer "cantidad_cuotas",                            :default => 0,   :null => false
    t.float   "capital_vencido",                            :default => 0.0, :null => false
    t.integer "cantidad_cuotas_vencidas",                   :default => 0,   :null => false
    t.float   "saldo_insoluto",                             :default => 0.0, :null => false
    t.float   "interes_vencido",                            :default => 0.0, :null => false
    t.float   "interes_mora",                               :default => 0.0, :null => false
  end

  create_table "resultado_cualitativa", :force => true do |t|
    t.integer "evaluacion_cualitativa_id",        :null => false
    t.float   "evaluacion_tecnica_puntaje"
    t.float   "evaluacion_tecnica_peso"
    t.float   "evaluacion_tecnica_ponderado"
    t.float   "evaluacion_territorial_puntaje"
    t.float   "evaluacion_territorial_peso"
    t.float   "evaluacion_territorial_ponderado"
    t.float   "evaluacion_sector_puntaje"
    t.float   "evaluacion_sector_peso"
    t.float   "evaluacion_sector_ponderado"
    t.float   "evaluacion_social_puntaje"
    t.float   "evaluacion_social_peso"
    t.float   "evaluacion_social_ponderado"
    t.float   "evaluacion_ambiental_puntaje"
    t.float   "evaluacion_ambiental_peso"
    t.float   "evaluacion_ambiental_ponderado"
    t.float   "evaluacion_financiera_ponderado"
    t.float   "evaluacion_cualitativa_puntaje"
    t.float   "evaluacion_cualitativa_peso"
    t.float   "evaluacion_cualitativa_ponderado"
  end

  create_table "revision_consultoria", :force => true do |t|
    t.string  "novedad",       :limit => 2000, :null => false
    t.string  "recomendacion", :limit => 2000, :null => false
    t.integer "solicitud_id",                  :null => false
  end

  create_table "riesgo_institucion", :force => true do |t|
    t.integer "dias_vencidos_cota_inferior",                                             :default => 0
    t.integer "dias_vencidos_cota_superior",                                             :default => 0
    t.string  "categoria",                   :limit => 1,                                                 :null => false
    t.decimal "porcentaje_riesgo",                        :precision => 16, :scale => 6, :default => 0.0
  end

  create_table "riesgo_sudeban", :force => true do |t|
    t.integer "dias_vencidos_cota_inferior",                                             :default => 0
    t.integer "dias_vencidos_cota_superior",                                             :default => 0
    t.string  "categoria",                   :limit => 1,                                                 :null => false
    t.decimal "porcentaje_riesgo",                        :precision => 16, :scale => 6, :default => 0.0
  end

  create_table "rol", :force => true do |t|
    t.string  "nombre",             :limit => 50,  :null => false
    t.string  "descripcion",        :limit => 300
    t.integer "empresa_sistema_id"
  end

  create_table "rol_autorizacion", :id => false, :force => true do |t|
    t.integer "rol_id",           :null => false
    t.integer "opcion_accion_id", :null => false
  end

  create_table "rol_comite", :force => true do |t|
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion"
    t.boolean "activo",                     :default => true
  end

  add_index "rol_comite", ["nombre"], :name => "rol_comite_uq_nombre", :unique => true

  create_table "rol_estacion", :id => false, :force => true do |t|
    t.integer "rol_id",      :null => false
    t.integer "estacion_id", :null => false
  end

  create_table "rol_opcion", :id => false, :force => true do |t|
    t.integer "rol_id",    :null => false
    t.integer "opcion_id", :null => false
  end

  create_table "rol_opcion_accion", :id => false, :force => true do |t|
    t.integer "rol_id",           :null => false
    t.integer "opcion_accion_id", :null => false
  end

  create_table "rol_opcion_accion_respaldo_2012_02_07", :id => false, :force => true do |t|
    t.integer "rol_id"
    t.integer "opcion_accion_id"
  end

  create_table "rol_opcion_respaldo_2012_02_07", :id => false, :force => true do |t|
    t.integer "rol_id"
    t.integer "opcion_id"
  end

  create_table "rol_respaldo_2012_02_07", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "nombre",      :limit => 50
    t.string  "descripcion", :limit => 300
  end

  create_table "rubro", :force => true do |t|
    t.string  "nombre",        :limit => 100,                   :null => false
    t.string  "descripcion"
    t.boolean "activo",                       :default => true, :null => false
    t.integer "codigo",                       :default => 0
    t.integer "sector_id",                                      :null => false
    t.integer "sub_sector_id",                                  :null => false
  end

  create_table "rubro_oficina", :force => true do |t|
    t.integer "rubro_id",                     :null => false
    t.integer "oficina_id",                   :null => false
    t.boolean "activo",     :default => true, :null => false
  end

  create_table "rubro_unificado", :force => true do |t|
    t.integer "codigo",                                  :null => false
    t.string  "nombre", :limit => 100
    t.boolean "activo",                :default => true, :null => false
  end

  create_table "sanidad_animal", :force => true do |t|
    t.integer "seguimiento_visita_id",                                     :null => false
    t.boolean "examenes_laboratorio",                   :default => false, :null => false
    t.text    "resultados"
    t.string  "tipo_examen",             :limit => 100
    t.boolean "plan_vacunacion_vigente",                :default => true
  end

  create_table "scoring_aceptacion", :force => true do |t|
    t.string  "scoring",        :limit => 4
    t.decimal "banda_inferior",              :precision => 16, :scale => 2
    t.decimal "banda_superior",              :precision => 16, :scale => 2
  end

  create_table "seccion", :force => true do |t|
    t.string "nombre",      :limit => 100, :null => false
    t.string "descripcion", :limit => 250, :null => false
  end

  create_table "sector", :force => true do |t|
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion"
    t.boolean "activo",                     :default => true, :null => false
    t.integer "codigo",                     :default => 0
  end

  add_index "sector", ["nombre"], :name => "sector_uq_nombre", :unique => true

  create_table "sector_economico", :force => true do |t|
    t.string  "descripcion",     :limit => 250,                :null => false
    t.boolean "activo"
    t.integer "tipo_formulario"
    t.integer "codigo_d3",                      :default => 0
  end

  create_table "sector_industrial", :force => true do |t|
    t.integer "agrupacion_industrial_id",                :null => false
    t.string  "nombre",                   :limit => 40,  :null => false
    t.string  "descripcion",              :limit => 300, :null => false
  end

  add_index "sector_industrial", ["nombre"], :name => "sector_industrial_uq_nombre", :unique => true

  create_table "sector_tecnico", :force => true do |t|
    t.integer "tecnico_campo_id", :null => false
    t.integer "sector_id",        :null => false
  end

  create_table "sector_tipo", :force => true do |t|
    t.string  "nombre",              :limit => 100, :null => false
    t.integer "sector_economico_id",                :null => false
  end

  create_table "seguimiento_cultivo", :force => true do |t|
    t.integer "seguimiento_visita_id",                   :null => false
    t.date    "fecha_siembra"
    t.integer "edad_cultivo",           :default => 0,   :null => false
    t.float   "superficie_sin_labores", :default => 0.0, :null => false
    t.float   "superficie_semillero",   :default => 0.0, :null => false
    t.float   "superficie_preparada",   :default => 0.0, :null => false
    t.float   "superficie_cosechada",   :default => 0.0, :null => false
    t.float   "superficie_sembrada",    :default => 0.0, :null => false
    t.float   "superficie_efectiva",    :default => 0.0, :null => false
    t.float   "superficie_perdida",     :default => 0.0, :null => false
    t.float   "rendimientos_estimados", :default => 0.0, :null => false
    t.date    "fecha_estimada_cosecha"
    t.float   "superficie_recomendada", :default => 0.0, :null => false
  end

  create_table "seguimiento_visita", :force => true do |t|
    t.integer "solicitud_id",                                                          :null => false
    t.date    "fecha_visita"
    t.time    "hora_visita"
    t.integer "motivo_visita_id"
    t.string  "cedula_persona_atencion",              :limit => 10
    t.string  "nombre_persona_atencion",              :limit => 30
    t.string  "apellido_persona_atencion",            :limit => 30
    t.string  "telf1_persona_atencion",               :limit => 12
    t.string  "telf2_persona_atencion",               :limit => 12
    t.string  "telf3_persona_atencion",               :limit => 12
    t.string  "vinculo_persona_atencion",             :limit => 60
    t.boolean "direccion_correcta",                                 :default => false, :null => false
    t.text    "observaciones"
    t.string  "codigo_visita",                        :limit => 30
    t.string  "cedula_nacionalidad_persona_atencion", :limit => 1,  :default => "V",   :null => false
    t.boolean "confirmada",                                         :default => false, :null => false
    t.string  "usuario_visita",                       :limit => 30
    t.date    "fecha_registro"
    t.boolean "activo",                                             :default => true,  :null => false
    t.string  "hora_visita_ampm",                     :limit => 2
  end

  create_table "semovientes", :force => true do |t|
    t.integer "seguimiento_visita_id",                                               :null => false
    t.integer "cantidad_becerra",                                   :default => 0,   :null => false
    t.string  "condicion_corporal_becerra",           :limit => 3
    t.float   "peso_promedio_becerra",                              :default => 0.0, :null => false
    t.integer "cantidad_becerro",                                   :default => 0,   :null => false
    t.string  "condicion_corporal_becerro",           :limit => 3
    t.float   "peso_promedio_becerro",                              :default => 0.0, :null => false
    t.integer "cantidad_mauta",                                     :default => 0,   :null => false
    t.string  "condicion_corporal_mauta",             :limit => 3
    t.float   "peso_promedio_mauta",                                :default => 0.0, :null => false
    t.integer "cantidad_maute",                                     :default => 0,   :null => false
    t.string  "condicion_corporal_maute",             :limit => 3
    t.float   "peso_promedio_maute",                                :default => 0.0, :null => false
    t.integer "cantidad_novilla",                                   :default => 0,   :null => false
    t.string  "condicion_corporal_novilla",           :limit => 3
    t.float   "peso_promedio_novilla",                              :default => 0.0, :null => false
    t.integer "cantidad_novillo",                                   :default => 0,   :null => false
    t.string  "condicion_corporal_novillo",           :limit => 3
    t.float   "peso_promedio_novillo",                              :default => 0.0, :null => false
    t.integer "cantidad_retajo",                                    :default => 0,   :null => false
    t.string  "condicion_corporal_retajo",            :limit => 3
    t.float   "peso_promedio_retajo",                               :default => 0.0, :null => false
    t.integer "cantidad_toro",                                      :default => 0,   :null => false
    t.string  "condicion_corporal_toro",              :limit => 3
    t.float   "peso_promedio_toro",                                 :default => 0.0, :null => false
    t.integer "cantidad_vaca_seca",                                 :default => 0,   :null => false
    t.string  "condicion_corporal_vaca_seca",         :limit => 3
    t.float   "peso_promedio_vaca_seca",                            :default => 0.0, :null => false
    t.integer "cantidad_vaca_ordenio",                              :default => 0,   :null => false
    t.string  "condicion_corporal_vaca_ordenio",      :limit => 3
    t.float   "peso_promedio_vaca_ordenio",                         :default => 0.0, :null => false
    t.integer "cantidad_porcinos",                                  :default => 0,   :null => false
    t.integer "cantidad_conejos",                                   :default => 0,   :null => false
    t.integer "cantidad_caballos",                                  :default => 0,   :null => false
    t.integer "cantidad_aves",                                      :default => 0,   :null => false
    t.integer "cantidad_burro",                                     :default => 0,   :null => false
    t.integer "cantidad_mula",                                      :default => 0,   :null => false
    t.integer "cantidad_ovino",                                     :default => 0,   :null => false
    t.integer "cantidad_caprino",                                   :default => 0,   :null => false
    t.integer "cantidad_caninos",                                   :default => 0,   :null => false
    t.integer "cantidad_felinos",                                   :default => 0,   :null => false
    t.string  "otra_especie",                         :limit => 25
    t.integer "cantidad_otra_especie",                              :default => 0,   :null => false
    t.float   "porcentaje_preniez",                                 :default => 0.0, :null => false
    t.integer "dias_intervalo_partos",                              :default => 0,   :null => false
    t.integer "cant_animales_adquiridos",                           :default => 0,   :null => false
    t.integer "cant_hembras",                                       :default => 0,   :null => false
    t.integer "cant_machos",                                        :default => 0,   :null => false
    t.date    "fecha_adquisicion_semovientes"
    t.integer "cant_animales_marcados_hierro_fondas"
    t.text    "anamnesis_diagnostico"
  end

  create_table "servicios_basicos", :force => true do |t|
    t.integer "solicitud_id",                 :null => false
    t.integer "unidad_produccion_id",         :null => false
    t.integer "seguimiento_visita_id",        :null => false
    t.boolean "vivienda"
    t.boolean "electricidad"
    t.boolean "transporte_publico"
    t.boolean "telefono"
    t.boolean "gas"
    t.boolean "aguas_blancas"
    t.boolean "aguas_servidas"
    t.text    "observaciones_vivienda"
    t.text    "observaciones_electricidad"
    t.text    "observaciones_transporte"
    t.text    "observaciones_gas"
    t.text    "observaciones_aguas_blancas"
    t.text    "observaciones_aguas_servidas"
    t.text    "observaciones_telefono1"
    t.text    "observaciones_telefono2"
    t.text    "observaciones_telefono3"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "siga_causado", :force => true do |t|
    t.date    "fecha",                                                                                 :null => false
    t.integer "numero_solicitud",                                                                      :null => false
    t.integer "numero_prestamo",       :limit => 8,                                                    :null => false
    t.string  "rif_ci",                :limit => 15,                                                   :null => false
    t.string  "nombre_beneficiario",                                                                   :null => false
    t.decimal "monto",                               :precision => 16, :scale => 2, :default => 0.0,   :null => false
    t.string  "forma_desembolso",      :limit => 1,                                                    :null => false
    t.string  "tipo_transaccion",      :limit => 1,                                                    :null => false
    t.boolean "registrado",                                                         :default => false, :null => false
    t.date    "fecha_registro"
    t.string  "cuenta_presupuestaria", :limit => 20
  end

  create_table "siga_compromiso", :force => true do |t|
    t.date    "fecha",                                                                                 :null => false
    t.integer "numero_solicitud",                                                                      :null => false
    t.string  "nombre_programa",                                                                       :null => false
    t.string  "cuenta_presupuestaria", :limit => 20,                                                   :null => false
    t.decimal "monto",                               :precision => 16, :scale => 2, :default => 0.0,   :null => false
    t.string  "rif_ci",                :limit => 15,                                                   :null => false
    t.string  "nombre_beneficiario",                                                                   :null => false
    t.string  "tipo_transaccion",      :limit => 1,                                                    :null => false
    t.boolean "registrado",                                                         :default => false, :null => false
    t.date    "fecha_registro"
  end

  create_table "siga_pagado", :force => true do |t|
    t.integer "numero_solicitud",                                                                          :null => false
    t.integer "numero_prestamo",          :limit => 8,                                                     :null => false
    t.string  "cuenta_presupuestaria",    :limit => 20,                                                    :null => false
    t.string  "forma_desembolso",         :limit => 1,                                                     :null => false
    t.string  "tipo_transaccion",         :limit => 1,                                                     :null => false
    t.string  "rif_ci",                   :limit => 15,                                                    :null => false
    t.string  "nombre_beneficiario",                                                                       :null => false
    t.decimal "monto",                                   :precision => 16, :scale => 2, :default => 0.0,   :null => false
    t.date    "fecha"
    t.string  "nro_orden_pago",           :limit => 15
    t.string  "nro_cheque",               :limit => 15
    t.string  "entidad_financiera",       :limit => 100
    t.boolean "registrado",                                                             :default => false, :null => false
    t.date    "fecha_registro"
    t.date    "fecha_actualizacion_siga"
  end

  create_table "silo", :force => true do |t|
    t.text    "direccion"
    t.integer "estado_id"
    t.integer "ciudad_id"
    t.integer "municipio_id"
    t.string  "persona_contacto",   :limit => 60
    t.string  "telefono",           :limit => 15
    t.string  "fax",                :limit => 15
    t.boolean "activo"
    t.date    "fecha_registro"
    t.string  "rif",                :limit => 15
    t.string  "nombre",             :limit => 45
    t.integer "nro_acta",                         :default => 0
    t.date    "fecha_modificacion"
    t.boolean "convenio",                         :default => false
  end

  create_table "siniestro", :force => true do |t|
    t.integer "solicitud_id",                                           :null => false
    t.integer "prestamo_id",                                            :null => false
    t.integer "cliente_id",                                             :null => false
    t.integer "seguimiento_visita_id",                                  :null => false
    t.date    "fecha_siniestro",                                        :null => false
    t.date    "fecha_notificacion",                                     :null => false
    t.date    "fecha_siembra"
    t.date    "fecha_cosecha"
    t.string  "nombre_notificador",                      :limit => 100, :null => false
    t.integer "causa_siniestro_id"
    t.text    "direccion_siniestro",                                    :null => false
    t.text    "descripcion_siniestro",                                  :null => false
    t.integer "tipo_perdida_id",                                        :null => false
    t.integer "unidades_adquiridas"
    t.integer "unidades_aprobadas"
    t.integer "unidades_siniestradas"
    t.integer "estatus_id",                                             :null => false
    t.string  "decision",                                :limit => 1,   :null => false
    t.float   "porcentaje_perdida"
    t.float   "hectareas_aprobadas"
    t.float   "hectareas_sembradas"
    t.float   "hectareas_siniestradas"
    t.integer "usuario_id"
    t.text    "informacion_infraestructura_siniestrada"
    t.integer "analista_siniestro_id"
  end

  create_table "siniestro_detalle_item", :force => true do |t|
    t.integer "siniestro_id",             :null => false
    t.integer "plan_inversion_id",        :null => false
    t.integer "sector_id",                :null => false
    t.integer "sub_sector_id",            :null => false
    t.integer "rubro_id",                 :null => false
    t.integer "partida_id",               :null => false
    t.integer "item_id",                  :null => false
    t.integer "unidad_medida_id",         :null => false
    t.integer "cantidad",                 :null => false
    t.float   "monto",                    :null => false
    t.float   "monto_desembolsado"
    t.float   "ajuste"
    t.integer "monto_indemnizar"
    t.float   "monto_facturado_efectivo"
    t.integer "confirmado"
  end

  create_table "siniestro_recaudo", :id => false, :force => true do |t|
    t.integer "id",                   :null => false
    t.integer "siniestro_id",         :null => false
    t.integer "recaudo_siniestro_id"
    t.boolean "entregado"
    t.boolean "entramite"
  end

  create_table "sitio_colocacion", :force => true do |t|
    t.text    "sitio",                    :null => false
    t.text    "nombre",                   :null => false
    t.boolean "activo", :default => true
  end

  create_table "solicitud", :force => true do |t|
    t.integer  "cliente_id",                                                                                                     :null => false
    t.integer  "numero",                                                                                                         :null => false
    t.integer  "programa_id",                                                                                                    :null => false
    t.date     "fecha_solicitud",                                                                                                :null => false
    t.date     "fecha_registro"
    t.float    "monto_solicitado"
    t.float    "monto_aprobado"
    t.string   "nombre_proyecto",                               :limit => 400
    t.string   "objetivo_proyecto",                             :limit => 400
    t.text     "justificacion"
    t.float    "aporte_social"
    t.float    "monto_propuesta_social"
    t.string   "estatus",                                       :limit => 1
    t.string   "numero_comite_estadal",                         :limit => 20
    t.string   "numero_comite_nacional",                        :limit => 15
    t.date     "fecha_comite_estadal"
    t.date     "fecha_comite_nacional"
    t.date     "fecha_solicitud_desembolso"
    t.string   "comentario_directorio",                         :limit => 400
    t.integer  "causa_rechazo_id"
    t.integer  "causa_diferimiento_id"
    t.integer  "parroquia_id"
    t.integer  "ciudad_id"
    t.integer  "municipio_id"
    t.string   "estatus_directorio",                            :limit => 1
    t.boolean  "intermediado",                                                                                :default => false
    t.integer  "modalidad_financiamiento_id",                                                                                    :null => false
    t.integer  "origen_fondo_id",                                                                                                :null => false
    t.float    "porcentaje_cooperativa"
    t.float    "porcentaje_empresa"
    t.float    "monto_cliente"
    t.boolean  "liberada",                                                                                    :default => false
    t.string   "causa_liberacion",                              :limit => 1
    t.float    "aumento_capital"
    t.string   "estatus_comite",                                :limit => 1,                                  :default => "N"
    t.string   "estatus_modificacion",                          :limit => 1,                                  :default => "N"
    t.string   "estatus_comite_temporal",                       :limit => 1,                                  :default => "N"
    t.integer  "causa_diferimiento_comite_id"
    t.boolean  "migrado_d3",                                                                                  :default => false
    t.integer  "causa_rechazo_comite_id"
    t.string   "codigo_d3",                                     :limit => 10
    t.string   "codigo_presupuesto_d3",                         :limit => 2,                                  :default => "00"
    t.string   "descripcion_presupuesto_d3",                    :limit => 100,                                :default => "-"
    t.string   "tipo_comite",                                   :limit => 1,                                  :default => "D"
    t.decimal  "tir",                                                          :precision => 16, :scale => 2, :default => 0.0
    t.decimal  "van",                                                          :precision => 16, :scale => 2, :default => 0.0
    t.integer  "tiempo_recuperacion",                                                                         :default => 0
    t.integer  "estatus_id"
    t.date     "fecha_actual_estatus"
    t.date     "fecha_firma_contrato"
    t.integer  "cuenta_matriz_id"
    t.integer  "numero_origen"
    t.string   "banco_origen",                                  :limit => 25
    t.string   "transcriptor",                                  :limit => 25
    t.date     "fecha_aprobacion"
    t.date     "fecha_liquidacion"
    t.integer  "ups_id"
    t.string   "observacion",                                   :limit => 250
    t.integer  "numero_grupo"
    t.integer  "numero_empresa"
    t.boolean  "control",                                                                                     :default => false
    t.integer  "mision_id"
    t.string   "analista_consejo",                              :limit => 25
    t.integer  "comite_id"
    t.string   "decision_comite",                               :limit => 1
    t.string   "comentario_comite",                             :limit => 400
    t.string   "numero_acta_resumen_comite",                    :limit => 15
    t.integer  "estatus_desembolso_id",                                                                       :default => 1
    t.boolean  "control_certificacion"
    t.boolean  "control_disponibilidad"
    t.string   "numero_acta_liquidacion",                       :limit => 15
    t.date     "fecha_acta_liquidacion"
    t.integer  "region_id"
    t.boolean  "certificado_presupuesto",                                                                     :default => false
    t.float    "monto_analista"
    t.integer  "scoring_aceptacion_id"
    t.float    "monto_actuales"
    t.float    "monto_proyecto"
    t.float    "calificacion_cuantitativa"
    t.float    "calificacion_cualitativa"
    t.float    "calificacion_social"
    t.string   "destino_credito",                               :limit => 400
    t.integer  "tipo_iniciativa_id"
    t.string   "usuario_pre_evaluacion",                        :limit => 30
    t.integer  "partida_presupuestaria_id"
    t.boolean  "consultoria"
    t.boolean  "decision_final"
    t.boolean  "confirmacion",                                                                                :default => false
    t.boolean  "avaluo_obra_civil",                                                                           :default => false
    t.string   "usuario_resguardo",                             :limit => 30
    t.integer  "reestructuracion_solicitud_id",                 :limit => 8
    t.decimal  "monto_ampliacion",                                             :precision => 16, :scale => 2
    t.boolean  "no_visto"
    t.integer  "oficina_id",                                                                                  :default => 1,     :null => false
    t.integer  "unidad_produccion_id"
    t.integer  "sector_id",                                                                                   :default => 0,     :null => false
    t.integer  "sub_sector_id",                                                                               :default => 0,     :null => false
    t.integer  "rubro_id",                                                                                    :default => 0,     :null => false
    t.integer  "empresa_integrante_id"
    t.boolean  "instancia_comite"
    t.string   "decision_comite_estadal",                       :limit => 1
    t.string   "decision_comite_nacional",                      :limit => 1
    t.integer  "comite_estadal_id"
    t.text     "comentario_comite_estadal"
    t.text     "comentario_comite_nacional"
    t.decimal  "hectareas_recomendadas",                                       :precision => 14, :scale => 3, :default => 0.0,   :null => false
    t.decimal  "semovientes_recomendados",                                     :precision => 14, :scale => 2, :default => 0.0,   :null => false
    t.integer  "folio_autenticacion"
    t.integer  "tomo_autenticacion"
    t.integer  "abogado_id"
    t.integer  "codigo_sras",                                   :limit => 8,                                  :default => 0
    t.boolean  "enviado_suscripcion",                                                                         :default => false
    t.text     "ruta_contrato"
    t.text     "ruta_acta_entrega"
    t.text     "ruta_nota_autenticacion"
    t.date     "fecha_nota_autenticacion"
    t.float    "hectareas_solicitadas"
    t.integer  "semovientes_solicitados"
    t.boolean  "por_inventario",                                                                              :default => false
    t.date     "fecha_a_entrega"
    t.boolean  "conf_maquinaria",                                                                             :default => false
    t.integer  "sub_rubro_id"
    t.integer  "actividad_id"
    t.datetime "fecha_hora_revocatoria_anulacion"
    t.integer  "usuario_responsable_revocatoria_anulacion"
    t.text     "justificacion_revocatoria_anulacion"
    t.date     "fecha_aprobacion_oficio_revocatoria_anulacion"
    t.string   "numero_oficio_revocatoria_anulacion",           :limit => 20
    t.integer  "causa_revocatoria_anulacion"
    t.string   "referencia_revocatoria_liquidacion",            :limit => 100
    t.date     "fecha_pago_revocatoria_liquidacion"
    t.integer  "moneda_id",                                                                                   :default => 1,     :null => false
  end

  add_index "solicitud", ["ciudad_id"], :name => "solicitud_ciudad_id_idx"
  add_index "solicitud", ["comite_id"], :name => "solicitud_comite_id_idx"
  add_index "solicitud", ["fecha_aprobacion"], :name => "solicitud_fecha_aprobacion_idx"
  add_index "solicitud", ["fecha_solicitud"], :name => "solicitud_fecha_solicitud_idx"
  add_index "solicitud", ["municipio_id"], :name => "solicitud_municipio_id_idx"
  add_index "solicitud", ["numero"], :name => "solicitud_uk_numero", :unique => true
  add_index "solicitud", ["parroquia_id"], :name => "solicitud_parroquia_id_idx"
  add_index "solicitud", ["programa_id"], :name => "solicitud_programa_id_idx"

  create_table "solicitud_anticipo_societario", :force => true do |t|
    t.integer "solicitud_id",                         :null => false
    t.integer "empresa_integrante_id",                :null => false
    t.float   "aporte_mensual"
    t.integer "periodo_aporte",          :limit => 2
    t.integer "integrantes_por_familia", :limit => 2
  end

  create_table "solicitud_aspectos_evaluar", :force => true do |t|
    t.integer "solicitud_id",                                                        :null => false
    t.integer "aspectos_resguardo_institucional_id",                                 :null => false
    t.boolean "evaluado",                                         :default => false
    t.string  "tipo",                                :limit => 1, :default => "A"
  end

  create_table "solicitud_avaluo", :force => true do |t|
    t.string   "nombre_perito",              :limit => 100
    t.date     "fecha_avaluo"
    t.float    "valor_avaluo"
    t.string   "urbanizacion",               :limit => 100
    t.string   "calle",                      :limit => 100
    t.string   "casa",                       :limit => 100
    t.string   "numero_apta",                :limit => 20
    t.string   "piso",                       :limit => 20
    t.string   "punto_referencia",           :limit => 50
    t.integer  "estado_id"
    t.integer  "municipio_id"
    t.integer  "parroquia_id"
    t.text     "comentario"
    t.integer  "solicitud_id",                                               :null => false
    t.integer  "solicitud_tipo_garantia_id",                                 :null => false
    t.string   "estatus",                    :limit => 1,   :default => "V", :null => false
    t.boolean  "documento_oferta"
    t.string   "numero_sudeban",             :limit => 20
    t.datetime "fecha_actualizacion",                                        :null => false
  end

  create_table "solicitud_avaluo_fianza", :force => true do |t|
    t.integer "cedula",                                  :null => false
    t.string  "nombre",                   :limit => 100, :null => false
    t.integer "nacionalidad_id"
    t.string  "estado_civil",             :limit => 1
    t.string  "domicilio",                :limit => 500
    t.integer "estado_id"
    t.integer "cedula_conyugue"
    t.string  "nombre_conyugue",          :limit => 100
    t.integer "nacionalidad_conyugue_id"
    t.string  "estado_civil_conyugue",    :limit => 1
    t.string  "domicilio_conyugue",       :limit => 500
    t.integer "estado_conyugue_id"
    t.integer "solicitud_avaluo_id",                     :null => false
  end

  create_table "solicitud_avaluo_imagen", :force => true do |t|
    t.string  "nombre_imagen",              :limit => 50,  :null => false
    t.string  "nombre_real",                :limit => 100, :null => false
    t.integer "solicitud_tipo_garantia_id",                :null => false
    t.text    "referencia"
  end

  create_table "solicitud_avaluo_inmobiliario", :force => true do |t|
    t.string  "nombre_perito",                  :limit => 100
    t.date    "fecha_avaluo_inmobiliario"
    t.float   "valor_avaluo_inmobiliario"
    t.string  "clasificacion",                  :limit => 1
    t.float   "espacio"
    t.string  "ubicacion",                      :limit => 500
    t.string  "descripcion",                    :limit => 500
    t.string  "lindero_norte",                  :limit => 100
    t.string  "lindero_sur",                    :limit => 100
    t.string  "lindero_este",                   :limit => 100
    t.string  "lindero_oeste",                  :limit => 100
    t.string  "nombre_registro",                :limit => 100
    t.integer "estado_id"
    t.date    "fecha_registro"
    t.string  "numero_registro",                :limit => 20
    t.string  "tomo_registro",                  :limit => 10
    t.string  "protocolo_registro",             :limit => 10
    t.string  "tipo_construccion",              :limit => 500
    t.integer "espacio_construccion"
    t.string  "ubicacion_construccion",         :limit => 500
    t.string  "nombre_registro_constrccion",    :limit => 100
    t.integer "estado_constrccion_id"
    t.date    "fecha_registro_constrccion"
    t.string  "numero_registro_constrccion",    :limit => 20
    t.string  "tomo_registro_constrccion",      :limit => 10
    t.string  "protocolo_registro_constrccion", :limit => 10
    t.text    "sistema_construtivo"
    t.integer "solicitud_avaluo_id",                           :null => false
    t.string  "numero_sudeban_inmobiliario",    :limit => 20
  end

  create_table "solicitud_avaluo_mobiliario", :force => true do |t|
    t.string  "nombre_perito",             :limit => 100
    t.date    "fecha_avaluo_mobiliario"
    t.float   "valor_avaluo_mobiliario"
    t.string  "tipo_documento",            :limit => 1
    t.string  "referencia_documento",      :limit => 20
    t.date    "fecha_documento"
    t.string  "empresa_documento",         :limit => 100
    t.string  "rif_empresa_documento",     :limit => 12
    t.string  "referencia_definitivo",     :limit => 20
    t.date    "fecha_factura"
    t.string  "empresa_factura",           :limit => 100
    t.string  "rif_empresa_difinitivo",    :limit => 12
    t.integer "solicitud_avaluo_id",                      :null => false
    t.string  "numero_sudeban_mobiliario", :limit => 20
  end

  create_table "solicitud_avaluo_mobiliario_tipos", :force => true do |t|
    t.string  "tipo",                       :limit => 50
    t.string  "modelo",                     :limit => 50
    t.string  "marca",                      :limit => 50
    t.string  "serial",                     :limit => 30
    t.float   "hipoteca"
    t.string  "ubicacion",                  :limit => 1,  :null => false
    t.integer "solicitud_tipo_garantia_id",               :null => false
  end

  create_table "solicitud_avaluo_prenda", :force => true do |t|
    t.string  "nombre_perito",          :limit => 100
    t.date    "fecha_avaluo_prenda"
    t.float   "valor_avaluo_prenda"
    t.string  "tipo_documento",         :limit => 1
    t.string  "referencia_documento",   :limit => 20
    t.date    "fecha_documento"
    t.string  "empresa_documento",      :limit => 100
    t.string  "rif_empresa_documento",  :limit => 12
    t.string  "referencia_definitivo",  :limit => 20
    t.date    "fecha_factura"
    t.string  "rif_empresa_difinitivo", :limit => 12
    t.integer "solicitud_avaluo_id",                   :null => false
    t.string  "empresa_factura",        :limit => 100
    t.string  "numero_sudeban_prenda",  :limit => 20
  end

  create_table "solicitud_avaluo_prenda_semoviente", :force => true do |t|
    t.integer "tipos_semovientes_id",                                    :null => false
    t.integer "cantidad",                                 :default => 1
    t.integer "peso",                                                    :null => false
    t.float   "monto",                                                   :null => false
    t.integer "solicitud_tipo_garantia_id",                              :null => false
    t.string  "raza",                       :limit => 50
    t.integer "edad"
    t.string  "unidad_edad",                :limit => 10
  end

  create_table "solicitud_capacidad", :force => true do |t|
    t.integer "solicitud_id",                                 :null => false
    t.string  "producto",                       :limit => 80, :null => false
    t.integer "capacidad_instalada_unidades"
    t.float   "capacidad_utilizada_porcentaje"
    t.integer "capacidad_utilizada_unidades"
    t.integer "capacidad_instalar_unidades"
    t.float   "capacidad_instalar_porcentaje"
    t.float   "capacidad_utilizar_porcentaje"
    t.integer "capacidad_utilizar_unidades"
  end

  create_table "solicitud_causa_devolucion_cliente", :force => true do |t|
    t.integer "solicitud_id"
    t.integer "causa_devolucion_cliente_id"
    t.text    "observaciones"
    t.integer "estatus_id"
  end

  create_table "solicitud_causa_renuncia", :force => true do |t|
    t.integer "solicitud_id"
    t.integer "causa_renuncia_id"
    t.text    "observaciones"
    t.integer "estatus_id",        :limit => 8
  end

  create_table "solicitud_certificacion_presupuestaria", :force => true do |t|
    t.integer "solicitud_id"
    t.integer "disponibilidad",                                                      :default => 0
    t.decimal "monto",                                :precision => 16, :scale => 2, :default => 0.0
    t.decimal "liquidacion_ano_actual",               :precision => 16, :scale => 2
    t.string  "proyecto",               :limit => 50
    t.string  "accion_especifica",      :limit => 50
    t.string  "partida",                :limit => 50
    t.string  "generica",               :limit => 50
    t.string  "especifica",             :limit => 50
    t.string  "sub_especifica",         :limit => 50
    t.string  "denominacion",           :limit => 50
    t.integer "numero",                 :limit => 8
    t.text    "observaciones"
    t.decimal "monto_anterior",                       :precision => 16, :scale => 2, :default => 0.0
  end

  create_table "solicitud_constitucion_garantia", :force => true do |t|
    t.string  "concepto",                   :limit => 100
    t.float   "monto"
    t.boolean "validacion_futura"
    t.date    "fecha_futura"
    t.date    "fecha_auteticacion"
    t.string  "notaria",                    :limit => 100
    t.string  "direccion_notaria",          :limit => 250
    t.integer "estado_id"
    t.integer "municipio_id"
    t.date    "fecha_protocolizacion"
    t.string  "registro",                   :limit => 500
    t.string  "direccion_registro",         :limit => 250
    t.string  "tomo",                       :limit => 10
    t.string  "protocolo",                  :limit => 10
    t.string  "folio",                      :limit => 10
    t.string  "comentarios",                :limit => 1000
    t.integer "solicitud_tipo_garantia_id"
    t.boolean "constituir",                                 :default => false
    t.string  "etiqueta_tomo",              :limit => 30
    t.string  "etiqueta_protocolo",         :limit => 30
    t.string  "etiqueta_folio",             :limit => 30
    t.string  "numero",                     :limit => 10
    t.integer "trimestre"
    t.string  "numero_autenticacion",       :limit => 10
    t.string  "folio_autenticacion",        :limit => nil,  :default => "10"
    t.string  "tomo_autenticacion",         :limit => nil
    t.string  "observacion",                :limit => 1000
    t.string  "observacion_autenticacion",  :limit => 1000
  end

  create_table "solicitud_contrato", :force => true do |t|
    t.integer "solicitud_id",    :null => false
    t.date    "fecha_recepcion", :null => false
    t.date    "fecha_notaria",   :null => false
    t.date    "fecha_registro"
    t.text    "nombre_archivo"
  end

  create_table "solicitud_evento", :force => true do |t|
    t.integer "solicitud_id",                 :null => false
    t.integer "usuario_id",                   :null => false
    t.string  "ip_address",    :limit => 20
    t.string  "estatus",       :limit => 1
    t.date    "fecha",                        :null => false
    t.string  "observaciones", :limit => 200
    t.time    "hora",                         :null => false
  end

  create_table "solicitud_historico", :force => true do |t|
    t.integer "solicitud_id",               :null => false
    t.string  "resolucion",   :limit => 20, :null => false
    t.date    "fecha",                      :null => false
  end

  create_table "solicitud_insumos_internos", :force => true do |t|
    t.integer "solicitud_id",                           :null => false
    t.integer "insumos_internos_id",                    :null => false
    t.boolean "entregado",           :default => false
  end

  create_table "solicitud_maquinaria", :force => true do |t|
    t.integer "tipo_maquinaria_id",                :null => false
    t.integer "clase_id",                          :null => false
    t.integer "solicitud_id",                      :null => false
    t.integer "cantidad",                          :null => false
    t.integer "marca_maquinaria_id"
    t.integer "modelo_id"
    t.integer "catalogo_id"
    t.integer "proforma_id"
    t.string  "estatus",             :limit => 1
    t.string  "serial_motor",        :limit => 50
    t.string  "serial_chasis",       :limit => 50
    t.float   "costo"
  end

  create_table "solicitud_obra_civil", :force => true do |t|
    t.date    "fecha"
    t.string  "nombre_obra",         :limit => 100
    t.float   "monto_presupuesto"
    t.string  "ubicacion_obra",      :limit => 1000
    t.string  "empresa_profesional", :limit => 100
    t.string  "revisior",            :limit => 100
    t.integer "solicitud_id",                        :null => false
  end

  create_table "solicitud_producto", :force => true do |t|
    t.string  "nombre",                          :limit => 100, :null => false
    t.string  "componente_importado",            :limit => 100
    t.integer "porcentaje_componente_importado"
    t.string  "producto_exportar",               :limit => 100
    t.integer "porcentaje_producto_exportar"
    t.integer "porcentaje_produccion_exportar"
    t.integer "pais_id"
    t.integer "solicitud_id",                                   :null => false
  end

  create_table "solicitud_recaudo", :force => true do |t|
    t.integer "solicitud_id",                                              :null => false
    t.integer "recaudo_id",                                                :null => false
    t.boolean "entregado",                              :default => false
    t.boolean "tramite",                                :default => false
    t.boolean "revisado_consultoria"
    t.boolean "no_revisado_consultoria"
    t.string  "observaciones",           :limit => 250
    t.boolean "no_aplica",                              :default => false, :null => false
  end

  add_index "solicitud_recaudo", ["solicitud_id", "recaudo_id"], :name => "solicitud_recaudo_uq", :unique => true

  create_table "solicitud_recaudo_avaluo", :force => true do |t|
    t.boolean "revisado"
    t.string  "observaciones",                    :limit => 250
    t.integer "solicitud_id",                                    :null => false
    t.integer "recaudos_avaluos_inspecciones_id",                :null => false
  end

  create_table "solicitud_resguardo", :force => true do |t|
    t.date    "fecha"
    t.string  "nombre_usuario",       :limit => 30,                 :null => false
    t.integer "completado"
    t.string  "coordinador",          :limit => 200
    t.text    "novedades"
    t.text    "recomendaciones"
    t.integer "solicitud_id",                                       :null => false
    t.integer "numero_informe"
    t.date    "fecha_creacion"
    t.integer "completado_resguardo",                :default => 0
  end

  create_table "solicitud_resguardo_imagen", :force => true do |t|
    t.string  "nombre_imagen", :limit => 50,  :null => false
    t.string  "nombre_real",   :limit => 100, :null => false
    t.string  "referencia",    :limit => 500
    t.integer "solicitud_id",                 :null => false
  end

  create_table "solicitud_rubro_sugerido", :force => true do |t|
    t.integer "sector_id",     :null => false
    t.integer "sub_sector_id", :null => false
    t.integer "rubro_id",      :null => false
    t.float   "cantidad",      :null => false
    t.integer "solicitud_id",  :null => false
  end

  create_table "solicitud_testigos", :force => true do |t|
    t.integer "solicitud_id",   :null => false
    t.text    "nombre_testigo"
    t.text    "cedula_testigo", :null => false
  end

  add_index "solicitud_testigos", ["solicitud_id", "cedula_testigo"], :name => "testigos_idx", :unique => true

  create_table "solicitud_tipo_garantia", :force => true do |t|
    t.integer "solicitud_id",                                            :null => false
    t.integer "tipo_garantia_id"
    t.string  "estatus",                   :limit => 1, :default => "P"
    t.text    "comentario"
    t.float   "relacion_garantia",                      :default => 0.0
    t.integer "programa_tipo_garantia_id"
  end

  create_table "stock_maquinaria", :force => true do |t|
    t.integer "tipo_maquinaria_id",               :null => false
    t.integer "clase_id",                         :null => false
    t.integer "marca_maquinaria_id",              :null => false
    t.integer "modelo_id",                        :null => false
    t.integer "minimo",                           :null => false
    t.integer "maximo",                           :null => false
    t.string  "indicador",           :limit => 1
  end

  add_index "stock_maquinaria", ["tipo_maquinaria_id", "clase_id", "marca_maquinaria_id", "modelo_id"], :name => "stock_maquinaria_uk", :unique => true

  create_table "sub_rubro", :force => true do |t|
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion"
    t.boolean "activo",                     :default => true, :null => false
    t.integer "codigo",                     :default => 0
    t.integer "rubro_id",                                     :null => false
  end

  add_index "sub_rubro", ["rubro_id", "nombre"], :name => "sub_rubo_ix_nombre"

  create_table "sub_sector", :force => true do |t|
    t.integer "sector_id",                                    :null => false
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion"
    t.boolean "activo",                     :default => true, :null => false
    t.integer "codigo",                     :default => 0
    t.string  "nemonico",    :limit => 2
  end

  add_index "sub_sector", ["nombre"], :name => "sub_sector_uq_nombre", :unique => true
  add_index "sub_sector", ["nombre"], :name => "unidad_medida_uq_nombre", :unique => true

  create_table "sucursal_casa_proveedora", :force => true do |t|
    t.string  "nombre",                 :limit => 300,                    :null => false
    t.integer "ciudad_id"
    t.integer "parroquia_id"
    t.integer "region_id"
    t.integer "municipio_id"
    t.string  "persona_contacto",       :limit => 150
    t.string  "email_persona_contacto", :limit => 50
    t.string  "edificio",               :limit => 150
    t.string  "numero",                 :limit => 10
    t.integer "casa_proveedora_id",                                       :null => false
    t.string  "avenida",                :limit => 90
    t.string  "urbanizacion",           :limit => 90
    t.string  "piso",                   :limit => 3
    t.string  "telefono1",              :limit => 20
    t.string  "telefono2",              :limit => 20
    t.string  "telefono3",              :limit => 20
    t.string  "telefono4",              :limit => 20
    t.string  "tipo_telefono1",         :limit => 1,   :default => "O"
    t.string  "tipo_telefono2",         :limit => 1,   :default => "O"
    t.string  "tipo_telefono3",         :limit => 1,   :default => "O"
    t.string  "tipo_telefono4",         :limit => 1,   :default => "O"
    t.boolean "es_express",                            :default => false
  end

  create_table "tabla_cuadre", :force => true do |t|
    t.integer "mes",                                                       :default => 0,     :null => false
    t.integer "ano",                                                       :default => 0,     :null => false
    t.decimal "saldo",                      :precision => 16, :scale => 2, :default => 0.0
    t.decimal "desembolso",                 :precision => 16, :scale => 2, :default => 0.0
    t.decimal "cobranza",                   :precision => 16, :scale => 2, :default => 0.0
    t.decimal "diferencia",                 :precision => 16, :scale => 2, :default => 0.0
    t.decimal "ajuste",                     :precision => 16, :scale => 2, :default => 0.0
    t.string  "banco_origen", :limit => 25,                                :default => "INI"
  end

  add_index "tabla_cuadre", ["ano", "mes"], :name => "ix_tabla_cuadre_mes_ano", :unique => true
  add_index "tabla_cuadre", ["banco_origen"], :name => "banco_origen_index"

  create_table "tanque", :force => true do |t|
    t.string "llamada",    :limit => 1000, :null => false
    t.string "log",        :limit => 2000, :null => false
    t.date   "timestamps"
  end

  create_table "tasa", :force => true do |t|
    t.string  "nombre",        :limit => 40,  :null => false
    t.string  "descripcion",   :limit => 300
    t.integer "sector_id"
    t.integer "sub_sector_id"
    t.integer "rubro_id"
    t.integer "sub_rubro_id"
  end

  add_index "tasa", ["nombre"], :name => "tasa_uq_nombre", :unique => true

  create_table "tasa_conversion_moneda", :force => true do |t|
    t.integer "moneda_id",                                                        :null => false
    t.date    "fecha",                                                            :null => false
    t.decimal "tasa_conversion", :precision => 16, :scale => 2,                   :null => false
    t.boolean "activo",                                         :default => true, :null => false
  end

  create_table "tasa_historico", :force => true do |t|
    t.float   "tasa_foncrei"
    t.float   "tasa_intermediario"
    t.float   "tasa_cliente"
    t.integer "programa_id",        :null => false
    t.integer "tasa_valor_id",      :null => false
  end

  create_table "tasa_valor", :force => true do |t|
    t.integer "tasa_id",                              :null => false
    t.date    "fecha_actualizacion",                  :null => false
    t.date    "fecha_resolucion_desde",               :null => false
    t.date    "fecha_resolucion_hasta"
    t.string  "resolucion",             :limit => 15, :null => false
    t.float   "valor"
  end

  create_table "tecnico_campo", :force => true do |t|
    t.string  "letra_cedula",        :limit => 1,                     :null => false
    t.integer "cedula",                                               :null => false
    t.integer "oficina_id",                                           :null => false
    t.string  "primer_nombre",       :limit => 20,                    :null => false
    t.string  "segundo_nombre",      :limit => 20
    t.string  "primer_apellido",     :limit => 20,                    :null => false
    t.string  "segundo_apellido",    :limit => 20
    t.boolean "sexo"
    t.date    "fecha_nacimiento"
    t.string  "telefono_habitacion", :limit => 12
    t.string  "telefono_celular",    :limit => 12
    t.string  "correo_electronico",  :limit => 50
    t.integer "estado_id",                                            :null => false
    t.integer "municipio_id",                                         :null => false
    t.integer "parroquia_id",                                         :null => false
    t.string  "direccion",           :limit => 300
    t.string  "estado_civil",        :limit => 1
    t.boolean "posee_vehiculo"
    t.string  "marca_vehiculo",      :limit => 20
    t.string  "modelo_vehiculo",     :limit => 20
    t.string  "ano_vehiculo",        :limit => 4
    t.string  "placa_vehiculo",      :limit => 10
    t.integer "profesion_id",                                         :null => false
    t.boolean "activo",                             :default => true
    t.integer "edad"
    t.integer "codigo"
    t.integer "cantidad_visitas",                   :default => 0,    :null => false
    t.string  "tipo_vehiculo",       :limit => 30
    t.string  "tipo_vehiculo_otro",  :limit => 45
    t.integer "carga_trabajo",                      :default => 0
  end

  create_table "telecobranzas", :force => true do |t|
    t.integer "gestion_cobranzas_id",                                   :null => false
    t.integer "direccion_id",                                           :null => false
    t.integer "telefono_id",                                            :null => false
    t.boolean "senal_compromiso",                    :default => false, :null => false
    t.integer "motivos_atraso_id"
    t.integer "persona_atendio_id"
    t.integer "llamada_infructuosa_id",                                 :null => false
    t.string  "estatus",                :limit => 1,                    :null => false
    t.text    "observacion"
  end

  create_table "tenencia_unidad_produccion", :force => true do |t|
    t.string "nombre", :limit => 100, :null => false
  end

  create_table "tipo_arte_pesca", :force => true do |t|
    t.string  "grupo",       :limit => 100,                   :null => false
    t.string  "tipo",        :limit => 100,                   :null => false
    t.string  "descripcion", :limit => 250,                   :null => false
    t.boolean "activo",                     :default => true, :null => false
  end

  add_index "tipo_arte_pesca", ["tipo"], :name => "tipo_arte_pesca_uk", :unique => true

  create_table "tipo_cartera", :force => true do |t|
    t.string "nombre", :limit => 50
  end

  create_table "tipo_cliente", :force => true do |t|
    t.string  "nombre",        :limit => 40,                    :null => false
    t.string  "descripcion",   :limit => 300
    t.boolean "activo",                       :default => true
    t.string  "clasificacion", :limit => 1
    t.integer "codigo_d3"
  end

  add_index "tipo_cliente", ["nombre"], :name => "tipo_cliente_uq_nombre", :unique => true

  create_table "tipo_cliente_tasa", :force => true do |t|
    t.integer "tipo_cliente_id"
    t.integer "tasa_id"
    t.boolean "activo",          :default => true
  end

  create_table "tipo_comunidad", :force => true do |t|
    t.string  "descripcion", :limit => 25, :null => false
    t.boolean "activo",                    :null => false
  end

  create_table "tipo_credito", :id => false, :force => true do |t|
    t.integer "id",                                           :null => false
    t.string  "nombre",      :limit => 40,                    :null => false
    t.string  "descripcion", :limit => 300
    t.boolean "activo",                     :default => true
  end

  add_index "tipo_credito", ["nombre"], :name => "tipo_credito_uq_nombre", :unique => true

  create_table "tipo_cultivo_acuicultura", :force => true do |t|
    t.text    "nombre",                        :null => false
    t.text    "descripcion",                   :null => false
    t.boolean "activo",      :default => true, :null => false
  end

  create_table "tipo_documento", :force => true do |t|
    t.string  "tipo",        :limit => 100,                   :null => false
    t.string  "descripcion", :limit => 250,                   :null => false
    t.boolean "activo",                     :default => true
  end

  add_index "tipo_documento", ["tipo"], :name => "tipo_documento_uq_tipo", :unique => true

  create_table "tipo_drenaje", :force => true do |t|
    t.text    "nombre",      :null => false
    t.text    "descripcion", :null => false
    t.boolean "activo",      :null => false
  end

  create_table "tipo_embarcacion", :force => true do |t|
    t.string  "tipo",        :limit => 100,                   :null => false
    t.string  "descripcion", :limit => 250,                   :null => false
    t.boolean "activo",                     :default => true, :null => false
  end

  add_index "tipo_embarcacion", ["tipo"], :name => "tipo_embarcacion_uk", :unique => true

  create_table "tipo_empresa", :force => true do |t|
    t.string "descripcion", :limit => 100, :null => false
  end

  create_table "tipo_equipo_seguridad", :force => true do |t|
    t.string  "tipo",        :limit => 100,                   :null => false
    t.string  "descripcion", :limit => 250,                   :null => false
    t.boolean "activo",                     :default => true, :null => false
  end

  add_index "tipo_equipo_seguridad", ["tipo"], :name => "tipo_equipo_seguridad_uk", :unique => true

  create_table "tipo_especie_acuicultura", :force => true do |t|
    t.text    "nombre",                        :null => false
    t.text    "descripcion",                   :null => false
    t.boolean "activo",      :default => true, :null => false
  end

  create_table "tipo_estacion", :force => true do |t|
    t.string "nombre",      :limit => 50,  :null => false
    t.string "descripcion", :limit => 300, :null => false
  end

  create_table "tipo_explotacion", :force => true do |t|
    t.string "nombre", :limit => 100, :null => false
  end

  create_table "tipo_fuente_agua", :force => true do |t|
    t.text    "nombre",                        :null => false
    t.text    "descripcion",                   :null => false
    t.boolean "activo",      :default => true
  end

  create_table "tipo_garantia", :force => true do |t|
    t.string  "nombre",      :limit => 40,                    :null => false
    t.string  "descripcion", :limit => 300,                   :null => false
    t.boolean "activo",                     :default => true
    t.string  "tipo",        :limit => 1
  end

  add_index "tipo_garantia", ["nombre"], :name => "tipo_garantia_uq_nombre", :unique => true

  create_table "tipo_gasto", :force => true do |t|
    t.string  "nombre",      :limit => 40,                    :null => false
    t.string  "descripcion", :limit => 300,                   :null => false
    t.boolean "activo",                     :default => true
  end

  add_index "tipo_gasto", ["nombre"], :name => "tipo_gasto_uq_nombre", :unique => true

  create_table "tipo_gestion_cobranza", :force => true do |t|
    t.text    "descripcion",                   :null => false
    t.boolean "activo",      :default => true, :null => false
  end

  create_table "tipo_infraestructura", :force => true do |t|
    t.text    "nombre",                        :null => false
    t.text    "descripcion",                   :null => false
    t.boolean "activo",      :default => true, :null => false
  end

  create_table "tipo_iniciativa", :force => true do |t|
    t.string "nombre", :limit => 100, :null => false
  end

  create_table "tipo_inmueble", :force => true do |t|
    t.boolean "activo",                    :null => false
    t.string  "descripcion", :limit => 20
  end

  create_table "tipo_maquinaria", :force => true do |t|
    t.string  "nombre",      :limit => 100, :null => false
    t.string  "descripcion"
    t.boolean "activo",                     :null => false
  end

  create_table "tipo_material", :force => true do |t|
    t.string  "tipo",        :limit => 100,                   :null => false
    t.string  "descripcion", :limit => 250,                   :null => false
    t.boolean "activo",                     :default => true, :null => false
  end

  add_index "tipo_material", ["tipo"], :name => "tipo_material_uk", :unique => true

  create_table "tipo_motor", :force => true do |t|
    t.string  "tipo",        :limit => 100,                   :null => false
    t.string  "descripcion", :limit => 250,                   :null => false
    t.boolean "activo",                     :default => true, :null => false
  end

  add_index "tipo_motor", ["tipo"], :name => "tipo_motor_uk", :unique => true

  create_table "tipo_movimiento_fideicomiso", :force => true do |t|
    t.integer "tipo_nota",                                          :null => false
    t.string  "modo_nota",          :limit => 3,                    :null => false
    t.text    "motivo",                                             :null => false
    t.boolean "sub_cuenta_banco",                :default => false
    t.boolean "sub_cuenta_insumos",              :default => false
    t.boolean "sub_cuenta_gastos",               :default => false
    t.boolean "sub_cuenta_sras",                 :default => false
    t.boolean "comision",                        :default => false
    t.boolean "disponible"
    t.integer "afecta_banco"
    t.integer "afecta_insumos"
    t.integer "afecta_gastos"
    t.integer "afecta_sras"
  end

  create_table "tipo_nylon", :force => true do |t|
    t.string  "tipo",        :limit => 100,                   :null => false
    t.string  "descripcion", :limit => 250,                   :null => false
    t.boolean "activo",                     :default => true, :null => false
  end

  add_index "tipo_nylon", ["tipo"], :name => "tipo_nylon_uk", :unique => true

  create_table "tipo_ordeno", :force => true do |t|
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion"
    t.boolean "activo",                     :default => true, :null => false
  end

  add_index "tipo_ordeno", ["nombre"], :name => "tipo_ordeno_uq_nombre", :unique => true

  create_table "tipo_pasto", :force => true do |t|
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion"
    t.boolean "activo",                     :default => true
  end

  add_index "tipo_pasto", ["nombre"], :name => "tipo_pasto_uq_nombre", :unique => true

  create_table "tipo_pasto_forraje", :force => true do |t|
    t.string "descripcion", :limit => 30
  end

  create_table "tipo_perdida", :force => true do |t|
    t.string  "nombre",      :limit => 100,                   :null => false
    t.string  "descripcion"
    t.boolean "activo",                     :default => true, :null => false
  end

  add_index "tipo_perdida", ["nombre"], :name => "ix_tipo_perdida", :unique => true

  create_table "tipo_riego", :force => true do |t|
    t.text    "nombre",      :null => false
    t.text    "descripcion", :null => false
    t.boolean "activo",      :null => false
  end

  create_table "tipo_sistema_acuicultura", :force => true do |t|
    t.text    "nombre",                        :null => false
    t.text    "descripcion",                   :null => false
    t.boolean "activo",      :default => true, :null => false
  end

  create_table "tipo_suelo", :force => true do |t|
    t.text    "nombre",                        :null => false
    t.text    "descripcion",                   :null => false
    t.boolean "activo",      :default => true
  end

  create_table "tipo_topografia", :force => true do |t|
    t.text    "nombre",                        :null => false
    t.text    "descripcion",                   :null => false
    t.boolean "activo",      :default => true
  end

  create_table "tipo_vialidad", :force => true do |t|
    t.text    "nombre",                        :null => false
    t.text    "descripcion",                   :null => false
    t.boolean "activo",      :default => true
  end

  create_table "tipos_semovientes", :force => true do |t|
    t.string "nombre", :limit => 100
  end

  create_table "tr_asiento_contable", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "comprobante_contable_id"
    t.float   "monto"
    t.string  "tipo",                     :limit => 1
    t.string  "codigo_contable",          :limit => 25
    t.string  "auxiliar_contable",        :limit => 20
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_boleta_arrime", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "solicitud_id"
    t.integer "silo_id"
    t.integer "cliente_id"
    t.integer "rubro_id"
    t.time    "hora_registro"
    t.string  "placa_vehiculo",              :limit => 15
    t.string  "letra_cedula_conductor",      :limit => 1
    t.integer "cedula_conductor"
    t.string  "nombre_conductor",            :limit => 100
    t.string  "numero_ticket",               :limit => 15
    t.string  "guia_movilizacion",           :limit => 20
    t.string  "numero_acta",                 :limit => 20
    t.text    "causa"
    t.string  "clase",                       :limit => 1
    t.string  "resultado",                   :limit => 30
    t.integer "tecnico_campo_id"
    t.date    "fecha_entrada"
    t.date    "fecha_salida"
    t.decimal "valor_total_entrada",                        :precision => 16, :scale => 2
    t.decimal "valor_total_salida",                         :precision => 16, :scale => 2
    t.decimal "peso_neto",                                  :precision => 16, :scale => 2
    t.decimal "peso_acondicionado",                         :precision => 16, :scale => 2
    t.boolean "confirmacion"
    t.date    "fecha_confirmacion"
    t.decimal "peso_vehiculo",                              :precision => 16, :scale => 2
    t.decimal "peso_remolque",                              :precision => 16, :scale => 2
    t.decimal "peso_vehiculo_salida",                       :precision => 16, :scale => 2
    t.decimal "peso_remolque_salida",                       :precision => 16, :scale => 2
    t.integer "usuario_id"
    t.string  "estatus",                     :limit => 1
    t.date    "fecha_decision"
    t.string  "nro_acta_rechazo",            :limit => 15
    t.string  "causa_rechazo"
    t.boolean "arrime_conjunto"
    t.decimal "valor_arrime",                               :precision => 16, :scale => 2
    t.decimal "peso_acondicionado_liquidar",                :precision => 16, :scale => 2
    t.integer "detalle_precio_gaceta_id"
    t.boolean "conjunto_verificado"
    t.integer "sub_rubro_id"
    t.integer "actividad_id"
    t.integer "ciclo_productivo_id"
    t.time    "hora_entrada_silo"
    t.time    "hora_entrada_peso"
    t.time    "hora_salida_peso"
    t.decimal "peso_tara",                                  :precision => 16, :scale => 2
    t.decimal "peso_bruto",                                 :precision => 16, :scale => 2
    t.integer "secos"
    t.decimal "total_secos",                                :precision => 16, :scale => 2
    t.decimal "total_kg",                                   :precision => 16, :scale => 2
    t.integer "condicion_saco_id"
    t.integer "mojados"
    t.decimal "total_mojados",                              :precision => 16, :scale => 2
    t.integer "total_sacos"
    t.decimal "peso_ajustado",                              :precision => 16, :scale => 2
    t.decimal "porcentaje_aplicado_seco",                   :precision => 16, :scale => 2
    t.decimal "porcentaje_aplicado_mojado",                 :precision => 16, :scale => 2
    t.integer "acta_silo_id"
    t.integer "humedos"
    t.decimal "total_humedos",                              :precision => 16, :scale => 2
    t.decimal "porcentaje_aplicado_humedo",                 :precision => 16, :scale => 2
    t.integer "detalle_convenio_silo_id"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",                  :limit => 1
  end

  create_table "tr_comprobante_contable", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.date    "fecha_registro"
    t.date    "fecha_comprobante"
    t.date    "fecha_envio"
    t.boolean "enviado"
    t.integer "numero_lote_envio"
    t.float   "total_debe"
    t.float   "total_haber"
    t.integer "numero_contabilidad"
    t.integer "unidad_asiento"
    t.integer "prestamo_id"
    t.integer "factura_id"
    t.integer "anio"
    t.integer "transaccion_id"
    t.boolean "reversado"
    t.boolean "reverso"
    t.integer "comprobante_reverso_id"
    t.integer "comprobante_reversado_id"
    t.text    "referencia"
    t.string  "estatus",                  :limit => 1
    t.integer "transaccion_contable_id"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_compromiso_pago", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "telecobranzas_id"
    t.integer "prestamo_id"
    t.date    "fecha_pago"
    t.date    "fecha_limite_pago"
    t.decimal "monto_pago",                            :precision => 16, :scale => 2
    t.string  "estatus",                  :limit => 1
    t.text    "observacion"
    t.decimal "monto_efectivamente_pago",              :precision => 16, :scale => 2
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_control_envio_desembolso", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.date    "fecha"
    t.string  "archivo",                  :limit => 100
    t.integer "numero_procesado"
    t.decimal "monto_procesado",                         :precision => 16, :scale => 2
    t.integer "entidad_financiera_id"
    t.integer "estatus"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_desembolso", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "numero"
    t.integer "prestamo_id"
    t.integer "solicitud_id"
    t.string  "modalidad",                :limit => 1
    t.float   "monto"
    t.date    "fecha_valor"
    t.date    "fecha_envio"
    t.date    "fecha_recepcion"
    t.integer "entidad_financiera_id"
    t.string  "tipo_cuenta",              :limit => 1
    t.string  "numero_cuenta",            :limit => 20
    t.boolean "realizado"
    t.integer "usuario_id"
    t.integer "seguimiento_visita_id"
    t.text    "observacion"
    t.string  "tipo_cheque",              :limit => 1
    t.string  "referencia",               :limit => 30
    t.boolean "confirmado"
    t.date    "fecha_registro"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_factura", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "numero"
    t.date    "fecha"
    t.date    "fecha_realizacion"
    t.date    "fecha_contable"
    t.integer "pago_cliente_id"
    t.integer "desembolso_id"
    t.integer "prestamo_id"
    t.string  "tipo",                     :limit => 1
    t.decimal "monto",                                  :precision => 16, :scale => 2
    t.boolean "proceso_nocturno"
    t.integer "prestamo_modificacion_id"
    t.decimal "remanente_por_aplicar",                  :precision => 16, :scale => 2
    t.string  "analista",                 :limit => 50
    t.text    "comentario_analista"
    t.string  "estado",                   :limit => 20
    t.string  "sector_economico",         :limit => 50
    t.string  "distincion_cobranza",      :limit => 3
    t.string  "codigo_contable",          :limit => 10
    t.boolean "consultoria_juridica"
    t.string  "estado_geografico",        :limit => 20
    t.decimal "abono_capital",                          :precision => 16, :scale => 2
    t.integer "tipo_cartera_id"
    t.boolean "recuperaciones"
    t.decimal "pago_capital",                           :precision => 16, :scale => 2
    t.decimal "pago_interes",                           :precision => 16, :scale => 2
    t.decimal "pago_mora",                              :precision => 16, :scale => 2
    t.decimal "monto_banco",                            :precision => 16, :scale => 2
    t.decimal "monto_sras",                             :precision => 16, :scale => 2
    t.decimal "monto_insumos",                          :precision => 16, :scale => 2
    t.decimal "monto_inventario",                       :precision => 16, :scale => 2
    t.decimal "monto_gastos",                           :precision => 16, :scale => 2
    t.boolean "pago_al_dia"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_factura_orden_despacho", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "orden_despacho_detalle_id"
    t.string  "item_nombre",                 :limit => 100
    t.integer "unidad_medida_id"
    t.decimal "cantidad",                                   :precision => 16, :scale => 2
    t.decimal "costo_real",                                 :precision => 16, :scale => 2
    t.decimal "monto_financiamiento",                       :precision => 16, :scale => 2
    t.integer "casa_proveedora_id"
    t.integer "sucursal_casa_proveedora_id"
    t.string  "numero_factura",              :limit => 20
    t.decimal "monto_factura",                              :precision => 16, :scale => 2
    t.decimal "cantidad_factura",                           :precision => 16, :scale => 2
    t.date    "fecha_factura"
    t.date    "fecha_emision"
    t.boolean "confirmada"
    t.string  "secuencia",                   :limit => 100
    t.boolean "emitida"
    t.integer "factura_estatus_id"
    t.text    "observacion"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",                  :limit => 1
  end

  create_table "tr_orden_despacho", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "solicitud_id"
    t.integer "seguimiento_visita_id"
    t.integer "prestamo_id"
    t.string  "numero",                   :limit => 32
    t.integer "estatus_id"
    t.decimal "monto",                                  :precision => 16, :scale => 2
    t.text    "observacion"
    t.integer "estado_id"
    t.integer "usuario_id"
    t.date    "fecha_orden_despacho"
    t.date    "fecha_cierre"
    t.boolean "realizado"
    t.date    "fecha_liquidacion"
    t.string  "tipo_pago",                :limit => 1
    t.text    "observacion_cerrado"
    t.integer "casa_proveedora_id"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_orden_despacho_detalle", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "orden_despacho_id"
    t.string  "item_nombre",              :limit => 100
    t.integer "unidad_medida_id"
    t.decimal "cantidad",                                :precision => 16, :scale => 2
    t.decimal "costo_real",                              :precision => 16, :scale => 2
    t.decimal "monto_financiamiento",                    :precision => 16, :scale => 2
    t.decimal "monto_facturacion",                       :precision => 16, :scale => 2
    t.decimal "cantidad_facturacion",                    :precision => 16, :scale => 2
    t.text    "observacion"
    t.integer "plan_inversion_id"
    t.decimal "monto_recomendado",                       :precision => 16, :scale => 3
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_pago_cliente", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.date    "fecha"
    t.string  "modalidad",                :limit => 1
    t.float   "monto"
    t.integer "cliente_id"
    t.integer "oficina_id"
    t.boolean "reversado"
    t.date    "fecha_contable"
    t.date    "fecha_realizacion"
    t.string  "numero_voucher",           :limit => 20
    t.decimal "efectivo",                               :precision => 16, :scale => 2
    t.integer "entidad_financiera_id"
    t.integer "cuenta_bcv_id"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_pago_cuota", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "plan_pago_cuota_id"
    t.integer "pago_prestamo_id"
    t.decimal "monto",                                   :precision => 16, :scale => 2
    t.boolean "aplicado"
    t.decimal "interes_corriente",                       :precision => 16, :scale => 2
    t.decimal "interes_diferido",                        :precision => 16, :scale => 2
    t.decimal "interes_mora",                            :precision => 16, :scale => 2
    t.decimal "capital",                                 :precision => 16, :scale => 2
    t.decimal "remanente_por_aplicar",                   :precision => 16, :scale => 2
    t.decimal "interes_desembolso",                      :precision => 16, :scale => 2
    t.decimal "cuota_extra",                             :precision => 16, :scale => 2
    t.string  "estatus_pago",             :limit => nil
    t.date    "fecha_vencimiento"
    t.date    "fecha_pago"
    t.integer "dias_atraso"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_pago_prestamo", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.decimal "monto",                                   :precision => 16, :scale => 2
    t.integer "prestamo_id"
    t.decimal "interes_corriente",                       :precision => 16, :scale => 2
    t.decimal "interes_diferido",                        :precision => 16, :scale => 2
    t.decimal "interes_mora",                            :precision => 16, :scale => 2
    t.decimal "capital",                                 :precision => 16, :scale => 2
    t.integer "pago_cliente_id"
    t.decimal "remanente_por_aplicar",                   :precision => 16, :scale => 2
    t.decimal "interes_desembolso",                      :precision => 16, :scale => 2
    t.decimal "interes_causado",                         :precision => 16, :scale => 2
    t.decimal "saldo_insoluto",                          :precision => 16, :scale => 2
    t.text    "observacion_precancelacion"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",                 :limit => 1
  end

  create_table "tr_pagos_compromiso", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "compromiso_pago_id"
    t.integer "pago_cliente_id"
    t.integer "pago_prestamo_id"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_performance_cobranzas", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "prestamo_id"
    t.integer "cliente_id"
    t.integer "cantidad_intentos"
    t.integer "cantidad_contactos"
    t.integer "cantidad_contactos_exitosos"
    t.integer "cantidad_promesas_pago"
    t.integer "cantidad_promesas_cumplidas"
    t.integer "cantidad_promesas_cumplidas_parcialmente"
    t.integer "cantidad_promesas_incumplidas"
    t.decimal "porcentaje_contactos",                                         :precision => 5, :scale => 2
    t.decimal "porcentaje_contactos_exitosos",                                :precision => 5, :scale => 2
    t.decimal "porcentaje_promesas_pago",                                     :precision => 5, :scale => 2
    t.decimal "porcentaje_promesas_pago_cumplidas",                           :precision => 5, :scale => 2
    t.decimal "porcentaje_promesas_pago_incumplidas",                         :precision => 5, :scale => 2
    t.decimal "porcentaje_promesas_pago_parcialmente_cumplidas",              :precision => 5, :scale => 2
    t.integer "cantidad_email_enviados"
    t.integer "cantidad_sms_enviados"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",                                      :limit => 1
  end

  create_table "tr_plan_inversion", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "solicitud_id"
    t.string  "estado_nombre",            :limit => 100
    t.string  "oficina_nombre",           :limit => 100
    t.string  "sector_nombre",            :limit => 100
    t.string  "sub_sector_nombre",        :limit => 100
    t.string  "rubro_nombre",             :limit => 100
    t.string  "partida_nombre",           :limit => 100
    t.string  "item_nombre",              :limit => 100
    t.integer "unidad_medida_id"
    t.integer "numero_desembolso"
    t.decimal "costo_real",                              :precision => 16, :scale => 2
    t.decimal "cantidad",                                :precision => 16, :scale => 3
    t.decimal "monto_financiamiento",                    :precision => 16, :scale => 2
    t.decimal "monto_desembolsado",                      :precision => 16, :scale => 2
    t.string  "seriales",                 :limit => nil
    t.string  "marcas",                   :limit => nil
    t.string  "tipo_item",                :limit => 1
    t.decimal "cantidad_por_hectarea",                   :precision => 16, :scale => 2
    t.decimal "costo_minimo",                            :precision => 16, :scale => 2
    t.decimal "costo_maximo",                            :precision => 16, :scale => 2
    t.decimal "cantidad_liquidada",                      :precision => 16, :scale => 2
    t.string  "sub_rubro_nombre",         :limit => 100
    t.string  "actividad_nombre",         :limit => 100
    t.boolean "inventario"
    t.string  "serial_motor",             :limit => 50
    t.string  "serial_chasis",            :limit => 50
    t.integer "casa_proveedora_id"
    t.string  "moneda",                   :limit => 5
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_plan_pago", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.date    "fecha_inicio"
    t.date    "fecha_fin"
    t.integer "prestamo_id"
    t.boolean "activo"
    t.boolean "proyeccion"
    t.integer "plazo",                        :limit => 2
    t.float   "tasa"
    t.decimal "monto",                                     :precision => 16, :scale => 2
    t.integer "meses_gracia",                 :limit => 2
    t.integer "meses_muertos",                :limit => 2
    t.boolean "diferir_intereses"
    t.boolean "exonerar_intereses_diferidos"
    t.float   "tasa_gracia"
    t.integer "frecuencia_pago",              :limit => 2
    t.integer "frecuencia_pago_gracia",       :limit => 2
    t.integer "dia_facturacion",              :limit => 2
    t.date    "fecha_evento"
    t.string  "motivo_evento",                :limit => 1
    t.boolean "migrado_d3"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",                   :limit => 1
  end

  create_table "tr_plan_pago_cuota", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "plan_pago_id"
    t.date    "fecha"
    t.integer "numero",                           :limit => 2
    t.decimal "valor_cuota",                                   :precision => 16, :scale => 2
    t.decimal "amortizado",                                    :precision => 16, :scale => 2
    t.decimal "amortizado_acumulado",                          :precision => 16, :scale => 2
    t.decimal "interes_corriente",                             :precision => 16, :scale => 2
    t.decimal "interes_corriente_acumulado",                   :precision => 16, :scale => 2
    t.decimal "interes_diferido",                              :precision => 16, :scale => 2
    t.decimal "interes_mora",                                  :precision => 16, :scale => 2
    t.decimal "saldo_insoluto",                                :precision => 16, :scale => 2
    t.float   "tasa_periodo"
    t.string  "tipo_cuota",                       :limit => 1
    t.boolean "vencida"
    t.string  "estatus_pago",                     :limit => 1
    t.date    "fecha_ultimo_pago"
    t.decimal "pago_interes_mora",                             :precision => 16, :scale => 2
    t.decimal "pago_interes_corriente",                        :precision => 16, :scale => 2
    t.decimal "pago_interes_diferido",                         :precision => 16, :scale => 2
    t.decimal "pago_interes_corriente_acumulado",              :precision => 16, :scale => 2
    t.decimal "pago_capital",                                  :precision => 16, :scale => 2
    t.decimal "remanente_por_aplicar",                         :precision => 16, :scale => 2
    t.decimal "causado_no_devengado",                          :precision => 16, :scale => 2
    t.boolean "desembolso"
    t.boolean "cambio_tasa"
    t.boolean "abono_extraordinario"
    t.decimal "monto_desembolso",                              :precision => 16, :scale => 2
    t.decimal "monto_abono",                                   :precision => 16, :scale => 2
    t.integer "dias_mora",                        :limit => 2
    t.float   "tasa_nominal_anual"
    t.decimal "interes_desembolso",                            :precision => 16, :scale => 2
    t.integer "cantidad_dias",                    :limit => 2
    t.decimal "pago_interes_desembolso",                       :precision => 16, :scale => 2
    t.boolean "cancelacion_prestamo"
    t.boolean "reclasificada"
    t.decimal "intereses_por_cobrar_al_30",                    :precision => 16, :scale => 2
    t.decimal "mora_exonerada",                                :precision => 16, :scale => 2
    t.boolean "migrado_d3"
    t.boolean "bolivar_fuerte"
    t.date    "fecha_ultima_mora"
    t.decimal "interes_ord_devengado_mes",                     :precision => 16, :scale => 2
    t.date    "fecha_ord_devengado"
    t.decimal "interes_ord_devengado_acum",                    :precision => 16, :scale => 2
    t.decimal "ajuste_devengo",                                :precision => 16, :scale => 2
    t.decimal "pago_total_cliente",                            :precision => 16, :scale => 2
    t.decimal "cuota_extra",                                   :precision => 16, :scale => 2
    t.decimal "pago_cuota_extra",                              :precision => 16, :scale => 2
    t.decimal "interes_dif_devengado_mes",                     :precision => 16, :scale => 2
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",                       :limit => 1
  end

  create_table "tr_prestamo", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "numero",                                     :limit => 8
    t.decimal "monto_solicitado",                                         :precision => 16, :scale => 2
    t.decimal "monto_aprobado",                                           :precision => 16, :scale => 2
    t.date    "fecha_aprobacion"
    t.integer "formula_id"
    t.boolean "tasa_fija"
    t.integer "tasa_id"
    t.float   "diferencial_tasa"
    t.float   "tasa_referencia_inicial"
    t.integer "plazo",                                      :limit => 2
    t.integer "meses_fijos_sin_cambio_tasa",                :limit => 2
    t.boolean "meses_gracia_si"
    t.integer "meses_gracia",                               :limit => 2
    t.boolean "meses_muertos_si"
    t.integer "meses_muertos",                              :limit => 2
    t.integer "cliente_id"
    t.integer "tipo_credito_id"
    t.integer "oficina_id"
    t.integer "solicitud_id"
    t.string  "estatus",                                    :limit => 1
    t.integer "tasa_mora_id"
    t.string  "forma_calculo_intereses",                    :limit => 1
    t.integer "base_calculo_intereses"
    t.boolean "permitir_abonos"
    t.string  "abono_forma",                                :limit => 1
    t.float   "abono_porcentaje"
    t.integer "abono_cantidad_cuotas",                      :limit => 2
    t.float   "abono_monto_minimo"
    t.integer "abono_lapso_minimo",                         :limit => 2
    t.float   "abono_dias_vencimiento"
    t.boolean "exonerar_intereses_mora"
    t.string  "base_cobro_mora",                            :limit => 1
    t.boolean "diferir_intereses"
    t.boolean "exonerar_intereses_diferidos"
    t.integer "frecuencia_pago",                            :limit => 2
    t.float   "tasa_valor"
    t.boolean "exonerar_intereses"
    t.integer "numero_veces_mora",                          :limit => 2
    t.date    "fecha_cambio_estatus"
    t.float   "tasa_inicial"
    t.float   "tasa_vigente"
    t.integer "dia_facturacion",                            :limit => 2
    t.string  "estatus_desembolso",                         :limit => 1
    t.decimal "saldo_insoluto",                                           :precision => 16, :scale => 2
    t.decimal "interes_vencido",                                          :precision => 16, :scale => 2
    t.integer "dias_mora",                                  :limit => 2
    t.decimal "monto_mora",                                               :precision => 16, :scale => 2
    t.decimal "causado_no_devengado",                                     :precision => 16, :scale => 2
    t.decimal "interes_diferido_vencido",                                 :precision => 16, :scale => 2
    t.decimal "remanente_por_aplicar",                                    :precision => 16, :scale => 2
    t.integer "cantidad_cuotas_vencidas",                   :limit => 2
    t.decimal "monto_cuotas_vencidas",                                    :precision => 16, :scale => 2
    t.decimal "deuda",                                                    :precision => 16, :scale => 2
    t.decimal "exigible",                                                 :precision => 16, :scale => 2
    t.decimal "capital_vencido",                                          :precision => 16, :scale => 2
    t.date    "fecha_revision_tasa"
    t.float   "porcentaje_riesgo_foncrei"
    t.float   "porcentaje_riesgo_intermediario"
    t.float   "porcentaje_tasa_foncrei"
    t.float   "porcentaje_tasa_intermediario"
    t.integer "frecuencia_pago_intermediario",              :limit => 2
    t.boolean "intermediado"
    t.integer "entidad_financiera_id"
    t.decimal "interes_desembolso_vencido",                               :precision => 16, :scale => 2
    t.string  "destinatario",                               :limit => 1
    t.date    "fecha_cobranza_intermediario"
    t.boolean "tasa_cero"
    t.decimal "monto_liquidado",                                          :precision => 16, :scale => 2
    t.date    "fecha_liquidacion"
    t.boolean "liberada"
    t.string  "causa_liberacion",                           :limit => 1
    t.decimal "aumento_capital",                                          :precision => 16, :scale => 2
    t.string  "reestructurado",                             :limit => 1
    t.integer "prestamo_origen_id"
    t.integer "prestamo_destino_id"
    t.float   "traslado_origen"
    t.float   "traslado_destino"
    t.boolean "tasa_forzada"
    t.date    "tasa_forzada_fecha_vigencia"
    t.float   "tasa_forzada_monto"
    t.date    "fecha_inicio"
    t.date    "fecha_ultimo_cierre"
    t.boolean "migrado_d3"
    t.string  "codigo_d3",                                  :limit => 20
    t.decimal "interes_diferido_por_vencer",                              :precision => 16, :scale => 2
    t.decimal "capital_pago_parcial",                                     :precision => 16, :scale => 2
    t.float   "saldo_capital"
    t.integer "meses_diferidos"
    t.boolean "senal_visita"
    t.integer "numero_d3",                                  :limit => 8
    t.decimal "porcentaje_riesgo_sudeban",                                :precision => 16, :scale => 6
    t.string  "clasificacion_riesgo_sudeban",               :limit => 4
    t.decimal "conversion_cuotas_mensuales_sudeban",                      :precision => 16, :scale => 2
    t.decimal "provision_individual_sudeban",                             :precision => 16, :scale => 2
    t.decimal "porcentaje_riesgo_bandes",                                 :precision => 16, :scale => 6
    t.string  "clasificacion_riesgo_bandes",                :limit => 4
    t.decimal "conversion_cuotas_mensuales_bandes",                       :precision => 16, :scale => 2
    t.decimal "provision_individual_bandes",                              :precision => 16, :scale => 2
    t.date    "fecha_base"
    t.integer "ultimo_desembolso"
    t.string  "codigo_contable",                            :limit => 6
    t.string  "banco_origen",                               :limit => 25
    t.integer "tipo_cartera_id"
    t.decimal "abono_capital",                                            :precision => 16, :scale => 2
    t.integer "dias_demorado"
    t.integer "dias_vencido"
    t.integer "dias_vigente"
    t.integer "cuotas_pagadas"
    t.integer "cuotas_pendientes"
    t.integer "cuotas_especiales_pagadas"
    t.integer "cuotas_especiales_vencidas"
    t.integer "cuotas_especiales_pendientes"
    t.decimal "capital_pagado",                                           :precision => 14, :scale => 2
    t.decimal "capital_por_pagar",                                        :precision => 14, :scale => 2
    t.decimal "intereses_pagados",                                        :precision => 16, :scale => 2
    t.decimal "mora_pagada",                                              :precision => 16, :scale => 2
    t.boolean "tipo_diferimiento"
    t.decimal "porcentaje_diferimiento",                                  :precision => 5,  :scale => 2
    t.boolean "consolidar_deuda"
    t.decimal "pago_mora_migracion",                                      :precision => 16, :scale => 2
    t.integer "cuotas_pagadas_migracion"
    t.decimal "monto_banco",                                              :precision => 16, :scale => 2
    t.decimal "monto_insumos",                                            :precision => 16, :scale => 2
    t.date    "fecha_vencimiento"
    t.decimal "monto_cuota",                                              :precision => 16, :scale => 2
    t.decimal "monto_cuota_gracia",                                       :precision => 16, :scale => 2
    t.integer "rubro_id"
    t.integer "producto_id"
    t.decimal "monto_sras_primer_ano",                                    :precision => 16, :scale => 2
    t.decimal "monto_sras_anos_subsiguientes",                            :precision => 16, :scale => 2
    t.decimal "monto_sras_total",                                         :precision => 16, :scale => 2
    t.decimal "monto_facturado",                                          :precision => 16, :scale => 2
    t.decimal "monto_despachado",                                         :precision => 16, :scale => 2
    t.date    "fecha_instruccion_pago"
    t.boolean "instruccion_pago"
    t.decimal "monto_inventario",                                         :precision => 16, :scale => 2
    t.decimal "monto_liquidado_insumos",                                  :precision => 16, :scale => 2
    t.integer "sub_rubro_id"
    t.integer "actividad_id"
    t.decimal "monto_gasto_total",                                        :precision => 16, :scale => 2
    t.integer "moneda_id"
    t.integer "cantidad_veces_mora"
    t.integer "cantidad_veces_vigente"
    t.integer "cantidad_dias_mora_acumulados"
    t.integer "cantidad_compromisos_incumplidos"
    t.integer "empresa_cobranza_id"
    t.decimal "tasa_conversion",                                          :precision => 16, :scale => 2
    t.date    "fecha_tasa_conversion"
    t.decimal "valor_moneda_nacional",                                    :precision => 16, :scale => 2
    t.decimal "porcentaje_veces_mora",                                    :precision => 5,  :scale => 2
    t.decimal "porcentaje_dias_mora",                                     :precision => 5,  :scale => 2
    t.decimal "indice_morosidad",                                         :precision => 5,  :scale => 2
    t.decimal "porcentaje_recuperacion_real_capital",                     :precision => 5,  :scale => 2
    t.decimal "porcentaje_recuperacion_esperada_capital",                 :precision => 5,  :scale => 2
    t.decimal "capital_cuotas_fecha",                                     :precision => 16, :scale => 2
    t.decimal "desviacion_recuperacion_capital",                          :precision => 5,  :scale => 2
    t.integer "dias_atraso_promedio"
    t.decimal "porcentaje_recuperacion_real_intereses",                   :precision => 5,  :scale => 2
    t.decimal "total_interes",                                            :precision => 16, :scale => 2
    t.decimal "porcentaje_recuperacion_esperado_intereses",               :precision => 5,  :scale => 2
    t.decimal "interes_cuota_fecha",                                      :precision => 16, :scale => 2
    t.decimal "desviacion_recuperacion_intereses",                        :precision => 5,  :scale => 2
    t.decimal "porcentaje_pagos_incumplidos",                             :precision => 5,  :scale => 2
    t.integer "analista_cobranzas_id"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",                                 :limit => 1
  end

  create_table "tr_prestamo_tasa_historico", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.float   "tasa_cliente"
    t.integer "prestamo_id"
    t.integer "tasa_id"
    t.date    "fecha"
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_presupuesto_pidan", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.integer "rubro_id"
    t.decimal "disponibilidad",                        :precision => 16, :scale => 2
    t.integer "estado_id"
    t.decimal "presupuesto",                           :precision => 16, :scale => 2
    t.decimal "compromiso",                            :precision => 16, :scale => 2
    t.integer "sub_rubro_id"
    t.integer "programa_id"
    t.decimal "monto_liquidado",                       :precision => 16, :scale => 2
    t.decimal "monto_por_liquidar",                    :precision => 16, :scale => 2
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "tr_solicitud", :primary_key => "tr_id", :force => true do |t|
    t.integer  "id"
    t.integer  "cliente_id"
    t.integer  "numero"
    t.integer  "programa_id"
    t.date     "fecha_solicitud"
    t.date     "fecha_registro"
    t.float    "monto_solicitado"
    t.float    "monto_aprobado"
    t.string   "nombre_proyecto",                               :limit => 400
    t.string   "objetivo_proyecto",                             :limit => 400
    t.text     "justificacion"
    t.float    "aporte_social"
    t.float    "monto_propuesta_social"
    t.string   "estatus",                                       :limit => 1
    t.string   "numero_comite_estadal",                         :limit => 20
    t.string   "numero_comite_nacional",                        :limit => 15
    t.date     "fecha_comite_estadal"
    t.date     "fecha_comite_nacional"
    t.date     "fecha_solicitud_desembolso"
    t.string   "comentario_directorio",                         :limit => 400
    t.integer  "causa_rechazo_id"
    t.integer  "causa_diferimiento_id"
    t.integer  "parroquia_id"
    t.integer  "ciudad_id"
    t.integer  "municipio_id"
    t.string   "estatus_directorio",                            :limit => 1
    t.boolean  "intermediado"
    t.integer  "modalidad_financiamiento_id"
    t.integer  "origen_fondo_id"
    t.float    "porcentaje_cooperativa"
    t.float    "porcentaje_empresa"
    t.float    "monto_cliente"
    t.boolean  "liberada"
    t.string   "causa_liberacion",                              :limit => 1
    t.float    "aumento_capital"
    t.string   "estatus_comite",                                :limit => 1
    t.string   "estatus_modificacion",                          :limit => 1
    t.string   "estatus_comite_temporal",                       :limit => 1
    t.integer  "causa_diferimiento_comite_id"
    t.boolean  "migrado_d3"
    t.integer  "causa_rechazo_comite_id"
    t.string   "codigo_d3",                                     :limit => 10
    t.string   "codigo_presupuesto_d3",                         :limit => 2
    t.string   "descripcion_presupuesto_d3",                    :limit => 100
    t.string   "tipo_comite",                                   :limit => 1
    t.decimal  "tir",                                                          :precision => 16, :scale => 2
    t.decimal  "van",                                                          :precision => 16, :scale => 2
    t.integer  "tiempo_recuperacion"
    t.integer  "estatus_id"
    t.date     "fecha_actual_estatus"
    t.date     "fecha_firma_contrato"
    t.integer  "cuenta_matriz_id"
    t.integer  "numero_origen"
    t.string   "banco_origen",                                  :limit => 25
    t.string   "transcriptor",                                  :limit => 25
    t.date     "fecha_aprobacion"
    t.date     "fecha_liquidacion"
    t.integer  "ups_id"
    t.string   "observacion",                                   :limit => 250
    t.integer  "numero_grupo"
    t.integer  "numero_empresa"
    t.boolean  "control"
    t.integer  "mision_id"
    t.string   "analista_consejo",                              :limit => 25
    t.integer  "comite_id"
    t.string   "decision_comite",                               :limit => 1
    t.string   "comentario_comite",                             :limit => 400
    t.string   "numero_acta_resumen_comite",                    :limit => 15
    t.integer  "estatus_desembolso_id"
    t.boolean  "control_certificacion"
    t.boolean  "control_disponibilidad"
    t.string   "numero_acta_liquidacion",                       :limit => 15
    t.date     "fecha_acta_liquidacion"
    t.integer  "region_id"
    t.boolean  "certificado_presupuesto"
    t.float    "monto_analista"
    t.integer  "scoring_aceptacion_id"
    t.float    "monto_actuales"
    t.float    "monto_proyecto"
    t.float    "calificacion_cuantitativa"
    t.float    "calificacion_cualitativa"
    t.float    "calificacion_social"
    t.string   "destino_credito",                               :limit => 400
    t.integer  "tipo_iniciativa_id"
    t.string   "usuario_pre_evaluacion",                        :limit => 30
    t.integer  "partida_presupuestaria_id"
    t.boolean  "consultoria"
    t.boolean  "decision_final"
    t.boolean  "confirmacion"
    t.boolean  "avaluo_obra_civil"
    t.string   "usuario_resguardo",                             :limit => 30
    t.integer  "reestructuracion_solicitud_id",                 :limit => 8
    t.decimal  "monto_ampliacion",                                             :precision => 16, :scale => 2
    t.boolean  "no_visto"
    t.integer  "oficina_id"
    t.integer  "unidad_produccion_id"
    t.integer  "sector_id"
    t.integer  "sub_sector_id"
    t.integer  "rubro_id"
    t.integer  "empresa_integrante_id"
    t.boolean  "instancia_comite"
    t.string   "decision_comite_estadal",                       :limit => 1
    t.string   "decision_comite_nacional",                      :limit => 1
    t.integer  "comite_estadal_id"
    t.text     "comentario_comite_estadal"
    t.text     "comentario_comite_nacional"
    t.decimal  "hectareas_recomendadas",                                       :precision => 14, :scale => 3
    t.decimal  "semovientes_recomendados",                                     :precision => 14, :scale => 2
    t.integer  "folio_autenticacion"
    t.integer  "tomo_autenticacion"
    t.integer  "abogado_id"
    t.integer  "codigo_sras",                                   :limit => 8
    t.boolean  "enviado_suscripcion"
    t.text     "ruta_contrato"
    t.text     "ruta_acta_entrega"
    t.text     "ruta_nota_autenticacion"
    t.date     "fecha_nota_autenticacion"
    t.float    "hectareas_solicitadas"
    t.integer  "semovientes_solicitados"
    t.boolean  "por_inventario"
    t.date     "fecha_a_entrega"
    t.boolean  "conf_maquinaria"
    t.integer  "sub_rubro_id"
    t.integer  "actividad_id"
    t.datetime "fecha_hora_revocatoria_anulacion"
    t.integer  "usuario_responsable_revocatoria_anulacion"
    t.text     "justificacion_revocatoria_anulacion"
    t.date     "fecha_aprobacion_oficio_revocatoria_anulacion"
    t.string   "numero_oficio_revocatoria_anulacion",           :limit => 20
    t.integer  "causa_revocatoria_anulacion"
    t.string   "referencia_revocatoria_liquidacion",            :limit => 100
    t.date     "fecha_pago_revocatoria_liquidacion"
    t.integer  "moneda_id"
    t.integer  "tr_transaccion_accion_id"
    t.string   "tr_momento",                                    :limit => 1
  end

  create_table "tr_transaccion_contable", :primary_key => "tr_id", :force => true do |t|
    t.integer "id"
    t.string  "nombre",                   :limit => 50
    t.string  "descripcion",              :limit => 250
    t.integer "tr_transaccion_accion_id"
    t.string  "tr_momento",               :limit => 1
  end

  create_table "transaccion", :force => true do |t|
    t.integer  "meta_transaccion_id"
    t.boolean  "reversada",                                                         :default => false
    t.datetime "fecha",                                                                                :null => false
    t.integer  "usuario_id",                                                                           :null => false
    t.integer  "prestamo_id",                                                                          :null => false
    t.string   "tipo",                :limit => 1,                                  :default => "L"
    t.string   "descripcion",         :limit => 300,                                                   :null => false
    t.decimal  "monto",                              :precision => 16, :scale => 2
  end

  create_table "transaccion_accion", :force => true do |t|
    t.boolean "reverso",                       :default => false
    t.integer "transaccion_id"
    t.string  "tipo",           :limit => 1,   :default => "A"
    t.string  "tabla",          :limit => 100,                    :null => false
    t.integer "tabla_id",                                         :null => false
  end

  create_table "transaccion_contable", :force => true do |t|
    t.string "nombre",      :limit => 50,  :null => false
    t.string "descripcion", :limit => 250
  end

  create_table "transaccion_fideicomiso", :force => true do |t|
    t.datetime "fecha",                                 :null => false
    t.integer  "usuario_id"
    t.integer  "estado_id"
    t.integer  "sector_id"
    t.integer  "sub_sector_id"
    t.integer  "rubro_id"
    t.integer  "cantidad_solicitudes"
    t.float    "monto_banco",          :default => 0.0, :null => false
    t.float    "monto_insumo",         :default => 0.0, :null => false
    t.float    "monto_sras",           :default => 0.0, :null => false
    t.float    "monto_total",          :default => 0.0, :null => false
    t.text     "solicitud_id"
    t.float    "monto_gastos_admin",   :default => 0.0, :null => false
  end

  create_table "unidad_medida", :force => true do |t|
    t.string "nombre",      :limit => 30, :default => "Metros", :null => false
    t.string "abreviatura", :limit => 10, :default => "Mts",    :null => false
  end

  create_table "unidad_negocio", :force => true do |t|
    t.string  "nombre",                        :limit => 100
    t.integer "tenencia_unidad_produccion_id"
    t.string  "propiedad_local",               :limit => 50
    t.float   "cuota_mensual"
    t.integer "tiempo_unidad_negocio"
    t.float   "superficie_total"
    t.integer "tipo_explotacion_id"
    t.integer "experiencia_id"
    t.integer "formacion_id"
    t.integer "porcentaje_ganancia_id"
    t.string  "tamano_negocio",                :limit => 100
    t.integer "porcentaje_uso"
    t.integer "actividad_economica_id"
    t.integer "situacion",                                    :null => false
    t.integer "solicitud_id",                                 :null => false
  end

  create_table "unidad_produccion", :force => true do |t|
    t.string  "codigo",          :limit => 20,  :null => false
    t.string  "nombre",          :limit => 150, :null => false
    t.float   "total_hectareas",                :null => false
    t.integer "ciudad_id",                      :null => false
    t.integer "municipio_id",                   :null => false
    t.integer "parroquia_id",                   :null => false
    t.string  "sector",          :limit => 100
    t.text    "direccion",                      :null => false
    t.text    "referencia",                     :null => false
    t.string  "lindero_norte",   :limit => 200
    t.string  "lindero_sur",     :limit => 200
    t.string  "lindero_este",    :limit => 200
    t.string  "lindero_oeste",   :limit => 200
    t.integer "cliente_id",                     :null => false
    t.string  "utm_norte",       :limit => 100
    t.string  "utm_sur",         :limit => 100
    t.string  "utm_este",        :limit => 100
    t.string  "utm_oeste",       :limit => 100
    t.integer "autonomia_pesca"
    t.string  "puerto_base",     :limit => 250
  end

  create_table "unidad_produccion_caracterizacion", :force => true do |t|
    t.integer "solicitud_id",                :null => false
    t.integer "unidad_produccion_id",        :null => false
    t.integer "seguimiento_visita_id"
    t.boolean "permisologia_agua"
    t.text    "observaciones_permisologia"
    t.text    "vialidad_condicion"
    t.text    "suelo_ph"
    t.boolean "riego_actual"
    t.integer "tipo_riego_actual_id"
    t.text    "condicion_riego_actual"
    t.boolean "requiere_riego"
    t.integer "tipo_riego_requerido_id"
    t.float   "superficie_riego_propuesto"
    t.text    "condiciones_climaticas"
    t.boolean "posee_drenaje"
    t.integer "tipo_drenaje_id"
    t.float   "superficie_drenaje"
    t.text    "condicion_drenaje"
    t.text    "rubros_vegetales"
    t.text    "rubros_animales"
    t.float   "porcentaje_vegetacion_baja"
    t.float   "porcentaje_vegetacion_media"
    t.float   "porcentaje_vegetacion_alta"
    t.float   "superficie_total"
    t.float   "superficie_aprovechable"
    t.float   "vialidad_distancia"
    t.float   "superficie_riego_actual"
  end

  create_table "unidad_produccion_colocacion", :force => true do |t|
    t.integer "solicitud_id"
    t.integer "unidad_produccion_id"
    t.integer "seguimiento_visita_id"
    t.integer "sitio_colocacion_id"
    t.text    "ubicacion"
  end

  create_table "unidad_produccion_condicion_acuicultura", :force => true do |t|
    t.integer "solicitud_id",                             :null => false
    t.integer "unidad_produccion_id",                     :null => false
    t.integer "seguimiento_visita_id"
    t.float   "superficie_disponible"
    t.integer "tipo_sistema_acuicultura_id"
    t.integer "tipo_cultivo_acuicultura_id"
    t.text    "observaciones"
    t.float   "calidad_agua_ph"
    t.float   "calidad_agua_temperatura"
    t.float   "calidad_agua_od"
    t.float   "vialidad_distancia"
    t.text    "vialidad_condiciones"
    t.float   "suelo_ph"
    t.float   "porcentaje_vegetacion_baja"
    t.float   "porcentaje_vegetacion_media"
    t.float   "porcentaje_vegetacion_alta"
    t.boolean "posee_drenaje"
    t.integer "tipo_drenaje_id"
    t.string  "condicion_drenaje",           :limit => 1
    t.float   "superficie_drenaje"
    t.text    "condiciones_climaticas"
    t.text    "rubros_animales"
    t.float   "densidad_siembra"
  end

  create_table "unidad_produccion_infraestructura", :force => true do |t|
    t.integer "solicitud_id"
    t.integer "unidad_produccion_id"
    t.integer "seguimiento_visita_id"
    t.integer "tipo_infraestructura_id"
    t.float   "cantidad",                :null => false
    t.float   "dimension"
    t.integer "unidad_medida_id"
    t.text    "material_construccion"
    t.text    "observaciones"
    t.text    "condicion"
  end

  create_table "unidad_produccion_inventario_animales", :force => true do |t|
    t.integer "solicitud_id",          :null => false
    t.integer "unidad_produccion_id",  :null => false
    t.integer "seguimiento_visita_id", :null => false
    t.integer "cantidad_bovinos"
    t.integer "cantidad_bufalinos"
    t.integer "cantidad_equinos"
    t.integer "cantidad_porcinos"
    t.integer "cantidad_caprinos"
    t.integer "cantidad_aves"
    t.integer "cantidad_ovinos"
    t.integer "cantidad_piscicolas"
    t.integer "cantidad_otros"
    t.text    "observaciones"
  end

  create_table "unidad_produccion_maquinaria", :force => true do |t|
    t.integer "solicitud_id",                        :null => false
    t.integer "unidad_produccion_id",                :null => false
    t.integer "seguimiento_visita_id",               :null => false
    t.text    "clase",                               :null => false
    t.text    "descripcion_item",                    :null => false
    t.text    "cantidad",                            :null => false
    t.text    "marca",                               :null => false
    t.text    "modelo",                              :null => false
    t.integer "anio",                                :null => false
    t.text    "condicion",                           :null => false
    t.text    "tipo_tenencia",                       :null => false
    t.string  "serial",                :limit => 50
    t.string  "nro_chasis",            :limit => 50
    t.integer "clase_id"
  end

  create_table "unidad_produccion_vocacion_tierra", :force => true do |t|
    t.integer "solicitud_id"
    t.integer "unidad_produccion_id",  :null => false
    t.integer "vocacion_tierra_id",    :null => false
    t.integer "seguimiento_visita_id", :null => false
    t.text    "descripcion_otro"
  end

  create_table "ups", :force => true do |t|
    t.string  "rif",                         :limit => 15,  :null => false
    t.string  "nombre",                      :limit => 100
    t.integer "sector_economico_id"
    t.integer "actividad_economica_id"
    t.integer "rama_actividad_economica_id"
    t.boolean "uso_calculadora"
    t.boolean "uso_maquina_escribir"
    t.boolean "uso_computadora"
    t.boolean "uso_equipos_especiales"
    t.boolean "uso_ninguno"
    t.boolean "uso_otro"
    t.string  "descripcion_otro",            :limit => 250
    t.string  "tipo_inmueble",               :limit => 1
    t.string  "localidad",                   :limit => 1
    t.integer "ciudad_id"
    t.integer "municipio_id"
    t.integer "parroquia_id"
    t.string  "avenida",                     :limit => 40
    t.string  "edificio",                    :limit => 40
    t.string  "zona",                        :limit => 40
    t.string  "piso",                        :limit => 3
    t.string  "numero",                      :limit => 10
    t.string  "referencia",                  :limit => 40
    t.string  "codigo_postal",               :limit => 8
    t.string  "direccion",                   :limit => 200
    t.string  "telefono",                    :limit => 25
    t.string  "email",                       :limit => 25
    t.string  "ingreso_mensual",             :limit => 1
    t.integer "nro_trabajadoras"
    t.integer "nro_trabajadores"
    t.boolean "experiencia"
    t.string  "proveedores_materia_prima",   :limit => 1
    t.boolean "credito_agricola"
    t.string  "celular",                     :limit => 25
  end

  create_table "usuario", :force => true do |t|
    t.string  "nombre_usuario",      :limit => 30,                    :null => false
    t.string  "primer_nombre",       :limit => 20,                    :null => false
    t.string  "segundo_nombre",      :limit => 20
    t.string  "primer_apellido",     :limit => 20,                    :null => false
    t.string  "segundo_apellido",    :limit => 20
    t.boolean "super_usuario",                     :default => false
    t.integer "oficina_id"
    t.date    "fecha_cambio_clave"
    t.boolean "activo",                            :default => true
    t.string  "cedula_nacionalidad", :limit => 1,  :default => "V",   :null => false
    t.integer "cedula"
    t.boolean "tecnico_campo",                     :default => false, :null => false
    t.text    "password"
    t.string  "lenguaje",            :limit => 2,  :default => "es",  :null => false
    t.integer "empresa_sistema_id"
    t.boolean "admin_empresa",                     :default => false
  end

  add_index "usuario", ["cedula"], :name => "usuario_uq_cedula", :unique => true

  create_table "usuario_estacion", :id => false, :force => true do |t|
    t.integer "usuario_id",  :null => false
    t.integer "estacion_id", :null => false
  end

  create_table "usuario_oficina", :force => true do |t|
    t.integer "usuario_id",                        :null => false
    t.integer "oficina_id",                        :null => false
    t.boolean "predeterminada", :default => false
  end

  create_table "usuario_opcion", :id => false, :force => true do |t|
    t.integer "usuario_id", :null => false
    t.integer "opcion_id",  :null => false
  end

  create_table "usuario_opcion_accion", :force => true do |t|
    t.integer "usuario_id",       :null => false
    t.integer "opcion_accion_id", :null => false
  end

  create_table "usuario_rol", :id => false, :force => true do |t|
    t.integer "usuario_id", :null => false
    t.integer "rol_id",     :null => false
  end

  create_table "usuario_rol_respaldo_2012_02_07", :id => false, :force => true do |t|
    t.integer "usuario_id"
    t.integer "rol_id"
  end

  create_table "utm_unidad_produccion", :force => true do |t|
    t.string  "utm",                  :limit => 100, :null => false
    t.integer "unidad_produccion_id",                :null => false
    t.string  "ubicacion_geografica", :limit => 1
  end

  create_table "vacuna", :force => true do |t|
    t.text "descripcion"
  end

  create_table "vacunacion", :force => true do |t|
    t.integer "sanidad_animal_id"
    t.integer "vacuna_id"
    t.date    "fecha_colocacion"
  end

  create_table "vocacion_tierra", :force => true do |t|
    t.string  "nombre",      :limit => 100,                    :null => false
    t.string  "descripcion", :limit => 250,                    :null => false
    t.boolean "activo",                     :default => false
  end

  create_table "wssession", :force => true do |t|
    t.string "ticket",     :limit => 2000, :null => false
    t.date   "timestamps"
  end

  create_table "wsusers", :force => true do |t|
    t.string "usuario",   :limit => 2000, :null => false
    t.string "passworsd", :limit => 2000, :null => false
  end

end
