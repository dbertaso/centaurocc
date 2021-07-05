# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: TipoMovimientoFideicomiso
# descripción: Migración a Rails 3
#



class TipoMovimientoFideicomiso < ActiveRecord::Base

self.table_name = 'tipo_movimiento_fideicomiso'

attr_accessible :id,
                :tipo_nota,
                :modo_nota,
                :motivo,
                :sub_cuenta_banco,
                :sub_cuenta_insumos,
                :sub_cuenta_gastos,
                :sub_cuenta_sras,
                :comision,
                :disponible,
                :afecta_banco,
                :afecta_insumos,
                :afecta_gastos,
                :afecta_sras
  
validates :tipo_nota, :presence => {
:message => I18n.t('Sistema.Body.Vistas.General.tipo') << " " << I18n.t('Sistema.Body.General.nota') << " " << I18n.t('Sistema.Body.Modelos.Errores.municipio_requerido')}


validates :modo_nota, :presence => {
:message => I18n.t('Sistema.Body.Vistas.General.modo') << " " << I18n.t('Sistema.Body.General.nota') << " " << I18n.t('Sistema.Body.Modelos.Errores.municipio_requerido')}


validates :motivo, :presence => {
:message => I18n.t('Sistema.Body.Vistas.General.motivo') << " " << I18n.t('Sistema.Body.Modelos.Errores.municipio_requerido')},
:length => { :in => 3..20, :allow_nil => false,
:too_short => "#{I18n.t('Sistema.Body.Vistas.General.motivo')} #{I18n.t('errors.messages.too_short.other')}",
:too_long => "#{I18n.t('Sistema.Body.Vistas.General.motivo')}  #{I18n.t('errors.messages.too_long.other')}"},
:uniqueness=>{:message => I18n.t('Sistema.Body.Vistas.General.motivo') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe') }
      
  
  def tipo_nota_text
    if self.tipo_nota == -1
       I18n.t('Sistema.Body.Vistas.General.debito')
    else
       I18n.t('Sistema.Body.Vistas.General.credito')
    end
  end
  
  def modo_nota_text
    if self.modo_nota == 'AUT'
       I18n.t('Sistema.Body.Vistas.General.automatica')
    else
       I18n.t('Sistema.Body.Vistas.General.manual')
    end
  end
  
#  def validate
#    unless self.motivo.nil? || self.motivo.empty?
#      #a = self.motivo[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
#      #if a.nil?
#        errors.add(nil, "Motivo es inválido")
#      #end
#    end
#  end
end


# == Schema Information
#
# Table name: tipo_movimiento_fideicomiso
#
#  id                 :integer         not null, primary key
#  tipo_nota          :integer         not null
#  modo_nota          :string(3)       not null
#  motivo             :text            not null
#  sub_cuenta_banco   :boolean         default(FALSE)
#  sub_cuenta_insumos :boolean         default(FALSE)
#  sub_cuenta_gastos  :boolean         default(FALSE)
#  sub_cuenta_sras    :boolean         default(FALSE)
#  comision           :boolean         default(FALSE)
#  disponible         :boolean
#  afecta_banco       :integer
#  afecta_insumos     :integer
#  afecta_gastos      :integer
#  afecta_sras        :integer
#

