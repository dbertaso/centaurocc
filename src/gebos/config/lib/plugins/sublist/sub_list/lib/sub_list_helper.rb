# ROR SubList Plugin
# Luke Galea - galeal@ideaforge.org
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

module SubListHelper  
  def sub_list_add_link( model = 'Note', label = image_tag( 'edit_add.png' ) )
    model = model.to_s.tableize.singularize
    models = model.pluralize
    
    link_to_remote( label, :update => models, :position => :bottom, :complete => visual_effect( :appear, models ), :url => { :action => "add_#{model}" } )
  end

  def sub_list_add_link( model = 'Note', label = image_tag( 'edit_add.png' ), parent_id = nil )
    model = model.to_s.tableize.singularize
    models = model.pluralize

    link_to_remote( label, :update => models, :position => :bottom, :complete => visual_effect( :appear, models ), :url => { :action => "add_#{model}",  :id => parent_id} )
  end
  
  def sub_list_content( model = 'Note', parent = 'incomplete' )
    logger.debug "singularize " << model.to_s.tableize.singularize
    model = model.to_s.tableize.singularize
    models = model.pluralize
    if models == 'vacunacions' : models = 'vacunacion' end
    content = render :partial => model, :collection => eval("@#{parent}.#{models}")
    "<div id=\"#{models}\"> #{content} </div>"
  end
  
  def sub_list_content_without_div( model = 'Note', parent = 'incomplete' )
    model = model.to_s.tableize.singularize
    models = model.pluralize
    
    render :partial => model, :collection => eval("@#{parent}.#{models}")
  end
  
  def sub_list_remove_link( item, model = 'Note', label = image_tag( 'eliminar.gif' ) )
    model = model.to_s.tableize.singularize
    models = model.pluralize
    
    link_to_remote( label, :update => "#{model}_#{item.id}", :loading => visual_effect( :blind_up, "#{model}_#{item.id}" ), :confirm => '¿Esta seguro que desea borrar este item?', :url => { :action => "remove_#{model}", :id => item } )
  end  
end
