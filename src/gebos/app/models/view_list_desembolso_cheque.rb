# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ViewListDesembolsoCheque
# descripcion: Migracion a Rails 3



class ViewListDesembolsoCheque < ActiveRecord::Base
  
  self.table_name = 'view_list_desembolso_cheque'
  
attr_accessible :beneficiario,
                :email,
                :cedula_rif,
                :oficina_id,
                :solicitud_id,
                :nro_tramite,
                :prestamo_id,
                :entidad_financiera_id,
                :banco,
                :cod_swift,
                :tipo_cuenta,
                :numero_cuenta,
                :unidad_produccion_id,
                :ciudad_id,
                :ciudad,
                :estado_id,
                :estado,
                :municipio_id,
                :municipio,
                :sector_id,
                :sector,
                :rubro,
                :rubro_id,
                :ciclo,
                :nombre,
                :desembolso_id,
                :numero_desembolso,
                :tipo_cheque,
                :referencia,
                :estatus,
                :monto_liquidar,
                :monto_banco,
                :monto_liquidado,
                :subrubro,
                :actividad,
                :sub_sector_id,
                :actividad_id,
                :sub_rubro_id,
                :programa_id,
                :programa,
                :moneda_id,
                :moneda

  
  public
  
  
    def monto_liquidar_fm

      format_fm(self.monto_liquidar)
    end

    def monto_liquidado_fm      
        format_fm(self.monto_liquidado)
    end

    def monto_banco_fm      
      format_fm(self.monto_banco)
    end

    def monto_por_liquidar_fm
      unless self.monto_banco.nil? || self.monto_liquidado.nil? || self.monto_liquidar.nil?
        valor = self.monto_banco - (self.monto_liquidado + self.monto_liquidar)
        format_fm(valor)
      end
    end

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

end

# == Schema Information
#
# Table name: view_list_desembolso_cheque
#
#  beneficiario          :string
#  email                 :string(80)
#  cedula_rif            :string
#  oficina_id            :integer
#  solicitud_id          :integer
#  nro_tramite           :integer
#  prestamo_id           :integer
#  entidad_financiera_id :integer
#  banco                 :string(80)
#  cod_swift             :string(12)
#  tipo_cuenta           :string(1)
#  numero_cuenta         :string(20)
#  unidad_produccion_id  :integer
#  ciudad_id             :integer
#  ciudad                :string(40)
#  estado_id             :integer
#  estado                :string(40)
#  municipio_id          :integer
#  municipio             :string(40)
#  sector_id             :integer
#  sector                :string(100)
#  rubro                 :string(100)
#  rubro_id              :integer
#  ciclo                 :integer
#  nombre                :string(50)
#  desembolso_id         :integer
#  numero_desembolso     :integer
#  tipo_cheque           :string(1)
#  referencia            :string(30)
#  estatus               :integer
#  monto_liquidar        :decimal(16, 2)
#  monto_banco           :decimal(16, 2)
#  monto_liquidado       :decimal(16, 2)
#  subrubro              :string(100)
#  actividad             :string(150)
#  sub_sector_id         :integer
#  actividad_id          :integer
#  sub_rubro_id          :integer
#  moneda_id             :integer
#  moneda                :text
#

