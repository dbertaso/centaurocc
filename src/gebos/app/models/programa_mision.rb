# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ProgramaMision
# descripción: Migración a Rails 3
#

class ProgramaMision < ActiveRecord::Base

  self.table_name = 'programa_mision'

  belongs_to :programa
  belongs_to :mision

  validates_presence_of :programa, :mision,
    :message => " es requerido"
  validates_uniqueness_of :programa_id, :scope=>'mision_id',
    :message => " ya existe"

  def after_initialize
  end
end

# == Schema Information
#
# Table name: programa_mision
#
#  id          :integer         not null, primary key
#  programa_id :integer
#  mision_id   :integer
#

