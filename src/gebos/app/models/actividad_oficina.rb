# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ActividadOficina
# descripción: Migración a Rails 3
#

class ActividadOficina < ActiveRecord::Base

  self.table_name = 'actividad_oficina'

  attr_accessible :actividad_id,
                  :oficina_id,
                  :activo

  belongs_to :oficina
  belongs_to :actividad

  validates_presence_of  :actividad_id,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of  :oficina_id,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.oficina')}  #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  def self.clonar(actividad_id)
    oficina = Oficina.find(:all, :conditions=> "id not in (select oficina_id from actividad_oficina where actividad_id = #{actividad_id})")
    oficina.each { |o|
      actividad_oficina = ActividadOficina.new
      actividad_oficina.oficina_id = o.id
      actividad_oficina.actividad_id = actividad_id
      actividad_oficina.activo = true
      actividad_oficina.save
    }
  end

  def self.oficinas(actividad_id)
    estado = Estado.find(:all, :order=>'nombre')
    a = 1
    respuesta = "<tr>"
    res = ""
    oficina_id = ""
    estado.each{ |e|
      if a > 3
        a = 1
        respuesta << "</tr><tr class='lista0'>#{res}</tr><tr class='lista1'>"
        res = ""
      end
      respuesta << "<td align='center'>" << e.nombre << "</td>"
      oficinas = ActividadOficina.find(:all, :conditions=>['actividad_id = ? and oficina_id in (select id from oficina where municipio_id in (select id from municipio where estado_id = ?))', actividad_id, e.id])
      res << "<td style='width: 33% '>"
      oficinas.each{|o|
        unless o.activo == true
          res << "<li><input type='checkbox' id='oficina_id' name='oficina_select_id' value='#{o.id}' onClick='GenericcheckOne(this,form.todos," + '"oficinas"' + ");' />&nbsp;" << o.oficina.nombre << "</li>"
        else
          res << "<li><input type='checkbox' id='oficina_id' checked name='oficina_select_id' value='#{o.id}' onClick='GenericcheckOne(this,form.todos," + '"oficinas"' + ");' />&nbsp;" << o.oficina.nombre << "</li>"
          oficina_id << o.id.to_s << ','
        end
      }
      res  << "&nbsp;</td>"
      a = a + 1
    }
    return [respuesta.html_safe, oficina_id]
  end

  def self.iniciar_actividad
    actividad = Actividad.find(:all)
    actividad.each {|a|
      ActividadOficina.clonar(a.id)
    }
  end

end

# == Schema Information
#
# Table name: actividad_oficina
#
#  id           :integer         not null, primary key
#  actividad_id :integer         not null
#  oficina_id   :integer         not null
#  activo       :boolean         default(TRUE), not null
#

