# encoding: utf-8

class GuiaCatalogo < ActiveRecord::Base

  self.table_name = 'guia_catalogo'
  
  attr_accessible :id,
				  :catalogo_id,
				  :guia_movilizacion_maquinaria_id,
				  :conforme

  belongs_to :guia_movilizacion_maquinaria
  belongs_to :catalogo

  
  def self.view_conforme(catalogo, guia_id)
    clase = 'lista0'
    html = ""
    catalogo.each {|c|
      guia = GuiaCatalogo.find(:first, :conditions => "catalogo_id = #{c.id} and guia_movilizacion_maquinaria_id = #{guia_id}")
      html << "<tr class='#{clase}'>"
      html << "<td style='text-align: center'>"
      unless guia.class.name == 'NilClass'
        if guia.conforme == true
          html << "<input id='guia_catalogo_id_#{c.id}_t' checked='checked' class='text' type='radio' value='T' onclick='inputChange();' name='guia_catalogo[id_#{c.id}]'></td>"
          html << "<td style='text-align: center'>"
          html << "<input id='guia_catalogo_id_#{c.id}_t' class='text' type='radio' value='F' onclick='inputChange();' name='guia_catalogo[id_#{c.id}]'></td>"
        elsif guia.conforme == false
          html << "<input id='guia_catalogo_id_#{c.id}_t' class='text' type='radio' value='T' onclick='inputChange();' name='guia_catalogo[id_#{c.id}]'></td>"
          html << "<td style='text-align: center'>"
          html << "<input id='guia_catalogo_id_#{c.id}_t' checked='checked' class='text' type='radio' value='F' onclick='inputChange();' name='guia_catalogo[id_#{c.id}]'></td>"
        else
          html << "<input id='guia_catalogo_id_#{c.id}_t' class='text' type='radio' value='T' onclick='inputChange();' name='guia_catalogo[id_#{c.id}]'></td>"
          html << "<td style='text-align: center'>"
          html << "<input id='guia_catalogo_id_#{c.id}_t' class='text' type='radio' value='F' onclick='inputChange();' name='guia_catalogo[id_#{c.id}]'></td>"
        end
      else
        html << "<input id='guia_catalogo_id_#{c.id}_t' class='text' type='radio' value='T' onclick='inputChange();' name='guia_catalogo[id_#{c.id}]'></td>"
        html << "<td style='text-align: center'>"
        html << "<input id='guia_catalogo_id_#{c.id}_t' class='text' type='radio' value='F' onclick='inputChange();' name='guia_catalogo[id_#{c.id}]'></td>"
      end
      html << "<td>#{c.clase.tipo_maquinaria.nombre}</td>"
      html << "<td>#{c.clase.nombre}</td>"
      html << "<td>#{c.marca_maquinaria.nombre unless c.marca_maquinaria.nil?}</td>"
      html << "<td>#{c.modelo.nombre unless c.modelo.nil?}</td>"
      html << "<td>#{c.serial.to_s}</td>"
      html << "<td>#{c.chasis.to_s}</td>"
      html << "<td>#{c.almacen_maquinaria.nombre unless c.almacen_maquinaria.nil?}</td></tr>"
      if clase == "lista0"
        clase = "lista1"
      else
        clase = "lista0"
      end
    }
    return html.html_safe
  end
  
end

# == Schema Information
#
# Table name: guia_catalogo
#
#  id                              :integer         not null, primary key
#  catalogo_id                     :integer
#  guia_movilizacion_maquinaria_id :integer
#  conforme                        :boolean
#

