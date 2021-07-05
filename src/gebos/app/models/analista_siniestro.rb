# encoding: utf-8
class AnalistaSiniestro < ActiveRecord::Base

  self.table_name = 'analista_siniestro'
  
  belongs_to :usuario
  belongs_to :siniestro
  


  def self.buscar_analista  siniestro
    transaction do      
      analista_siniestro              = AnalistaSiniestro.find(:first,:order=>'pendientes asc')

      unless analista_siniestro.nil?
      analista_siniestro.pendientes   = analista_siniestro.pendientes.to_i + 1
      analista_siniestro.save!
      siniestro_nuevo=Siniestro.new(siniestro)
      logger.debug "parametros de siniestro " << siniestro.inspect.to_s

      siniestro_nuevo.analista_siniestro_id = analista_siniestro.id
      logger.debug "id del siniestro " << siniestro_nuevo.id.to_s << " analista id " << siniestro_nuevo.analista_siniestro_id.to_s
      if siniestro_nuevo.save
        return true
      else
        return siniestro_nuevo.errors
      end 
      #return siniestro_nuevo.send(:update_without_callbacks)
      #anteriormente return siniestro.save      
      else      
        return false      
      end 
    end
  end

end

# == Schema Information
#
# Table name: analista_siniestro
#
#  id         :integer         not null, primary key
#  usuario_id :integer         not null
#  pendientes :integer
#  atendidos  :integer
#

